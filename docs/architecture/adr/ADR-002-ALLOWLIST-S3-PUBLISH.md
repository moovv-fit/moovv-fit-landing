# ADR-002: Allowlist-Based S3 Publish

**Status**: ✅ Current
**Linear**: CORE-165 (related: CORE-153)

## Context
Deploys synced the repo root to the public content bucket and relied on `--exclude` patterns. Anything not matched was published, so dev/private files leaked (for example `for-physios/.gitignore`, `videos/README.txt`, `tools/*.py`).

## Decision
Publish from an allowlist, failing closed:
- `scripts/stage-publish.sh` copies only allowlisted paths into `publish/` and strips dotfiles, `README*`, `*.md`, `*.sh`, `*.py`, `*.toml`, `*.map`, `*.env`, `*.txt`, `tools/`, `previews/`.
- `scripts/guard-publish.sh` fails the build if any of those remain.
- `deploy.yml` (staging and production) stages, guards, then runs `aws s3 sync publish/ ... --delete`. Non-HTML assets use a long immutable cache; HTML uses a 5 minute cache.

New top-level pages or folders must be added to `ALLOW` in `stage-publish.sh`.

## Consequences
- New dev files cannot reach the bucket by default.
- `--delete` removes bucket objects not in `publish/`, including previously leaked files.
- Forgetting to allowlist a new page means it is not published.
- `deploy.sh` (local) is not yet migrated and still uses excludes.
- `_headers` (Cloudflare Pages format) remains allowlisted because it exists in the bucket today; S3/CloudFront ignores it. Review separately.
