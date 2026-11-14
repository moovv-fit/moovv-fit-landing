# Moovv Fit Landing Pages

## 🎯 Mission
Moovv (moovv.fit) — Marketing, patient lead acquisition, and partner landing pages.
Stack: HTML5 | CSS3 | Vanilla JS | CloudFront | GitHub Actions

## 🤖 Behavior (STRICT)
- **Brevity:** Max 20 words. Status: ✅/🚧/❌/❓
- **Code-first:** Explain only for design deviations.
- **Read → Batch edit:** Check patterns first. One edit per file.
- **No auto-tests:** Only when requested.

## 🚫 Forbidden Patterns
See `#[[file:.agents/steering/system-rules.md]]`. Key prohibitions:
- NO inline styles (use CSS classes in `css/styles.css`)
- NO `!important` in CSS (use proper specificity)
- NO fixed px for font sizes (use `rem`)
- NO missing `alt` attributes on images
- NO hardcoded hex colors (use CSS variables `--color-*`)
- NO non-semantic HTML (use `<header>`, `<nav>`, `<main>`, `<section>`, `<footer>`)

## 📁 Repository Structure
- `*.html` — Root landing pages
- `for-physios/*.html` — Physiotherapist portal landing
- `for-clinics/*.html` — Clinic onboarding landing
- `css/styles.css` — Core responsive styles
- `js/main.js` — Lightweight client interaction scripts

## 🌿 Worktree & Commit Conventions
All feature work MUST use worktrees. Direct work on `main` is blocked by `.husky/pre-push`.
- Create: `git worktree add .worktrees/feat-CORE-123-feature -b feat/CORE-123-feature`
- Commit format: `type(LINEAR-ISSUE): description`

## 📎 Deep Context (on-demand)
- `#[[file:.agents/steering/system-rules.md]]` — Constraints & HTML/CSS standards
- `#[[file:.agents/steering/html-conventions.md]]` — HTML templates & accessibility
- `#[[file:.agents/steering/css-patterns.md]]` — CSS variables, grid, and breakpoints
- `#[[file:.agents/steering/operational-context.md]]` — Deployment & local preview
- `#[[file:docs/architecture/adr/README.md]]` — Architecture Decision Records
