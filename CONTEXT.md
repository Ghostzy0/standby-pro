# Standby Pro continuation

Updated23 October2026. This is the active improved app repository. Original source/history/package identity are preserved. The separate historical source baseline is https://github.com/Ghostzy0/standby-pro-baseline . No faithful third-party replica is established; see docs/releases/provenance-and-fidelity.md.

## Source and version

- Historical source:9ce5e1676a1eae2681037d75eb354cd76addf207, tag v1.0.0-baseline.1 in this repository; app1.0.0+1.
- Improved app:1.1.0+2, source/web prerelease v1.1.0-preview.1. Engine, interface, typography and documentation are separate focused PRs. No production signed native binary is claimed.
- Flutter3.41.9/Dart3.11.5; existing dependencies locked. Android package ID com.ytchannel.standbypro. Preferences retain standby_settings_v1. New weather opt-in fields default off for migrated data.

## Completed checks and decisions

Baseline10 tests and analysis passed before changes. Improved34 tests, analysis and web release build passed in a fresh remote clone. Chrome headless exercised presets, real timer countdown/pause/reset, settings/about/back, quiet restore via keyboard and390×844 navigation. Widget tests cover320×568,844×390 and2× text scale. Actual screenshots and public-safe logs are in docs/evidence and docs/assets. Three assisted review rounds cover baseline/platform, UI/UX and release/security; parent review checks exact source/artifacts and remote recovery separately. Assisted review is not human approval.

Weather is optional city selection without GPS. No calendar/media native integration is claimed. App-local dimming works independently of native support. Android foreground keep-awake is labelled accurately; iOS/web native controls remain unavailable. Sensitive unused permissions and implicit debug release signing are removed. Roboto fonts and licences are bundled after the browser revealed an implicit remote font request; the final weather-off tested path contacted only the preview origin.

## Remaining gates

Physical Android/iPhone, production signing/update identity, TalkBack/VoiceOver, charging/lock-screen/battery-saver, long-run thermal/OLED and background timer reliability remain unaccepted in issue#4. No paid service fallback exists. Open-Meteo free endpoint is noncommercial; commercial distribution needs suitable service rights. The visual timer is not a background alarm. Arbitrary missing-glyph font fallback paths are not covered by the Latin UI network test.

Next action: reproduce the chosen release on a physical Android phone with a controlled signing identity, then record foreground/background/lock/unplug and accessibility results in issue#4. Do not turn widget/browser evidence into phone-readiness claims.
