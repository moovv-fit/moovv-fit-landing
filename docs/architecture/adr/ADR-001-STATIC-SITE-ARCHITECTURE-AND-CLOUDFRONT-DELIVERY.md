# ADR-001: Static Site Architecture & CloudFront CDN Delivery

**Status**: ✅ Current  

## Context
Marketing and lead acquisition sites require ultra-fast Time to First Byte (TTFB), top SEO performance, and high availability without backend server dependencies.

## Decision
Build landing surfaces using lightweight static HTML5/CSS3/Vanilla JS (or Astro static build) deployed to Amazon S3 and distributed globally through Amazon CloudFront CDN with TLS/SSL via AWS Certificate Manager.

## Consequences
- Zero server maintenance, near-infinite scalability, sub-100ms global TTFB.
- Integrated routing with platform edge rules defined in `moovv-fit-infra`.
