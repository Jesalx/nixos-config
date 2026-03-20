---
name: tidy
description: Scan code for idiomatic improvements, cleanup, and best practices. Present findings without making changes.
user-invocable: true
disable-model-invocation: true
argument-hint: [file, package, or description of scope]
allowed-tools: Read, Grep, Glob, Bash(git diff *), Bash(git log *)
---

Scan code for worthwhile improvements and present findings — do not make changes.

## Scope

$ARGUMENTS

- **If an argument is provided**: scope the review to the specified file, package,
  directory, or area described.
- **If no argument is provided**: scan the project broadly — explore the directory
  structure, read key files across packages, and look for patterns and issues
  across the codebase.

## Process

1. **Determine scope** — use the argument or explore the project structure broadly.
   Read the relevant files thoroughly before forming opinions.

2. **Identify the language and ecosystem** — tailor all suggestions to the
   conventions, idioms, and tooling of the language in use. What counts as
   idiomatic Go is different from idiomatic TypeScript or Nix.

3. **Scan for improvements** using the categories below as a lens. Only raise
   findings that are genuinely worthwhile — skip nitpicks and stylistic
   preferences that don't improve clarity, correctness, or maintainability.

   **Idiomatic patterns**:
   - Language-specific idioms being ignored (e.g., Go: error handling patterns,
     receiver naming; Rust: ownership idioms; Python: comprehensions over manual
     loops)
   - Standard library facilities that replace hand-rolled logic
   - API misuse or outdated patterns when newer alternatives exist

   **Simplification**:
   - Code that can be expressed more directly — unnecessary indirection, wrapper
     functions that add no value, overly clever constructions
   - Redundant checks, dead branches, unreachable code
   - Overly defensive code that guards against impossible states

   **Best practices**:
   - Error handling gaps — swallowed errors, missing context on wrapped errors
   - Resource management — unclosed handles, missing cleanup, defer placement
   - Naming that obscures intent — single-letter names in non-trivial scope,
     misleading names, inconsistent conventions within a package

   **Reuse and structure**:
   - Duplicated logic that could be unified without premature abstraction
   - Functions doing too many things that would be clearer split apart
   - Public API surface that is wider than necessary

   **Cleanup**:
   - Dead code — unused functions, types, constants, imports
   - Stale TODO/FIXME comments that reference resolved issues
   - Inconsistencies within a package (e.g., mixed error handling strategies,
     inconsistent naming)

4. **Prioritize** — order findings by impact. A real bug or correctness issue
   ranks above a naming improvement. Group related findings together.

## Output

Present findings as a numbered list, ordered by importance.

For each finding:

- **One-line summary** of the improvement
- **Location**: file and line number(s)
- **What and why**: what the current code does, what the improvement is, and why
  it matters — be specific and concrete, not generic
- **Example**: a brief code sketch showing the improved version when it helps
  clarify the suggestion (keep these short)

After the list, note any areas you reviewed and found clean — this tells the user
where no action is needed.

Do not pad with low-value findings. If the code is solid, say so. If there are
only 2 real improvements, list 2.
