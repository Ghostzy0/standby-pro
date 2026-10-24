# Standby Pro continuation

Updated24 October2026. **PAUSED by direct human instruction at19:29UTC; no auto-resume.** This is the active improved app repository. Original source/history/package identity are preserved. The separate historical source baseline is https://github.com/Ghostzy0/standby-pro-baseline . No faithful third-party replica is established; see docs/releases/provenance-and-fidelity.md.

## Source and version

- Historical source:9ce5e1676a1eae2681037d75eb354cd76addf207, tag v1.0.0-baseline.1 in this repository; app1.0.0+1.
- Improved app:1.1.0+3, source/web prerelease v1.1.0-preview.2. Earlier preview.1 remains immutable. Engine, interface, typography and documentation are separate focused PRs. No production signed native binary is claimed.
- Flutter3.41.9/Dart3.11.5; existing dependencies locked. Android package ID com.ytchannel.standbypro. Preferences retain standby_settings_v1. New weather opt-in fields default off for migrated data.

## Completed checks and decisions

Baseline10 tests and analysis passed before changes. Preview.1 passed34 tests, analysis and a web release build in a fresh remote clone. Preview.2 adds focused regressions and bundles the app MIT notice; source CI at2b03046 passes44 tests, clean analysis and web release compilation. Chrome headless exercised presets, real timer countdown/pause/reset, settings/about/back, quiet restore via keyboard and390×844 navigation. Widget tests cover320×568,844×390 and2× text scale. Actual screenshots and public-safe logs are in docs/evidence and docs/assets. Three assisted review rounds cover baseline/platform, UI/UX and release/security; parent review checks exact source/artifacts and remote recovery separately. Assisted review is not human approval.

Weather is optional city selection without GPS. No calendar/media native integration is claimed. App-local dimming works independently of native support. Android foreground keep-awake is labelled accurately; iOS/web native controls remain unavailable. Sensitive unused permissions and implicit debug release signing are removed. Roboto fonts and licences are bundled after the browser revealed an implicit remote font request; the final weather-off tested path contacted only the preview origin.

Final native compilation at release 1a21922 passed Android debug APK and default CocoaPods iOS simulator builds on hosted runners, each with 44 tests and clean analysis. These binaries were disposable and never installed or accepted for distribution; see docs/evidence/native-hosted-builds-2026-10-24.md. A local SPM experiment refreshed to2b03046/app1.1.0+3 includes the MIT notice but uses arm64-only/minimum-iOS15 configuration and ad-hoc signing. It does not establish an unchanged universal/iOS13 build, developer/store signing or physical-phone behavior. All 22 runtime app/lib/assets/pubspec/lock inputs of that isolated experiment match release 1a21922; native project configuration differs. Initial simulator setup rejected iPhone17+iOS27.1 before creating a device; compatible installed27.0 is prepared. The corrected retry was paused before execution. No simulator runtime evidence exists; require a new explicit owner resume before further tests.

Published preview.2 assets were all downloaded and verified: 8 assets, 162 exact source files and 37 exact web files. Pages deployment b185c02 serves the new build; live Chrome checked the bundled app MIT licence route with no page errors and origin-only requests. See docs/evidence/final-acceptance-2026-10-24.md for the dated parent acceptance boundary.

## Remaining gates

Physical Android/iPhone, production signing/update identity, TalkBack/VoiceOver, charging/lock-screen/battery-saver, long-run thermal/OLED and background timer reliability remain unaccepted in issue#4. No paid service fallback exists. Open-Meteo free endpoint is noncommercial; commercial distribution needs suitable service rights. The visual timer is not a background alarm. Arbitrary missing-glyph font fallback paths are not covered by the Latin UI network test.

No physical phone was tested on 24 October. After explicit owner resume, next device action when one is available: reproduce the chosen release on a physical Android phone with a controlled signing identity, then record foreground/background/lock/unplug and accessibility results in issue#4. Do not turn widget/browser evidence into phone-readiness claims.
