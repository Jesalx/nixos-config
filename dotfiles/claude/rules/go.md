---
paths:
  - "**/*.go"
---

# Go Development Preferences

## Core Philosophy

Write clear, simple, idiomatic Go. Prefer readability over cleverness. Use
modern Go practices and idioms — leverage the latest language features and
standard library additions.

## Standard Library First

Always reach for the standard library before introducing a dependency. Only
introduce external modules when the standard library genuinely cannot cover the
need, and prefer well-maintained, narrowly scoped modules over large frameworks.

## Error Handling

- Always handle errors explicitly. Never discard an error with `_` unless there
  is a comment explaining why it is safe to do so.
- Wrap errors with context using `fmt.Errorf("doing thing: %w", err)`.
- Define sentinel errors with `var ErrNotFound = errors.New("not found")` at
  package level when callers need to match on them.
- Define custom error types only when callers need to extract structured data.
- Return early on errors to keep the happy path unindented.

## Interfaces

- Keep interfaces small — one or two methods is ideal.
- Define interfaces at the **consumer** site, not the provider.
- Accept interfaces, return concrete types.

## Package Design

- Packages should be small and focused around a single responsibility.
- Avoid a `utils`, `helpers`, or `common` package — find a meaningful name or
  inline the code.
- Avoid deeply nested directories. A flat-ish structure is idiomatic for most
  projects.

## Context

- Pass `context.Context` as the first parameter to any function that does I/O,
  makes an outbound call, or may block.
- Propagate the caller's context — do not store it in a struct.
- Never create `context.Background()` deep in a call chain; pass the context
  down from the top level.
- Use `context.WithoutCancel` when work must outlive the request (e.g. async
  cleanup) rather than creating a new `context.Background()`.

## Concurrency

- Always ensure goroutines can be stopped. Accept a `context.Context` or provide
  a shutdown/close mechanism.
- Prefer channels over mutexes for coordinating between goroutines. Use
  `sync.Mutex` only when protecting simple shared state where a channel would
  add unnecessary complexity.
- Use `sync.WaitGroup` for fan-out work where all goroutines should run to
  completion. Use `errgroup.Group` when you want fail-fast cancellation on the
  first error.

## Testing

- Use table-driven tests as the default pattern.
- Use `t.Parallel()` in tests and subtests where safe to enable concurrent
  test execution.
- Use `httptest.NewServer` for HTTP integration tests.
- Prefer real implementations (in-memory stores, temp dirs) over mocks. Only
  mock at true external boundaries.
- Always run tests with `-race`: `go test -race ./path/to/package`.
- Benchmark before optimizing: use `testing.B` and `go test -bench`.

```go
func TestParseSize(t *testing.T) {
    t.Parallel()

    tests := []struct {
        name    string
        input   string
        want    int64
        wantErr error
    }{
        {name: "bytes", input: "512B", want: 512},
        {name: "kilobytes", input: "1KB", want: 1024},
        {name: "empty", input: "", wantErr: ErrInvalidSize},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel()

            got, err := ParseSize(tt.input)
            if !errors.Is(err, tt.wantErr) {
                t.Fatalf("ParseSize(%q) error = %v, wantErr %v", tt.input, err, tt.wantErr)
            }
            if got != tt.want {
                t.Errorf("ParseSize(%q) = %d, want %d", tt.input, got, tt.want)
            }
        })
    }
}
```

## Documentation and Comments

- Every exported identifier gets a doc comment starting with its name.
- Write comments that explain **why**, not **what**. The code shows what.

## Code Formatting and Tooling

- All code must pass `gofmt` / `goimports`.
- Run `go vet ./...` scoped to packages with changed files.
- Run `golangci-lint run` scoped to packages with changed files only.
- Run `go mod tidy` after dependency changes.

## Miscellaneous Preferences

- Use struct literals with field names: `Point{X: 1, Y: 2}`, not `Point{1, 2}`.
- Use `defer` for cleanup — but be aware of its performance in tight loops.
- Use `make` with a size hint when the slice/map length is known or estimable.
- Prefer `slices`, `maps`, and `cmp` packages over hand-rolled loops for
  sorting, searching, collecting keys, etc.
- Prefer `strings.Builder` for building strings in loops.
- Use `time.Duration` in APIs, never bare `int` seconds or milliseconds.
- Accept `io.Reader` / `io.Writer` in functions that process streams rather than
  `[]byte` or `string`, to allow callers flexibility.
