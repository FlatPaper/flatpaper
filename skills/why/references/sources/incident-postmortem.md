# Incident and postmortem context

Append this to every investigator's brief when the target looks defensive: null checks, retries, timeouts, rate limits, feature flags, egress guards, OOM handling. Each investigator runs the queries for its own source.

- **Source control.** Commits like "fix for incident", "add defensive check", "hotfix", or a revert followed by "re-apply with fix". A same-day merge with little review suggests a hotfix.
- **Issue tracker.** Tickets labeled `incident`, `sev-*`, `postmortem`, `postmortem-action-item`, or `reliability`, created near the date the code was added.
- **Docs.** Postmortems that name the service, symbol, or error string. Their action items often name the fix.
- **Team chat.** Incident channels (`#incident-*`, `#sev-*`, or the team's equivalent) in the days before the code landed.
- **Observability and error tracking.** Incidents, alerts, and error spikes in the window before the change, and whether they stop after it.
