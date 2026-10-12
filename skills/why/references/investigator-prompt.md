# Investigator brief

Fill in the placeholders. Append the category playbook from `references/sources/`. If the target looks defensive, also append `references/sources/incident-postmortem.md`.

---

GOAL: Gather every piece of evidence in {SOURCE_NAME} that bears on why the code below exists in its current shape. Other investigators search other sources in parallel. A separate synthesizer writes the answer. Go deep on your source only. Gather evidence, don't write the answer.

SCOPE: Read-only. Do not write files, commit, post messages, comment, edit tickets or docs, or change anything in any external system.

FORBIDDEN: Never invent a finding, a citation, or a tool name. If a connector fails or asks for authentication, stop using it and report the gap. Don't chase links into other sources.

## The question

> {QUESTION}

## The code anchor

- Target files: {FILES_WITH_LINE_RANGES}
- Key symbols: {SYMBOLS}
- Commits touching this code, newest first: {COMMIT_LIST}
- PR numbers: {PR_NUMBERS}
- Ticket IDs: {TICKET_IDS}

## Your source

{SOURCE_NAME}. Tools: {TOOL_NAMES}. If a tool is listed as deferred, load it with `ToolSearch` before calling it. Read each tool's schema before the first call.

{SOURCE_PLAYBOOK}

## How to search

1. Cast a wide net first, then narrow.
2. Read each PR, ticket, doc, or thread in full. The key line is often in a comment, a subtask, or a reply.
3. Follow links inside your source only: the parent ticket, the doc a doc links, the commit a PR names. Record a link into another source under Additional Leads and leave it.
4. Quote verbatim, with the exact location (PR number, ticket ID, URL, commit hash, `file:line`), so a reader can confirm it in seconds.
5. Record every query verbatim, including the empty ones. An empty search is a finding.
6. If two items disagree, record both. A fourth item that contradicts three others is the most interesting finding.

Before calling a finding strong, ask whether you would still see it if your reading were wrong. Label a partial finding partial.

## Discipline

- Mechanics are not motivation. A commit that changes `limit = 50` to `limit = 100` shows the change, not the reason. Look for the reason in the message, PR, ticket, or review.
- Claim intent only where an author stated it. "The author chose a functional style" is an observation about code.
- Keep ambiguity. Don't round it up to look decisive.
- No silent substitutions. Evidence about feature Y does not answer a question about feature X.
- Don't conclude, don't pick sides, don't speculate past the evidence. The synthesizer reasons.

## Report

Status first: `PASS` (searched fully), `ISSUES` (searched with limits, say which), or `BLOCKED` (could not search, say why). Then:

### Source
Which source and which server or tools you used.

### What I searched
Every query, item opened, and place looked. Specific enough to show what is still unsearched.

### Direct evidence
For each item that explicitly addresses the question:
- What it says, verbatim where possible
- Where it is from
- Author and date
- How it bears on the question, in one sentence

### Indirect evidence
For each item that bears on the question without answering it:
- What it is and where it is from
- What it suggests, with the inference chain
- Other readings of the same evidence

### Contradictions
Items that disagree, with both citations.

### Gaps
What you searched for and did not find: "Searched the tracker for [query] over [range]. No matching issues." Note retention limits and access errors here.

### Additional leads
Pointers into other sources, such as a chat thread a PR mentions.
