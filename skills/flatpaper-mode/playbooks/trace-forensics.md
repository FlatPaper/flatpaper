### Trace forensics

**You own the diagnosis from the artifact.** The deliverable is a cited diagnosis, not a fix.

Distinct from Runtime forensics, which instruments a live process. Here the capture already exists: a trace, a CPU profile, a heap snapshot, a core dump, a spindump, a HAR file, or a log bundle. The artifact is a fixed dataset. Read it. Don't re-run it.

1. Identify the format and load it with the right tool. Chrome trace JSON, `.cpuprofile`, and Perfetto traces open in Perfetto, DevTools, or speedscope. `perf.data` reads with `perf report` or `perf script`. A core dump opens in `lldb` or `gdb` with the matching binary. A HAR or JSON log reads with `jq`. A spindump or text log reads as text. Parse large artifacts in an `Explore` subagent via the Agent tool, briefed per `../references/subagent-brief.md`, and keep the reduced finding in the main thread (guard the context window). The check is the format named and the artifact loaded without errors.
2. Transform the raw artifact into a form you can query. Dump it into sqlite or DuckDB, one row per sample, frame, node, request, or log line. Reach the queryable shape before you read. The check is a query that returns the row count you expect.
3. Narrow to the cause. For a profile, query the frames that hold the most time and walk the call tree to the hot path. For a leak, follow the retainer chain from the leaked object to a root. For a spindump or core dump, find the thread stuck on CPU or blocked and its wait reason. For a HAR, sort by duration and find the request the user waits on. For logs, find the first error and what preceded it. The check is one named frame, chain, thread, or request.
4. Attribute to source. Map the hot frame to file, symbol, and line through the artifact's own symbols or source maps. Cite `file:line`. A frame with no source mapping is not yet a diagnosis. Resolve the symbols, or say plainly that the artifact does not carry them.
5. If you have a paired capture (before and after, good and bad), diff the two to confirm. Otherwise mark the finding as the strongest hypothesis the artifact supports, not a confirmed cause. Put it in a confidence tier from `../references/principles.md`.

No code changes. Once the cause is known, the fix is matched to Bug fix or Perf on the next prompt.

**Reply:** the artifact and its format, the reduced finding, the source location, the artifact and query paths, and whether a paired capture confirmed it. No fix unless asked.
