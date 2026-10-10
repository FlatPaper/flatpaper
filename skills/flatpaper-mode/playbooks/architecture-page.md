### Architecture page

**You own the map. It must match the code and what is deployed.**

Creates or updates the repo's architecture page: one archify diagram with its cards, plus reference tables below it, published as one artifact. Sources live in the repo under `docs/architecture/` so the page is reviewed in PRs with the code it describes.

Layout:

```
docs/architecture/
├── meta.json        see step 9
├── build.sh         renders the diagram, then inserts the reference tables below the cards
└── diagrams/
    ├── <name>.archify.json     the diagram spec: nodes, edges, cards (read this, not the HTML)
    ├── <name>.reference.html   hand-written tables: lifecycle, repository map, terms, sources
    └── <name>.html             build output, the published page
```

0. Read the repo's own rules for documentation (`AGENTS.md`, `CLAUDE.md`, `docs/README.md`). If one conflicts with this playbook, such as "diagrams are ASCII only", say so and ask before building.
1. Read `docs/architecture/meta.json`. If it exists, this is an update. A page in the older layout (`index.html` plus diagram files) moves to this layout on its first update. Run `git diff --stat <built_from_sha>..HEAD -- . ':!docs/architecture'`, and if `evidence` names another repo, compare `evidence.release` with that repo's latest release. Limit the work to what changed. If nothing relevant changed, say so and stop.
2. Pin the subject. If the facts live in another repo, check out the exact release tag and record repo, tag, and SHA. Then read each environment's deployment pins and record which release each one runs. The page says which environments run what it shows.
3. Trace the code for what the page shows, with read-only Explore subagents for large areas. Every node, edge, card, and table row must trace to a file, config, or manifest. Mark anything inferred, or owned by a repo you cannot read, as such.
4. Pick the one diagram that answers the most questions, usually the deployed architecture. Put lifecycles, inventories, and glossaries in reference tables, not more diagrams.
5. Write the spec with the archify skill. If the spec cites source evidence, `deliver` needs `--repo-root <checkout at the pinned SHA>`; `build.sh` takes that path as its argument. If archify is not available, say so and stop.
6. Write `<name>.reference.html` and `build.sh`. Run `build.sh`. Archify's showcase checks must pass. Render the page, look at it, and fix overlaps directly; never drop an edge that shows a real relationship to clear one.
7. Hand the tables to fresh subagents to fact-check row by row against the pinned checkout and the deployment repos. Spot-check their key claims yourself, then apply the corrections.
8. Publish `<name>.html` with the Artifact tool. On the first run, publish a new artifact. On later runs, publish to `artifact_url` so the link stays stable. Read the page back and confirm the reference sections are there and their intro carries today's verification date and the pinned SHA.
9. Write `meta.json`: `artifact_url`, `built_from_sha` (this repo's HEAD), `updated`, and when the facts come from elsewhere, `evidence` as `{"repo": "<owner>/<name>", "release": "<tag>", "sha": "<sha>", "environments": {"<env>": "<release>"}}`. The session-start drift line flags commits since `built_from_sha` and a newer `evidence.release`. It does not notice an environment being promoted; recheck `environments` on each update. Commit `docs/architecture/` on the current branch. When another playbook triggered this, it goes in the same PR as the code change. If a decision log is active, add a row with the URL and SHA.

**Reply:** the URL, what changed and why, the release and SHA the page reflects, which environments run it, and the rows no one could verify.
