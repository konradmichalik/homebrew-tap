#!/usr/bin/env bash
#
# Aggregate GitHub release-asset download counts for every package in this tap
# and emit a single JSON document on stdout.
#
# Packages are discovered automatically: each Casks/*.rb and Formula/*.rb is
# read, the owner/repo is parsed from its `homepage` line, and the relevant
# release assets (.dmg for casks, .tar.gz for formulae) are summed.
#
# Requires: gh (authenticated), jq. Set GENERATED_AT to override the timestamp.

set -euo pipefail

generated_at="${GENERATED_AT:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}"

repo_from_rb() {
  # Extract "owner/name" from the homepage "https://github.com/owner/name" line.
  grep -oE 'homepage "https://github\.com/[^"]+"' "$1" \
    | head -1 \
    | sed -E 's#.*github\.com/([^"]+)".*#\1#'
}

fetch_releases() {
  # Fetch the releases array for a repo as valid JSON. Retries a few times on
  # transient failures and rejects unexpected payloads (e.g. rate-limit/error
  # objects), returning "[]" rather than corrupting the aggregate.
  local repo="$1" raw attempt
  for attempt in 1 2 3; do
    raw="$(gh api "repos/${repo}/releases" --paginate 2>/dev/null | jq -s 'add // []' 2>/dev/null || true)"
    if printf '%s' "$raw" \
        | jq -e 'type == "array" and (length == 0 or (.[0] | type == "object" and has("tag_name")))' >/dev/null 2>&1; then
      printf '%s' "$raw"
      return 0
    fi
  done
  echo "warning: could not fetch valid releases for ${repo} after retries" >&2
  printf '[]'
  return 0
}

package_json() {
  local file="$1" type="$2" ext="$3"
  local name repo
  name="$(basename "$file" .rb)"
  repo="$(repo_from_rb "$file")"

  if [ -z "$repo" ]; then
    echo "warning: no homepage repo found in $file, skipping" >&2
    return
  fi

  fetch_releases "$repo" \
    | jq -c \
        --arg name "$name" \
        --arg repo "$repo" \
        --arg type "$type" \
        --arg ext "$ext" '
      map(select(type == "object")) as $rels
      | {
          name: $name,
          type: $type,
          repo: $repo,
          releases: ($rels | length),
          downloads_total:   ([$rels[] | (.assets // [])[] | .download_count] | add // 0),
          downloads_install: ([$rels[] | (.assets // [])[] | select(.name | endswith($ext)) | .download_count] | add // 0),
          latest: (
            ($rels | map(select(.draft | not)) | sort_by(.created_at) | reverse | .[0]) as $l
            | if $l == null then null else {
                tag: $l.tag_name,
                published_at: $l.published_at,
                downloads_install: ([($l.assets // [])[] | select(.name | endswith($ext)) | .download_count] | add // 0)
              } end
          )
        }'
}

{
  for f in Casks/*.rb;   do [ -e "$f" ] && package_json "$f" cask    ".dmg";    done
  for f in Formula/*.rb; do [ -e "$f" ] && package_json "$f" formula ".tar.gz"; done
} | jq -s --arg ts "$generated_at" '
  sort_by(-.downloads_install) as $packages
  | {
      generated_at: $ts,
      totals: {
        packages:          ($packages | length),
        downloads_total:   ($packages | map(.downloads_total)   | add // 0),
        downloads_install: ($packages | map(.downloads_install) | add // 0)
      },
      packages: $packages
    }'
