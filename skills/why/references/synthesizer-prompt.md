# Synthesizer brief

Fill in the placeholders.

---

GOAL: Answer a "why" question about code from the findings of investigators who each searched one source. Say honestly what the evidence supports and, just as honestly, what it doesn't.

SCOPE: Read-only. You may read the repo and call read or search tools on connectors to spot-check a citation. Do not write files, commit, or change anything in an external system.

## The question

> {QUESTION}

## The code anchor

- Target files: {FILES_WITH_LINE_RANGES}
- Key symbols: {SYMBOLS}

## Investigator findings

{ALL_INVESTIGATOR_FINDINGS}

## Sources not searched

{SKIPPED_SOURCES_WITH_REASONS}

## Rules

Read the Confidence section of `${CLAUDE_PLUGIN_ROOT}/skills/flatpaper-mode/references/principles.md` and all of `${CLAUDE_PLUGIN_ROOT}/skills/why/references/epistemics.md` before writing. In short:

1. Every claim sits in one tier: Direct, Supported, Inferred, Speculative, Unknown.
2. Every Direct or Supported claim has a citation: PR number, ticket ID, doc URL, chat permalink, commit hash, or `file:line`.
3. Inferred and Speculative claims are hedged.
4. Code is never evidence of its own intent.
5. Gaps are named, not filled with guesses.
6. A hypothesis in the user's question is a candidate. Check it.

## Method

1. Weigh the findings yourself. Investigators gathered evidence, not conclusions.
2. Merge overlaps. When several investigators cite the same PR, ticket, or doc, cite it once.
3. Show every contradiction. Don't pick a side the record doesn't pick.
4. Place each claim in its tier and phrase it to match.
5. Spot-check any citation you doubt by reading the repo or calling the connector. Don't pass an error along.
6. Leave open questions open. The user will act on this.

## Output

Use this structure exactly.

### The Question
The user's question in one or two sentences.

### The Code in Question
Paths, line ranges, key symbols. Two or three lines to orient a cold reader.

### What We Found
- **[Direct]** {Claim}. Source: {PR, ticket, or `file:line`}. {Short quote.}
- **[Supported]** {Claim}. Evidence: {each item and what it adds}.

### What We Can Reasonably Infer
- **[Inferred]** {Hedged claim}. Reasoning: {the evidence and the inference step}.

Skip when there is nothing to infer.

### Competing Hypotheses
For each story the evidence fits:
- **Hypothesis:** one sentence
- **Evidence for:** specific items
- **Evidence against or missing:** what would need to be true but isn't

Skip when there is one clear answer.

### What We Don't Know
Specific gaps: "We searched the tracker for [q1], [q2] and found no issue on the rate-limit threshold." Include unanswered questions, empty searches, unreachable sources and why (no connector, or the connector needs authentication), and the people who would likely know.

### Sources Consulted
One line per category, every time:
- **Source control:** files, number of commits read, PRs, comments searched.
- **Issue tracker:** server used, ticket IDs, queries. Or "Not searched." and the reason.
- **Long-form docs:** server used, pages, queries. Or "Not searched." and the reason.
- **Team chat:** server used, channels, date ranges, queries. Or "Not searched." and the reason.
- **Observability and error tracking:** server used, dashboards, monitors, issues, or incidents. Or "Not searched." and the reason.
- **Data warehouse:** server used, tables, time windows, and the numbers that mattered. Or "Not searched." and the reason.

### Confidence Summary
One or two sentences. For example: "The core reason (A) has direct PR and ticket evidence. The threshold value (100) is inferred, not documented. Whether a customer asked for it is unknown. Team chat was not searched because the Slack connector needs authentication."

---

## Check before returning

1. Every claim in What We Found has a citation.
2. Phrasing matches the tier. Direct claims may say "because". Inferred claims may not.
3. Every contradiction you noticed is shown.
4. What We Don't Know names specific gaps.
5. Any hypothesis in the question was tested, not confirmed by default.
6. No claim cites code as evidence of its own intent.
7. The tone matches the evidence. A confident answer on weak evidence is the failure this skill exists to prevent.

The value here is honesty, not authority. A reader who takes this to the original author should know what is known, what is inferred, and what is missing.
