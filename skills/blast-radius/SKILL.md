---
name: blast-radius
description: Find what a change could break somewhere else before it ships, beyond the diff, and prove the one fact it is safe because of by running real code. Takes a diff, a branch, or a PR. Use for /blast-radius, "what could this break", "blast radius of X", or a small diff you don't trust yet.
disable-model-invocation: true
---

# Blast radius

Find what a change breaks somewhere else, before it ships.

Listing the callers is not the job. Grep finds those in a second. The job is the breakage grep won't show you.

## Input

A diff, a branch, or a PR.

- **A diff.** Read it as given.
- **A branch.** `git diff <base>...<branch>` and `git log <base>..<branch>`.
- **A PR.** `gh pr diff <number>` and `gh pr view <number> --json title,body,baseRefName,commits,files`.

With no input, use the current branch against its base.

## Don't trust your own writeup

A blast-radius writeup that sounds right is worthless. It reads as convincing whether or not it is true. So don't hand back the writeup alone. Find the one or two facts the change's safety depends on and prove them by running code.

### How sure are you

Take each such fact as far down this list as is cheap, and say where it stopped.

1. You said so. Worthless on its own.
2. You pointed at the line. A real `file:line`, or the library's own source.
3. You showed the bad case can't happen. You walked the failure step by step and it does not reach.
4. You ran it. A script or test that calls the real code and fails loud if you are wrong.
5. You reproduced it in the running app.

Step 4 is usually one small script that imports the same library the app ships and calls the exact function you are worried about. Step 5 uses the project's `verify-<app>` skill if one exists.

## Steps

1. Read the change. Read the diff, the symbols it adds, changes, and deletes, and what it now does differently. Include the part the diff doesn't spell out. Read the PR body and commit messages for intent.
2. Find the one fact it is safe because of. Most changes that look risky are safe because of a single fact, like "this call only drops cache entries that are already dead and does nothing else". If that fact holds, most risky cases clear at once. Spend your time here, not on a long list of maybes.
3. Look where grep stops. Read the source of the library you call at its pinned version, and check for any local patch. Work out when things run: async ordering, retries, teardown, startup order. Follow what a symbol search misses: the JSON an API returns, a wire format, a DB column, another language reading the same bytes, a feature flag, a config value, code three hops downstream.
4. Be honest about each risk. Give it a real chance of happening and a real cost if it does. Keep the risks you confirmed. List the ones you checked and cleared separately. Cite a real `file:line`. A search that finds nothing is still an answer. Never invent a caller or an API.
5. Prove the one fact. Write a script or test that runs the real code, run it, and paste what happened. Leave it where a reviewer can rerun it, and show the command.

## What to hand back

- **What it does.** What changed, including the part that isn't obvious.
- **The one fact it is safe because of.** State it, say which rung of the list you got it to, and show the proof. If you could not prove it, write unproven.
- **Risks.** Each names how it breaks, the `file:line`, how likely and how bad, and how to check. Paste the proof for the ones that matter.
- **Cleared.** What you checked and why it is fine.
- **Before you merge.** The cheapest test or repro that catches the real bug, and the rerunnable script for the one or two facts the change is safe because of.

Cite real code. Strip anything private before it goes anywhere public.

**Reply:** the writeup above, with the one safety fact either proven or marked unproven, and the command that reruns its proof.
