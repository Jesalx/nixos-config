---
path: **/.github/workflows/**
---

# GitHub Actions

## Workflow structure

- Every workflow must include `workflow_dispatch` so it can be triggered manually
- Use `paths` filters on push/pull_request triggers to avoid unnecessary runs —
  always include the workflow file itself in the paths list
- Prefer parallel independent jobs (format, lint, test) over a single sequential job
- Name workflows and jobs in lowercase for consistency (e.g., `name: neovim`,
  `name: format`)

## Performance

- Cache language-specific dependencies (module caches, build caches, package
  manager caches) to avoid redundant downloads and rebuilds

## Security

- Never hardcode secrets — use `${{ secrets.* }}` or `${{ github.token }}`
- Use `${{ github.token }}` (scoped to the repo) over `${{ secrets.GITHUB_TOKEN }}`
  where the default token permissions suffice
- Avoid `pull_request_target` unless you understand the security implications —
  prefer `pull_request` for PR-triggered workflows

## Testing and validation

- After editing a workflow, validate with `actionlint` if available
- When adding a new tool or linter, add both a CI job and local tooling so
  developers can run the same checks locally
- Use matrix strategies for testing across multiple versions when applicable

## Style

- Scope `env:` to the narrowest level needed — prefer step-level over job-level
  over workflow-level to avoid unintended variable leakage between steps/jobs
- Use `run: |` (literal block scalar) for multi-line shell commands
- Keep step names descriptive but concise (e.g., "Install dependencies", "Check formatting")
- Group related setup steps (checkout, install, cache) before action steps
