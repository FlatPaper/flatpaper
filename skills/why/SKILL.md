---
name: why
description: Find out why code is the way it is. Anchors in git history, discovers which evidence sources this session can reach (issue trackers, docs, chat, observability, error tracking, data warehouse), searches each in parallel, and returns a cited answer with every claim in a confidence tier and every unsearched source named. Use for "why does X work this way", "why did we pick Y", design rationale, where a threshold came from, regressions, postmortems, or before changing code whose purpose is unclear.
---

# Why

Find the forces that gave code its shape. Adapted from poteto's pstack.

For what code does and how it works, use the Investigation playbook (`${CLAUDE_PLUGIN_ROOT}/skills/flatpaper-mode/playbooks/investigation.md`). This skill answers why.

Work like a careful investigator. Say what you know, what you infer, and what you could not find. Every claim sits in one of the confidence tiers in `${CLAUDE_PLUGIN_ROOT}/skills/flatpaper-mode/references/principles.md` (Direct, Supported, Inferred, Speculative, Unknown). `references/epistemics.md` adds the phrasing rules and traps the tiers don't cover.

## Step 1. Pin the target and the question

The target is a chunk of code, a pattern, a feature, or a named decision. The question is a rationale, a tradeoff, a motivating edge case, an outside constraint, dead code, or a history sweep.

If the target is vague, take your best guess from the conversation (open files, recent edits, what was just discussed). State it in one line so the user can redirect, then go on.

Check: one line naming the target and one naming the question.

## Step 2. Build the code anchor

Do this inline before spawning anything. Collect:

- File paths and line ranges, and the key symbols.
- Last-touch commits: `git blame -L <start>,<end> <file>`.
- History through renames: `git log --follow --oneline -- <file>`, then `git log --follow -p -- <file>` where the diffs matter.
- PR numbers from commit subjects (`(#1234)`) and bodies (`git log -1 --format=%B <commit>`).
- The bodies and discussion of each substantive PR: `gh pr view <n> --json title,body,author,createdAt,mergedAt,labels,closingIssuesReferences,comments,reviews`.
- Ticket IDs named in commits or PR bodies.

Note whether the target looks defensive: null checks, retries, timeouts, rate limits, feature flags, egress guards, OOM handling. If it does, investigators also get `references/sources/incident-postmortem.md`.

Check: the anchor lists files, symbols, commits, PRs, and ticket IDs, or says "none found" for each.

## Step 3. Discover the evidence sources

Claude Code exposes MCP connectors as tools named `mcp__<server>__<tool>`. Read this session's tool list, including tools listed only by name as deferred. Don't assume any connector is present, and never guess a tool name.

Map each server to one evidence category:

| Category | Best at | Playbook |
|---|---|---|
| Source control | Rationale captured in review | `references/sources/code-archaeology.md` |
| Issue tracker | The product or business forcing function | `references/sources/issue-tracker.md` |
| Long-form docs | Design rationale written before the code | `references/sources/docs.md` |
| Team chat | Deliberation that never reached a doc | `references/sources/chat.md` |
| Observability and error tracking | The runtime reality that motivated defensive code | `references/sources/observability.md` |
| Data warehouse | Where a number came from, flag and experiment history | `references/sources/observability.md` |

Classify by server name, tool names, and tool descriptions. If a server fits two categories, pick its main evidence and note the call. Source control is always reachable through git and `gh`. GitHub Issues are reachable through `gh issue` even with no tracker connector.

For each server, record one status:

- **Reachable.** It exposes search or read tools. If those tools are deferred, load them with `ToolSearch` before use.
- **Needs auth.** It exposes only `authenticate` or `complete_authentication`. Record it as unreachable and name it in the gaps, with the server to authenticate. Don't stop the investigation and don't start an auth flow unless the user is present and asks.
- **None.** No server in the session maps to the category.

Check: a coverage table with every category, its server or "none", and its status.

## Step 4. Spawn investigators in parallel

Default to full coverage. An empty search is a finding. Spawn one investigator per reachable category, all in one message with `run_in_background: true`. Each owns exactly one category. Don't ask one agent to cover two servers.

- Source control: `subagent_type: "Explore"`, `model: "sonnet"`. It is read-only and needs only git, `gh`, and file search.
- Every MCP-backed category: `subagent_type: "general-purpose"`, `model: "sonnet"`. Tell it not to write files or change anything in the external system.

Each brief is `references/investigator-prompt.md` filled in, plus the category's playbook from the table, plus `references/sources/incident-postmortem.md` when the target looks defensive, plus the anchor and the user's question verbatim.

Skip a category only with a written reason that goes into Sources Consulted. Two reasons are valid:

- **Unreachable.** No server, or it needs auth. This is a gap, not a choice: "Team chat not searched. The Slack connector needs authentication."
- **Provably irrelevant.** A high bar: "Error tracking skipped. The target is a build script with no runtime path."

For a trivial target, one commit whose PR body fully answers the question, you may answer inline. Say that you checked and the other searches would be redundant. This should be rare.

Check: every category is either spawned or has a written skip reason.

## Step 5. Synthesize

When all investigators return, spawn one synthesizer: `subagent_type: "general-purpose"`, `model: "opus"`. General-purpose keeps MCP access so it can spot-check citations. Give it all findings including nulls, the skip reasons, the anchor, the question, and `references/synthesizer-prompt.md` filled in. It reads `references/epistemics.md` and the confidence tiers before writing. When you paste a template into a brief, replace `${CLAUDE_PLUGIN_ROOT}` with the plugin's real path (two directories above this skill's base directory), since a subagent cannot expand it.

Check: the output has every section of the synthesizer template, and Sources Consulted has one line per category.

## Step 6. Present

Hand the user the synthesizer's output. You may tighten it or add context from the conversation. Don't change the confidence language or move a claim between tiers.

If the user asks why because they plan to change the code, add a constraint set after Sources Consulted:

- **Preserve.** Behavior the record says was deliberate.
- **Change.** What the record says is free to change, or was a stopgap.
- **Avoid.** Approaches the record shows were tried and rejected.
- **Risk.** What breaks if a Speculative or Unknown reading turns out wrong.

## Failure modes

- **Recency bias.** The latest commit is not the whole story. The current shape is usually many earlier decisions. Trace back.
- **Confirming the user's guess.** A hypothesis in the question is one candidate. Test it.
- **Code as its own evidence.** What the code does is not why it exists.
- **Silent gaps.** A source you could not reach goes in the answer, by name.

**Reply:** the synthesized answer, then Sources Consulted with one line per category, including the ones not searched and why.
