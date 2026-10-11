# Subagent brief

A subagent cannot ask you a question. A vague brief fails quietly. Every spawn carries these fields:

```
GOAL         one sentence, the outcome, doable by a stranger with no chat access
SCOPE        paths it may write, paths it may not, and its own worktree or branch
CONTEXT      pointers to files and PRs, plus upstream results pasted in full
ACCEPTANCE   checkable criteria, one per line
VERIFY       the exact commands to run, plus known gotchas
TIMEBOX      a rough cap; on expiry it returns partial findings and stops
FORBIDDEN    no push --force, no rebase, no fixes outside scope, plus unit-specific bans
REPORT       status, branch, head SHA, what it actually ran, deviations, follow-ups
```

A field you cannot fill is a unit you have not scoped. Don't spawn it.

Size the brief to the unit. A one-command unit gets a paragraph that still names the goal, scope, verify command, and report shape.

Siblings cannot see each other. When one unit depends on another, paste the upstream result into the downstream brief.

When the directives changed, spawn a fresh subagent with the consolidated scope. Don't resume the old one with SendMessage, because old directives decay across resumes.

Never resume an agent just to check on it. Judge progress by side effects: files written, commits, and output.

## Fan-out

When several workers cover parallel slices, each one reports `PASS`, `ISSUES`, or `BLOCKED` with evidence. A worker that can prove a defect lists every issue it can prove, not only the first. Drop a result that misses what its brief asked for, and respawn that worker once. After a second miss, record a gap. A gap is not a pass. Return one table, not raw worker output.
