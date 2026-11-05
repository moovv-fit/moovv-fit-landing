# RCA: /for-clinics/ Showing Wrong Content (403 Access Denied)

**Date:** 2026-11-05  
**Status:** ❌ Site down (403 errors)  
**Severity:** Critical — entire landing site inaccessible  

---

## Summary

The landing site at `www.moovv.fit` (including `/for-clinics/`) is returning **403 Access Denied** errors. The browser fallback behavior shows cached consumer content because CloudFront cannot fetch the correct files from S3.

## Root Cause

The S3 bucket policy for `moovv-fit-content-production` is **missing the landing site CloudFront distribution ARN**.

| Distribution | ID | In Bucket Policy? |
|-------------|-----|-------------------|
| www.moovv.fit (landing) | `EEEPV3BXEHZLK` | ❌ **NO** |
| content.moovv.fit | `E2YCFC7CY9FCQL` | ✅ Yes |
| app.moovv.fit | `E1GQFT37ETXXA3` | ✅ Yes |

### Current Bucket Policy (broken)
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "cloudfront.amazonaws.com" },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::moovv-fit-content-production/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::855246887543:distribution/E2YCFC7CY9FCQL"
        }
      }
    },
    {
      "Sid": "AllowAppCloudFrontOAC",
      "Effect": "Allow",
      "Principal": { "Service": "cloudfront.amazonaws.com" },
      "Action": "s3:GetObject",
      "Resource": [
        "arn:aws:s3:::moovv-fit-content-production/reports/*",
        "arn:aws:s3:::moovv-fit-content-production/web/*"
      ],
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::855246887543:distribution/E1GQFT37ETXXA3"
        }
      }
    }
  ]
}
```

**Missing:** `arn:aws:cloudfront::855246887543:distribution/EEEPV3BXEHZLK`

## Timeline

| Time (UTC) | Event |
|------------|-------|
| 2026-11-01 15:12:07 | CloudFormation updated bucket policy (removed landing distribution?) |
| 2026-11-01 15:18:46 | Deploy workflow uploaded new `for-clinics/index.html` to S3 |
| 2026-11-05 | User reports `/for-clinics/` showing wrong content |

## Evidence

### S3 Content is Correct
```bash
$ aws s3 cp s3://moovv-fit-content-production/web/landing/for-clinics/index.html - | head -10
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="description" content="Moovv for Clinics — manage multiple locations...">
```
✅ The clinic B2B content is correctly deployed in S3.

### CloudFront Returns 403
```bash
$ curl -I "https://www.moovv.fit/for-clinics/"
HTTP/2 403
content-type: application/xml
server: AmazonS3
x-cache: Error from cloudfront
```

### CloudFront Configuration is Correct
- Distribution: `EEEPV3BXEHZLK`
- Origin: `moovv-fit-content-production.s3.ap-south-1.amazonaws.com`
- Origin Path: `/web/landing`
- OAC: `EYP8MGWTA0KKK` (configured correctly)
- CloudFront Function: `moovv-landing-dir-index-production` (URL rewriting works)

## Why Screenshots Show Consumer Content

The browser showed consumer content because:
1. CloudFront returned 403 for `/for-clinics/`
2. Browser may have cached old root page content
3. Screenshots show consumer landing page (moovv.fit root content)

This is a **red herring** — the real issue is the site is completely down (403s).

---

## Fix Required

### Immediate Fix (Manual)

Add the landing distribution ARN to the bucket policy:

```bash
aws s3api put-bucket-policy --bucket moovv-fit-content-production --profile moovv-fit-ujwal-admin --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowContentCDN",
      "Effect": "Allow",
      "Principal": { "Service": "cloudfront.amazonaws.com" },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::moovv-fit-content-production/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::855246887543:distribution/E2YCFC7CY9FCQL"
        }
      }
    },
    {
      "Sid": "AllowAppCloudFrontOAC",
      "Effect": "Allow",
      "Principal": { "Service": "cloudfront.amazonaws.com" },
      "Action": "s3:GetObject",
      "Resource": [
        "arn:aws:s3:::moovv-fit-content-production/reports/*",
        "arn:aws:s3:::moovv-fit-content-production/web/*"
      ],
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::855246887543:distribution/E1GQFT37ETXXA3"
        }
      }
    },
    {
      "Sid": "AllowLandingCloudFrontOAC",
      "Effect": "Allow",
      "Principal": { "Service": "cloudfront.amazonaws.com" },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::moovv-fit-content-production/web/landing/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::855246887543:distribution/EEEPV3BXEHZLK"
        }
      }
    }
  ]
}'
```

### Long-term Fix

Update the CDK/CloudFormation stack that manages the bucket policy to include all three distributions:
- `E2YCFC7CY9FCQL` — content.moovv.fit
- `E1GQFT37ETXXA3` — app.moovv.fit
- `EEEPV3BXEHZLK` — www.moovv.fit (landing)

---

## Verification Steps After Fix

```bash
# 1. Test direct access
curl -s "https://www.moovv.fit/for-clinics/" | head -5

# 2. Verify correct content
curl -s "https://www.moovv.fit/for-clinics/" | grep "Moovv for Clinics"

# 3. Check HTTP status
curl -I "https://www.moovv.fit/for-clinics/"
# Should return: HTTP/2 200
```

---

## Preventive Measures

1. **Add monitoring:** CloudWatch alarm for 4xx error rate on the landing CloudFront distribution
2. **IaC review:** Ensure landing distribution is in the CDK stack that manages bucket policies
3. **Deploy verification:** Add a curl health check to the GitHub Actions deploy workflow
