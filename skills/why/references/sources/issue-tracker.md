# Issue tracker

Covers Linear, Shortcut, Jira, GitHub Issues, and others like them. Use whichever the session reaches: an `mcp__<server>__<tool>` connector, or `gh issue` for GitHub Issues. Read each tool's schema before calling it. Tool names differ by tracker.

## What it holds

- Issues, stories, or tickets that state the feature, bug, and motivation.
- Comments: clarifications, scope changes, "why we're doing this".
- Parent and child links: an epic or initiative above a tactical ticket.
- Labels or tags that name the kind of motivation (`compliance`, `customer-request`, `perf`, `incident-followup`).
- Projects, milestones, iterations, and deadlines.
- Attached specs and linked PRs.

This is where the product and business reason usually lives: "customer X asked" or "this is for the Q3 compliance push."

## How to search

1. **Start with linked IDs.** Fetch every ticket ID from the anchor first (`ENG-1234`, `sc-5678`, `PROJ-91`, `#412`). Read the whole ticket, comments included.
2. **Search by keyword.** Feature name, key symbol, error string, business term. Try several phrasings.
3. **Search by PR.** Many trackers record linked PRs. Search for the PR number or URL.
4. **Walk up.** From a child ticket, fetch its parent, epic, or initiative. Children are tactical. Parents carry the why.
5. **Read the project.** Project or epic descriptions and attached docs often hold the spec.
6. **Check labels and milestones.** They name the kind of motivation and the deadline.

For GitHub Issues without a connector:

```bash
gh issue view <n> --json title,body,author,createdAt,closedAt,labels,comments
gh issue list --state all --search '<phrase>' --limit 50
```

## Good evidence

- A description that states the business problem: "Acme needs X for their SOC2 audit."
- A comment that records a decision and its reason.
- A parent titled like an initiative: "Reduce payment failures."
- An attached spec, or labels like `incident-followup` or `compliance`.

## Pitfalls

- **Scope drift.** A ticket closed and reopened with a new scope. Read the history.
- **Template filler.** A required "Why" field with "improve user experience" is not an answer.
- **Stale plans.** Compare the ticket's dates with the ship date.
- **Duplicate chains.** Follow closed-as-duplicate links to the canonical ticket.
- **No access.** A ticket you can't open is a gap. Don't guess its contents.

## What to return

Per ticket: ID, title, link, author, created and closed dates, labels, parent, and the motivation quoted verbatim.
