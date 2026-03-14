---
name: desc
description: Generate a conventional commit description for current jj changes and apply it with jj desc
disable-model-invocation: true
---

Generate a conventional commit message for the current changes and apply it.

Steps:

1. Run `jj diff` to review the current changes
2. Analyze the changes and produce a commit message following the format below
3. Apply it by running: `jj desc --stdin <<'EOF'
<message>
EOF`

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
- Bullet points are optional — only include them if they add meaningful detail not already clear from the first line
- Maximum 3 bullet points; use fewer if fewer are warranted
- Bullet points should cover _why_ or _what specifically_, not restate the summary
- There must be a blank line between the summary and the bullet points
- Do not include the ``` fences in the applied message
- After applying, output the final message so the user can see what was set
