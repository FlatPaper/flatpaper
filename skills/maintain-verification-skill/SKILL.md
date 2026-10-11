---
name: maintain-verification-skill
description: Keep a project's verification skill and feature map honest. One read-only reader per feature file, one live session that drives every feature, and at most one PR of proven corrections. Use for /maintain-verification-skill, "audit the verify skill", or after notable app changes. Can run on a schedule.
disable-model-invocation: true
---

# Maintain a verification skill

A feature map rots as soon as the app changes. This skill is the upkeep loop for a skill made by `/flatpaper:create-verification-skill`, or any project-local verification skill with a feature map. Adapted from poteto's pstack.

The unit of rigor is the feature, not every sentence. Cover every feature file from source and drive every feature live. You don't have to run every bullet.

## Outcomes

Pick one, and say which.

- **clean.** Every feature got source and live coverage. Nothing is worth shipping. No branch, no PR.
- **changed.** One PR ships proven corrections to the docs, the harness, or the map.
- **blocked.** Coverage could not finish, or a proven fix could not ship safely. Say exactly what blocked it.

## Edit scope

Edit only the verification skill's own directory: its `SKILL.md`, `features/`, and any harness scripts it owns. Never edit product code. When the app no longer does what the map says, that is either doc drift (fix the map) or a product regression (report it, and don't paper over it in the docs).

## Pass

1. Locate the target. Find the project-local skill with Launch and Drive sections and a feature map, usually `.claude/skills/verify-<app>/`. With several candidates, ask which one. With none, stop and point at `/flatpaper:create-verification-skill`. Don't invent a target.
2. Index hygiene. Read `features/README.md` and list its sibling files. Fix missing, extra, duplicate, or dead entries. Keep this light.
3. Source wave. Launch one read-only Explore subagent per feature file, all at once. Each one reads the source and explains how this user-facing feature works, flags likely doc drift with `file:line` citations, and returns one short recipe for checking it live. Readers never drive the app and never edit files. Return shape: feature summary, source entry points, likely drift or none, one recipe.
4. Reconcile. Every feature file has a returned summary. Merge overlapping recipes into as few app states as practical. Spot-check the drift readers cited. Don't re-prove clean claims. Sweep recent commits for user-facing surfaces the map is missing. Call one missing only with a concrete source path.
5. Live pass. Required even when the source looks clean. One coordinator, the main thread, does all the driving. Follow the verification skill's own launch model: one long-lived instance driven in turn for servers and UIs, or a fresh isolated session per drive for short-lived CLIs. The skill's Launch section decides. Drive every feature at least once. Hold three invariants the whole pass, whatever fails:
   - Health-check before driving. Run Doctor before the first drive, on each fresh session where sessions are the unit, and again after any failed drive. Where Doctor can't see the failure, such as a stuck UI on a healthy process, reset to a known state or relaunch.
   - Evidence survives every cleanup. Check it at its named location. Don't assume it.
   - Nothing a drive started outlives it. Clean up after failed attempts too, whether the session is stuck, exited, or shared. For a shared instance, clean what the drive left behind, not the instance.

   A Doctor failure caused by drift in the skill is drift. Fix it under edit scope, restart only what the fix invalidated, and retry once before calling the pass blocked. A feature that can't be reached is `verified-unreachable` only with the concrete prerequisite (auth, entitlement, OS, external state) and the route you tried. If the map omits that prerequisite, that is drift. Drive any harness fix live again before it ships. Final teardown happens after the last drive, re-proofs included. The evidence stays.
6. Triage. Classify each failure as one of these:
   - **Doc drift.** The user-POV description is wrong or missing. Fix it.
   - **Harness gap.** The behavior works but the harness can't drive it. Fix the harness. Any script it ships is executable and its invocation is shown in the skill body.
   - **Product gap.** The app is broken. Record it for the user. Keep it out of this PR.
7. Ship or stop. For changed, open one PR of proven corrections, and re-read every changed file first. Follow the repo's commit and PR rules, and read the PR back with `gh pr view --json title,body,baseRefName,isDraft` and `gh pr checks`. For clean or blocked, open no PR. Report the outcome and the coverage honestly.

Keep short run notes in a scratch location: features covered, unreachable prerequisites, confirmed drift, outcome. Don't commit them.

## On a schedule

This pass suits a recurring run. Use `/schedule` for a cron-driven cloud agent, or `/loop` to repeat it in a session. A scheduled run follows the same outcomes and edit scope.

**Reply:** the outcome (clean, changed, or blocked), features covered live and from source, each failure with its class, product gaps for the user, and the PR link if one shipped.
