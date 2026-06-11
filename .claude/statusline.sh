#!/usr/bin/env bash
# Claude Code statusline — compact, left-aligned single line
# Format: [⎈ worktree · ]⎇ branch  ·  ⌖ ▰▰▰▰▰▰▰▰▰▰  56%  ·  Opus 4.7 [1m]

set -uo pipefail
exec 2>/dev/null

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

input=$(cat)
[[ -z "$input" ]] && exit 0

j() { printf '%s' "$input" | jq -r "$1 // empty" 2>/dev/null; }

cwd=$(j '.cwd')
model=$(j '.model.display_name')
model_id=$(j '.model.id')
worktree=$(j '.workspace.git_worktree')
pct=$(j '.context_window.used_percentage')
rate_5h=$(j '.rate_limits.five_hour.used_percentage')
rate_5h_reset=$(j '.rate_limits.five_hour.resets_at')
session_id=$(j '.session_id')

# Persist rate-limit across sessions — Claude Code only populates rate_limits after the first API call,
# so a fresh session sees nothing until you message; cache the most recent values to bridge that gap.
RATE_CACHE="$HOME/.claude/statusline-rate.json"
if [[ -n "$rate_5h" && -n "$rate_5h_reset" ]]; then
  printf '{"used_percentage":%s,"resets_at":%s}\n' "$rate_5h" "$rate_5h_reset" > "$RATE_CACHE" 2>/dev/null
elif [[ -f "$RATE_CACHE" ]]; then
  cached_reset=$(jq -r '.resets_at // empty' "$RATE_CACHE" 2>/dev/null)
  if [[ -n "$cached_reset" ]] && (( cached_reset > $(date +%s) )); then
    rate_5h=$(jq -r '.used_percentage // empty' "$RATE_CACHE" 2>/dev/null)
    rate_5h_reset="$cached_reset"
  fi
fi

# Strip "(1M context)" / "(200K context)" from display name — [1m] tag handles the variant
model="${model%% (*}"

pct_int=${pct%.*}
pct_int=${pct_int:-0}

# Git branch (cached briefly to avoid repeated git calls on rapid refreshes)
branch=""
if [[ -n "$cwd" && -d "$cwd" ]]; then
  cache_dir="/tmp/claude-statusline"
  mkdir -p "$cache_dir" 2>/dev/null
  cache_key=$(printf '%s' "$cwd" | shasum | awk '{print $1}')
  cache_file="$cache_dir/$cache_key"
  if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -f %m "$cache_file" 2>/dev/null || echo 0))) -lt 5 ]]; then
    branch=$(<"$cache_file")
  else
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    printf '%s' "$branch" > "$cache_file" 2>/dev/null
  fi
fi

# Linear workspace slug — used to build clickable ticket links.
# Change this to your team's slug (the part after linear.app/ in any of your ticket URLs).
LINEAR_ORG_SLUG="teifi"

