---
name: show-me-your-work
description: Keep a reviewable decision trail for long-running, unattended, or multi-phase work. A TSV log with one row per decision (what, why, evidence, result), audited against the transcript and reviewed by a fresh subagent before handing back. Use for /show-me-your-work, autonomous runs, or work the user reviews after stepping away.
---

# Show me your work

Keep one decision log per task. Adapted from poteto's pstack.

## The format

A TSV file, one row per decision. Cells stay on one line. Evidence is a pointer, not prose.

- **ts.** ISO 8601 timestamp.
- **phase.** The phase or workstream.
- **decision.** What was chosen or done, in one line.
- **why.** The reason in plain words, as you would tell a teammate.
- **evidence.** A pointer that proves it: commit SHA, PR number, `file:line`, a log path, a screenshot path. Never a paragraph.
- **result.** The outcome: `tests green`, `reverted`, `INCONCLUSIVE`, `open`.

Example:

```
ts	phase	decision	why	evidence	result
2026-10-02T07:14:22Z	verify	checked the live daemon on the workspace	stop reading source and look at the real box	moab service status	ws 101, /api/runs 200 with []
2026-10-02T07:14:45Z	pivot	looked at why runs are missing, not the dashboard	empty list means runs never registered	runs/*/runner.log	preflight rejects the model name
```

## Logging a row

Use the helper. It stamps the time, writes the header on first use, strips tabs and newlines, and neutralizes cells a spreadsheet would run as formulas.

```
"${CLAUDE_PLUGIN_ROOT}/skills/show-me-your-work/scripts/log.sh" <logfile> <phase> <decision> <why> <evidence> <result>
```

Log decision points, not every action: a fork chosen, a unit finished with its check result, a pivot or revert and what triggered it, a blocker. In a loop, one row per iteration.

When you return to a log another run wrote, read its last rows first. Your first row uses phase `start` and names your run.

## Where it lives

`decisions.tsv` in the working directory, or `.audit/<task-slug>.tsv` when several tasks share a directory. Keep it out of git by default. Commit it only when a reviewer needs the trail to trust the result.

## Rules

- Append-only. A wrong call gets a new row that supersedes it. Never edit or delete a row.
- Prefer evidence from committed scripts over one-off commands.

## Audit before handing back

1. Read this session's transcript at `~/.claude/projects/<project-dir>/<session-id>.jsonl`. Read only this session's file.
2. Check each row. It maps to a real decision or action, and its evidence resolves and shows what the row claims.
3. A fork, pivot, or abandoned approach that shaped the work but has no row is a gap. Add a row.
4. Correct the log by appending rows, never by editing.

## Fresh review

Spawn a subagent that did not do the work. Use a different model from the one that did the work when one is available. It reads the log and the transcript and flags:

- decisions with weak or missing evidence
- verification claimed without proof in the transcript
- choices that look risky in hindsight
- open items nothing closed

Same-family review is weaker than a different model family. Say which model reviewed.

## The reply

End with an **Attention** section. First line `reviewed by <model>`. Then each flag, pointing at specific rows. "No flags" is a valid value.

The user reads Attention first, then only the rows it points to. Render the log in a terminal with `column -s$'\t' -t decisions.tsv`.
