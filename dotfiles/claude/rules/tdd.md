# Test-Driven Development

Follow the red-green-refactor cycle for all code changes that have a testable
behavior. Write the test first, confirm it fails, then write the implementation.

## The Cycle

### 1. Red — Write a failing test

- Write a test for the next piece of behavior before writing any implementation
  code.
- Run the test. It **must fail**. If it passes, either the behavior already
  exists or the test is wrong — investigate before proceeding.
- Confirm it fails for the **right reason**: a missing function, wrong return
  value, or expected error — not a syntax error, import failure, or unrelated
  crash. The failure message should describe the behavior gap you are about to
  fill.

### 2. Green — Make it pass

- Write the **minimum implementation** to make the failing test pass. Nothing
  more.
- Do not generalize, optimize, or handle edge cases that are not tested yet.
  Those are the next cycle.
- Run the full test suite, not just the new test. New code must not break
  existing behavior.

### 3. Refactor — Clean up under green tests

- With all tests passing, improve the code: extract duplication, rename for
  clarity, simplify conditionals, improve structure.
- Refactor both production code **and** test code.
- Run tests after each refactoring step. If a test fails, undo the last change
  and take a smaller step.
- Do not add new behavior during refactoring. If you spot missing behavior,
  that is the next red-green-refactor cycle.

Then repeat. Each cycle adds one behavior.

## Applying TDD to Different Tasks

**New feature or function:** Start by writing a test for the simplest useful
behavior. Build up complexity one test at a time through successive cycles.

**Bug fix:** Write a test that reproduces the bug — it should fail against the
current code. Then fix the bug and confirm the test passes.

**Refactoring existing code:** Ensure adequate test coverage exists before
refactoring. If it does not, add characterization tests for the current
behavior first (these should pass immediately), then refactor under those tests.

## Discipline

- **One test at a time.** Do not write a batch of tests and then implement them
  all at once. Each cycle is one behavior.
- **Small steps.** If a test requires a large implementation to pass, the test
  is asking for too much. Break it into smaller, independently testable
  behaviors.
- **Do not skip red.** Seeing the test fail is not a formality — it verifies
  the test actually exercises the behavior you intend. A test you have never
  seen fail is a test you cannot trust.
- **Do not skip refactor.** The first implementation that passes is rarely the
  best one. Clean up while the context is fresh and the tests are green.
