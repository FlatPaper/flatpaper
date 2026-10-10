#!/usr/bin/env bash
# Print a line when docs/architecture/ is older than what it describes. Silent otherwise.
# Two sources of drift: commits to this repo since built_from_sha, and, when the page
# describes another repo's release (meta.json "evidence"), a newer release of that repo.
# Runs at session start: it must never print errors, and never wait long on the network.
exec 2>/dev/null
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
meta="$dir/docs/architecture/meta.json"
[ -f "$meta" ] || exit 0

field() {  # field <jq path> <sed key>; sed covers built_from_sha when jq is missing
  if command -v jq >/dev/null; then jq -r "$1 // empty" "$meta" 2>/dev/null
  else sed -n "s/.*\"$2\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$meta" | head -1; fi
}

sha=$(field .built_from_sha built_from_sha)
if [[ $sha =~ ^[0-9a-f]{7,40}$ ]]; then
  behind=$(git -C "$dir" rev-list --count "$sha..HEAD" -- . ':!docs/architecture' 2>/dev/null)
  [ "${behind:-0}" -gt 0 ] 2>/dev/null &&
    echo "flatpaper: the architecture page was built from ${sha:0:7} and is $behind commit(s) behind. Run the Architecture page playbook if those commits moved a boundary it shows."
fi

# Release drift needs jq and gh. Only evidence.release is compared; promotions between
# environments (evidence.environments) are not detected.
command -v jq >/dev/null && command -v gh >/dev/null || exit 0
repo=$(field .evidence.repo x)
release=$(field .evidence.release x)
[[ $repo =~ ^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$ ]] && [ -n "$release" ] || exit 0

# Cache the answer for a day, and give gh 3 seconds at most.
cache="${TMPDIR:-/tmp}/flatpaper-latest-release-${repo//\//_}"
if [ -z "$(find "$cache" -mtime -1 2>/dev/null)" ]; then
  tmp="$cache.$$"
  { gh api "repos/$repo/releases/latest" --jq .tag_name >"$tmp" 2>/dev/null || : >"$tmp"; } &
  pid=$!
  for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do kill -0 "$pid" 2>/dev/null || break; sleep 0.2; done
  if kill -0 "$pid" 2>/dev/null; then kill "$pid" 2>/dev/null; rm -f "$tmp"; exit 0; fi
  wait "$pid" 2>/dev/null
  mv "$tmp" "$cache" 2>/dev/null
fi
latest=$(head -1 "$cache" 2>/dev/null)
[[ $latest =~ ^[A-Za-z0-9._+-]+$ ]] && [ "$latest" != "$release" ] &&
  echo "flatpaper: the architecture page describes $repo $release; the latest release is $latest. Run the Architecture page playbook in update mode."
exit 0
