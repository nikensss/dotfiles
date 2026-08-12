# tmux-pr-herd.jq - render one pull request's unresolved review threads for a terminal pane.
#
# Read by `tmux-pr-herd preview`, which is what fzf runs to fill the miniature. One jq
# invocation does everything: select, order, normalise markdown, wrap, colour. Nothing
# downstream may re-wrap what comes out of here - the SGR escapes have zero display width
# and every wrapper on this box counts them as columns (`fold -w 10` breaks inside an
# escape), which is also why the wrapping lives in here rather than in a fold/fmt stage.
#
# Cost, measured against a 152KB payload of 21 open PRs: 10-12ms for the worst real PR
# (11 unresolved threads, 3 suggestion blocks), of which ~5ms is parsing the JSON. That is
# invisible on a cursor move. It is one fork, deliberately: a per-line subshell version of
# herd's row renderer measured 540ms against 60ms fork-free (tmux-claude-herd:98).
#
# args: --argjson W <cols>  --argjson NOW <epoch>  --argjson PR <number>

def esc($hex):
  def hx($p): ($hex[$p:$p+2]|explode) as $e
    | ((if $e[0]<58 then $e[0]-48 else $e[0]-87 end)*16
       + (if $e[1]<58 then $e[1]-48 else $e[1]-87 end));
  "\u001b[38;2;\(hx(0));\(hx(2));\(hx(4))m";

# The palette is herd's, hex for hex (tmux-claude-herd:108-115), so the two popups read as
# one tool. Only the meanings are re-pointed at review threads.
def RESET:   "\u001b[0m";
def C_LABEL: esc("c4b5fd");   # violet-300 - thread index chip
def C_WORK:  esc("86efac");   # green-300  - suggested change
def C_AGENT: esc("7dd3fc");   # sky-300    - line number, MED/P2 severity
def C_NEED:  esc("fb923c");   # orange-400 - CRIT/HIGH/P1 severity
def C_IDLE:  esc("71717a");   # zinc-500   - outdated chip
def C_LOC:   esc("e4e4e4");   # white      - basename, human author, prose
def C_SUB:   esc("a1a1aa");   # zinc-400   - bot author, code inside a plain fence
def C_DIM:   esc("52525b");   # zinc-600   - directories, rails, rules, ages

# -- display width -------------------------------------------------------------

# cw <codepoint>: cells this codepoint occupies. jq has no hex literals, so the ranges are
# decimal and the comments carry the codepoints.
def cw($c):
  if   ($c >=   4352 and $c <=   4447)    # 1100..115F  Hangul Jamo
    or ($c >=  11904 and $c <=  42191)    # 2E80..A4CF  CJK
    or ($c >=  44032 and $c <=  55203)    # AC00..D7A3  Hangul syllables
    or ($c >=  63744 and $c <=  64255)    # F900..FAFF  CJK compat
    or ($c >=  65072 and $c <=  65135)    # FE30..FE6F  vertical/compat forms
    or ($c >=  65280 and $c <=  65376)    # FF00..FF60  fullwidth
    or ($c >=  65504 and $c <=  65510)    # FFE0..FFE6  fullwidth signs
    or ($c >= 127744 and $c <= 129791)    # 1F300..1FAFF emoji
    or ($c >= 131072 and $c <= 262141)    # 20000..3FFFD CJK ext B+
  then 2
  elif ($c >= 768 and $c <= 879)          # 0300..036F  combining marks
    or ($c >= 65024 and $c <= 65039)      # FE00..FE0F  variation selectors
  then 0
  else 1 end;

# dw: display width of a string. Fast path first - a string whose byte length equals its
# codepoint count is pure ASCII (any codepoint >= U+0080 costs at least 2 bytes), so its
# width is just its length. Review text is overwhelmingly ASCII and this is the hot loop:
# adding this cut a 122-thread stress render from 1045ms to 199ms.
def dw: if (utf8bytelength == length) then length
        else explode | map(cw(.)) | add // 0 end;

# clipw <n>: truncate to n cells, ellipsis included in the budget.
def clipw($n):
  . as $s
  | if ($s|dw) <= $n then $s
    else (reduce ($s|explode|.[]) as $c ({a:"",w:0,d:false};
            if .d or (.w + cw($c) > $n - 1) then .d = true
            else {a:(.a + ([$c]|implode)), w:(.w + cw($c)), d:false} end)).a + "…"
    end;

