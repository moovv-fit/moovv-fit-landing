# Moovv Fit Landing Pages

Static landing pages for [moovv.fit](https://www.moovv.fit).

## Structure

```
/                    → Brand landing (www.moovv.fit)
/for-physios/        → Physio landing (www.moovv.fit/for-physios)
```

## Deployment

**Staging** — auto-deploys on push to `main`
- URL: `https://www.staging.moovv.fit`

**Production** — deploys when Release Please PR is merged
- URL: `https://www.moovv.fit`

### Manual Deploy

```bash
# Via GitHub Actions
gh workflow run deploy.yml -f environment=staging
gh workflow run deploy.yml -f environment=production -f confirmation=DEPLOY_PROD
```

### What gets published (allowlist)

Deploys do not sync the repo root. `scripts/stage-publish.sh` copies only an
allowlisted set of paths into `publish/` (git-ignored), and
`scripts/guard-publish.sh` fails the run if any dev/private file (dotfiles,
`README*`, `*.md`, `*.sh`, `*.py`, `*.toml`, `*.map`, `*.env`, `*.txt`, `tools/`,
`previews/`) is still present. `aws s3 sync` then runs from `publish/` only.
See [ADR-002](docs/architecture/adr/ADR-002-ALLOWLIST-S3-PUBLISH.md).

```bash
scripts/stage-publish.sh publish   # build publish/ from the allowlist
scripts/guard-publish.sh publish   # verify nothing dev/private is in it
```

**Adding a new top-level page or folder?** Add it to the `ALLOW` list in
`scripts/stage-publish.sh`, otherwise it is silently not published (the script
fails if an allowlisted path is missing). `--delete` removes bucket objects that
are not in `publish/`.

> `deploy.sh` (local emergency deploy) still uses the old exclude approach and
> does not go through the allowlist. Prefer the GitHub Actions workflow.

## Infrastructure

CloudFront + S3 managed via CDK in [moovv-fit-infra](https://github.com/moovvfit/moovv-fit-infra).

| Resource | Staging | Production |
|----------|---------|------------|
| S3 Path | `moovv-fit-content-staging/web/landing/` | `moovv-fit-content-production/web/landing/` |
| CloudFront | `www.staging.moovv.fit` | `www.moovv.fit` |
| CF Distribution ID | SSM: `/moovv-fit/staging/landing_cloudfront_distribution_id` | SSM: `/moovv-fit/production/landing_cloudfront_distribution_id` |

## Local Development

Static HTML — open files directly in browser or use:

```bash
npx serve .
```
