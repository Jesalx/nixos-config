---
paths:
  - "**/rules/**/*.md"
---

# Rule Files

Rules capture stable preferences and conventions that Claude should apply
when working on matching files. Keep them declarative and imperative. They
are a reference, not a narrative.

## Location and Discovery

- Rules live in `~/.claude/rules/` (user) or `.claude/rules/` (project).
  Claude Code discovers them automatically.
- The canonical source can live outside `~/.claude/` (e.g. a dotfiles repo)
  and be symlinked into place.
- Rules without `paths:` load every session, alongside `CLAUDE.md`.
  Path-scoped rules load only when Claude reads a matching file.

## Frontmatter

- Omit frontmatter for universal rules (e.g. TDD, cross-cutting style).
- Add `paths:` to scope a rule to specific files, frameworks, or directories.
- Use the YAML array form when listing multiple globs. A single glob may
  use the scalar form.

```yaml
---
paths:
  - "**/*.go"
  - "**/go.mod"
---
```

- Be specific with globs. `"**/*.go"` is right for Go rules; `"**/*"` defeats
  the point of scoping.
- Use `**/` to match at any depth. Patterns are matched against file paths,
  not directory paths.

## Scope and Splitting

- One topic per file. Topics are languages, frameworks, tools, or practices.
- Split when a file mixes concerns. The `go.md` (language idioms) and
  `go-test.md` (testing conventions) pair is the canonical split.
- Never create a `utils.md`, `misc.md`, or `general.md`. If a rule does not
  fit a topic, it belongs in global `CLAUDE.md`.
- Each rule stands alone. Avoid cross-file references.

## Naming

- Kebab-case for multi-word filenames: `go-test.md`, `github-actions.md`.
- Topic-first: `go-test.md`, not `test-go.md`.
- Name by the topic, not the path glob it scopes to.

## Voice and Format

- Imperative bullets: "Use X", "Prefer Y", "Never Z". State the rule
  directly.
- Include a brief _why_ only when the rule would surprise the reader. Do
  not explain what the rule is. The rule is the bullet.
- Be concise and idiomatic. Prefer the shortest phrasing that preserves
  meaning. Use the terminology the target community uses.
- `##` for top-level sections. `###` rarely needed; flatter is better.
- An optional short intro paragraph at the top is useful for framing
  philosophy (see `tdd.md`, `go.md`).
- Use **bold** sparingly for key terms inline. Avoid walls of bold.
- Code samples only when the convention is easier to show than describe.
- Do not qualify rules with language or tool versions (e.g. "in Go 1.22+",
  "since Terraform 1.5"). Rules assume the latest stable version. Write the
  rule as current practice.
- Avoid em dashes and hyphens as sentence punctuation. Use periods, commas,
  colons, or parentheses. Hyphens in compound words (e.g. `kebab-case`,
  `path-scoped`) are fine.

## Maintenance

- Rules are stable preferences, not ephemeral notes. If it changes weekly,
  it does not belong here.
- Delete rules that no longer reflect current preferences. Stale rules are
  worse than missing ones.
- When adding a new rule, check whether an existing file already owns the
  topic. Extend before creating.
