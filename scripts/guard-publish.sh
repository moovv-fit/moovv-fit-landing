#!/usr/bin/env bash
# Fail if the publish dir contains dev/private files. Run before any S3 sync.
# Usage: scripts/guard-publish.sh [publish-dir]   (default: publish)
set -euo pipefail
shopt -s nocasematch

cd "$(dirname "${BASH_SOURCE[0]}")/.."
OUT="${1:-publish}"
[ -d "$OUT" ] || { echo "::error::$OUT does not exist"; exit 1; }

shopt -s globstar dotglob nullglob
bad=0
cd "$OUT"
for f in **/*; do
  [ -f "$f" ] || continue
  base="${f##*/}"
  if [[ "$base" == .* ]] \
     || [[ "$base" == README* ]] \
     || [[ "$base" == "vite.svg" ]] \
     || [[ "$base" =~ \.(md|sh|py|toml|map|env|txt)$ ]] \
     || [[ "/$f" == */tools/* ]] || [[ "/$f" == */previews/* ]]; then
    echo "::error::dev/private file in publish dir: $f"
    bad=1
  fi
done
[ "$bad" -eq 0 ] || exit 1
echo "Guard passed: no dev/private files in $OUT/"
