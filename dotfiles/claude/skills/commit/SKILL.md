---
name: commit
description: Generate a conventional commit description for current jj changes, apply it with jj desc, then start a new change with jj new
disable-model-invocation: true
allowed-tools: Bash(jj diff *), Bash(jj desc *), Bash(jj new *)
---

Generate a conventional commit message for the current changes and apply it.

Steps:

1. Run `jj diff` to review the current changes
2. Analyze the changes and produce a commit message following the format below
3. Apply it by running: `jj desc --stdin <<'EOF'
<message>
EOF`
4. Run `jj new` to start a new change

Format:

```
<type>(<optional scope>): <short summary>

- <detail>
- <detail>
```

Rules:

- First line must follow Conventional Commits: type(scope): summary
  - Types: feat, fix, refactor, chore, docs, test, perf, ci, build, style
  - Scope is optional but use it when the change is clearly scoped to a module/package
  - Summary is lowercase, imperative mood, no period, max 72 chars
- When changes span multiple concerns:
  - Find the unifying intent or theme — what is this changeset _for_? Use that as the summary
  - If no single theme exists, use the highest-impact or primary change as the summary; secondary changes go in bullets
  - If changes span multiple types, pick the dominant type (e.g. a new feature with accompanying tests is still `feat`, not `test`)
  - If changes span multiple scopes, either use the parent scope or omit the scope entirely
  - Never list changes in the summary line (e.g. avoid "add x, fix y, update z")
- Bullet points are optional — only include them if they add meaningful detail not already clear from the first line
- Maximum 3 bullet points; use fewer if fewer are warranted
- Bullet points should cover _why_ or _what specifically_, not restate the summary
- There must be a blank line between the summary and the bullet points
- Do not include the ``` fences in the applied message
- After applying, output the final message so the user can see what was set
