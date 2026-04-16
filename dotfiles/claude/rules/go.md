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

## Naming

- Package names: short, lowercase, single word, matching the source directory.
  No underscores or `mixedCaps`.
- Avoid stuttering: `bufio.Reader`, not `bufio.BufReader`. If a package
  exports a single type, name its constructor `New`, not `NewX`.
- Getters omit `Get`: field `owner` → method `Owner()`; setter is `SetOwner`.
- One-method interfaces take an `-er` suffix (`Reader`, `Formatter`,
  `CloseNotifier`).
- Canonical method names (`Read`, `Write`, `Close`, `Flush`, `String`) have
  fixed signatures and meanings. Match them only when your type means the
  same thing. Name a string converter `String()`, not `ToString()`.
- Use `MixedCaps` or `mixedCaps` for multiword names, never underscores.
- Initialisms keep consistent case: `URL` or `url` (never `Url`), `ID` not
  `Id`, `ServeHTTP` not `ServeHttp`.
- Variable names grow with scope: single letters (`i`, `c`, `r`) for
  short-lived locals, descriptive names for package-level or long-lived
  identifiers.

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
- Avoid in-band error signals. Return a separate `(value, ok)` or
  `(value, error)` instead of overloading the primary return with magic
  values like `-1` or an empty string.
- Return early on errors to keep the happy path unindented.
- Error strings are lowercase with no trailing punctuation, prefixed with the
  package or operation to identify their origin (`"image: unknown format"`).

## Control Flow

- Omit `else` when the `if` body ends in `return`, `break`, `continue`, or
  `goto`. The happy path stays unindented.
- A `switch` with no expression replaces `if`/`else if` chains.
- Use a type switch (`switch v := x.(type)`) to dispatch on the dynamic type
  of an interface.
- Use the comma-ok form for type assertions: `v, ok := x.(T)`. A bare
  `x.(T)` panics on mismatch.

## Interfaces

- Keep interfaces small.
- Define interfaces at the **consumer** site, not the provider.
- Accept interfaces, return concrete types. When a type exists only to
  implement an interface, its constructor returns the interface instead
  (`crc32.NewIEEE` returns `hash.Hash32`).
- Assert interface conformance at compile time with
  `var _ Iface = (*Type)(nil)` only when no static conversion already proves it.

## Methods

- If any method on a type needs a pointer receiver, use pointer receivers for
  all methods on that type.
- Prefer pointer receivers for large structs, types containing a lock, or
  types with mutating methods.

## Zero Values

- Design types so the zero value is usable where practical. `bytes.Buffer`
  and `sync.Mutex` work without initialization; aim for the same.
- When the zero value cannot be useful, provide a `NewX` constructor.

## Allocation

- `make` is for slices, maps, and channels. It returns an initialized `T`.
- `new(T)` returns `*T` to zeroed memory. Prefer composite literals like
  `&File{fd: fd, name: name}` over `new` followed by field assignments.

## Embedding

- Embed types to promote methods rather than writing forwarding wrappers.
- Embed interfaces to compose them (`type ReadWriter interface { Reader; Writer }`).

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

- Prefer synchronous functions that return results directly over ones that
  spawn goroutines or invoke callbacks. Callers can add concurrency; they
  cannot easily remove it.
- Always ensure goroutines can be stopped. Accept a `context.Context` or provide
  a shutdown/close mechanism.
- Share memory by communicating: default to passing values on channels. Use
  `sync.Mutex` when it is simpler.
- Use `sync.WaitGroup` for fan-out work where all goroutines should run to
  completion. Use `errgroup.WithContext` when you want fail-fast cancellation
  on the first error.

## Panic and Recover

- Panic only for unrecoverable conditions or impossible states. Return an
  `error` for anything a caller could reasonably handle.
- `recover` only runs inside a deferred function. Convert internal panics
  into returned errors so they never escape a package's public API.

## Style and Conventions

- Every exported identifier should have a doc comment.
- Use struct literals with field names: `Point{X: 1, Y: 2}`, not `Point{1, 2}`.
- Method receivers are short: one or two letters, consistent across all methods
  on the type (e.g. `s` for `*Server`). Never `self` or `this`.
- Use `defer` for resource cleanup immediately after acquiring the resource.
- Use `make` with a size hint when the slice/map length is known or estimable.
- Declare empty slices as `var s []T`, not `s := []T{}`. Use the non-nil form
  only when empty must be distinguishable from nil (e.g. JSON arrays
  marshaling to `[]`).
- Prefer `slices`, `maps`, and `cmp` packages over hand-rolled loops.
- Use range-over-func iterators (`iter.Seq`, `iter.Seq2`) for lazy sequences
  and custom collection traversal. Prefer iterators over returning a collected
  slice when the caller may not need all elements or the set is large.
- Represent durations with `time.Duration`, never bare `int` seconds or milliseconds.
- Accept `io.Reader` / `io.Writer` for stream processing rather than `[]byte`
  or `string`.
- Use `net/http.ServeMux` for HTTP routing with method and path-parameter
  patterns (`"GET /users/{id}"`, read with `r.PathValue`).
