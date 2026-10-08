# flatpaper

A Claude Code plugin for agent work you can trust and review later. Adapted from poteto's [pstack](https://github.com/cursor/plugins/tree/main/pstack).

Three ideas carry it:

1. Every task has a done check that can fail.
2. Proof comes from the real artifact, not the agent's word.
3. Long work leaves a decision trail you can audit in minutes.

## What's inside

| Piece | What it does |
|---|---|
| `guidelines.md` | Always-on rules, loaded at session start by a hook |
| `UserPromptSubmit` hook | One-line reminder on every prompt: concise replies, and a done check, proof, and constraints |
| `/flatpaper:flatpaper-mode` | Rigorous mode. Matches the task to a playbook (investigation, bug fix, feature, refactoring, prototype, autonomous run) |
| `/flatpaper:show-me-your-work` | Decision log (TSV), audited against the transcript, with an Attention section from a fresh reviewer |

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

## Use

Quick questions need nothing. The guidelines are always on.

For real work, say the goal and how you'll know it's done:

```
/flatpaper:flatpaper-mode the dashboard shows no runs through the Coder URL. repro first, then fix. done means a smoke run appears through the Coder URL. show me the /api/runs response.
```

When you step away:

```
/flatpaper:flatpaper-mode im stepping away. <goal>. done means <predicate>. keep a decision log. if stuck, stop and write up why.
```

When you're back:

```
/flatpaper:show-me-your-work catch me up on what you did
```

Read the Attention section first.
