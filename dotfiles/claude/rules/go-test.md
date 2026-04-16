---
paths:
  - "**/*.go"
---

# Go Testing Preferences

## Tests Are the Specification

- **Existing test expectations are authoritative.** Never modify assertions
  without explicit user confirmation that the behavioral contract has changed.
  When tests fail, present the details (which tests, expected vs. actual, and
  why) and let the user decide the fix. Structural refactors (e.g. converting
  to table-driven) are always fine.
- **Proactively increase coverage.** When writing or modifying code, add tests
  for uncovered edge cases, error paths, and boundary conditions without
  waiting to be asked.

## Style

- Use table-driven tests as the default pattern: named struct cases, `t.Run`
  subtests, `errors.Is` for error comparison.
- Use `t.Parallel()` in tests and subtests where safe.
- Use `t.Context()` instead of `context.Background()` in tests that need a
  context. It cancels when the test ends.
- Prefer `t.Cleanup` over `defer` in tests. It runs at test end, so helpers
  can register their own teardown.
- Prefer real implementations (in-memory stores, temp dirs, `httptest.NewServer`)
  over mocks. Only mock at true external boundaries.
- Always run tests with `-race`. Benchmark before optimizing with `testing.B`.
- Use `cmp.Diff` (`github.com/google/go-cmp/cmp`) for comparing structs and
  complex types. It produces readable diffs in failure output.
- Use `t.Fatalf` when a failure would cause subsequent lines to panic, `t.Errorf`
  otherwise to continue collecting failures.

## Test Helpers and `testing.TB`

- Test helpers must call `tb.Helper()` as their first line so failures report
  the caller's location.
- Accept `testing.TB` instead of `*testing.T` in helpers that only use shared
  methods (`Helper`, `Fatal`, `Cleanup`, `TempDir`, etc.). This makes helpers
  reusable across tests, benchmarks, and fuzz functions. Narrow to the concrete
  type only when you need type-specific methods (`t.Run`, `b.ResetTimer`).

## Test Fixtures and `testdata/`

- Store test fixtures, sample inputs, and golden files in a `testdata/`
  directory within the package. The Go toolchain ignores `testdata/` during
  build.
- Reference fixtures with relative paths (`"testdata/input.json"`). `go test`
  sets the working directory to the package's source directory.
- For script-style or integration tests with multiple related files per case,
  use `txtar` (`golang.org/x/tools/txtar`) to pack them into one archive.

## Golden File Tests

- Use golden files when the output under test is large, complex, or most
  readable as a whole (formatted text, serialized data, code generation output).
- Define a package-level flag for regeneration:
  `var update = flag.Bool("update", false, "update golden files")`
- Write to the golden file when `-update` is set, then read and compare.
  Include a re-run hint in failure messages.
- Derive golden file paths from `t.Name()` so subtests each get their own file
  (e.g. `filepath.Join("testdata", t.Name()+".golden")`).
- Commit golden files to version control. Diffs in review are the point.
