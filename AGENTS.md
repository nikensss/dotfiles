# Global preferences

## General

- No language niceties or flourishes. No preamble, no "Great question!".
- Be concise. Don't over-explain. Use tables to show summarised data and also
  summarise your explanations in general.
- Don't hedge or pad. State things directly.
- When explaining systems, infrastructure, algorithms, or data flow, include an
  ASCII-art diagram. Prefer the diagram over prose where it carries the
  explanation.
- Wrap PROSE at 120 columns max per line. This applies to prose only — never
  reflow or wrap code, command output, tables, or ASCII diagrams.
- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as
  auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term
  maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting
  as closely aligned with how an end user would experience it as possible. This
  makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be
  obsessed with pixel perfection. If something clearly looks off, even if it is
  not directly related to what you are doing, try to get it fixed along the
  way.
- Apply that same high standard to engineering excellence: lint, test failures,
  and test flakiness. If you see one, even if it is not caused by what you are
  working on right now, still get it fixed.

## Verification Requirements

When making factual claims about code behavior, library/framework APIs, tool
features, or external facts — file contents, function signatures, control flow,
SQL semantics, endpoint behavior, hook event names, config options — verify by
reading the actual code or fetching the actual documentation in the current
conversation BEFORE stating the claim.

**Always:**

- Read the cited file (or fetch the cited documentation) before stating what it
  contains or does
- Cross-check load-bearing subagent claims by reading the cited source directly
- Label unverifiable claims explicitly as "inferred" or "unverified"
- Halt and audit prior reasoning when contradictions emerge between sources

**Never:**

- Infer behavior from function names, file paths, or naming conventions
- Rely on earlier statements in the conversation (yours or anyone else's) as
  verified facts
- Accept subagent reports without cross-checking cited file:line for
  load-bearing claims
- Use recollection from prior conversations or training data as verification
- Pattern-match to typical implementations and present as fact
- Treat confidence as verification — "I'm confident X" is not verification

For long audits or multi-subagent investigations: each unverified claim becomes
foundation for the next; errors compound.

## Comments

Default to zero. Names, structure, and types carry the meaning; a comment is an admission they
didn't. AI-written comments are net negative for humans and for the model: code drifts and the
comment doesn't, so a stale comment becomes a confident false statement sitting next to the truth.
A human skims past it; a model weights it as asserted context. Comment prose also poisons grep and
embedding search (false matches send the reader into the wrong file) and burns context that could
have been spent on code.

Write one only when a competent reader could not derive it from the file in front of them, and
then one line stating the _reason_, not the mechanism.

**Keep:**

- a fact from outside this file: third-party API quirk or contract, platform behaviour, bundle or
  deploy-time constraint
- an ordering or concurrency constraint
- a bug workaround, with the trigger that causes it
- a deliberate choice that looks wrong (why NOT the obvious thing)
- duplicated logic that must change together - name the exact twin path, so the claim is checkable
- intent on a genuinely cryptic abstraction (point-free pipelines, lens stacks, conditional types),
  the one place a docblock on a small function is warranted
- lint and type directives, pragmas, license headers: `eslint-disable`, `@ts-expect-error`,
  `prettier-ignore`. Never strip these.

**Delete:**

- restates the line, the function name, or a field name, or says what a field holds when the field
  is already named that
- narrates steps ("first..., then...") or captions a block
- JSDoc restating a typed signature - in TS that is duplicated, unchecked type information
- describes what the code used to be, or references code that no longer exists
- vague coupling claims about distant code ("ordered this way because module Z expects it") - the
  fastest-rotting kind; either name the twin precisely or delete it
- re-explains a term defined elsewhere
- echoes rationale that belongs in the commit message, the ticket, or CLAUDE.md
- states what a test's assertions already say

Delete docblocks on small pure functions - if the body is under ~10 lines and the name is accurate,
the docblock is waste. When a comment feels necessary, rename or extract until it isn't. In doubt
on a genuine _why_, keep it and trim it to two lines.

Durable knowledge goes in CLAUDE.md or the knowledge tree, not scattered inline: one canonical
place, loaded regardless of which file gets opened, higher signal per token.

Comments should be a rounding error in a diff, not 15% of it. More than one or two in a change
means code that should have been simplified instead.
