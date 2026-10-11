#!/usr/bin/env bash
# Rebuild the architecture page: archify renders the diagram and its cards,
# then the reference tables (hand-written HTML) go in below the cards.
set -euo pipefail
# The diagram cites this repo's files; archify checks them against a checkout at
# meta.repository.revision. Defaults to this checkout.
ROOT="$(cd "${1:-$(dirname "$0")/../..}" && pwd)"
ARCHIFY="${ARCHIFY:-$HOME/.claude/skills/archify/bin/archify.mjs}"
cd "$(dirname "$0")/diagrams"

node "$ARCHIFY" deliver architecture flatpaper.archify.json \
  flatpaper.html --quality showcase --repo-root "$ROOT" --json >/dev/null

# Insert before the line that closes the page container, the last "  </div>"
# ahead of the viewer script.
perl -0pi -e '
  BEGIN { local $/; open my $f, "<", "flatpaper.reference.html" or die; $ref = <$f> }
  s{\n  </div>\n\n  <script>}{\n$ref\n  </div>\n\n  <script>} == 1 or die "anchor not found\n"
' flatpaper.html

grep -c 'class="ref-section"' flatpaper.html | sed 's/^/reference sections: /'