# clipleft <n>: elide a path from the LEFT at a "/" boundary. The basename is the half you
# recognise, so "…/prisma/migrations/20260806_x/migration.sql" beats a right-truncated
# "apps/web-rms/prisma/migrations/2026080…".
def clipleft($n):
  . as $s
  | if ($s|dw) <= $n then $s
    else (reduce ($s|split("/")|reverse|.[]) as $x ({k:[],w:2,stop:false};
            if .stop or (.w + ($x|dw) + 1) > $n then .stop = true
            else {k:([$x]+.k), w:(.w + ($x|dw) + 1), stop:false} end)) as $r
      | if ($r.k|length) == 0 then ($s|clipw($n)) else "…/" + ($r.k|join("/")) end
    end;

# -- greedy word wrap ----------------------------------------------------------

# wrap <w>: fold one logical line to w cells. Hard-breaks a token wider than the line, so
# nothing can ever exceed w - review bodies really do contain 141-column knowledge-base
# URLs as a single token, and BSD fmt would have emitted that verbatim into a 96-column
# pane (it never splits a word). BSD `fold -s -w` gets the width right but joins nothing
# and would have to run per line anyway, which is a fork per line.
def wrap($w):
  . as $line
  | if ($line|dw) <= $w then [$line]
    else (reduce ($line|split(" ")|map(select(length>0))|.[]) as $word ({out:[],cur:""};
              ($word|dw) as $ww
            # An oversized token has to be chopped whether or not the current line is
            # empty - flush first, then chop. Getting this order wrong leaves the URL
            # above sitting unbroken in the pane.
            | if $ww > $w then
                ((.out + (if .cur=="" then [] else [.cur] end)) as $o0
                 | (reduce ($word|explode|.[]) as $c ({o:[],b:"",bw:0};
                      if (.bw + cw($c)) > $w then {o:(.o+[.b]), b:([$c]|implode), bw:cw($c)}
                      else {o:.o, b:(.b+([$c]|implode)), bw:(.bw+cw($c))} end)) as $z
                 | {out:($o0 + $z.o), cur:$z.b})
              elif .cur == "" then {out:.out, cur:$word}
              elif ((.cur|dw) + 1 + $ww) <= $w then {out:.out, cur:(.cur+" "+$word)}
              else {out:(.out+[.cur]), cur:$word} end))
         | .out + (if .cur=="" then [] else [.cur] end)
    end;

# -- markdown ------------------------------------------------------------------

# demd: flatten one line of markdown to something a terminal can show. Only the constructs
# that actually occur in review bodies are handled; the rest is left alone on purpose,
# because a half-applied renderer is worse than none.
def demd:
    gsub("!\\[[^\\]]*\\]\\([^)]*\\)"; "")               # images / bot severity badges
  | gsub("\\[(?<t>[^\\]]*)\\]\\([^)]*\\)"; "\(.t)")     # [text](url) -> text
  | gsub("<a [^>]*>|</a>|<img [^>]*>"; "")              # greptile's anchor-wrapped badge
  | gsub("\\*\\*(?<t>[^*]+)\\*\\*"; "\(.t)")            # bold markers
  | sub("^\\s*#{1,6}\\s+"; "")                          # ATX heading marker
  | sub("^\\s*[*+]\\s+"; "• ")                          # bullet -> a real bullet
  | sub("^\\s*-\\s+"; "• ")
  | sub("\\s+$"; "");

# chip: the severity badge review bots put at the top of a comment, as a short coloured
# word. Reading it off the raw body is deliberate - demd deletes the badge image.
def chip:
  if   test("^!\\[critical\\]")          then {t:"CRIT", c:C_NEED}
  elif test("^!\\[high\\]")              then {t:"HIGH", c:C_NEED}
  elif test("^!\\[medium\\]")            then {t:"MED",  c:C_AGENT}
  elif test("^<a [^>]*><img alt=\"P1\"") then {t:"P1",   c:C_NEED}
  elif test("^<a [^>]*><img alt=\"P2\"") then {t:"P2",   c:C_AGENT}
  else null end;

