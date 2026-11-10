#!/usr/bin/env bash
# Stage an allowlisted, clean copy of the site into ./publish for S3 sync.
# Anything not listed in ALLOW is never published (fails closed).
# Usage: scripts/stage-publish.sh [output-dir]   (default: publish)
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
OUT="${1:-publish}"

ALLOW=(
  index.html blog.html privacy.html terms.html support.html account-deletion.html
  _headers
  css js images fonts hero-gifs videos for-physios for-clinics
)

for item in "${ALLOW[@]}"; do
  [ -e "$item" ] || { echo "::error::allowlisted path missing: $item"; exit 1; }
done

rm -rf "$OUT"
mkdir -p "$OUT"

# Strip dev/private files that may sit inside allowlisted folders.
rsync -a --relative --prune-empty-dirs \
  --exclude='.*' \
  --exclude='*.md' --exclude='*.sh' --exclude='*.py' --exclude='*.toml' \
  --exclude='*.map' --exclude='*.txt' --exclude='*.env' \
  --exclude='README*' --exclude='tools/' --exclude='previews/' \
  "${ALLOW[@]}" "$OUT/"

[ -f "$OUT/index.html" ] || { echo "::error::$OUT/index.html missing"; exit 1; }
echo "Staged $(cd "$OUT" && shopt -s globstar dotglob nullglob && n=0; for f in **/*; do [ -f "$f" ] && n=$((n+1)); done; echo $n) files in $OUT/"
