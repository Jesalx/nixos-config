---
paths:
  - "**/*_test.go"
---

# Go Testing Preferences

## Tests Are the Specification

- **Existing test expectations are authoritative.** Never modify assertions
  without explicit user confirmation that the behavioral contract has changed.
  When tests fail, present the details (which tests, expected vs. actual, and
  why) and let the user decide the fix. Structural refactors (e.g. converting
  to table-driven) are always fine.
- **Proactively increase coverage.** When writing or modifying code, add tests
  for uncovered edge cases, error paths, and boundary conditions — don't wait
  to be asked.

## Style

- Use table-driven tests as the default pattern: named struct cases, `t.Run`
  subtests, `errors.Is` for error comparison.
- Use `t.Parallel()` in tests and subtests where safe.
- Prefer real implementations (in-memory stores, temp dirs) over mocks. Only
  mock at true external boundaries.
- Always run tests with `-race`. Benchmark before optimizing with `testing.B`.
- Test helpers must call `t.Helper()` as their first line so failures report
  the caller's location.
- Use `cmp.Diff` for comparing structs and complex types — it produces readable
  diffs in failure output.
- Use `t.Fatalf` when a failure would cause subsequent lines to panic, `t.Errorf`
  otherwise to continue collecting failures.
