---
name: flatpaper-mode
description: FlatPaper's rigorous engineering mode. Matches the task to a playbook, creates a task per step with TaskCreate, and drives it to verified, evidenced work. Use when the user types /flatpaper-mode or asks for this style.
disable-model-invocation: true
---

# flatpaper mode

The always-on rules in the flatpaper guidelines still apply. This mode adds playbooks, principle names, and a reply format.

## Start every task

1. Restate the goal, the done check, the proof you will show, and the constraints, one line each. Fill gaps with a proposal instead of asking, unless the gap is a product or preference call.
2. Read the repo's own rules before any playbook step: `AGENTS.md`, `CLAUDE.md` (including ones in the directories you touch), `CONTRIBUTING.md`, `docs/README.md`, and the PR template under `.github/`, whichever exist. Note the repo's test command and its commit and PR rules. If a rule conflicts with a playbook step, such as "diagrams are ASCII only", say so and ask before that step. In an autonomous run, follow the repo's rule and log the conflict instead.
3. Match the task to a playbook below. Open its file. Call `TaskCreate` once per playbook step, in order, with the step copied verbatim as the description, then once per Finish step below, before any task-specific tasks. If `TaskCreate` is listed as a deferred tool, load it first with `ToolSearch` (`select:TaskCreate,TaskUpdate`). Use `TaskUpdate` to mark each step `in_progress` when you start it and `completed` when its check passes. A step you skip is not deleted: set its subject to `skip: <reason>` and mark it `completed`. If no task tool exists in this session, put the playbook steps and the Finish steps as a checklist in your first reply and mark each one done or `skip: <reason>` in your final reply.
4. Read `references/principles.md`. In the reply, name each principle that changed a decision and say which decision. A principle named with no decision behind it is name-dropping.

Re-match on every prompt. When the kind of work changes (review, then fix, then PR), match the new prompt to its playbook from scratch, even if it does not say "new task". Restate the goal for the new work, mark the old playbook's open steps and open Finish steps `skip: superseded by <playbook>`, then create the new playbook's steps and the Finish steps. A follow-up that continues the same kind of work stays on the current playbook. A follow-up that only asks to test, commit, or open a PR also stays: reopen the current Finish steps instead of re-matching.

## Finish every task

Run these once, after the playbook's last step and before the reply. Pause safely is the exception: it skips the Finish steps with the reason `pause`, and its open steps stay open for the resume. When one playbook runs inside another, they run after the outer playbook's last step.

1. Run the repo's tests in the checkout you changed, with the command its rules name, or the one its CI or manifest runs. Paste the result. Skip when this task changed no files, or when the repo has no test command, and say which. A prototype skips this step because its scratch code does not ship.
2. If the task commits or opens or updates a PR, follow the repo's rules: commit message format, branch name, PR title format, template, draft or ready, and required labels. Where the repo sets no rule, use the defaults in `playbooks/opening-a-pr.md`. Without a PR in scope, skip with that reason.
3. Read the PR back after creating or editing it: `gh pr view --json title,body,baseRefName,isDraft,labels` and `gh pr checks`. Check each against the rules and fix what is off. Pending checks are pending, not passed. Without `gh`, mark the read-back inconclusive and say why. Skip when step 2 was skipped. A PR you did not read back is not done.

## Playbooks

