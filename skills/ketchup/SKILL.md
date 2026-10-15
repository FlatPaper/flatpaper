---
name: ketchup
description: Catch the user up on what changed in this chat since their last message, in a few plain sentences. Give each action item just enough context to make the call. Use for /ketchup, "catch me up", or "what did I miss".
disable-model-invocation: true
---

# Ketchup

Adapted from poteto's pstack.

Catch the user up on what changed in this chat since the last message they wrote before `/ketchup`, and help them understand each change, not only where it stands. Notifications, hook output, and subagent results are not their messages. Assume the user remembers their last message and nothing after it.

Write in plain words and short sentences, with no jargon, like one person catching up another. Say what changed for the user, not how you did it. Say "the tests pass", not "CI is green". Leave out hashes, file paths, commands, build numbers, and test counts unless the user needs one to act. Call each PR, branch, or agent by a name the user would know, not by a label you invented. If a fact needs context to make sense, give the context or leave the fact out.

## Gather what changed

Keep this turn read-only. Do not change code, start an app or a job, or post anything. Collect your own work since that message, reports from subagents, and messages from anyone else in this chat. Check the current state of each PR, CI run, or background agent this chat touched, with `gh pr view`, `gh pr checks`, and the task list. Check each number you will show against the facts it comes from, and say so when you correct one.

An action item is a decision or step only the user can take, such as a product choice, an approval, an irreversible action, or access you lack. Include any still waiting on the user, even one raised before their last message. Work you can still do yourself is not an action item. Never make up a call to fill the reply. A step the user did not ask for and the work does not need is not an action item, unless it is irreversible and waiting on the user. Then give it one line.

## Write the reply

Keep the reply well under 150 words, not counting before-and-after blocks. Never give a fact twice. Leave out work that changed nothing for the user. When words run short, cut from what happened before you cut from the action items.

Open with one sentence that says how many things need the user, or that nothing does. If nothing happened and nothing waits on the user, say so and stop.

Then give one short bullet per thing the user asked for: what came of it, and whether it is done, still running, failed, or not checked. Write each line the way you would say it out loud: "Search was slow from a missing index", not "Search review: done". Name any bug found and fixed on the way. Each line must stay true when read alone. Never mark something done that still waits on the user, and leave out anything the action items say. Under the summary, give at most three short lines that change what the user knows or must do. Then name in one line any work left that you can do yourself.

Then list the action items as plain bullets. Give each two lines, or one for an unasked irreversible step: the decision with your recommendation and why, then what happens if the user does not answer. Ask the call the user owns, such as merge, approve, or pick. A step you would take first goes in your recommendation. So does anything that must happen first, and anything that cannot be undone. Write "unknown" for a part you do not know. Link to the detail.

## Show a choice as a before and after

The terminal can't render images, so show a choice as text, after the action items. Put the current state next to each option, or the options alone when there is no current state. Give every option the work weighed, each with what it gets the user and what it costs. Use whatever fits:

- A short diff or two code blocks labeled **Before** and **After**.
- A table of numbers, with the current value beside each option.
- Command output you already captured, trimmed to the lines that matter.

Never invent a number, and never describe a screen you did not capture as if you saw it. Point only at files and links that exist. When the catch-up needs screenshots or a diagram to make sense, offer in one line to publish it as an Artifact page.

**Reply:** the count of things that need the user, one bullet per thing they asked for, the action items, then any choice as a before and after.