# Extract ticket id (wm-1234, WM-2882, etc.) when present; else use truncated full branch.
# When a ticket is found, also build the Linear URL so we can hyperlink it via OSC 8.
display_branch=""
ticket_url=""
if [[ -n "$branch" ]]; then
  ticket=$(printf '%s' "$branch" | grep -oE '[A-Za-z]+-[0-9]+' | head -1)
  if [[ -n "$ticket" ]]; then
    display_branch="$ticket"
    ticket_upper=$(printf '%s' "$ticket" | tr '[:lower:]' '[:upper:]')
    ticket_url="https://linear.app/${LINEAR_ORG_SLUG}/issue/${ticket_upper}"
  else
    if [[ ${#branch} -gt 24 ]]; then
      display_branch="${branch:0:23}…"
    else
      display_branch="$branch"
    fi
  fi
fi

# GitHub PR detection — always render when a PR exists for the current branch.
# Claude Code's built-in footer may also show it (its refresh behavior is undocumented
# and inconsistent — appears to refresh on terminal focus events). We accept the occasional
# duplicate as the price for never missing a freshly-opened PR.
pr_segment_num=""
pr_segment_url=""
if [[ -n "$branch" && -n "$cwd" && -d "$cwd" ]] && command -v gh >/dev/null; then
  pr_cache_dir="/tmp/claude-statusline-pr"
  mkdir -p "$pr_cache_dir" 2>/dev/null

  cwd_key=$(printf '%s' "$cwd" | shasum | awk '{print $1}')
  current_pr_file="$pr_cache_dir/current-$cwd_key.json"
  current_pr_age=99999
  [[ -f "$current_pr_file" ]] && current_pr_age=$(( $(date +%s) - $(stat -f %m "$current_pr_file" 2>/dev/null || echo 0) ))

  if (( current_pr_age > 60 )); then
    if [[ -f "$current_pr_file" ]]; then
      # Stale: refresh in background so the render stays fast
      ( (cd "$cwd" && gh pr view --json number,url,state 2>/dev/null) > "$current_pr_file.tmp" 2>/dev/null
        if [[ -s "$current_pr_file.tmp" ]]; then mv "$current_pr_file.tmp" "$current_pr_file"
        else echo '{}' > "$current_pr_file"; rm -f "$current_pr_file.tmp"; fi ) &
      disown 2>/dev/null || true
    else
      # First time for this cwd: sync fetch
      (cd "$cwd" && gh pr view --json number,url,state 2>/dev/null) > "$current_pr_file.tmp" 2>/dev/null
      if [[ -s "$current_pr_file.tmp" ]]; then
        mv "$current_pr_file.tmp" "$current_pr_file"
      else
        echo '{}' > "$current_pr_file"
        rm -f "$current_pr_file.tmp"
      fi
    fi
  fi

  # Only surface OPEN PRs — sidesteps Claude Code's known bug of showing closed/merged ones,
  # and matches the user's preference for "if it's open and exists, show it".
  pr_segment_num=$(jq -r 'select(.state == "OPEN") | .number' "$current_pr_file" 2>/dev/null)
  pr_segment_url=$(jq -r 'select(.state == "OPEN") | .url' "$current_pr_file" 2>/dev/null)
fi

# Truecolor helpers
fg() {
  local hex="$1"
  printf '\033[38;2;%d;%d;%dm' "0x${hex:1:2}" "0x${hex:3:2}" "0x${hex:5:2}"
}
RESET=$'\033[0m'
UNDERLINE=$'\033[4m'

# OSC 8 hyperlink helpers — wraps text so the terminal renders it as clickable.
# Modern terminals (Ghostty, iTerm2, Wezterm, Kitty, Alacritty) all support this.
osc8_open()  { printf '\033]8;;%s\007' "$1"; }
osc8_close() { printf '\033]8;;\007'; }

# Palette (Tailwind-ish)
C_BRANCH="#7dd3fc"      # sky-300
C_WORKTREE="#c084fc"    # purple-400
C_MODEL="#ede9fe"       # violet-100 — very pale body so the tag pops
C_MODEL_TAG="#c4b5fd"   # violet-300 — clear accent on the [1m] tag
C_SEP="#52525b"         # zinc-600
C_BAR_EMPTY="#3f3f46"   # zinc-700
C_PR="#fdba74"          # orange-300 — warm, more visibly orange

# Weather category palette — each weather code maps to its own color so the icon
# and temperature read as a coherent "mood" segment.
C_W_SUN="#fbbf24"       # amber-400 — sunny / clear, leans warm-orange
C_W_PCLOUD="#fef3c7"    # amber-100 — partly cloudy, paler and less saturated yellow
C_W_CLOUD="#cbd5e1"     # slate-300 — cloudy / overcast
C_W_FOG="#a1a1aa"       # zinc-400 — fog
C_W_THUNDER="#fde047"   # yellow-300 — thunder / storm
C_W_RAIN="#0ea5e9"      # sky-500 — rain, darker and bluer than cyan
C_W_SNOW="#cffafe"      # cyan-100 — snow, icy near-white
C_GREEN="#86efac"
C_YELLOW="#fde047"
C_ORANGE="#fb923c"
C_RED="#f87171"

if   (( pct_int >= 80 )); then C_CTX="$C_ORANGE"
elif (( pct_int >= 50 )); then C_CTX="$C_YELLOW"
else                            C_CTX="$C_GREEN"
fi

# Weather: current condition + temp, plus a "→ <icon> Xh" indicator for the upcoming change.
#   dry now + rain ≥50% in next 6h  →  → ⛆︎ Xh
#   raining now + clearing <30% in next 6h  →  → ☀ Xh
# Source: Open-Meteo (https://open-meteo.com) — free, no key. Uses KNMI's Harmonie model
# for the Netherlands (15-min refresh on current conditions) and falls back to global
# numerical models elsewhere. WMO weather codes 0–99.
# Geocoding cached permanently per location; weather cached 15 min, stale refresh in background.

# Set your city below. Open-Meteo requires coordinates, so we geocode the name once.
# Leave empty to skip the weather segment entirely.
WEATHER_LOCATION="Den Haag"

weather_loc_key=$(printf '%s' "${WEATHER_LOCATION:-none}" | tr -c '[:alnum:]_-' '_')
WEATHER_CACHE="/tmp/claude-statusline-weather-${weather_loc_key}.json"
WEATHER_COORDS="/tmp/claude-statusline-coords-${weather_loc_key}.json"

weather_icon=""
weather_temp=""
weather_color=""
transition_h=""
transition_icon=""

if [[ -n "$WEATHER_LOCATION" ]] && command -v curl >/dev/null && command -v jq >/dev/null; then
  # Geocode the location once (city coordinates don't change; cache permanently)
  if [[ ! -s "$WEATHER_COORDS" ]]; then
    geocode_url_loc="${WEATHER_LOCATION// /+}"
    curl -s --max-time 3 "https://geocoding-api.open-meteo.com/v1/search?name=${geocode_url_loc}&count=1&format=json" \
      > "$WEATHER_COORDS.tmp" 2>/dev/null
    if [[ -s "$WEATHER_COORDS.tmp" ]] && jq -e '.results[0].latitude' "$WEATHER_COORDS.tmp" >/dev/null 2>&1; then
      mv "$WEATHER_COORDS.tmp" "$WEATHER_COORDS"
    else
      rm -f "$WEATHER_COORDS.tmp"
    fi
  fi

  lat=""
  lon=""
  if [[ -s "$WEATHER_COORDS" ]]; then
    lat=$(jq -r '.results[0].latitude // empty' "$WEATHER_COORDS" 2>/dev/null)
    lon=$(jq -r '.results[0].longitude // empty' "$WEATHER_COORDS" 2>/dev/null)
  fi

  if [[ -n "$lat" && -n "$lon" ]]; then
    weather_age=99999
    [[ -f "$WEATHER_CACHE" ]] && weather_age=$(( $(date +%s) - $(stat -f %m "$WEATHER_CACHE" 2>/dev/null || echo 0) ))

    weather_url="https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&models=knmi_seamless&current=temperature_2m,weather_code&hourly=precipitation_probability,weather_code&forecast_hours=8&timezone=auto"

    if [[ ! -f "$WEATHER_CACHE" ]]; then
      curl -s --max-time 3 "$weather_url" > "$WEATHER_CACHE.tmp" 2>/dev/null
      if [[ -s "$WEATHER_CACHE.tmp" ]] && jq -e '.current.weather_code' "$WEATHER_CACHE.tmp" >/dev/null 2>&1; then
        mv "$WEATHER_CACHE.tmp" "$WEATHER_CACHE"
      else
        rm -f "$WEATHER_CACHE.tmp"
      fi
    elif (( weather_age > 900 )); then
      (curl -s --max-time 3 "$weather_url" > "$WEATHER_CACHE.tmp" 2>/dev/null
       if [[ -s "$WEATHER_CACHE.tmp" ]] && jq -e '.current.weather_code' "$WEATHER_CACHE.tmp" >/dev/null 2>&1; then
         mv "$WEATHER_CACHE.tmp" "$WEATHER_CACHE"
       else
         rm -f "$WEATHER_CACHE.tmp"
       fi) &
      disown 2>/dev/null || true
    fi

    if [[ -s "$WEATHER_CACHE" ]]; then
      weather_temp_raw=$(jq -r '.current.temperature_2m // empty' "$WEATHER_CACHE" 2>/dev/null)
      weather_temp="${weather_temp_raw%.*}"  # strip decimal
      weather_code=$(jq -r '.current.weather_code // empty' "$WEATHER_CACHE" 2>/dev/null)

      # WMO weather codes (0–99) → icon + color.
      # Reference: https://open-meteo.com/en/docs (Weather variable documentation)
      weather_color="$C_W_SUN"
      case "$weather_code" in
        0)                                              weather_icon="☀";   weather_color="$C_W_SUN" ;;
        1|2)                                            weather_icon="⛅︎"; weather_color="$C_W_PCLOUD" ;;
        3)                                              weather_icon="☁︎"; weather_color="$C_W_CLOUD" ;;
        45|48)                                          weather_icon="≋";  weather_color="$C_W_FOG" ;;
        51|53|55|56|57|61|63|65|66|67|80|81|82)         weather_icon="⛆︎"; weather_color="$C_W_RAIN" ;;
        71|73|75|77|85|86)                              weather_icon="❄";  weather_color="$C_W_SNOW" ;;
        95|96|99)                                       weather_icon="⚡︎"; weather_color="$C_W_THUNDER" ;;
        *)                                              weather_icon="☀";   weather_color="$C_W_SUN" ;;
      esac

      if [[ -n "$weather_temp" ]]; then
        is_raining=false
        case "$weather_code" in
          51|53|55|56|57|61|63|65|66|67|80|81|82|95|96|99) is_raining=true ;;
        esac

        # Open-Meteo hourly arrays: index 0 = current hour boundary, index 1 = next full hour.
        # We look at indices 1..6 to find the first hour where the forecast crosses the threshold.
        if [[ "$is_raining" == "true" ]]; then
          trans_h=$(jq -r '(.hourly.precipitation_probability[1:7] // []) | to_entries | map(select((.value | tonumber? // 100) < 30)) | if length > 0 then (.[0].key + 1) else empty end' "$WEATHER_CACHE" 2>/dev/null)
          transition_icon="☀"
        else
          trans_h=$(jq -r '(.hourly.precipitation_probability[1:7] // []) | to_entries | map(select((.value | tonumber? // 0) >= 50)) | if length > 0 then (.[0].key + 1) else empty end' "$WEATHER_CACHE" 2>/dev/null)
          transition_icon="⛆︎"
        fi

        if [[ -n "$trans_h" && "$trans_h" != "null" && "$trans_h" -gt 0 ]]; then
          transition_h="$trans_h"
        fi
      fi
    fi
  fi
