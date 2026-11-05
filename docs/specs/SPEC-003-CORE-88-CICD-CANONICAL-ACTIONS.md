# SPEC-003: Landing CI/CD Modernization & Reproducible Tag Dispatch

- **Linear Ticket:** [CORE-88](https://linear.app/moovv-fit/issue/CORE-88)
- **Parent Initiative:** [CORE-87: [Cross-Repo] CI/CD & GitHub Actions Modernization and Dual-Org Deployment Alignment](https://linear.app/moovv-fit/issue/CORE-87)
- **Target Repository:** `moovv-fit-landing` (`repos/apps/landing`)
- **Reviewers & Approvers:**
  - **Ujwal Parker** (DevOps & Infrastructure Lead)
  - **Pawan Deshmukh** (Deployment Reliability & Operational Risk)
  - **Rahul Jain** (Release Governance)

---

## 1. Executive Summary & Objective

Across the Moovv Fit organization profile, all submodules are standardizing on canonical GitHub Actions versions to eliminate outdated Node.js runner warnings, optimize runner caching, and enable reproducible tag-based rollbacks (ADR-005).

**CORE-88** modernizes `repos/apps/landing/.github/workflows/deploy.yml` to:
1. Upgrade action references to organization canonical versions.
2. Add an optional `tag` input to `workflow_dispatch` to enable rolling back or deploying a specific git release tag without creating dummy commits.
3. Enforce the symlink traversal safety fix (`--no-follow-symlinks`) across all S3 deployment steps.

---

## 2. Technical Changes & Upgrades

### Action Version Alignments

| Current Version in Landing | Canonical Org Standard | Purpose |
|---|---|---|
| `actions/checkout@v4` | `actions/checkout@v7` | Faster git fetch, Node 22 runner support |
| `aws-actions/configure-aws-credentials@v4` | `aws-actions/configure-aws-credentials@v6` | Enhanced OIDC token exchange reliability |
| *(None)* | `actions/setup-node@v7` | Standardized environment runner caching |
| *(None)* | `pnpm/action-setup@v6` | Consistent CLI tooling support |

---

## 3. Workflow Dispatch with Tag Rollback Capability

Currently, manual workflow triggers only accept `environment` (`staging` or `production`). If a regression occurs on production, rolling back requires checking out a previous commit and pushing it as a new commit.

The updated `workflow_dispatch` schema adds an optional `tag_or_ref` field:

```yaml
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target deployment environment'
        required: true
        type: choice
        options:
          - staging
          - production
        default: staging
      tag_or_ref:
        description: 'Optional git tag or commit SHA to deploy (defaults to current ref)'
        required: false
        type: string
        default: ''
```

When provided, the checkout step dynamically checks out the specified tag:

```yaml
      - name: Checkout Source Code
        uses: actions/checkout@v7
        with:
          ref: ${{ github.event.inputs.tag_or_ref != '' && github.event.inputs.tag_or_ref || github.ref }}
```

---

## 4. Symlink Protection Invariant

As resolved in previous sessions, `.agents/` and `.kiro/` directories contain symlinks (`.kiro/hooks -> ../.agents/hooks`). Without `--no-follow-symlinks`, the AWS CLI attempts recursive symlink traversal, throwing non-zero exit codes.

All `aws s3 sync` commands in `deploy.yml` will strictly preserve:
```bash
aws s3 sync . "$BUCKET/" \
  --no-follow-symlinks \
  --delete \
  --exclude ".git/*" \
  --exclude ".github/*" \
  --exclude ".agents/*" \
  --exclude ".kiro/*" \
  --exclude "*.md" ...
```

---

## 5. Review & Sign-Off Checklist

- [ ] **Ujwal Parker**: Validation that `actions/checkout@v7` and `aws-actions/configure-aws-credentials@v6` pass in the `moovv-fit` org OIDC environment.
- [ ] **Pawan Deshmukh**: Confirmation of production rollback procedure using the `tag_or_ref` parameter.
- [ ] **Rahul Jain**: Operational sign-off on zero-downtime deployment guarantees.
