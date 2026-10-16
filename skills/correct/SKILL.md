---
name: correct
description: Find the mistakes agents keep repeating in this repo and make each one impossible. Try architecture first, then types, then a lint whose error names the fix, then a hook or test, and write docs last. Prove each check fails on the mistake and passes on the fix. Use for /correct, or each time the user corrects you for the same thing twice.
disable-model-invocation: true
---

# Correct

The user keeps correcting agents in this repo for the same mistakes. Change the repo so the next agent can't make them. This is the "encode lessons in structure" principle in `${CLAUDE_PLUGIN_ROOT}/skills/flatpaper-mode/references/principles.md`.

Assume every contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Design the repo so a change that looks right from one file is right for the whole repo.

## Find the mistake classes

Read recent commits, reverts, review comments, `CLAUDE.md` and `AGENTS.md`, and comments that explain workarounds. Read the user's corrections in this session too. Group the mistakes into classes. A class counts once it has happened twice.

## Fix each class at the highest level that works

1. **Eliminate it with architecture.** Give each piece of state one owner and each task one supported way. Hide internals so the wrong import fails. Replace hand-synced lists with one source of truth. Delete old ways and dead code an agent would copy.
2. **Enforce it with types so the bad state can't be written.**
3. **Add a lint or CI check whose error names the fix.** If bad code still compiles, fail with a message that names the file, type, or function to use instead. If the pattern is already common, fail only when a change adds more.
4. **Block it with a Claude Code hook.** Use this when the mistake is an agent action, not code: a command it runs, a file it edits, a step it skips before stopping. Put a `PreToolUse`, `PostToolUse`, or `Stop` hook in `.claude/settings.json`, or in a plugin's `hooks/hooks.json`. Have it exit non-zero with a message that names the fix. A hook only binds Claude Code sessions, so prefer a lint or CI check when people and other tools also touch the code.
5. **Test the behavior.** Fix or delete any test that would still pass if every function it calls returned nothing, or that fails when only the internals change.
6. **Write docs or `CLAUDE.md` rules last, only for judgment calls.** Nothing fails when an agent skips them. Give the rule a prominent spot and an example of the failure.

## Fix and prove

Fix the most frequent classes now, one commit each. Prove each new check both ways: run it on a real past mistake and paste the failure, then run it on the fix and paste the pass. A check you have only seen pass proves nothing. Run the same command locally and in CI. Exceptions go on the offending line with a reason, an expiry date, and a human's approval.

## Keep the rule table

Keep a table in `CLAUDE.md` that pairs each rule with what enforces it. When the user corrects you, fix the mistake and add the rule. If the rule was already there and nothing enforces it, that's a repeat, so fix it at the highest level in the same change. Drop a rule once its mistake can't happen.

**Reply:** each class with its evidence, the level you picked and why a higher level didn't work, and the pasted fail and pass output for each new check.