fi

# Rate limit (5h) — same threshold gradient
rate_5h_int=""
if [[ -n "$rate_5h" ]]; then
  rate_5h_int=${rate_5h%.*}
  rate_5h_int=${rate_5h_int:-0}
  if   (( rate_5h_int >= 100 )); then C_RATE="$C_RED"
  elif (( rate_5h_int >= 80 ));  then C_RATE="$C_ORANGE"
  elif (( rate_5h_int >= 50 ));  then C_RATE="$C_YELLOW"
  else                                C_RATE="$C_GREEN"
  fi
fi

# 10-segment bar — same character throughout, color shows progress
bar_filled=$(( (pct_int + 5) / 10 ))
(( bar_filled < 0 )) && bar_filled=0
(( bar_filled > 10 )) && bar_filled=10
filled_part=""
empty_part=""
for ((i = 0; i < bar_filled; i++)); do filled_part+="▰"; done
for ((i = bar_filled; i < 10; i++)); do empty_part+="▰"; done

SEP="$(fg "$C_SEP")  ·  $RESET"

out=""

if [[ -n "$worktree" ]]; then
  out+="$(fg "$C_WORKTREE")⎈ $worktree$RESET$SEP"
fi

if [[ -n "$display_branch" ]]; then
  if [[ -n "$ticket_url" ]]; then
    out+="$(osc8_open "$ticket_url")$(fg "$C_BRANCH")⎇ ${UNDERLINE}${display_branch}$RESET$(osc8_close)"
  else
    out+="$(fg "$C_BRANCH")⎇ $display_branch$RESET"
  fi
