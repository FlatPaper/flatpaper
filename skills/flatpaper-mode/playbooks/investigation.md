### Investigation

**You own the answer.** Read-only. The output is a cited explanation or a recommendation, not a code change.

1. Trace the code with read-only Explore subagents when the area is large. Read directly when it is narrow.
2. For "why was it built this way" questions, check git history (`git log -S`, `git blame`), linked PRs, and issues. "Nobody wrote down why" is a valid finding.
3. Separate evidence from inference. Cite `file:line`, commits, and command output for each claim.
4. For a choice between options, answer with a recommendation and a tradeoffs table. If running something would settle the choice, say so and route to Prototype.

No code changes. If the findings point at a fix, say so and stop. The fix starts as a new task.

**Reply:** the answer first, then the evidence used, then open questions. For "are we sure?", give your real judgment and push back if the premise is wrong.
