# Observability, error tracking, and data warehouse

The runtime record: what happened in production, as opposed to what was planned. One playbook for three categories, because the method is the same. Find the signal near the target, then line its timeline up with the ship date. Examples: Datadog, Grafana, Honeycomb, or New Relic for observability. Sentry or Rollbar for errors. Databricks, Snowflake, or BigQuery for the warehouse. Read each tool's schema before calling it. Tool names differ by connector.

## Observability (Datadog and similar)

1. Find the owning service and its dependencies.
2. Search dashboards and monitors by feature, service, and symbol. A monitor's threshold is often the answer to "why is this clamped at N?"
3. Pull the metric around the ship date. A spike just before the merge and calm after is supporting evidence.
4. Search logs for the error strings or symbols the code guards against. Always bound by time, about 30 days either side of the change. Aggregate instead of dumping raw lines.
5. For timeouts, retries, and slow paths, check traces and span stats for the endpoint.
6. Search incidents by date and service. A timeline that says "added a check for X" is near-direct evidence.

## Error tracking (Sentry and similar)

1. Find the organization and project.
2. Search issues by the exception classes the code handles, its function names, the error strings it checks, and its file path.
3. For each candidate, note first seen, last seen, event count, and affected releases. Does the error stop at the release that shipped the target?
4. Read a full event. Does the stack trace pass through the target? Do tags and breadcrumbs match what it defends against?
5. Treat any AI root-cause summary the tool offers as a hypothesis, not evidence. The events are the evidence.

## Data warehouse (Databricks and similar)

For "where did this number come from", flag-gated code, experiments, and migrations.

1. Confirm a table exists before querying it (`SHOW TABLES`, `DESCRIBE`). Schemas are company-specific. A result from a table you never confirmed is a classic failure.
2. Use read-only queries, and bound every one by time.
3. Useful shapes: event volume around the merge (a step up means a launch, a decay means a removal), the p99 of a value in the weeks before the change compared with the code's threshold, and experiment exposure for the flag key near the ship date.
4. Return numbers, not rows: counts, percentiles, first and last seen.

## Pitfalls

- **Correlation is not cause.** Other changes land in the same window. Check neighboring PRs.
- **Instrumented is not caused.** A metric or event shows someone cared enough to measure it, not that the code exists because of it. Pair it with a PR or commit.
- **Instrumentation changes.** A step in volume may be a new event being logged, not new behavior.
- **Retention.** Data older than the retention window is a gap, not a null result. Say which.

## What to return

Per item: type (dashboard, monitor, metric, log pattern, trace, incident, error issue, table), name, link or ID, owner and date, the exact query or condition, the numbers or quote that matter, and how the timeline lines up with the ship date.