else
  out+="$(fg "$C_SEP")⎇ —$RESET"
fi

out+="$SEP$(fg "$C_CTX")⌖ ${filled_part}$(fg "$C_BAR_EMPTY")${empty_part}$(fg "$C_CTX")  ${pct_int}%$RESET"

if [[ -n "$rate_5h_int" ]]; then
  reset_str=""
  if [[ -n "$rate_5h_reset" ]]; then
    remaining=$(( rate_5h_reset - $(date +%s) ))
    if (( remaining > 0 )); then
      reset_str=$(printf ' %d:%02d' "$((remaining / 3600))" "$(( (remaining % 3600) / 60 ))")
    fi
  fi
  out+="$SEP$(fg "$C_RATE")⧗ ${rate_5h_int}%${reset_str}$RESET"
fi

if [[ -n "$model" ]]; then
  out+="$SEP$(fg "$C_MODEL")$model$RESET"
  if [[ "$model_id" == *"[1m]"* ]]; then
    out+="$(fg "$C_MODEL_TAG") [1m]$RESET"
  fi
fi

if [[ -n "$weather_temp" ]]; then
  out+="$SEP$(fg "$weather_color")${weather_icon} ${weather_temp}°$RESET"
  if [[ -n "$transition_h" ]]; then
    # Transition inherits the destination icon's category color, so "→ ☀ 2h" reads
    # amber (clearing) and "→ ☔ 3h" reads cyan (rain coming).
    case "$transition_icon" in
      "☀") transition_color="$C_W_SUN" ;;
      "⛆︎") transition_color="$C_W_RAIN" ;;
      *)   transition_color="$C_W_CLOUD" ;;
    esac
    out+="$(fg "$transition_color")  → ${transition_icon} ${transition_h}h$RESET"
  fi
fi

if [[ -n "$pr_segment_num" ]]; then
  out+="$SEP$(osc8_open "$pr_segment_url")$(fg "$C_PR")PR ${UNDERLINE}#${pr_segment_num}$RESET$(osc8_close)"
fi

printf '%s' "$out"
