### Bug fix

**You own this task. Plan, review, verify.**

Every shipped line traces to runtime evidence. A change that "might help" is a hypothesis, not a fix. When evidence refutes a hypothesis, revert what it motivated.

1. Reproduce it yourself on the surface where it happens (CLI, browser, workspace, pipeline). Use the project's `verify-<app>` skill if one exists. Ask the user to reproduce only with a specific reason you cannot reach the surface.
2. Find the cause by elimination. List candidate hypotheses, then rule them out one at a time with runtime evidence (logs, instrumentation, real responses). Don't stop at the first plausible cause. Check whether the symptom fully disappears once that cause is removed.
3. Plan the smallest fix the evidence justifies.
4. Verify on the same surface. The original repro now passes. "Inconclusive" or a different surface is not a pass. Say so.
5. If there is a cheap local test path, commit the failing test before the fix, so history shows the failure first. Skip when the test would need brittle mocks. Running the real command is stronger evidence.

**Reply:** what was broken, the root cause, the fix, and how you verified it. Paste the failing and then passing repro output verbatim.
