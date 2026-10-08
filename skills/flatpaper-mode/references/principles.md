# Principles

Names to steer by. The user may say a name mid-task ("apply prove it works"). Each entry says when it applies and what it requires. Adapted from poteto's pstack.

## Core

- **Laziness protocol.** Sizing a diff or tempted to add layers. Prefer deletion and the smallest change that solves the problem.
- **Foundational thinking.** Before writing logic. Choose the core types and data structures first, so downstream code becomes obvious.
- **Redesign from first principles.** Adding a requirement to an existing design. Design as if it had been there from day one instead of bolting it on.
- **Attack the premise.** Two or more fixes that share one premise have failed the same check. Question the premise before writing another fix that assumes it.
- **Subtract before you add.** Before an addition or rewrite. Remove dead code, redundant checks, and stale references first.
- **Minimize reader load.** Code that is hard to trace. Count layers and hidden state. Collapse one-caller wrappers.
- **Outcome-oriented execution.** Planned migrations. Converge on the target design. Don't keep throwaway compatibility layers alive.
- **Experience first.** Scope tradeoffs. Choose the user's result over implementation convenience.
- **Exhaust the design space.** A decision with no precedent. Build two or three prototypes and compare before committing.
- **Build the lever.** Work repeated by hand. Build the script, codemod, or check that does or proves it. The tool is what a reviewer reruns.

## Architecture

- **Model the domain.** Logic that branches a lot. Encode the rules in one structure (state machine, table, typed model) instead of scattered conditionals.
- **Boundary discipline.** Validation and error handling. Check at system boundaries (CLI, config, network, external APIs). Trust internal types.
- **Type system discipline.** Designing types. Make illegal states unrepresentable. Parse external data at the boundary.
- **Make operations idempotent.** Steps that may crash and retry. Running twice must reach the same end state.
- **Migrate callers then delete legacy APIs.** Replacing an internal API. Move every caller and delete the old API in the same change.
- **Separate before serializing shared state.** Concurrent writers to one file, branch, or key. Remove the sharing before adding locks.

## Verification

- **Prove it works.** Before saying done. Check the real artifact, not a proxy, a self-report, or "it compiles". When a check surprises you, suspect the check first.
- **Fix root causes.** Debugging. Reproduce first. Ask why until you reach the cause. No guards that silence the symptom.
- **Sequence verifiable units.** Multi-step work. Small units, each ending in a check, verified before the next.
- **Test behavior, not implementation.** Writing or keeping a test. Call the code as its users do and assert a literal expected value. A test that passes when every called function returns None gets rewritten or deleted.
- **Explain the number.** Before reporting a measurement. Name what limits it and rule out that it measured something else.

## Delegation

- **Guard the context window.** Large outputs or many files. Send bulk to subagents and keep summaries in the main thread.
- **Never block on the human.** Reversible work while the user is away. Proceed, log the call, and let the user correct it later.

## Meta

- **Encode lessons in structure.** The same instruction given twice. Turn it into a lint, test, hook, or script instead of more text.