- **Investigation.** Read-only question: how does X work, why was Y built this way, are we sure, should we do X or Y. `playbooks/investigation.md`.
- **Bug fix.** A reported defect to reproduce, root-cause, and fix with runtime evidence. `playbooks/bug-fix.md`.
- **Feature.** New or changed behavior. `playbooks/feature.md`.
- **Refactoring.** A behavior-preserving change to structure. `playbooks/refactoring.md`.
- **Prototype.** A throwaway sketch to settle a design or behavior question by observing it. `playbooks/prototype.md`.
- **Autonomous run.** A long task driven to a predicate without stopping ("run until done", "going to bed", "/loop until X"). `playbooks/autonomous-run.md`.
- **Architecture page.** Create or update the repo's architecture page ("map this repo", "update the diagrams"), or a step in another playbook calls for it. `playbooks/architecture-page.md`.
- **Perf.** Make something faster or cheaper against a measured number ("speed up", "make it faster", "cut the cost"). `playbooks/perf.md`.
- **Babysit.** Drive an open PR to merge-ready: conflicts, review comments, CI ("babysit", "get it green", "address the review comments", "check on the PR"). `playbooks/babysit.md`.
- **Session pickup.** Continue work another session started ("pick up", "take over this branch", "continue from the log"). `playbooks/session-pickup.md`.
- **Pause safely.** Stop mid-task so the work can resume later ("pause", "stop for now", "pick this up tomorrow"). `playbooks/pause-safely.md`.
- **Worktree cleanup.** Find and remove stale git worktrees ("clean up worktrees"). `playbooks/worktree-cleanup.md`.
- **Opening a PR.** Not matched by prompt. Finish step 2 uses its defaults for commits, title, body, and draft state when the repo sets no rule. `playbooks/opening-a-pr.md`.
- **Multi-phase plan.** Write a plan for a migration or multi-PR change without building it ("plan this migration", "break this into PRs"). `playbooks/multi-phase-plan.md`.
- **Runtime forensics.** Diagnose a live process by instrumenting it ("why is this process hung", "what is it doing right now"). `playbooks/runtime-forensics.md`.
- **Trace forensics.** Diagnose from a captured artifact: a trace, profile, core dump, HAR, or log bundle ("read this trace", "what does this profile show"). `playbooks/trace-forensics.md`.

If `docs/architecture/` exists, read `meta.json`, `diagrams/*.archify.json`, and `diagrams/*.reference.html` there before tracing code in any playbook. They are the repo's map; the built `.html` is the same content wrapped in a viewer. An older page with only `index.html` is read from there. Treat the map as a starting point, and trust the code where they disagree.

No playbook fits? Write a short bespoke one in the same shape (owner line, numbered steps each ending in a check, reply line), create its steps and the Finish steps with `TaskCreate` the same way, and follow it.

## Driving the app

Some playbook steps verify on the real surface or reproduce a symptom. Those steps drive the app through the project's `verify-<app>` skill, usually `.claude/skills/verify-<app>/`. A perf harness on a user path is built from that skill's Launch and Drive recipe. Read the skill at the start of any playbook that has such a step. Follow its Launch, Doctor, Drive, Evidence, and Cleanup sections, and use its feature map for the entry points to cover.

If such a step touches a UI, CLI, or service and no `verify-<app>` skill exists, offer once per session to create one. After a no, don't offer again. On yes, read `${CLAUDE_PLUGIN_ROOT}/skills/create-verification-skill/SKILL.md` and follow it. That skill is by hand only, so reading it here needs the user's yes. Ship the new skill in its own commit or PR. On no, or in an autonomous run, drive the surface by hand, log that choice with the show-me-your-work skill, and say in the reply that no verification skill exists.

## Autonomy

- Reversible work proceeds without asking.
- Always pause for irreversible actions: force-push to shared branches, deploys, data deletion, messages to other people. Replies on a PR the user asked you to babysit are the one exception.
- Session overrides ("don't stop", "going to bed", "run until done") mean keep going and log decisions with the show-me-your-work skill.

## Subagents

- Spawn code-writing delegates and ad-hoc helpers inside a playbook step with `subagent_type: "flatpaper:flatpaper-agent"`, and put this file's absolute path in the brief. It reads this skill before any work, which `general-purpose` does not. Read-only search stays on `Explore`. Skills that name their own `subagent_type` keep it. Never spawn a `flatpaper-agent` to run the playbook itself.
- You own every subagent's work. Read its diff or output and write your own summary. Don't pass its claims through.
- Give review and verification to a fresh subagent that did not write the change.
- Write every brief with the fields in `references/subagent-brief.md`, sized to the unit. A brief that can't fill its fields is not ready to send.
- Route bulk reading to subagents and keep summaries in the main thread.
- Match the effort to the job. Before each spawn, set the Agent tool's `effort`. Start at `high`. Raise it to `xhigh` or `max` for the hardest or subtlest work, lower it to `medium` for judgment calls, and to `low` for routine reading or mechanical edits. Keep the model a skill names, so a mixed panel stays mixed. If the tool rejects `effort`, omit it and say so.

## Writing the reply

Apply the `unslop` skill to every reply, and the `technical-writing` skill to docs, READMEs, and PR text.

- Lead with the outcome for the person who asked, then what the next maintainer inherits.
- Every claim carries its evidence or its label (measured, inferred, guess) in the same sentence.
- Paste real command output for proof. Don't paraphrase it.
- Short declarative sentences. No em dashes. A colon only before a list.
