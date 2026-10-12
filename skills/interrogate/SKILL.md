---
name: interrogate
description: Adversarial review of a change by three parallel reviewers on different Claude models, then a lead verdict that sorts every finding into act on, consider, noted, or dismissed. Applies no fixes. Use for /interrogate, "adversarial review", "multi-model review", "challenge this", "stress test this code", "find blind spots", "tear this apart", or a contested design before the PR.
---

# Interrogate

Adapted from poteto's pstack.

Spawn one reviewer per model to review a change adversarially. The signal comes from model diversity, not assigned personas. The deliverable is a synthesized verdict. Don't apply changes.

All reviewers are Claude models. Same-family review catches less than cross-vendor review, so agreement across them is a weaker signal than agreement across vendors.

## Step 1: Scope

Find what to review:

- If the user points at files or a diff, use that.
- On a feature branch, run `git diff <base>...HEAD` for the full changeset.
- If the message refers to recent work, gather those files.

Package the diff or file contents with the context files the reviewers need.

## Step 2: Intent

Before spawning reviewers, state the intent in one paragraph, drawn from the user's message, the commit messages, the PR description, and the code. If the intent is unclear, ask the user before going on.

## Step 3: Spawn reviewers

Launch all reviewers in one message with the Agent tool. Each is a fresh subagent that never wrote the change. One reviewer per model by default:

| Reviewer | `model` |
|----------|---------|
| Reviewer A | `opus` |
| Reviewer B | `sonnet` |
| Reviewer C | `fable` |

Each gets `subagent_type: "general-purpose"` and a brief that forbids edits. If the Agent tool rejects a model, run that reviewer without `model` (the session model) and say so. Don't block the review on it.

Build every reviewer's prompt from `references/reviewer-prompt.md`, filled with the stated intent, the diff or files, `references/rubric.md`, and `references/code-quality-review.md`. Every reviewer gets the same prompt.

## Step 4: Synthesize

Parse every reviewer's findings. Merge findings that describe the same issue in different words, and note which reviewers raised each. Findings raised independently by two or more are the strongest signal here, weaker than they would be across vendors. Read a lone finding, and weight it accordingly. Note disagreements. When one reviewer flags something and another says the opposite, that is context for the verdict.

## Step 5: Lead judgment

You are the lead reviewer, a pragmatic senior engineer, not a neutral aggregator. Apply `references/lead-judgment.md`. Put every finding in one bucket, with the reviewers that raised it and a one-line rationale:

- **Act on.** Real issues of correctness, security, or maintainability given the actual goals. They would block a real PR.
- **Consider.** Legitimate, but not clearly worth the cost now. Worth the user's attention.
- **Noted.** Valid but not actionable: context-dependent, premature, or low impact at this stage.
- **Dismissed.** Wrong, nitpicky, or missing context, with a short reason.

## Output

```
### Intent
> the Step 2 paragraph

### Reviewers
- Reviewer A: opus, N findings (one line per reviewer)

### Act on
Each: description, which reviewers raised it, why it matters.

### Consider
Each: description, which reviewers raised it, the tradeoff.

### Noted
Short list.

### Dismissed
Each with a short reason.

### Agreement map
Where reviewers agreed and diverged, and what that pattern says.
```

**Reply:** the verdict above. No fixes applied.
