### Perf

**You own the measurement story. Every kept change ties to a number. Reading source is not measuring.**

For a one-off speedup or regression, and for a sustained climb on one metric against a target.

1. Pick a case that reproduces the user's complaint, with realistic data size, state, and concurrency. If no case reproduces it, fix the repro first. Fix one metric, the direction that counts as better, and a stop predicate that pairs a target with a floor on attempts ("at least 30% faster and at least 8 attempts"), so a lucky early win can't end the run. Use the user's numbers when given.
2. Build the harness, prove it is sensitive, then freeze it. Run contrasting workloads and confirm the target case shows the symptom while easier cases separate. Make it print an error count and a count of the work done. Once frozen, one command emits the metric. Check machine load first (`uptime`, plus `nproc` on Linux or `sysctl -n hw.ncpu` on macOS).
3. Record the baseline as the median of 5 or more runs with the range, never one run. When comparing two sides, alternate them (A, B, A, B). Record a green run of the regression gate (the tests that must keep passing).
4. Vet the baseline and every later number with these questions. Answer each from a run, not from the code.
   - **Why not double?** Name the limiter. Profile in a run you don't report: `top`, `perf` or `strace -c` on Linux, `sample <pid>` or Instruments on macOS (`dtruss` needs root and SIP off), or a runtime profiler (`py-spy`, `node --cpu-prof`). If the load generator saturates first, you measured the load generator.
   - **Was it tuned?** Each side runs as production runs it: release build, production flags, same versions and data. A side on defaults means you compared configurations.
   - **Did it break limits?** Do the arithmetic against disk, network, and cores. Removing a piece that takes 10% of the run saves at most 10% of the wall time, about 1.11x throughput. A result past a limit measured a cache, a no-op, or a bug.
   - **Did it error?** Count failures and check outputs are correct, not just present. Rejections are fast.
   - **Does it reproduce?** A gap smaller than the run-to-run range is no measurable difference.
   - **Does it matter end to end?** Measure the path a user waits on and report a micro result as a share of it.
   - **Did it even happen?** Confirm the work ran inside the timed region. Unawaited promises, unread generators, and timeouts time nothing.
5. Ground each hypothesis in a named mechanism ("defer X off the boot path because it blocks first paint"). Try the cheapest kind first: don't do it, don't do it again, do less, do it later, do it concurrently, do it cheaper.
6. Loop with one change, one measurement, keep or revert. The `swarm` skill may explore hypotheses in parallel (profiling, reading, prototypes), but every number you keep is measured serially on the frozen harness, because parallel runs share the machine. Measure with the frozen harness and run the gate. Keep a change only when the metric moves past the range and the gate stays green. Otherwise revert it in full. Never stack untested changes. One commit per kept change, staging only its files (`git add <files>`, never `-A`). Log each attempt, kept or reverted, with the show-me-your-work skill.
7. Push past the first plateau by changing category or combining near-misses. Stop when the predicate is met, including its floor on attempts. If the target looks out of reach, stop and say so with the limiter. Never relax the predicate to meet it. Revert any win that breaks behavior.

**Reply:** the metric and target, baseline to final as median and range with the percent delta, the limiter, attempts kept and reverted, each kept change on one line, and the decision log path.
