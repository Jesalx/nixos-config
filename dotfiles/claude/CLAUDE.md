# Global Defaults

## Behavior

- Always run tests/linting after code changes if a test command is available
- Add doc comments following the language's conventions
- Only add inline comments when the _why_ isn't obvious from context, never
  to explain _what_ code does
- Prefer built-in tools (Glob, Grep, Read, Edit, etc) over Bash equivalents
- Use `jj` instead of `git` for version control
- Fail fast. Never silently swallow errors or proceed in a broken state.

## Code Style

- Prefer explicit over implicit
- Keep functions small and single-purpose
- Match the style of surrounding code rather than imposing your own
- Prefer idiomatic code following best practices and conventions of the language/framework

## Dependencies

- Prefer the standard library over third-party packages.
- Do not add new dependencies without explicit approval from the user.

## Security

- Never commit secrets, credentials, API keys, or tokens. If a file looks
  like it contains secrets (`.env`, `credentials.json`, `*.pem`, etc.), warn
  before staging or committing.
- Never hardcode secrets in source code. Use environment variables, secret
  managers, or framework-specific secret mechanisms.
- If you encounter an exposed secret in the codebase, flag it immediately.

## Communication

- If uncertain, say so rather than guessing
