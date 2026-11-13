# Changelog

## [1.4.0](https://github.com/moovv-fit/moovv-fit-landing/compare/v1.3.0...v1.4.0) (2026-11-13)


### Features

* **assets:** add logo variants (dark/light, SVG/PNG) ([cd1dd29](https://github.com/moovv-fit/moovv-fit-landing/commit/cd1dd29edc116c284cc1d27f4606ee2ba56ec84c))
* **CORE-149:** add KIRO_SPOT=1 env check to non-spot hooks ([b73db9d](https://github.com/moovv-fit/moovv-fit-landing/commit/b73db9d505a8c625f212bc2850bfc299e83219cb))
* **hero:** update copy for freemium model ([#2](https://github.com/moovv-fit/moovv-fit-landing/issues/2)) ([ef27eca](https://github.com/moovv-fit/moovv-fit-landing/commit/ef27ecaa742f9b7fea61ead6dad1d48a692943b8))


### Bug Fixes

* **ci:** add S3 sync exclude patterns for dev/workspace files (CORE-153) ([#5](https://github.com/moovv-fit/moovv-fit-landing/issues/5)) ([6d492c6](https://github.com/moovv-fit/moovv-fit-landing/commit/6d492c6844588ac5f515959373b4d1435f7335ec))
* **ci:** mask multi-line release-bot key and stop exporting it via GITHUB_ENV (CORE-212) ([#8](https://github.com/moovv-fit/moovv-fit-landing/issues/8)) ([196aca4](https://github.com/moovv-fit/moovv-fit-landing/commit/196aca47d304ff73cb0aa2d4088fd8e101642fa0))
* **ci:** remove id-token permission from release-please ([8d5e820](https://github.com/moovv-fit/moovv-fit-landing/commit/8d5e820e3a3bb9775be6e6320927c58c64751c47))
* **ci:** restore id-token permission for deploy workflow ([909faec](https://github.com/moovv-fit/moovv-fit-landing/commit/909faecd616386f21adc99aef979e8e21920d54e))
* **ci:** use GitHub App via SSM for release-please ([144b363](https://github.com/moovv-fit/moovv-fit-landing/commit/144b363cf93514cb06b3db385ec9659aaf8f7dd9))
* **ci:** use PAT for release-please to fix permissions ([dbe19e5](https://github.com/moovv-fit/moovv-fit-landing/commit/dbe19e55afec2a3730fd901cb5fa2a0676d7973c))
* **CORE-149:** restore agent-type hooks for proper prompt injection ([18b7119](https://github.com/moovv-fit/moovv-fit-landing/commit/18b7119acd9aee6c3e4ca73b0570d6c6e5cb0959))
* **deploy:** exclude dev files from HTML sync pass [CORE-153] ([fad723f](https://github.com/moovv-fit/moovv-fit-landing/commit/fad723fc7b22a3a017983d49b5392073195be874))
* **deploy:** exclude nested tools/ and README files from S3 sync [CORE-153] ([4ba1382](https://github.com/moovv-fit/moovv-fit-landing/commit/4ba138225c2e674bc36a62c223a646e43a57e03e))
* update legacy physio.moovv.fit URLs to app.moovv.fit/physio ([e76164d](https://github.com/moovv-fit/moovv-fit-landing/commit/e76164d46b5498541934b6e3853e4af32c44709c))

## [1.3.0](https://github.com/moovv-fit/moovv-fit-landing/compare/v1.2.0...v1.3.0) (2026-11-03)


### Features

* **privacy:** add Grievance Officer for DPDP compliance (CORE-78) ([78a9900](https://github.com/moovv-fit/moovv-fit-landing/commit/78a99007e823f917899e096c9eab386bc94822e6))


### Bug Fixes

* **faq:** add 768px breakpoint for FAQ mobile rules to match root ([091eb51](https://github.com/moovv-fit/moovv-fit-landing/commit/091eb516f27f58e4d29ed261d410c0e071430b11))
* **faq:** align sub-landing FAQ styles to match root card appearance ([a60cf41](https://github.com/moovv-fit/moovv-fit-landing/commit/a60cf41ebfc2b88148d8fdbf9bbba335bf8d5ecd))
* **faq:** move mobile rules from 768px to 600px breakpoint ([18c2f25](https://github.com/moovv-fit/moovv-fit-landing/commit/18c2f25fe67844f7544a58a034631b1af3266ed4))
* **nav:** align sub-landing pages to root conventions ([8634afb](https://github.com/moovv-fit/moovv-fit-landing/commit/8634afb3efeb37e012a14b5e7d1593ce48cf2cb6))

## [1.2.0](https://github.com/moovvfit/moovv-fit-landing/compare/v1.1.0...v1.2.0) (2026-10-08)


### Features

* add multi-agent AI development structure ([d06a3d5](https://github.com/moovvfit/moovv-fit-landing/commit/d06a3d53a8e6806453b4997e91c6f82af1d13ffe))
* **auth:** add patient/physio groups to Pool A and backfill users ([07a0291](https://github.com/moovvfit/moovv-fit-landing/commit/07a0291fb83e99cd88e1ba2f8d4f86d386255487))
* **for-clinics:** add privacy and terms pages for clinic branding ([0bf0cb8](https://github.com/moovvfit/moovv-fit-landing/commit/0bf0cb853d9978a2f74f7867ee58b52d8d0071c1))
* unified auth links + clinic FAQ fix + cleanup docs ([264fa73](https://github.com/moovvfit/moovv-fit-landing/commit/264fa73674499c57bf65072002eced90398eee2d))


### Bug Fixes

* add account-deletion page for Play Store, update clinic login URL ([3b7ba6c](https://github.com/moovvfit/moovv-fit-landing/commit/3b7ba6ca66749880400727d02c7b0dc7e88da4fe))
* **ci:** add debug output for S3 sync failure ([08e98cb](https://github.com/moovvfit/moovv-fit-landing/commit/08e98cbb7c782fb7c674e6443e24e35f0e70c1f9))
* **ci:** exclude .agents and .kiro from S3 sync ([27d9110](https://github.com/moovvfit/moovv-fit-landing/commit/27d911088dc4d97dc4e500aec30c631ef1b39574))
* **ci:** handle S3 sync delete warnings gracefully ([4882fd7](https://github.com/moovvfit/moovv-fit-landing/commit/4882fd7c24bc2681c67db4584c2beb508ed65992))
* FAQ list width and centering to match root site ([6abd6b0](https://github.com/moovvfit/moovv-fit-landing/commit/6abd6b0969903cc79edb269e0785e3d3c36535b8))
* **for-physios:** full-width alignment for compare-value section ([627ac0b](https://github.com/moovvfit/moovv-fit-landing/commit/627ac0ba64f17990bc8a89a905cfed5e2b198138))
* remove machine-specific symlinks from git tracking ([93ce597](https://github.com/moovvfit/moovv-fit-landing/commit/93ce5971f6ef34d2598f5ca8f2bf93635db2cb1c))
* standardize contact email to hello@moovv.fit ([f748258](https://github.com/moovvfit/moovv-fit-landing/commit/f7482589b31469e6d727ab9ccac46f7601c42f8e))
* update physio and clinic login links to unified auth URLs ([4c1a72d](https://github.com/moovvfit/moovv-fit-landing/commit/4c1a72d82330576595945df9fe693790d2ee930c))

## [1.1.0](https://github.com/moovvfit/moovv-fit-landing/compare/v1.0.0...v1.1.0) (2026-09-29)


### Features

* consolidate brand + physio landing pages ([bb02603](https://github.com/moovvfit/moovv-fit-landing/commit/bb0260369c516df1b3d05ee98d383afcb394b9ca))
* **for-clinics:** add clinic landing page with assets, update nav/forms across pages ([03a4521](https://github.com/moovvfit/moovv-fit-landing/commit/03a4521ece59a7a870773174d6016c195a19be91))


### Bug Fixes

* **for-clinics:** UI fixes - logo tag, currency toggle, FAQ, pricing text, CTA ([2aae52e](https://github.com/moovvfit/moovv-fit-landing/commit/2aae52e487e1ec6bd457fabf1ed92008cfdee01b))
* use OIDC auth, production only ([5f6be32](https://github.com/moovvfit/moovv-fit-landing/commit/5f6be328c98c7b448a4f07dcf5fb1942fd3af7d1))
