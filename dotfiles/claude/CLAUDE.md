# Global Defaults

## Think Before Coding

- Before non-trivial work, state assumptions and surface any ambiguity.
- If a request has multiple plausible interpretations, or something is unclear,
  ask rather than guess. Do not silently pick one.

## Simplicity First

- Write the minimum code that solves the stated problem. Nothing speculative:
  no features beyond what was asked, no configurability or abstractions for
  single-use code, no error handling for scenarios that cannot occur.
- If a simpler approach exists, propose it before implementing. Push back when
  a request is more complex than its goal requires.
- Test: would a senior engineer call this overcomplicated? If it could be
  shorter without losing correctness or clarity, rewrite it.

## Surgical Changes

- Every changed line must trace to the current request. Match existing style,
  even where you would do it differently.
- Do not refactor, reformat, or "improve" adjacent code. Flag unrelated dead
  code or problems; do not delete or fix them unprompted.
- Remove imports, variables, and functions your own changes orphaned. Leave
  pre-existing dead code unless asked.

## Goal-Driven Execution

- Prefer verifiable success criteria over imperative steps, then loop until
  they are met. Turn tasks into checks: "fix the bug" becomes write a failing
  test that reproduces it, then make it pass; "refactor X" becomes ensure tests
  pass before and after.
- For multi-step work, state a brief plan with a verification step for each.
- Show evidence, not assertions. Report the command you ran and its output
  (test results, build exit code, diff), rather than claiming success.

## Conventions

- Use `jj`, not `git`, for version control.
- Fail fast. Never silently swallow errors or proceed in a broken state.
- IMPORTANT: never weaken or remove test assertions to make a test pass. Fix
  the implementation, not the test.
- Add doc comments per the language's conventions. Add inline comments only
  when the _why_ is not obvious, never to explain _what_ the code does.
- When a change introduces or modifies a convention, dependency, or
  architectural pattern, update the project CLAUDE.md. This is the one
  sanctioned exception to Surgical Changes; keep the edit minimal.
- Project-specific build, test, lint, and run commands belong in each project's
  CLAUDE.md, not here.

## Dependencies

- Prefer the standard library. Do not add new dependencies without explicit
  approval.

## Security

- IMPORTANT: never commit or hardcode secrets, credentials, API keys, or
  tokens. Use environment variables or a secret manager.
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
