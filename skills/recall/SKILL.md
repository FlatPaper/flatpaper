---
name: recall
description: Rebuild your recent working context from this project's Claude Code session transcripts, live git and PR state, decision logs, and the shared record (user reports, prior fixes, incidents), then hand back a tight current-state brief. Use for /recall, "recall my work on X", "what have I been working on", "where did I leave off", before starting or resuming work.
disable-model-invocation: true
---

# Recall

Before you start or resume work, rebuild the user's recent working context and hand back a tight brief of where things stand and what to do next. Read only what the in-scope threads need, then stop.

The context lives in two records. This project's session transcripts hold what you did and decided. The shared record holds everything that happened around the same code under other names: the symptoms users keep reporting, the fixes that shipped and got reverted, the errors still firing in prod. That second record is what the `why` skill searches. A feature with a long bug tail keeps most of its story there, so don't rebuild it from transcripts alone.

## Where transcripts live

Claude Code stores each session at `~/.claude/projects/<project-dir>/<session-id>.jsonl`. `<project-dir>` is the working directory path with each `/` and other non-alphanumeric character turned into `-`, such as `-Users-me-src-app`. Each line is one JSON event. The user is asking about their own sessions, so reading this project's directory is allowed. Also read the directories for this project's worktrees. Map each path from `git worktree list` to its `<project-dir>` name. A name prefix match is not enough, since an unrelated project can share the prefix. Never read any other project directory. They hold unrelated private chats.

## Steps

1. Classify, then route. Resuming one specific prior session is the Session pickup playbook (`${CLAUDE_PLUGIN_ROOT}/skills/flatpaper-mode/playbooks/session-pickup.md`), not this. A catch-up on the current chat is the `ketchup` skill. Recall loads working context across recent sessions before you act. If the user already gave you the full state (paths, branch, the change), use it and skip the mining.
2. Lock the scope before searching. Pin the window ("recent" defaults to the last 7 days), the topic if named, and the project (always this one). State the scope back. Never quietly turn "all" into "recent N".
3. Mine the transcripts. List them by real modification time (`ls -t`), never by name. Skip the current session and obvious noise (subagent and test runs). Grep for the topic first, then read only the matching sessions and only their relevant regions. For more than two sessions, spawn parallel `Agent` workers (`subagent_type: Explore`, `model: haiku`, `run_in_background: true`), each taking a slice. Pass each worker its explicit list of transcript files. A worker never globs `~/.claude/projects`. Each returns one block per session: topic, the user's goal, decisions, open threads, struggles and corrections, and artifacts (PRs, branches, tickets), citing the session id. The raw transcripts stay in the workers. You get only their findings.
4. Read the decision logs. Look for show-me-your-work logs (`decisions.tsv`, `.audit/*.tsv`) and any `RESUME.md` in the repo and its worktrees. Their rows are the shortest path to what was decided and why.
5. Sweep the shared record whenever the topic names a feature, file, subsystem, or bug. This is the default, not a judgment call. Hand it to the `why` skill's source investigators, but steer the question to "what's the current state, what's been tried and didn't hold, and what are users still reporting". Run them in parallel with step 3. Null results are findings. Skip an unavailable connector and say so. Skip this step only for pure activity recall with no named target ("what did I do this week").
6. Verify against live state. Run `git status`, `git branch -vv`, `git worktree list`, and `gh pr list --author @me`. Check each PR and branch the mining surfaced with `gh pr view` and `gh pr checks`. A transcript's claim is not proof of what is true now.
7. Write the brief to the contract below. Group by thread. Stay on the named topic.

## Output contract

Lead with the capsule, then thread status, then problems, then the next move.

- **Capsule.** At most 5 bullets. What this work is and where it stands overall.
- **Threads.** One line each, prefixed with exactly one status tag: `[merged #N]`, `[open PR #N]`, `[in flight <branch>]`, `[verified, uncommitted]`, `[reverted #N]`, or `[planned, not started]`. Tag every thread.
- **Problems.** At most 5, the recurring ones. Include the symptoms users keep reporting and any fix that shipped and was reverted, so the next attempt starts where the last one failed.
- **Next move.** The single most useful next action, concrete.

An adjacent feature or ticket stays out unless it blocks this one. When the brief outgrows a screen, cut detail before you cut threads. Write it through the `unslop` skill. Cite transcript findings by session id and shared-record findings by source (PR number, ticket id, thread link). Strip private context before any public output.

**Reply:** the brief, to the contract above.
