#!/usr/bin/env bash
# Print one line when docs/architecture/ is older than the code it describes. Silent otherwise.
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
meta="$dir/docs/architecture/meta.json"
[ -f "$meta" ] || exit 0
sha=$(sed -n 's/.*"built_from_sha"[[:space:]]*:[[:space:]]*"\([0-9a-f]*\)".*/\1/p' "$meta" | head -1)
[ -n "$sha" ] || exit 0
behind=$(git -C "$dir" rev-list --count "$sha..HEAD" -- . ':!docs/architecture' 2>/dev/null) || exit 0
[ "${behind:-0}" -gt 0 ] || exit 0
echo "flatpaper: the architecture page was built from ${sha:0:7} and is $behind commit(s) behind. Run the Architecture page playbook if those commits moved a boundary it shows."