# is_noise: bot boilerplate that carries no review content.
def is_noise:
  test("^\\s*(Context Used:|Knowledge Base Used:|Note: If this suggestion doesn't match|\\*\\*Context Used|\\*\\*Knowledge Base Used|> \\[bot\\] This reply was generated)");

def ago($t):
  ($NOW - ($t|fromdateiso8601)) as $d
  | if   $d <    60 then "\($d|floor)s"
    elif $d <  3600 then "\(($d/60)|floor)m"
    elif $d < 86400 then "\(($d/3600)|floor)h"
    else                 "\(($d/86400)|floor)d" end;

def is_bot:
  . as $l | ["greptile-apps","gemini-code-assist","dependabot","github-actions",
             "coderabbitai","codecov","sonarcloud"] | index($l) != null;

# -- one comment body -> array of styled lines ---------------------------------
#
# $rail  the already-coloured rail prefix every line of this comment carries
# $tw    text width left after the rail
# $cap   max body lines before the rest folds into a "N more lines" marker
def render_body($body; $rail; $tw; $cap):
  ($body | split("\n"))
  # Fence state machine, run BEFORE any markdown stripping: what is inside a fence must
  # not be wrapped or stripped. Load-bearing - review bodies carry <s-page>, <s-banner>,
  # <T> and <string> inside fences, all of which the tag strip in demd would eat.
  | (reduce .[] as $ln ({o:[], f:"none"};
      if ($ln|test("^\\s*```"))
      then (if .f != "none" then {o:(.o + [{k:"fence-end"}]), f:"none"}
            elif ($ln|test("^\\s*```suggestion")) then {o:(.o + [{k:"sugg-start"}]), f:"sugg"}
            else {o:(.o + [{k:"code-start"}]), f:"code"} end)
      elif .f != "none" then {o:(.o + [{k:.f, t:$ln}]), f:.f}
      elif ($ln|is_noise) then .
      else {o:(.o + [{k:"text", t:($ln|demd)}]), f:.f} end)).o
  # collapse runs of blank text lines to at most one
  | (reduce .[] as $b ({o:[], blank:true};
       if $b.k=="text" and ($b.t|test("^\\s*$"))
       then (if .blank then . else {o:(.o+[$b]), blank:true} end)
       else {o:(.o+[$b]), blank:false} end)).o
  | map(
      # Code is CLIPPED, never word-wrapped: re-flowing code at spaces is actively
      # misleading, and its leading indentation is meaning.
      if   .k=="text" then (.t | wrap($tw) | map({k:"text", t:.}))
      elif .k=="sugg-start" then [{k:"sugg-start"}]
      elif .k=="code-start" then [{k:"code-start"}]
      elif .k=="fence-end"  then [{k:"fence-end"}]
      else [{k:.k, t:(.t|clipw($tw - 2))}] end)
  | add // []
  # drop leading/trailing blanks - stripped bot boilerplate leaves them behind
  | (until((length == 0) or (.[-1].k != "text") or (.[-1].t | test("\\S")); .[0:-1]))
  | (until((length == 0) or (.[0].k != "text") or (.[0].t | test("\\S")); .[1:]))
  # The cap exists because ctrl-f/ctrl-b scroll ONE line per press: an uncapped 3400-char
  # bot essay costs ~45 keypresses to get past and buries every other thread. The full
  # text is one keystroke away - the hop key opens the PR in a browser.
  | (if length > $cap then .[0:$cap] + [{k:"more", t:"\(length - $cap) more lines"}] else . end)
  | map(
      if   .k=="text"       then $rail + C_LOC  + .t + RESET
      elif .k=="sugg"       then $rail + C_DIM + "│" + C_WORK + .t + RESET
      elif .k=="code"       then $rail + C_DIM + "│" + C_SUB  + .t + RESET
      elif .k=="sugg-start" then $rail + C_WORK + "╭ suggested change" + RESET
      elif .k=="code-start" then $rail + C_DIM  + "╭" + RESET
      elif .k=="fence-end"  then $rail + C_DIM  + "╰" + RESET
      else                       $rail + C_DIM + "… " + .t + RESET end);

