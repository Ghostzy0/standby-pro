# Standby Pro project state

Updated23 October2026. Current active source is Flutter/Dart with original clock faces/themes, Display/Layouts/Timer/Settings/About, optional city weather and defensive local settings. This repository retains the original history and community. Historical baseline source is pinned at9ce5e167 / v1.0.0-baseline.1; clean separate baseline repository has per-file provenance and a labelled packaging correction.

Recorded toolchain Flutter3.41.9/Dart3.11.5. Improved34 tests, analysis and web release build pass in a fresh remote clone. Browser and synthetic widget evidence are in docs/evidence; three assisted audits are in docs/audits. Read CONTEXT.md, PLAN.md and versioned release notes for exact acceptance limits.

No production signed APK/IPA, physical phone acceptance, real calendar/media integration, system StandBy/WidgetKit, background alarm, battery-life or burn-in guarantee. No ads/IAP/accounts/analytics. Original source MIT; bundled Roboto Apache2; other package licences in THIRD-PARTY-NOTICES.txt. Open-Meteo data CC BY4.0 and free service noncommercial.

Next action: physical Android validation with controlled signing identity, then iPhone/signing and assistive testing. Preserve the v1 preference key and package identity; no silent paid API or sensitive permission fallback.
