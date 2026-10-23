# Standby Pro baseline source audit

Audited commit: `9ce5e1676a1eae2681037d75eb354cd76addf207`
Scope: Dart app, Android/iOS native setup, tests, packaging, and reference-image provenance. Source review only; no builds, runtime tests, or device checks were performed.

## Release blockers and high-risk findings

### High — iOS advertises system features that have no implementation

`app/lib/src/state/standby_controller.dart:105-114` invokes the `standby_pro/system` methods for keep-awake, brightness, and media, but `app/ios/Runner/AppDelegate.swift:4-16` only registers Flutter plugins and installs no handler for that channel. `StandbySystemService` converts a missing channel into `false` without surfacing failure (`app/lib/src/services/standby_system_service.dart:18-28`). Consequently the iOS build silently ignores the keep-awake and brightness controls; media commands also have no iOS implementation. Add a native iOS channel (and restore system brightness/lifecycle state correctly), or disable and disclose unsupported controls on iOS. Verify on a physical iPhone, including lock/dim behavior and media playback.

### High — calendar and music cards present fabricated fallback data as device data

The initial snapshot creates future events named “Focus block” and “Wind down” and a track named “Ambient Focus” (`app/lib/src/domain/standby_models.dart:366-400`). There is no calendar or now-playing reader in the app; the Android bridge only dispatches media key events (`app/android/app/src/main/kotlin/com/ytchannel/standbypro/MainActivity.kt:73-84`). The calendar card renders event titles without any fallback marker, and the music buttons remain enabled even when `isControllable` is false (`app/lib/src/features/standby/widgets/integration_cards.dart:65-134,137-220`). Users can mistake sample data for their schedule or current playback, while transport buttons may do nothing. Implement actual sources and permission/error states, or label sample content prominently and disable unavailable controls. Add tests proving fallback values cannot be mistaken for live data.

### High — “Live weather” includes invented highs and lows and is fixed to London

`WeatherService.fetchLondonWeather()` requests only current temperature and weather code, fixes coordinates/city to London, then fabricates high and low values as `temp + 3` and `temp - 5` (`app/lib/src/services/weather_service.dart:10-32`). The widget renders those values as actual H/L values, and “Live weather” means only that this request succeeded (`app/lib/src/features/standby/widgets/integration_cards.dart:29-60`; `app/lib/src/state/standby_controller.dart:57-69`). Remove the fabricated values or request forecast highs/lows, provide a user-selected location, and distinguish actual measurements from fallback. Test malformed, missing, stale, and failed API responses.

### High — keep-awake behavior contradicts the “while charging” control

Android directly adds or clears `FLAG_KEEP_SCREEN_ON` whenever the setting is applied (`app/android/app/src/main/kotlin/com/ytchannel/standbypro/MainActivity.kt:59-64`); it never checks charging state. The app calls this “Keep awake while charging” in customization (`app/lib/src/features/standby/standby_screen.dart:470-477`) and README. Either rename it to describe foreground behavior, or implement charger-aware behavior and test plug/unplug transitions. No behavior was verified on hardware in this audit.

### High — tracked reference screenshots expose an unrelated commercial app listing; rights are unverified

Ten screenshots are committed under `assets/references/` (first added in commit `ffc3a70`). They are not declared as Flutter assets in `app/pubspec.yaml`, so this review did not find them included in the app bundle. Inspection of `Screenshot_2026-05-02-23-19-45-96.jpg` shows a Google Play listing for “StandBy Mode: Clock & Widgets,” naming Zetabitapps and linking to `zetabitapps.com/privacy-policy`; JPEG EXIF identifies Android device software `CPH2791_16.0.5.701(EX01)`. The screenshot source, authorization, and intended repository use are undocumented. Remove them from public source packaging or record the source and permission; do not use them as product screenshots. Their being outside Flutter's declared assets does not resolve redistribution of the repository itself.

## Other release gaps

- `app/lib/src/state/standby_controller.dart:72-77` ignores its injected `SettingsRepository` and constructs a fresh SharedPreferences-backed repository for every update. This breaks the persistence seam and makes isolated controller tests unreliable. Use the injected repository consistently, and test a controller save/load round trip.
- `app/lib/src/state/standby_controller.dart:41-50` performs asynchronous initialization without error handling; load or system-channel errors can leave startup incomplete. Add an explicit loading/error path and ensure partially initialized observers/timers are cleaned up.
- The Android manifest declares location, calendar, notifications, and wake-lock permissions (`app/android/app/src/main/AndroidManifest.xml:2-8`), while iOS Info.plist explains calendar and location access (`app/ios/Runner/Info.plist:29-34`). The plan explicitly leaves permission flows and real calendar integration unfinished (`PLAN.md:30-32`); no code requests these permissions or reads these data sources. Remove unused declarations and descriptions until features exist, or implement and explain the permission flow.
- The tests cover model serialization, helper policies, and a static widget render, but do not exercise controller persistence, weather parsing, method-channel outcomes, actual calendar/media integrations, or native bridges (`app/test/standby_domain_test.dart`, `app/test/standby_widget_test.dart`). These are meaningful coverage gaps, not evidence that those paths fail at runtime.

## Verification boundary

This is a source and packaging review at the recorded commit. No Flutter test/analyzer/build command, iOS build, APK inspection, or physical-device test was run. The known plan marks physical Android testing and iOS signing/device validation as unfinished (`PLAN.md:25-27`).
