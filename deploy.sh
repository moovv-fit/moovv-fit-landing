#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Moovv Fit Landing — Local Deployment Script
# Usage:
#   ./deploy.sh staging      # Deploys to https://www.staging.moovv.fit
#   ./deploy.sh production   # Deploys to https://www.moovv.fit
# ==============================================================================

ENV="${1:-staging}"
PROFILE="${AWS_PROFILE:-moovv-fit-ujwal-admin}"
REGION="ap-south-1"

case "$ENV" in
  staging)
    BUCKET="s3://moovv-fit-content-staging/web/landing"
    DIST_ID="E2U0JW2RPO2HFD"
    URL="https://www.staging.moovv.fit"
    ;;
  production)
    BUCKET="s3://moovv-fit-content-production/web/landing"
    DIST_ID="EEEPV3BXEHZLK"
    URL="https://www.moovv.fit"
    ;;
  *)
    echo "❌ Unknown environment: $ENV (use 'staging' or 'production')"
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 Deploying landing to $ENV ($URL)..."
echo "   S3: $BUCKET"
echo "   CloudFront: $DIST_ID"
echo "   AWS Profile: $PROFILE"

# 1. Sync assets with long immutable cache
aws s3 sync . "$BUCKET/" \
  --profile "$PROFILE" \
  --region "$REGION" \
  --no-follow-symlinks \
  --delete \
  --exclude ".git/*" \
  --exclude ".github/*" \
  --exclude ".agents/*" \
  --exclude ".kiro/*" \
  --exclude "*.md" \
  --exclude ".gitignore" \
  --exclude ".release-please-manifest.json" \
  --exclude "release-please-config.json" \
  --exclude ".linear.toml" \
  --exclude "deploy.sh" \
  --cache-control "public, max-age=31536000, immutable" \
  --metadata-directive REPLACE

# 2. Sync HTML files with short cache (5 min)
aws s3 sync . "$BUCKET/" \
  --profile "$PROFILE" \
  --region "$REGION" \
  --no-follow-symlinks \
  --exclude "*" \
  --include "*.html" \
  --include "for-physios/*.html" \
  --include "for-clinics/*.html" \
  --cache-control "public, max-age=300" \
  --metadata-directive REPLACE

# 3. Create CloudFront cache invalidation
echo "🔄 Invalidating CloudFront cache..."
INVALIDATION_ID=$(aws cloudfront create-invalidation \
  --profile "$PROFILE" \
  --distribution-id "$DIST_ID" \
  --paths "/*" \
  --query "Invalidation.Id" \
  --output text)

echo "✅ Successfully deployed to $ENV!"
echo "   URL: $URL"
echo "   Invalidation ID: $INVALIDATION_ID"
