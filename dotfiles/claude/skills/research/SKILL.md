---
name: research
description: Research the codebase to answer a question. Spawns multiple Explore agents with overlapping scopes so their findings cross-check each other, writes a full report to $NOTES_DIR/<project>/<timestamp>-<slug>.md (alongside the project's <project>.md notes), then gives the user a direct summary.
user-invocable: true
disable-model-invocation: true
argument-hint: <question or topic to research>
allowed-tools: Agent, Bash(mkdir *), Bash(date *), Bash(jj root), Bash(git rev-parse *), Bash(pwd), Bash(basename *), Read, Write, Grep, Glob
---

## Query

$ARGUMENTS

If empty, ask for a topic and stop.

## Process

### 1. Pick a path

Determine the project name: basename of the current repo root, or basename of `pwd` if not in a repo. Try in order: `jj root 2>/dev/null`, then `git rev-parse --show-toplevel 2>/dev/null`, then `pwd`. Take `basename` of the result.

If `$NOTES_DIR` is not set, stop and tell the user to export it in their environment.

`$DIR = $NOTES_DIR/<project>`
`$FILE = $DIR/<timestamp>-<slug>.md`

- **Timestamp**: `date +%Y-%m-%d-%H%M`.
- **Slug**: 2-5 word kebab-case from the query. Lowercase ASCII, drop filler words, no trailing dash. Examples: `cache-invalidation`, `http-client-retry`.

`mkdir -p "$DIR"` (creates the project subdirectory if it does not exist). If `$FILE` already exists, append `-2`, `-3`, etc. before `.md`. Report path: `$FILE`.

### 2. Plan overlapping scopes

Three scopes that overlap on the core subject so agents independently observe the same key files:

- **A (Breadth)**: subsystem map, entry points, main types, layout.
- **B (Depth)**: follow the specific code path end to end.
- **C (Perimeter)**: callers, tests, config, docs, recent history. Real usage and edge cases.

### 3. Dispatch agents in parallel

Call `Agent` three times in a single message with `subagent_type: Explore`. Each prompt includes:

- The original query, verbatim.
- The scope (A, B, or C).
- **"Use very thorough exploration depth. Explore thoroughly. Report tersely. Cut framing, not evidence."**
- Note: two other agents run in parallel for cross-check; cite evidence, don't summarize from memory.
- Output contract (Markdown):
  - `## Answer` — direct answer from this vantage.
  - `## Evidence` — numbered claims with `path/to/file:line` citations. Claims can run 1-4 sentences; code quotes up to ~10 lines are allowed when a citation alone would not show the point.
  - `## Uncertain` — anything unverified.
  - `## Files examined` — one comma-separated line, no descriptions.
- Style rules: target ~1000 words total (soft; use more if nuance truly needs it). No intro, preamble, or conclusion paragraphs. Do not restate the query or scope. No "I examined X to understand Y" narration. When trimming, cut framing first; never cut evidence or citations.

### 4. Cross-check findings

1. **Agreements**: claims by 2+ agents about the same symbol, file, or behavior agreeing in substance (lines need not match). Mark **confirmed**.
2. **Single-source**: if material, re-read the cited `file:line`. Mark **confirmed** if it checks out, **unverified** otherwise.
3. **Conflicts**: read the cited files directly; if still ambiguous, dispatch one targeted Explore agent (tell it to use medium exploration depth and a narrow scope) to adjudicate. If unresolved, drop the claim from "Findings" and move it to "Open Questions" phrased with explicit uncertainty.

### 5. Write the report

The report is an answer to the user's question, not a log of how it was researched. It must not reference agents, scopes, cross-checks, adjudication, or any internal process. No confidence labels on findings.

Cross-check results are a filter, not a section: include a finding only if it was corroborated by 2+ agents or you re-read the cited `file:line` and verified it yourself. Everything else goes to "Open Questions" or is phrased with explicit uncertainty in the prose (still cited).

Write to `$FILE`:

```markdown
# <original query>

_<date>_

## Summary

<Direct answer to the question. Lead with the answer, then the key supporting facts. No longer than needed.>

## Findings

1. <one-sentence claim>. Evidence: `path/to/file:line`, `path/to/other:line`.
2. ...

## Open Questions

<Anything the codebase does not answer, or where evidence was insufficient. Omit this section if none.>
```

### 6. Respond to the user

1. Path to the report.
2. The summary text.

Don't paste the full report into chat.

## Rules

- Write the report before answering. The file is the source of truth.
- If the query is too ambiguous to scope, ask one clarifying question before dispatching.
- Dispatch agents in parallel (one message, multiple calls). Never serialize.
