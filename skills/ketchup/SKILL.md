---
name: ketchup
description: Catch the user up on everything in this chat since their last message, in plain words. Give each action item a short summary with enough context to make the call, shown as a before and after. Use for /ketchup, "catch me up", or "what did I miss".
disable-model-invocation: true
---

# Ketchup

Adapted from poteto's pstack.

Catch the user up on everything in this chat since the last message they wrote before `/ketchup`. Notifications, hook output, and subagent results are not their messages. Write plainly, the way you would talk to a teammate who stepped out. Assume the user remembers their last message and nothing after it. Call each PR, branch, or agent by a name they would know, not by a label you invented during the work.

## Gather what changed

Keep this turn read-only. Do not change code, start an app or a job, or post anything. Collect your own work since that message, reports from subagents, and messages from anyone else in this chat. Check the current state of each PR, CI run, or background agent this chat touched, with `gh pr view`, `gh pr checks`, and the task list. Say which are still running and which you could not check.

An action item is a decision or step only the user can take, such as a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item.

## Write the reply

Open with one sentence that says how many action items there are, or that there are none. If nothing happened and nothing waits on the user, say so and stop.

Then say what happened, most important first. Give each result and what it means for the user. Skip steps that changed nothing. Name in one line any work left that you can do yourself.

Then give each action item a short summary. Cover the decision to make, why it matters now, the options and what each costs, your recommendation, and what happens if the user does not answer. If you do not know a part, say so instead of guessing. Link to the detail when there is one, and write the summary so the user can decide without opening it.

## Show each decision as a before and after

The terminal can't render images, so show each action item as text. Put the current state next to each option, or the options alone when there is no current state. Use whatever fits:

- A short diff or two code blocks labeled **Before** and **After**.
- A table of numbers, with the current value beside each option.
- Command output you already captured, trimmed to the lines that matter.

Never invent a number, and never describe a screen you did not capture as if you saw it. Point only at files and links that exist. If no before and after exists for an item, say so plainly.

Prefer a table or a short block to dense prose. When the catch-up is long, with many items or visuals that need a page, offer in one line to publish it as an Artifact page.

**Reply:** the count of action items, what happened, then each action item with its summary and its before and after.
