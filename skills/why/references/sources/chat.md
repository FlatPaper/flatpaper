# Team chat

Written for Slack. Adapt it for Microsoft Teams, Discord, and others like them. Read each tool's schema before calling it. Tool names differ by connector. If the connector exposes only an authenticate tool, or a call fails on auth, stop and report chat as not searched. Don't invent findings.

## How to search

1. **Author and date.** Messages from the PR author in the days around the merge. This narrows the search a lot and often finds the discussion.
2. **PR link.** Chat often links PRs during review. Search for the PR URL, or `/pull/<n>`.
3. **Error string.** If the code handles a specific error, search the string. Incident threads surface this way.
4. **Feature name or symbol.** Then narrow to the channels that come up.
5. **Fetch the thread.** Always read the whole thread, not the single hit.

## Pitfalls

- **Retention.** Old messages may be gone. If nothing exists before some date, report the cutoff as a gap.
- **DMs.** Many decisions happen in private messages you can't search. Name that limit.
- **Jokes are not decisions.** "lol just do the thing" before a commit is not a rationale. Look for considered discussion.
- **Context collapse.** One message reads differently without its thread.

## What to return

Per message or thread: channel, permalink, author, date, the relevant lines quoted verbatim, and whether it reads as a decision or as passing talk.
