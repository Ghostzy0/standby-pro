# Standby Pro v1.0.0-baseline.1

Archival **source prerelease**, 23 October 2026. Exact app source at `9ce5e1676a1eae2681037d75eb354cd76addf207` (root VERSION `1.00`, Flutter `1.0.0+1`). The tag pins this historical commit; the separate documentation PR records today's evaluation. No app patch or redesign is included.

## Verified now

Apple Silicon macOS, Xcode 27.1; Flutter 3.41.9 (`00b0c91f06`), Dart 3.11.5. In an isolated checkout of that SHA: `flutter pub get --enforce-lockfile`, `flutter test` (10 passed), `flutter analyze` (no issues). Flutter dependency resolution generated local iOS Podfile/config references; no app source modifications were used by tests. See `docs/evidence/baseline-checks.txt` on the documentation/improvement branches.

## Contents and installation

The attached source archive includes exact tracked `app/`, LICENSE, README and VERSION from the baseline. Unrelated third-party reference screenshots are excluded from this distribution because redistribution rights are unknown; they remain in historical Git. GitHub's automatic full-tree archives may include historical reference captures; do not reuse those images as app artwork.

```sh
git clone https://github.com/Ghostzy0/standby-pro.git
cd standby-pro
git checkout v1.0.0-baseline.1
cd app
flutter pub get --enforce-lockfile
flutter test
flutter analyze
```

Use Flutter 3.41.9/Dart 3.11.5 for the recorded check. Android additionally requires JDK17, compatible Android SDK and Gradle; iOS requires macOS/Xcode, CocoaPods and signing for a phone. No APK/IPA is attached: this host initially lacks Java/Android SDK and CocoaPods, and no signing or physical device acceptance was attempted. The native Android release configuration currently uses **debug signing**, unsuitable for production distribution.

## Known limitations

- London-only weather; high/low are synthesized, not measured forecast extrema. No automatic refresh beyond initial request.
- Calendar events and music metadata are synthetic examples; music transport attempts Android media keys without confirming an active session.
- Android keep-awake applies while its window is visible, regardless of charging; label is misleading. No charging monitor, background service or lock-screen integration.
- iOS has no system MethodChannel handler for keep-awake/brightness/media. No system StandBy/WidgetKit extension.
- Settings load/write and async disposal paths need hardening. Responsive settings/short-screen layouts and assistive technology are not accepted on physical devices.
- Burn-in shifting and minute cadence are software mitigations, not guarantees of battery life or OLED safety.
- MIT covers original source, not arbitrary historical reference screenshots. Open-Meteo data/service has separate attribution and noncommercial free-endpoint terms.

Local preferences use `standby_settings_v1`. Save any desired settings before uninstalling; OS app-data removal clears preferences. Later improved builds retain the key; debug/release signing changes may require reinstall and lose local settings. No user data is uploaded by the app beyond its direct weather request.

AI setup prompt: “Clone Ghostzy0/standby-pro at v1.0.0-baseline.1. Use Flutter 3.41.9, run locked dependencies/tests/analyze, and report native SDK/signing/device gaps before proposing a build.”
