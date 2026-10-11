### Pause safely

**You own a clean stop. Leave a checkpoint a cold-start session can resume from.**

This fires only on an explicit request ("pause", "stop for now", "wrap up"). On "keep going" or "going to bed, keep going", do not pause.

1. Stop at a safe boundary. Finish the current atomic step or back out of it. Start nothing new. Stop running subagents, `/loop` wakes, and Monitor watches.
2. Take no irreversible action to pause. Never `push --force`. Don't push a branch with an open PR, since a wip commit restarts CI and notifies reviewers. Open no PR. Skip the Finish steps with the reason `pause`, and leave the playbook's open steps open.
3. Make one `wip:` commit on the current branch (use the repo's commit format if it rejects `wip:`, and keep the word wip), staging only the files you changed (`git add <files>`). If the current branch is main and the user did not make main the working branch, create a wip branch first. If the tree is broken, say so in one line of the commit body.
4. Write the resume note to a file outside the context. Use the active decision log, or a `RESUME.md` in the scratchpad or the worktree (untracked). It says where you are, what's done and verified, what's next, and the open questions, with key file paths. Read it back.

**Reply:** where you stopped, the commit and whether the tree is clean, the resume note path, and the first action on resume. This is a pause, not a final report.