# -- main ----------------------------------------------------------------------

.data.repository.pullRequests.nodes[] | select(.number == $PR)
| [ .reviewThreads.nodes[] | select(.isResolved | not) ]
# ORDER: live threads before outdated ones, then by file, then by line.
#
# Position-stable on purpose. The preview scrolls one line at a time, so any order that
# changes when someone replies moves the ground under a cursor sitting 40 lines down. A
# new reply lengthens one block; it never reshuffles the list. Recency is not lost - every
# comment carries its own age on the byline. Grouping by file also matches how the work is
# done: you open one file and fix everything in it.
| sort_by([(if .isOutdated then 1 else 0 end), .path, (.line // 0)])
| . as $threads
| ($threads|length) as $n
| if $n == 0 then "  \(C_DIM)no unresolved review threads\(RESET)"
  else
    ( to_entries | map(
        .key as $i | .value as $t
      # -- header rule: index, path:line, fill, outdated chip ---------------------
      # All on one line, so a 20-row pane still shows three or four threads.
      | ("\($i+1)/\($n)") as $ix
      # An outdated thread's hunk is gone from the diff, so it is the least actionable
      # thing here: demoted and chipped, never hidden.
      #
      # The chip sits on the LEFT, before the path, even though the right end of the rule is
      # the emptier place for it. fzf draws its own preview scroll indicator ("3/22") over
      # the top-right of the window, and on the first thread's rule that landed on top of
      # the chip and left "outd" behind.
      | (if $t.isOutdated then "outdated · " else "" end) as $od
      | ($od|dw) as $odw
      # Nearly every outdated thread carries line == null. An empty ":?" is noise when the
      # chip already says why, so a null line prints no suffix at all.
      | (if $t.line then ":\($t.line)" else "" end) as $ln
      # The path budget has to include the ":N" suffix, or an 87-column path plus its line
      # number overflows the rule by exactly the width of that suffix. And -8 rather than
      # -7 because the rule always keeps at least one dash of fill, so the path may not
      # claim the last column.
      | ($t.path | clipleft($W - 8 - ($ix|dw) - ($ln|dw) - $odw)) as $p
      | ($p | split("/")) as $seg
      | ((if ($seg|length) > 1 then C_DIM + ($seg[0:-1]|join("/")) + "/" else "" end)
         + C_LOC + $seg[-1] + (if $t.line then C_AGENT + $ln else "" end) + RESET) as $pcol
      | ([$W - 7 - ($ix|dw) - ($p|dw) - ($ln|dw) - $odw, 1] | max) as $fill
      | ("\(C_DIM)╶─\(RESET) \(C_LABEL)\($ix)\(RESET) \(C_DIM)─\(RESET) "
         + (if $od == "" then "" else "\(C_IDLE)\($od)\(RESET)" end)
         + $pcol + " \(C_DIM)" + ("─" * $fill) + RESET) as $rule
      # Comments in API order, which is chronological. Comment 0 is the root and sits
      # directly on the rail; replies are marked with ↳ and indented two further columns.
      | ([$rule]
         + ( $t.comments.nodes | to_entries | map(
               .key as $ci | .value as $c
             | ($c.author.login // "ghost") as $who
             | ($c.body | chip) as $sev
             | (if ($who|is_bot) then C_SUB else C_LOC end) as $wc
             | (if $sev then " \($sev.c)\($sev.t)\(RESET)\(C_DIM) ·" else "" end) as $sevs
             | (if $ci == 0 then "  \(C_DIM)┃\(RESET) " else "  \(C_DIM)┃\(RESET)   " end) as $rail
             | ((if $ci == 0 then "  \(C_DIM)┃\(RESET) " else "  \(C_DIM)┃ ↳\(RESET) " end)
                + "\($wc)\($who)\(RESET)\(C_DIM) ·\($sevs) \(ago($c.createdAt)) ago\(RESET)") as $byline
             | [ (if $ci == 0 then empty else "  \(C_DIM)┃\(RESET)" end), $byline ]
               + render_body($c.body; $rail; $W - (if $ci == 0 then 4 else 6 end); 12)
           ) | add )
         + [""])
      ) | add )
    | .[]
  end
