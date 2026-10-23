# Change and patch log

## v1.0.0-baseline.1 — archival source, 23 October 2026

Exact historical source `9ce5e1676a1eae2681037d75eb354cd76addf207`, root VERSION 1.00 / app 1.0.0+1. No source patch or redesign. No production binary promised. Current verification and known shortcomings are documented separately; original May verification is historical only.

## Improvement — in progress

See PLAN.md and CONTEXT.md. No improved release published yet.

## v1.1.0-preview.1 — source and browser preview,23 October2026

- Adds Display, Layouts, Timer and Settings navigation and About/data-status information; preserves all four original clock faces/themes.
- Adds a local visual focus timer with presets, pause/reset and explicit foreground/no-alarm limits.
- Makes weather opt-in with four public cities, real extrema, provider timezone conversion, visible timestamps/loading/failure and attribution. Removes sample-as-live expectations.
- Hardens old/corrupt preferences, ordered persistence/failure feedback, async disposal/races and lifecycle cadence. Minute-level pixel shifts respect reduced motion.
- Labels sample calendar and unavailable audio; removes unused sensitive permissions and misleading charger/battery signals. Removes implicit Android debug signing for release builds.
- Bundles licensed Roboto typography after network testing found an implicit remote font request. Adds dependency notices, security/contribution guidance, static docs/landing pages and honest setup/privacy/FAQ content.
- Fixes large-text display overflow and documentation image distortion found by runtime review.

Verification:34 tests, analysis and web release build pass from a fresh remote clone; browser workflow/mobile preview and three assisted reviews. Physical devices, native signing, assistive technology and long-run battery/OLED acceptance remain open. This preview is not a production signed native release.
