---
paths:
  - "**/*.go"
  - "**/go.mod"
  - "**/go.sum"
---

# Go Development Preferences

Write clear, simple, idiomatic Go. Prefer readability over cleverness. Use
modern Go practices and leverage the latest language features and standard
library additions. Prefer the standard library and `golang.org/x/` packages.
Never add other external packages unless explicitly instructed by the user.

## Error Handling

- Always handle errors explicitly. Never discard an error with `_` unless there
  is a comment explaining why it is safe to do so.
- Wrap errors with context using `fmt.Errorf("doing thing: %w", err)`.
- Use `errors.Is` for sentinel matches, `errors.As` for type extraction.
  Never use `==` except against `nil`.
- Define sentinel errors (`var ErrNotFound = errors.New("not found")`) at
  package level when callers need to match on them. Define custom error types
  only when callers need to extract structured data; otherwise prefer sentinels
  or wrapped strings.
- Return early on errors to keep the happy path unindented.

## Interfaces

- Keep interfaces small.
- Define interfaces at the **consumer** site, not the provider.
- Accept interfaces, return concrete types.

## Generics

- Prefer concrete types and interfaces by default. Use generics when the logic
  is truly type-independent and you would otherwise duplicate code across types.
- Constrain type parameters as tightly as possible. Prefer `cmp.Ordered`,
  `comparable`, or a named constraint over `any`.

## Enums and Constants

- Use `iota` in a `const` block for related integer constants. Start with a
  meaningful name, not a blank identifier, so zero values are explicit.
- Add a `String() string` method so enum values are readable in logs and
  errors.
- Prefer string-typed constants (`type Status string`) when values are
  serialized to JSON/YAML or appear in external APIs. Use `iota` when values
  are internal and ordering or bitwise operations matter.

## Package Design

- Packages should be small and focused around a single responsibility.
- No `utils`, `helpers`, or `common` packages.
- Avoid deeply nested directories. A flat-ish structure is idiomatic.
- Avoid `init()`. Prefer explicit initialization from `main` or constructors.

## Context

- Pass `context.Context` as the first parameter to any function that does I/O,
  makes an outbound call, or may block.
- Propagate the caller's context. Do not store it in a struct.
- Never create `context.Background()` deep in a call chain; pass the context
  down from the top level.
- Use `context.WithoutCancel` when work must outlive the request (e.g. async
  cleanup) rather than creating a new `context.Background()`.
- Prefer `context.Cause(ctx)` over `ctx.Err()` when reporting cancellations.
  It surfaces _why_ the context ended. Use the `*Cause` variants
  (`WithCancelCause`, `WithTimeoutCause`, `WithDeadlineCause`) when there is a
  meaningful reason to attach.

## Concurrency

- Always ensure goroutines can be stopped. Accept a `context.Context` or provide
  a shutdown/close mechanism.
- Use channels for signaling and communication; use `sync.Mutex` for protecting
  shared state. Use whichever is simpler for the case.
- Use `sync.WaitGroup` for fan-out work where all goroutines should run to
  completion. Use `errgroup.WithContext` when you want fail-fast cancellation
  on the first error.

## Style and Conventions

- Every exported identifier should have a doc comment.
- Use struct literals with field names: `Point{X: 1, Y: 2}`, not `Point{1, 2}`.
- Method receivers are short: one or two letters, consistent across all methods
  on the type (e.g. `s` for `*Server`). Never `self` or `this`.
- Use `defer` for resource cleanup immediately after acquiring the resource.
- Use `make` with a size hint when the slice/map length is known or estimable.
- Prefer `slices`, `maps`, and `cmp` packages over hand-rolled loops.
- Use range-over-func iterators (`iter.Seq`, `iter.Seq2`) for lazy sequences
  and custom collection traversal. Prefer iterators over returning a collected
  slice when the caller may not need all elements or the set is large.
- Represent durations with `time.Duration`, never bare `int` seconds or milliseconds.
- Accept `io.Reader` / `io.Writer` for stream processing rather than `[]byte`
  or `string`.
