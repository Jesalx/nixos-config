---
name: vet
description: Explore a feature or change to find weaknesses, edge cases, race conditions, error handling gaps, and other potential issues. Only invoke when the user explicitly runs /vet.
user-invocable: true
argument-hint: [description]
allowed-tools: Read, Grep, Glob
---

Vet a proposed feature or change by asking Socratic questions that expose
ambiguity, weaknesses, and risks — helping the user strengthen their approach
before implementation.

## Context

$ARGUMENTS

## Process

1. **Understand the proposal** — Read the relevant code, types, interfaces, and
   call sites that would be affected. If this is a new feature with little
   existing code, focus on understanding the user's intent, the constraints of
   the system it will live in, and the interfaces it must satisfy.

2. **Identify the most important questions** — Use the categories below as a
   lens, but only raise questions that are genuinely relevant to this specific
   proposal. Do not mechanically walk through every category.

   **Design-level concerns** (vet these first):
   - **Ambiguity**: behaviors the proposal doesn't define — what should happen
     in situations the user hasn't addressed? Multiple valid interpretations of
     the same requirement?
   - **Missing requirements**: scenarios or inputs the proposal is silent on
   - **Trade-offs**: implicit choices the proposal makes where a meaningful
     alternative exists — why this approach over another?
   - **Scope**: is the proposal trying to do too much or too little? Are there
     natural boundaries that would simplify the design?

   **Implementation-level concerns** (vet when relevant code exists):
   - **Boundaries**: inputs, module interfaces, external systems, concurrency
   - **Edge cases**: zero/empty values, limits, invalid input, timing, state
   - **Error handling**: unchecked errors, partial state on failure, cleanup
   - **Implicit assumptions**: ordering, uniqueness, availability, size
   - **Security surface**: injection, auth gaps, data exposure, resource exhaustion

3. **Ask, don't tell** — Frame each concern as a question that leads the user
   to think through the issue themselves. Questions should be specific and
   grounded in the proposal or code — not generic.

   Design-level examples:
   Good: "The proposal covers creating and listing widgets, but what should
   happen when a widget is deleted while another process holds a reference to it?"
   Bad: "Have you thought about deletion?"

   Good: "This adds a cache in front of the database — what's the acceptable
   staleness window, and who decides when to invalidate?"
   Bad: "Have you considered caching trade-offs?"

   Implementation-level examples:
   Good: "What happens to the open file handle if `Parse` returns an error on line 47?"
   Bad: "Have you considered error handling?"

   Good: "This map is accessed from both the HTTP handler and the background
   goroutine on line 83 — what serializes those accesses?"
   Bad: "Is this concurrent-safe?"

## Output

Present 3–7 targeted questions, ordered by importance (most critical first).

For each question:
- Ground it in the proposal or specific code (file, line, function) when applicable
- Make the scenario concrete enough that the user can reason about it
- If useful, include a small code snippet or example showing the relevant path

After the questions, briefly note any areas you examined and found solid — this
tells the user what they don't need to worry about.

Do not pad with low-value questions. If the proposal only has 2 real concerns,
ask 2 questions. If it's solid, say so and explain why.
