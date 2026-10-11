# flatpaper

A Claude Code plugin for agent work you can trust and review later. Adapted from poteto's [pstack](https://github.com/cursor/plugins/tree/main/pstack).

It is built for Claude Code. The hooks, the `/flatpaper:` skill names, the task tools, and the plugin layout are Claude Code's. pstack is the Cursor version of the same ideas.

Three ideas carry it:

1. Every task has a done check that can fail.
2. Proof comes from the real artifact, not the agent's word.
3. Long work leaves a decision trail you can audit in minutes.

## What's inside

| Piece | What it does |
|---|---|
| `guidelines.md` | Always-on rules, loaded at session start by a hook |
| `UserPromptSubmit` hook | One-line reminder on every prompt: concise replies, and a done check, proof, and constraints |
| `/flatpaper:flatpaper-mode` | Rigorous mode. Matches the task to a playbook (investigation, bug fix, feature, refactoring, prototype, autonomous run, architecture page) |
| Architecture drift line | At session start, says when `docs/architecture/` is behind this repo's commits, or behind the latest release of the repo it describes. Silent otherwise. |
| `/flatpaper:show-me-your-work` | Decision log (TSV), audited against the transcript, with an Attention section from a fresh reviewer |
| `/flatpaper:create-verification-skill` | Generates a project-local `verify-<app>` skill (launch, doctor, drive, evidence, cleanup, feature map) and proves it once, including that Doctor can fail |

## Install

Load it from a local clone with a shell alias. Edits take effect on the next session.

```bash
alias claude='claude --plugin-dir ~/Documents/GitHub/flatpaper'
```

To use it in the IDE extension or desktop app too, install it from the local clone instead. Nothing is published.

```bash
claude plugin marketplace add ~/Documents/GitHub/flatpaper
claude plugin install flatpaper@flatpaper --scope user
```

## Settings

Add these to `~/.claude/settings.json`, then restart Claude Code. A session that is already open keeps its old tool list.

```json
{
  "env": {
    "CLAUDE_CODE_ENABLE_TODO_TOOLS": "1"
  },
  "attribution": { "commit": "", "pr": "", "sessionUrl": false }
}
```

| Setting | Required | Why |
|---|---|---|
| `CLAUDE_CODE_ENABLE_TODO_TOOLS=1` | Yes | Claude Code hides `TaskCreate` and `TaskUpdate` by default on newer models. flatpaper-mode puts each playbook step in the task list with them. Without it, the mode falls back to a checklist in its replies. |
| `attribution` | No | Removes the Claude co-author line from commits and PRs, enforced by Claude Code instead of a rule. |

Optional tools: `jq` and `gh` (logged in). The finish steps read a PR back with `gh`. Without it, that check is reported inconclusive. The architecture drift line uses both to check the latest release of the repo a page describes. Without them, it still checks this repo's commits.

## Use

Quick questions need nothing. The guidelines are always on.

### The prompt format

For real work, start with the mode and give up to five parts, one sentence each:

```
/flatpaper:flatpaper-mode <goal>. done means <check>. show me <proof>. <what you know>. <constraints>.
```

| Part | What it is | Example |
|---|---|---|
| `<goal>` | The outcome, not the steps. Its wording steers the playbook (see below). | fix the csv export dropping its last row |
| `<check>` | Something that can pass or fail. Not "see if", not a duration. | done means the 60k-row fixture exports every row |
| `<proof>` | The real output you want to see. | show me row counts before and after |
| `<what you know>` | Facts only, not your theory of the cause. | started after yesterday's deploy. failing job is 4812 |
| `<constraints>` | What it must not do, or must do first. | repro first. no PR. don't touch the schema |

Only the goal is required. A missing check, proof or constraints gets proposed back to you in one line, but yours is the one the agent can't quietly weaken.

### Words that steer the playbook

| Say | Playbook |
|---|---|
| how does, why is, is anything wrong, are we sure | Investigation (read-only) |
| fix, broken, repro | Bug fix |
| add, build, support | Feature |
| clean up, restructure, without changing behavior | Refactoring |
| try, sketch, which works better | Prototype |
| im stepping away, run until, /loop until | Autonomous run |
| map this repo, update the architecture page | Architecture page |

### Several tasks in one session

Each prompt is matched to a playbook again. When the kind of work changes (review, then fix, then PR), the mode switches playbooks and marks the old one's open steps as superseded. Starting with `new task:` makes the switch explicit. Don't `/clear` in between. The next step usually needs what the last one found.

```
/flatpaper:flatpaper-mode is anything on the architecture page wrong or hard to follow? done means each finding cites the line and the code that contradicts it. read-only.
fix the wrong items. show me a before/after table with evidence. no PR yet.
raise a draft PR.
```

Every playbook ends with the same finish steps: run the repo's tests, follow its PR rules, and read the PR back with `gh pr view`. The repo's rules files (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `docs/README.md`, the PR template) are read at the start of every task.

### Examples

```
/flatpaper:flatpaper-mode the dashboard shows no runs through the Coder URL. done means a smoke run appears through the Coder URL. show me the /api/runs response. /ws returns 403 through the proxy; a local tunnel works. repro first.

/flatpaper:flatpaper-mode scan every test in this repo for tests that would pass if the code did nothing, and for behavior with no test. done means every test file is judged. show me the results as an artifact. no PR.
```

When you step away:

```
/flatpaper:flatpaper-mode im stepping away. <goal>. done means <check>. keep a decision log. if stuck, stop and write up why.
```

When you're back:

```
/flatpaper:show-me-your-work catch me up on what you did
```

Read the Attention section first.

Once per repo, give the agent a scripted way to prove the app works:

```
/flatpaper:create-verification-skill
```
