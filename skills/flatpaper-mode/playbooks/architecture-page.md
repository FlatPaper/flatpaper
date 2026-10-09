### Architecture page

**You own the map. It must match the code.**

Creates or updates the repo's architecture page: plain-language descriptions plus archify diagrams, published as one artifact. Sources live in the repo under `docs/architecture/` so diagrams are reviewed in PRs with the code they describe.

Layout:

```
docs/architecture/
├── meta.json          {"artifact_url": "...", "built_from_sha": "...", "updated": "YYYY-MM-DD"}
├── index.html         descriptions, one section per diagram, links to each diagram
└── diagrams/<name>.html
```

1. Read `docs/architecture/meta.json`. If it exists, this is an update. Run `git diff --stat <built_from_sha>..HEAD -- . ':!docs/architecture'` and limit the work to diagrams that diff touches. If nothing relevant changed, say so and stop.
2. Trace the code for what the diagrams show, with read-only Explore subagents for large areas. Every node and edge must trace to a file, config, or manifest. Mark anything you inferred as inferred.
3. Choose two to four diagrams that answer real questions: deployed architecture, the main runtime or pipeline flow, a lifecycle. Skip a diagram that one sentence would explain.
4. Generate each diagram with the archify skill into `docs/architecture/diagrams/<name>.html`. If archify is not available, say so and stop.
5. Write `docs/architecture/index.html`. One section per diagram: what it shows, three to six short cards on the non-obvious parts, the source pointers, and a link to the diagram file. Footer: `Built from <short sha> on <date>`.
6. Publish with the Artifact tool, the index as the page and the diagrams through `files`. On the first run, publish a new artifact and save its URL. On later runs, publish to the `artifact_url` in `meta.json` so the link stays stable.
7. Prove it. Read the published page back with the Artifact tool. The footer SHA matches `HEAD`, and every diagram link appears in the artifact's file listing.
8. Write `meta.json` with the URL, the SHA the page was built from, and today's date. Commit `docs/architecture/` on the current branch. When another playbook triggered this, it goes in the same PR as the code change. If a decision log is active, add a row with the URL and SHA.

**Reply:** the URL, which diagrams changed and why, and the SHA the page reflects.
