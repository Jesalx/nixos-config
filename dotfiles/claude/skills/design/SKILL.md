---
name: design
description: Interactive design session for exploring a feature or change through conversation — surfaces ambiguity, edge cases, trade-offs, and missing requirements, then consolidates agreed decisions into a clear summary. Only invoke when the user explicitly runs /design.
disable-model-invocation: true
user-invocable: true
argument-hint: [description of feature/change]
allowed-tools: Read, Grep, Glob
---

Have a conversation with the user to explore and refine a feature or change
until the design is solid, then consolidate everything into a clear summary.

## Context

$ARGUMENTS

## How this works

This is a multi-turn conversation, not a one-shot analysis. You and the user
will go back and forth — you ask questions, they answer, their answers raise new
questions or resolve old ones, and gradually the design takes shape. The goal is
to reach a point where both of you agree the important decisions have been made
and the key risks are addressed.

## Starting the session

1. **Read the relevant code** — types, interfaces, call sites, anything that
   would be affected. If this is a greenfield feature, focus on the system it
   will live in and the interfaces it must satisfy.

2. **Restate what you understand** — In a sentence or two, reflect back what you
   think the user wants to accomplish. This catches misunderstandings early.

3. **Ask your first round of questions** — Pick the 2-4 most important open
   questions. Focus on the things that would most change the shape of the design
   depending on the answer.

## During the conversation

Each turn, do three things:

1. **Acknowledge what was decided** — When the user answers a question, briefly
   confirm the decision ("Got it — so we'll use optimistic locking and surface
   conflicts to the caller"). This builds a shared record.

2. **Follow the thread** — Their answer may resolve one question but open
   others. Follow up on what matters. If they said "we'll use a cache," ask
   about invalidation. If they said "the caller handles errors," ask what the
   caller does with them.

3. **Ask the next round** — Prioritize by impact. Questions that could change
   the fundamental approach come before questions about edge cases in a specific
   code path.

### What to explore

Use these as a lens, not a checklist. Only raise what's genuinely relevant.

**Design-level:**

- Ambiguity — behaviors the proposal doesn't define, multiple valid
  interpretations
- Missing requirements — scenarios or inputs the proposal is silent on
- Trade-offs — implicit choices where a meaningful alternative exists
- Scope — is this trying to do too much or too little?

**Implementation-level** (when relevant code exists):

- Boundaries — inputs, module interfaces, external systems, concurrency
- Edge cases — zero/empty values, limits, invalid input, timing, state
- Error handling — unchecked errors, partial state on failure, cleanup
- Implicit assumptions — ordering, uniqueness, availability, size
- Security surface — injection, auth gaps, data exposure, resource exhaustion

### How to ask

Be specific and grounded. Questions should reference the actual proposal or
code, not be generic prompts.

Good: "The proposal covers creating and listing widgets, but what should happen
when a widget is deleted while another process holds a reference to it?"
Bad: "Have you thought about deletion?"

Good: "This map is accessed from both the HTTP handler and the background
goroutine — what serializes those accesses?"
Bad: "Is this concurrent-safe?"

If you can illustrate the concern with a short code snippet or concrete
scenario, do it — it helps the user reason about the problem.

### Converging

As questions get resolved, the conversation naturally shifts from big
architectural questions to smaller details. When you notice this happening — or
when the remaining open items are minor — say so:

"I think the core design is solid. The remaining questions are about [X and Y]
— want to nail those down now or leave them for implementation?"

The user might want to keep going or might say it's good enough. Either is fine.

## Consolidating

When the user indicates the design is ready (or you both agree), produce a
summary that captures everything discussed. This summary is the main deliverable
— it should be clear enough that someone reading only the summary (not the full
conversation) can understand the design and act on it.

Structure the summary as:

### Design: [feature/change name]

**Goal** — One or two sentences on what this accomplishes.

**Decisions** — The key choices made during the conversation, stated as facts
(not questions). Group related decisions together. Include the reasoning when
it's not obvious.

**Edge cases and error handling** — Specific scenarios discussed and how they'll
be handled.

**Out of scope** — Things explicitly deferred or excluded, so they don't creep
back in.

**Open items** (if any) — Questions that were acknowledged but intentionally
left for later.

Adapt this structure to fit the proposal. A small change might not need "out of
scope." A complex feature might need additional sections. The point is to
capture what was decided in a form that's useful downstream.
