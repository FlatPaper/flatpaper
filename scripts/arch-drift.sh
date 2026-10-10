#!/usr/bin/env bash
# Print a line when docs/architecture/ is older than what it describes. Silent otherwise.
# Two sources of drift: commits to this repo since built_from_sha, and, when the page
# describes another repo's release (meta.json "evidence"), a newer release of that repo.
dir="${CLAUDE_PROJECT_DIR:-$PWD}"
meta="$dir/docs/architecture/meta.json"
[ -f "$meta" ] || exit 0
command -v jq >/dev/null || exit 0

sha=$(jq -r '.built_from_sha // empty' "$meta")
if [ -n "$sha" ]; then
  behind=$(git -C "$dir" rev-list --count "$sha..HEAD" -- . ':!docs/architecture' 2>/dev/null)
  [ "${behind:-0}" -gt 0 ] &&
    echo "flatpaper: the architecture page was built from ${sha:0:7} and is $behind commit(s) behind. Run the Architecture page playbook if those commits moved a boundary it shows."
fi

repo=$(jq -r '.evidence.repo // empty' "$meta")
release=$(jq -r '.evidence.release // empty' "$meta")
if [ -n "$repo" ] && [ -n "$release" ] && command -v gh >/dev/null; then
  latest=$(gh api "repos/$repo/releases/latest" --jq .tag_name 2>/dev/null)
  [ -n "$latest" ] && [ "$latest" != "$release" ] &&
    echo "flatpaper: the architecture page describes $repo $release; the latest release is $latest. Run the Architecture page playbook in update mode."
fi
exit 0
