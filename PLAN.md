# Standby Pro release plan

Updated 23 October 2026. Existing repository, history, MIT licence, package identity and original clock styles are preserved. Six GitHub stars show interest, not active-user evidence. Original May plan and project memory are archived in `docs/releases/`.

## Observed architecture

Flutter/Dart app in `app/`; Android Kotlin MethodChannel for brightness, foreground keep-screen-on and media keys; generated iOS target without the equivalent bridge. SharedPreferences JSON key `standby_settings_v1`; four clock faces and four theme presets; Single/Duo widget surface. Weather is an HTTP Open-Meteo request for fixed London coordinates. Calendar and now-playing are synthetic. Existing domain/widget tests have not yet been rerun on this host. No release/tag/CI existed at inspection. Baseline `9ce5e1676a1eae2681037d75eb354cd76addf207`, app version `1.0.0+1`, root VERSION `1.00`.

## Ordered milestones and acceptance

1. **Preserve and label current baseline.** Tag exact baseline `v1.0.0-baseline.1`; source archival prerelease, not a stable binary. Run existing tests/analysis if SDK obtainable; record original failures and exact host. Separate documentation PR. Document synthetic integrations, missing iOS bridge, Android debug signing, uncertain reference-art rights. No redesign or silent historical patch.
2. **Reliable engine and settings.** Defensive settings migration/load, serialized persistence, disposal/lifecycle guards, immediate cadence changes; honest weather state and no invented extrema. Keep original JSON key and enum names; additive fields default safely. Tests cover corrupt input, async disposal/failure, minute/second/background transitions, weather parsing.
3. **Useful coherent screens.** Bedside display, a library of original layouts/presets, full readable settings, a local focus timer, and About/data-status setup. Preserve themes/faces and use original code/assets. Clear samples/unavailable states; weather opt-in with fixed selectable cities (no location prompt), attribution and timestamps. Timer is foreground visual assistance, not an alarm/background notification.
4. **Platform safety and accessibility.** Honest foreground keep-awake control, no fake charging indicator; app-local dimming fallback and accessible exit; reduced motion, responsive small/landscape layouts, target sizes, semantic labels. No calendar/photo/location permissions without integration. Avoid always-on/burn-in/battery guarantees.
5. **Review, package and publish improvement.** At least three Luna review slices: engine/platform; rendered UI/UX; clean-clone/security/licence/release. Fix high findings, record medium deferrals. Run checks once per meaningful revision; publish separately versioned prerelease if physical acceptance remains open. Attach PRs to chat. Source and available tested artifacts with SHA256, architecture/signing caveats, clean reproduction and migration instructions.
6. **Honest discoverability.** Repo metadata/topics and static accessible GitHub Pages docs, actual runtime captures, source/releases/privacy/setup/FAQ. Semantic HTML, title/description/OG/canonical/sitemap/robots. Schema only supported facts; no fabricated ratings. Google SoftwareApplication rich results need genuine rating/review, so omit that rich-result claim. Optional llms.txt only as navigation convenience.

## Design and motion contract

Primary job: read the time at a glance, then deliberately change display or run a short local focus session. Dark background, original Aurora/Night Red/Solar/Matrix accents, large clock numerals, subdued controls; settings remain readable, scrollable and reversible. No perpetual decorative motion. Respect reduced-motion preference; pixel shifting has an off switch and is mitigation only. Data states: weather disabled/loading/current/stale/failure; calendar/audio explicitly samples or unavailable; saved settings error has recovery. Avoid permissions/accounts/prompts overnight.

## Dependencies, risks and limits

Use existing Flutter packages; generate dependency notices from resolved packages. MIT source licence does not clear third-party reference screenshots: retain historical tree, exclude unrelated references from improved release distribution and explain removal. Open-Meteo free endpoint noncommercial; explicit opt-in and attribution, no paid API fallback. No analytics/ads/accounts. Physical Android, iPhone signing/lockscreen/charging/long-run OLED and battery behaviour remain owner/device gates. Recorded host is Apple Silicon/macOS with Xcode27.1. Flutter3.41.9 was obtained and used; a Homebrew JDK17 exists but Android platform SDK and CocoaPods are not available in the current build setup. No new signing/device permissions were requested.

## Evidence criteria

Every claim names source inspection, command/build, synthetic widget/browser run or physical device. Save commands/results and screenshots in docs/evidence; preserve public-safe unique evidence remotely before deleting owned outputs. Reproduce from clean clone/lockfile, inspect distributed archive contents, SHA256 every attached artifact, verify remote release links and Pages responses. Never label assisted review human approval.

**Source/browser milestones completed:** baseline preserved, improved engine/screens implemented,34 tests plus analysis/web build passed, three assisted reviews completed, source/web release and static documentation prepared. Physical/signing/AT/long-run gates remain in issue#4.

**Next action:** physical Android acceptance with a controlled signing identity; retain all documented native and fidelity limits.
