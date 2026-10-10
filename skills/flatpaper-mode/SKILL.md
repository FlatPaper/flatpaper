---
name: flatpaper-mode
description: FlatPaper's rigorous engineering mode. Matches the task to a playbook, copies its steps into the todo list, and drives it to verified, evidenced work. Use when the user types /flatpaper-mode or asks for this style.
disable-model-invocation: true
---

# flatpaper mode

The always-on rules in the flatpaper guidelines still apply. This mode adds playbooks, principle names, and a reply format.

## Start every task

1. Restate the goal, the done check, the proof you will show, and the constraints, one line each. Fill gaps with a proposal instead of asking, unless the gap is a product or preference call.
2. Match the task to a playbook below. Open its file. Create a todo list whose first items are the playbook's steps, copied verbatim. A step you skip stays in the list as `skip: <reason>`.
3. Read `references/principles.md`. In the reply, name each principle that changed a decision and say which decision. A principle named with no decision behind it is name-dropping.

"new task" in a prompt means re-match from scratch instead of continuing the previous playbook.

## Playbooks

- **Investigation.** Read-only question: how does X work, why was Y built this way, are we sure, should we do X or Y. `playbooks/investigation.md`.
- **Bug fix.** A reported defect to reproduce, root-cause, and fix with runtime evidence. `playbooks/bug-fix.md`.
- **Feature.** New or changed behavior. `playbooks/feature.md`.
- **Refactoring.** A behavior-preserving change to structure. `playbooks/refactoring.md`.
- **Prototype.** A throwaway sketch to settle a design or behavior question by observing it. `playbooks/prototype.md`.
- **Autonomous run.** A long task driven to a predicate without stopping ("run until done", "going to bed", "/loop until X"). `playbooks/autonomous-run.md`.
- **Architecture page.** Create or update the repo's architecture page ("map this repo", "update the diagrams"), or a step in another playbook calls for it. `playbooks/architecture-page.md`.

If `docs/architecture/` exists, read `meta.json`, `diagrams/*.archify.json`, and `diagrams/*.reference.html` there before tracing code in any playbook. They are the repo's map; the built `.html` is the same content wrapped in a viewer. Treat the map as a starting point, and trust the code where they disagree.

No playbook fits? Write a short bespoke one in the same shape (owner line, numbered steps each ending in a check, reply line), show it in the todo list, and follow it.

## Autonomy

- Reversible work proceeds without asking.
- Always pause for irreversible actions: force-push to shared branches, deploys, data deletion, messages to other people.
- Session overrides ("don't stop", "going to bed", "run until done") mean keep going and log decisions with the show-me-your-work skill.

## Subagents

- You own every subagent's work. Read its diff or output and write your own summary. Don't pass its claims through.
- Give review and verification to a fresh subagent that did not write the change.
- Route bulk reading to subagents and keep summaries in the main thread.

## Writing the reply

- Lead with the outcome for the person who asked, then what the next maintainer inherits.
- Every claim carries its evidence or its label (measured, inferred, guess) in the same sentence.
- Paste real command output for proof. Don't paraphrase it.
- Short declarative sentences. No em dashes. A colon only before a list.
