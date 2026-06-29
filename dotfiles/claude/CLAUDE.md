# Global Defaults

## Think Before Coding

- State assumptions explicitly before non-trivial work. If uncertain, ask
  rather than guess.
- If multiple interpretations exist, present them; do not pick one silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop, name what is confusing, and ask.

## Simplicity First

- Write the minimum code that solves the stated problem. Nothing speculative.
- No features beyond what was asked, no configurability or abstractions for
  single-use code, no error handling for scenarios that cannot occur.
- If it could be substantially shorter without losing correctness or clarity,
  rewrite it. Test: would a senior engineer call this overcomplicated?

## Surgical Changes

- Every changed line should trace to the current request. Match existing
  style, even where you would do it differently.
- Do not refactor, reformat, or "improve" adjacent code. If you spot unrelated
  dead code or a problem, mention it; do not delete or fix it unprompted.
- Remove imports, variables, and functions your own changes orphaned. Leave
  pre-existing dead code unless asked.

## Goal-Driven Execution

- Prefer verifiable success criteria over imperative steps, then loop until
  they are met.
- Turn tasks into checks: "fix the bug" becomes write a failing test that
  reproduces it, then make it pass; "refactor X" becomes ensure tests pass
  before and after.
- For multi-step work, state a brief plan with a verification step for each.

## Project Conventions

- Use `jj`, not `git`, for version control.
- Fail fast. Never silently swallow errors or proceed in a broken state.
- Never weaken or remove test assertions to make tests pass. Fix the
  implementation, not the test.
- Add doc comments per the language's conventions. Add inline comments only
  when the _why_ is not obvious, never to explain _what_ the code does.
- When changes introduce or modify a convention, dependency, or architectural
  pattern, update the project CLAUDE.md. This is the one sanctioned exception
  to Surgical Changes; keep the edit minimal.

## Dependencies

- Prefer the standard library. Do not add new dependencies without explicit
  approval.

## Security

- Never commit or hardcode secrets, credentials, API keys, or tokens. Use
  environment variables or a secret manager.
- If a file looks like it holds secrets (`.env`, `credentials.json`, `*.pem`)
  or you find an exposed secret, flag it before staging or committing.

## Writing Style

- No em dashes in generated content, docs, or edits. Use commas, parentheses,
  colons, or separate sentences.

## Verifying Claims

- For factual claims about code behavior, storage, or data structures, verify
  against the source and cite `file:line`. If you cannot cite it, say
  "unverified" instead of asserting.
- Do not rationalize existing code. If something looks wrong, flag it.
