# Source control (git and gh)

## What it holds

- Commit messages, dates, authors, and diffs.
- PR bodies, review comments, and discussion, through `gh`.
- Code comments, TODOs, FIXMEs, and deprecation notes.
- ADRs, if the repo keeps them.
- Tests, whose names and assertions often encode the edge case that drove a change.
- Files changed in the same commits (co-change).
- CHANGELOG entries and release notes.
- Ticket IDs in commit messages and PR bodies.

The source closest to the code and the most complete. Everything that went through the repo is here.

## How to search

Expand the seed commits:

```bash
git log --follow --oneline -- <file>          # history through renames
git log -S '<exact string>' -- <file>         # commits that added or removed this text
git log -G '<regex>' -- <file>                # same, for a pattern
git blame -L <start>,<end> <file>             # last touch per line
git blame -w -C -C -M -L <start>,<end> <file> # skip moves and whitespace to reach the real origin
git show <hash>                               # one commit in full
git log <old>..<new> -p -- <file>             # changes between two points
```

Read the PRs and the issues they close:

```bash
gh pr view <n> --json title,body,author,mergedAt,labels,closingIssuesReferences,comments,reviews
gh api repos/{owner}/{repo}/pulls/<n>/comments   # inline review comments
gh pr list --state merged --search '<symbol or phrase>'
```

Look for written rationale outside the commits:

```bash
rg -l -i 'architecture decision|## decision|## context' --glob '*.md'
rg -n -C2 '(TODO|FIXME|HACK|XXX|NOTE)' <file>
rg -l '<symbol>' --glob '*test*'
```

## Good evidence

- A PR body or review thread that states the reason.
- A revert followed by a re-apply "with fix for X".
- A test added in the same commit that pins the edge case.
- A comment next to the line that names the constraint.

## Pitfalls

- A squash merge hides the intermediate commits. The PR's commit list (`gh pr view <n> --json commits`) may still have them.
- A mass reformat or move hides the real origin. Use `-w -C -C -M` on blame and keep walking back.
- A ticket ID in a commit points into the issue tracker. Record it as a lead. Don't search the tracker yourself.
