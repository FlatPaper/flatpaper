---
name: technical-writing
description: "Layered technical-writing standard: Diátaxis mode first, Google developer style sentences, STE instruction rules, Global English syntax. Use for /technical-writing, or when writing or reviewing docs, RFCs, READMEs, PR descriptions, or commit messages."
---

# Technical writing

Write so a tired engineer understands on the first read. Apply all four layers.

Three rules sit above the layers:

- **Cut every word that does no work.** If the sentence survives without a word, the word goes. "In order to" is "to". "It is important to note that" is nothing.
- **Use the short, everyday word.** "Use", not "utilize". "Help", not "facilitate". "Do", not "perform". A long word has to buy its length with precision.
- **When a rule makes a sentence worse, fix the sentence another way or leave it alone.** A sentence that follows every rule and sounds like a machine wrote it has failed.

The codebase is the word list. Write the real symbol, file, flag, or command name, not a synonym or a description of it.

Don't invent jargon. Use the words a developer would say out loud: "move", "delete", "a budget that only decreases", not "evacuate", "ratchet", or "endgame". A named pattern is fine when the doc says what it means the first time. To add a new offender, propose it and its replacement for rule 26 of the `unslop` skill in your reply, with the diff. Don't edit that skill.

## Vary the rhythm

A doc can obey every layer and still read machine-written: every sentence clipped short, no view anywhere, nothing specific.

- Mix sentence lengths on purpose. Short sentences land a point. Longer ones carry a fact with its condition or consequence.
- Split the sentence that carries two thoughts. Keep the long sentence that carries one.
- Have a view where the mode allows it. Explanation weighs trade-offs, so say what you make of them. Reference stays dry.
- Be specific. Not "schema changes can cause issues" but "a column rename fails the build".

## Pick the mode first (Diátaxis)

One document, one mode. Two questions pick it: does the content serve doing or understanding, and does it serve learning or work?

- Doing and learning: **tutorial**. Say what the learner will build. Every step produces a visible result, and you tell them what they should see. Cut explanation to one clause and a link. Write as "we", in commands.
- Doing and work: **how-to**. Solve a problem a person has. Assume competence. Action only, and link the background. Allow forks: "If you want x, do y." Name it by the task: "How to calibrate the radar array".
- Understanding and work: **reference**. Only describe. Dry, complete, and sure, with no hedging. Mirror the structure of the thing described. Generate from code where possible.
- Understanding and learning: **explanation**. One bounded topic that tolerates an implicit "About..." in front of its title. Anchor on a real why question. Give design decisions, history, constraints, and alternatives. Opinion is allowed here and nowhere else.

Don't mix modes. Split and link instead.

## Write sentences to the reader (Google developer style)

- Talk to the reader as "you", in the present tense. "Will" only for things that happen later.
- Say who does what: "the compiler checks", not "is checked".
- Write instructions as commands: "Click Submit." Never "should be done".
- Put the condition before the instruction: "To delete the document, click Delete."
- Put the common case first. Exceptions after.
- No buzzwords, no figurative language, no "please" in instructions, and never "simply", "easy", or "quickly" in a procedure.
- Don't pre-announce ("we will soon support...").
- Link text says where the link goes. Never "click here".
- Headings carry the point, in sentence case. A task heading is a bare verb phrase. One h1 per page, no skipped levels.
- Numbered lists for sequences, bullets for everything else. Introduce a list with a complete sentence. Keep items parallel.
- Code goes in code font. UI elements go in bold. Use serial commas. Drop "etc." and say up front that a list is partial.

## Make statements load one at a time (STE rules)

- One instruction per sentence. One thought per sentence everywhere else.
- Split instructions longer than about 20 words and other sentences longer than about 25.
- Put the warning or condition before the step it guards.
- Keep "the" and "a": "Remove backup file" reads two ways. "Remove the backup file" reads one.
- Give each word one meaning, and one word per action: "start" everywhere, not "start" here and "initiate" there.
- Write procedures as direct commands, never as narration or in the passive.
- Avoid "-ing" words where a plain verb works.

## Leave no sentence open to two readings (Global English)

- Keep "only" and "not" next to the word they change: "only fails on growth" and "fails only on growth" say different things.
- Break up long noun strings: "the proto import budget check script" becomes "the script that checks the proto-import budget".
- Make every "it", "they", and "this" point at one obvious thing. Repeat the noun when in doubt.
- Don't drop verbs: "Phase 1 moves the converters and Phase 2 the runtime" leaves Phase 2 without one.
- Keep the small words that show structure, such as "that" in "Ensure that the switch is off".
- Say which parts "and" or "or" joins when a sentence can group two ways. "Both...and" and "either...or" fix it for free.
- Use periods, not semicolons. Replace an em dash with a new sentence.
- No slashes: write "a, b, or both" instead of "a/b" or "and/or". Never form plurals with "(s)".
- Call each thing by one name, everywhere.
- Skip idioms, Latin abbreviations, and metaphors.

## Voice and repo specifics

- Run the `unslop` skill over every doc this skill touches. That skill owns the slop-pattern catalog.
- PR descriptions and commit messages are writing too. Every layer except Diátaxis applies. A PR body is a briefing a reviewer reads in under a minute. Link logs, SHA lists, and metric tables instead of pasting them.
- Product UI strings are not documentation. Use the product's copy guidelines.
- Write real paths. Make every count or tree claim true at the commit that lands it, and include the command that regenerates it.

## Worked example

Before:

> Configuration of the proto import ratchet budget script parameters is performed via budget.json. Note that it's important to remember that running with --write, which updates the committed budget to reflect the current count, should only be done when lowering it. If exceeded, CI fails.

After:

> `budget.mjs` reads the committed budget from `budget.json` and counts the files that import protos. If the count exceeds the budget, CI fails. Run `budget.mjs --write` only to lower the budget.
