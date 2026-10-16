# Epistemics

How to reason and write when the evidence is old, partial, and sometimes contradictory. The five confidence tiers (Direct, Supported, Inferred, Speculative, Unknown) are defined in `${CLAUDE_PLUGIN_ROOT}/skills/flatpaper-mode/references/principles.md`. This file adds what the tiers leave out.

Code shows what it does, not why it exists. The why lives in commits, PRs, tickets, docs, and conversations, and all of them are incomplete. A confident guess misleads the user, because they will act on it.

## Claims about human decisions

When the exact scope of a human ruling matters, find the person's original words. Keep the source, the speaker, and enough of the wording to show the scope. An agent's summary of a ruling is an interpretation, however old it is, and a paraphrase alone cannot establish the scope. If the original is gone, say so and leave the scope uncertain. Never invent a firm ban or permission.

"Avoid that endpoint during this migration" and an agent's "the user forbids that endpoint" are different claims. Report the original and the interpretation separately. Copies of one interpretation in several notes are one evidence chain, not several decisions. Trace them to their source before raising confidence.

## What counts as Direct

Something an author wrote that says why. Not "the code does X, so the author wanted X." Examples:

- A PR body: "this fixes the bug where users with more than 1000 items couldn't paginate."
- A ticket: "we're adding this because Acme asked for it in their security review."
- A code comment: "clamp to 100 because the upstream API rejects larger values."
- A design doc: "we chose A over B because we need persistence across restarts."
- A chat message from the author: "switching to this since the old one was flaky in tests."

## Phrasing by tier

- **Direct.** Plain, present tense, cited. "This exists because X." Source next to it.
- **Supported.** Confident but visibly derived. "The evidence points strongly to X:" then each item.
- **Inferred.** Hedged, with the chain shown. "Given A and B, C seems likely because D."
- **Speculative.** "One possibility is X, but we found no direct evidence." Usually sits next to other hypotheses.
- **Unknown.** Name what you searched and with what terms. "We searched the tracker for A and B, read the 6 PRs that touched this file since 2023, and grepped the repo for the threshold value. None gave a reason." That beats "we couldn't find out."

Confidence words need a citation right next to them and never go on an inference: "because", "the reason is", "was designed to", "fixes", "addresses", "solves", "the team decided".

Hedges mark interpretation: "appears to", "seems to", "likely", "suggests", "is consistent with", "one reading is", "plausibly", "may have been".

Avoid "obviously", "clearly", "of course", "just" (as in "it's just for performance"), and "I think". If it were obvious the user would not be asking. Write "the evidence suggests" instead of a personal opinion.

## Don't rationalize

Code that makes sense today may have been written for reasons that no longer hold, or that were wrong at the time. Don't fit a clean story onto messy history. Don't assume the author did the right thing and work backward. Don't assume a consistent pattern was deliberate. It may be copy and paste. Absence of evidence is not evidence of absence: "nobody mentioned security, so it wasn't a concern" is not a finding.

## The user's guess

"Why do we do it this way, I assume it's for performance?" The guess is a lead, not a conclusion. Treat it as one candidate and check it on its own. If the evidence supports it, say so with citations. If not, say so and give what the evidence does support.

## When sources disagree

Show both, with citations. Don't pick the tidier one. A ticket that says "needed for customer X's compliance" and a PR that says "cleaning up tech debt" may both be true: the ticket motivated the work and the PR gave the author's framing. Let the user make the call.

## When evidence is missing

An honest "we don't know" is one of the most useful outputs. It tells the user the answer is not in the obvious places, and who to ask: the author, the product owner, the team lead. Name each gap: the question, the sources searched, the terms used, and what came back.

## Before finalizing

- Every claim in What We Found has a citation, or it moves to Inferred or Competing Hypotheses.
- Phrasing matches the tier.
- No claim uses the code as evidence of its own intent.
- What We Don't Know exists and names specific gaps. An empty one is suspicious.
