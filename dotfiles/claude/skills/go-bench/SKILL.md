---
name: go-bench
description: Write, run, and analyze Go benchmarks. Use when the user asks to benchmark Go code, optimize performance, compare benchmark results, or investigate allocations and throughput.
argument-hint: [description]
allowed-tools: Read, Grep, Glob, Edit, Write, Bash(go test *), Bash(go tool *), Bash(benchstat *)
---

Write, run, and analyze idiomatic Go benchmarks.

## Context

$ARGUMENTS

## Process

1. **Read the code under test** — understand the function signatures, hot paths,
   allocations, and data structures before writing anything.
2. **Read existing benchmarks** in the package — check for `Benchmark*` functions
   that already cover the target code. Do not duplicate existing benchmarks.
3. **Write or update benchmarks** following the conventions below.
4. **Run the benchmarks** and present results clearly.
5. **Analyze results** — identify bottlenecks, allocation patterns, and
   optimization opportunities. Provide specific, actionable suggestions with code.

## Writing Benchmarks

### Basic Pattern

Always use `b.Loop()` for the benchmark loop.

```go
func BenchmarkParse(b *testing.B) {
    input := []byte(`{"key": "value"}`)
    for b.Loop() {
        Parse(input)
    }
}
```

### Timer Control

Call `b.ResetTimer()` after expensive one-time setup.

```go
func BenchmarkProcess(b *testing.B) {
    data := generateLargeDataset()
    b.ResetTimer()
    for b.Loop() {
        Process(data)
    }
}
```

Use `b.StopTimer()` / `b.StartTimer()` to exclude expensive per-iteration
setup from measurement. Avoid when setup cost is negligible — the calls
themselves have overhead.

```go
func BenchmarkInsert(b *testing.B) {
    for b.Loop() {
        b.StopTimer()
        db := setupFreshTable()
        b.StartTimer()
        Insert(db, record)
    }
}
```

### Sub-benchmarks

Use `b.Run()` to compare variants, input sizes, or implementations:

```go
func BenchmarkEncode(b *testing.B) {
    sizes := []int{64, 256, 1024, 4096}
    for _, size := range sizes {
        b.Run(fmt.Sprintf("size=%d", size), func(b *testing.B) {
            data := make([]byte, size)
            b.ResetTimer()
            for b.Loop() {
                Encode(data)
            }
        })
    }
}
```

### Throughput

Call `b.SetBytes(n)` when the benchmark processes a known amount of data:

```go
func BenchmarkRead(b *testing.B) {
    buf := make([]byte, 4096)
    b.SetBytes(int64(len(buf)))
    for b.Loop() {
        Read(buf)
    }
}
```

### Parallel Benchmarks

Use `b.RunParallel()` to measure performance under concurrent load:

```go
func BenchmarkConcurrentGet(b *testing.B) {
    cache := NewCache()
    b.ResetTimer()
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            cache.Get("key")
        }
    })
}
```

### Custom Metrics

Use `b.ReportMetric()` for domain-specific measurements:

```go
b.ReportMetric(float64(itemsProcessed)/elapsed.Seconds(), "items/s")
```

## Running Benchmarks

Always use `-run=^$` to skip unit tests. Always use `-benchmem`. Never use
`-race` when benchmarking — it distorts timings.

### Quick run

```bash
go test -bench=BenchmarkName -benchmem -run=^$ ./path/to/package
```

### Statistically rigorous run

Use `-count=N` to collect multiple samples for `benchstat`. Increase
`-benchtime` if results are noisy or the operation is very fast.

```bash
go test -bench=BenchmarkName -benchmem -run=^$ -count=10 ./path/to/package
```

### Testing across CPU counts

```bash
go test -bench=BenchmarkName -benchmem -run=^$ -cpu=1,2,4,8 ./path/to/package
```

## Comparing Results

Always use `benchstat` for before/after comparison. Never eyeball raw numbers.

```bash
go test -bench=BenchmarkName -benchmem -run=^$ -count=N ./pkg > old.txt
# ... make changes ...
go test -bench=BenchmarkName -benchmem -run=^$ -count=N ./pkg > new.txt
benchstat old.txt new.txt
```

Present `benchstat` output to the user. Focus on:

- **time/op** change and whether it is statistically significant (p-value)
- **allocs/op** and **B/op** changes
- Any regressions, even small ones

## Profiling

When benchmarks alone are not enough to identify the bottleneck:

```bash
go test -bench=BenchmarkName -run=^$ -cpuprofile=cpu.out -memprofile=mem.out ./pkg
go tool pprof -top cpu.out
```

Available profiles: `-cpuprofile`, `-memprofile`, `-blockprofile`, `-mutexprofile`.

## Optimization Checklist

When analyzing results, check for:

- **High allocs/op**: allocations inside hot loops — slices without size hints,
  inefficient string concatenation, interface boxing, closures capturing variables.
- **Unnecessary copies**: large structs passed by value, `range` over large values.
- **String/byte conversions**: repeated `[]byte(s)` or `string(b)` in hot paths.
- **Map overhead**: map operations in hot loops — profile to determine if the access
  pattern justifies the hash overhead.
- **Sync overhead**: lock contention under concurrent load — profile with
  `-mutexprofile` to identify contended locks and evaluate granularity.
- **Interface dispatch**: hot-path virtual calls — consider generics or concrete types.
- **Inefficient I/O**: unbuffered reads/writes — wrap with `bufio`.

## Output

When finished, report:

- Benchmark results (formatted `go test -bench` output)
- Key findings: hotspots, allocation patterns, throughput
- Specific optimization suggestions with code, ordered by expected impact
- If comparing: `benchstat` output with significance analysis
