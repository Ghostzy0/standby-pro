# Platform and product research

Research checked 2026-10-23. Primary-source facts are linked inline; recommendations are explicitly marked as inference. This brief is based on the repository README, PLAN, MEMORY, Flutter services and UI. It does not represent device validation.

## What the current app actually provides

- The project is a Flutter bedside display with clock faces, weather/calendar/music cards, night tint, burn-in offsets, and an Android `FLAG_KEEP_SCREEN_ON` bridge. The README's claims about calendar and live music exceed the visible implementation: `PLAN.md` still lists real calendar data and expanded media metadata as future work, and `WeatherService.fetchLondonWeather()` uses fixed London coordinates. The product copy should say "sample calendar" / "demo calendar" and make the weather location limitation explicit until those paths are implemented.
- The Android native bridge enables/disables `FLAG_KEEP_SCREEN_ON` on the activity window. Android documents this as a visible-window behavior; when the app goes to background, the OS may turn the screen off normally. The system flag is not a charger monitor, a background service, or a promise to override OEM battery policy. [Android: Keep the screen on](https://developer.android.com/develop/background-work/background-tasks/awake/screen-on), [Android: choose the right API to keep the device awake](https://developer.android.com/develop/background-work/background-tasks/awake).
- `StandbyController` slows its ticker in background, but no visible accessibility adaptation exists for custom motion. The project currently has tests and analysis recorded from May 2026, but no physical Android or signed iOS validation per `MEMORY.md`.

## Platform constraints

### Apple iPhone

**Verified facts.** Apple's StandBy starts when the user connects the iPhone to power, places it stationary in landscape, and taps/presses the side button. On supported Always-On models it can remain visible; otherwise the user reactivates it by tapping, nudging the table, or Siri. Users choose the system's StandBy display timeout. Low-light Night Mode applies a red tint. [Apple Support: Use StandBy](https://support.apple.com/en-euro/guide/iphone/-iph878d77632/ios).

Apple provides a supported third-party extension point: a small WidgetKit widget can appear in StandBy, scaled into one half of the screen. Apple's guidance is to show glanceable information, use larger type, and make backgrounds removable. [Apple Developer: Add StandBy support to widgets](https://developer.apple.com/documentation/widgetkit/adding-standby-and-carplay-support-to-your-widget).

**Inference and implication.** Keep iOS wording to “bedside display while the app is open” until real iOS builds/devices prove behavior. A later iOS-specific feature should be a WidgetKit extension that participates in Apple's StandBy, rather than claiming the Flutter activity can replace or control the system StandBy experience. The repository currently has generated iOS scaffolding but no widget extension or iOS device evidence.

### Android

**Verified facts.** Android's `FLAG_KEEP_SCREEN_ON` keeps the screen on only while the window is visible to the user; it must be set on an Activity/window and has no background-service equivalent. Android warns that holding the screen on drains battery and recommends using it briefly. [Android: Keep the screen on](https://developer.android.com/develop/background-work/background-tasks/awake/screen-on), [WindowManager.LayoutParams](https://developer.android.com/reference/android/view/WindowManager.LayoutParams#FLAG_KEEP_SCREEN_ON).

Android distinguishes keeping a display on from keeping the CPU awake. Wake locks may drain the battery quickly and should be held only when needed. The app's existing screen flag does not make background timers or a charging screen saver persist. [Android: choose the right API](https://developer.android.com/develop/background-work/background-tasks/awake).

**Inference and implication.** Describe the feature as “Keep screen on while Standby Pro is open” and call it an optional foreground setting. Avoid “always on,” “works while locked,” “auto-starts when charging,” “prevents burn-in,” or “battery safe.” Support a visible exit/disable control, and explain that Android's normal screen-off and vendor power rules apply once the app is backgrounded. For a later charge-triggered launch, consider Android's user-configured system screen saver / dock flow rather than silently launching a background activity; this is a product direction, not implemented behavior.

## Accessibility and motion

**Verified facts.** Flutter's `MediaQueryData.disableAnimations` maps to Android's “Remove animations” setting; iOS exposes reduced motion separately as `AccessibilityFeatures.reduceMotion`. Framework animations may adapt automatically, but custom explicit animations should inspect the relevant platform settings and simplify or skip nonessential motion. [Flutter API: `disableAnimations`](https://api.flutter.dev/flutter/widgets/MediaQueryData/disableAnimations.html), [Flutter API: `reduceMotion`](https://api.flutter.dev/flutter/dart-ui/AccessibilityFeatures/reduceMotion.html).

Flutter recommends screen-reader testing with TalkBack and VoiceOver, descriptive control labels, at least 48×48 dp Android / 44×44 pt iOS tap targets, adequate contrast, and layouts that survive large text scaling. [Flutter accessibility](https://docs.flutter.dev/ui/accessibility), [Flutter UI design and styling](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling).

**Inference and recommendation.** A compact first release can make custom transitions and decorative movement honor both Android disable-animations and iOS reduce-motion settings, preserve meaningful state changes, and verify touch controls and labels in TalkBack/VoiceOver. Large clock numerals need not scale with system text exactly like settings labels, but controls and secondary text should remain operable at large text settings. The app currently has subdued motion by design; do not advertise full accessibility conformance without hands-on checks.

## Weather service and licensing

**Verified facts.** The app calls `api.open-meteo.com` directly from the device. Open-Meteo's free/open-access API is restricted to non-commercial use and requires CC BY 4.0 attribution; listed limits include 10,000 calls/day, 5,000/hour, 600/minute and a monthly limit of 300,000. Open-Meteo explicitly classifies subscription/ad-supported apps and commercial products as commercial use. Its paid API plan grants commercial-use rights and a dedicated endpoint/key. [Open-Meteo Terms](https://open-meteo.com/en/terms), [Open-Meteo Pricing](https://open-meteo.com/en/pricing).

The weather data itself is CC BY 4.0 and permits commercial reuse with attribution, while access to the free API service is separately restricted to non-commercial use. Do not confuse the data license with permission to use the free API in a paid/commercial app. Open-Meteo disclaims guarantees of accuracy, completeness, or uninterrupted availability. [Open-Meteo Terms](https://open-meteo.com/en/terms).

**Inference and recommendation.** The repository decision says “no ads or in-app purchases in the first build,” which is consistent with free tier use only if the resulting app remains non-commercial. If product plans turn commercial, replace this call with an appropriately licensed paid API before release, or choose another data source with compatible terms. Add visible attribution such as “Weather data: Open-Meteo” linked to the provider, show a last-updated timestamp, and label stale/fallback values so demo or cached weather cannot be mistaken for current conditions. Current service hard-codes London and synthesizes high/low values (`temp ± 3/5`), so do not call those forecast extrema.

## Comparable public open-source projects

These are useful product/interaction references, not code or asset sources. Inspect their current licenses and individual asset provenance before copying or adapting anything.

- [Nightdream](https://github.com/firebirdberlin/nightdream) is an Android desk clock/screensaver with dynamic brightness, AMOLED night mode, gesture resize, alarms/radio, and weather options. Its repository lists GPL-3.0. It suggests that a focused dim/night/screen-saver mode can be an anchor feature; GPL-3.0 makes direct code reuse a licensing decision, and visual copying is not recommended.
- [MorphClock](https://github.com/dgmltn/android-MorphClock) describes itself as a bedside clock Daydream app and links a license file. This makes it a relevant small interaction reference; verify exact license terms and source/asset status before any reuse.
- [Clock by BlackyHawky](https://github.com/BlackyHawky/Clock) is a current customizable Android clock/screen saver with multiple clock faces, AMOLED mode, alarms, timers, and device-specific caveats. Its repository identifies GPL-3.0 and Apache-2.0 licenses (different components); treat it as feature and UX inspiration and retain component-level license awareness.

## Recommended small release

**Inference: prioritize “honest, reliable bedside basics” over adding another widget.** A coherent next release could be:

1. **Accurate status and setup:** clarify “open and on screen” keep-awake behavior, display weather source/location/time, and label calendar/music content as demo, unavailable, or live according to the actual integration state. This fixes trust gaps in existing README claims without broadening platform scope.
2. **Accessible bedside controls:** honor system reduced-motion settings for custom animation; give dimming/night/keep-awake controls clear semantics and sufficiently large targets; confirm large-text layout and screen-reader order on physical devices.
3. **Weather correctness:** either make location user-selectable with explicit permission/fallback or remove the location-selection promise; stop fabricating highs/lows; implement stale/error states and attribution. Confirm API terms fit the actual distribution model first.
4. **Platform validation evidence:** one real Android phone run through foreground, background, unplugged, and battery-saver scenarios; one macOS/Xcode signed iOS run plus widget-extension feasibility review if iOS StandBy is a product promise. Do not label either platform “validated” before that evidence exists.

Possible truthful short description today: **“A customizable bedside clock and glanceable dashboard for phones. Keep the app open while charging; screen behavior depends on your device and system settings. Weather is currently London-based; calendar and music cards may show sample data.”** If preparing commercial distribution, omit live Open-Meteo weather until commercial API rights are in place.

## Asset and dependency license concerns

- The repo declares MIT for the app. Re-check the root `LICENSE` before publishing, include third-party notices where package licenses require them, and generate a release-time dependency/license inventory (the direct Flutter dependencies include `shared_preferences`, `http`, `intl`, and `cupertino_icons`; transitive packages are not enumerated here).
- Do not copy competitor source, icons, screenshots, fonts, illustrations, or store copy based only on the fact that a repository is public. Record the exact asset origin, license, attribution text, and modifications. Be especially careful with mixed-license repositories such as BlackyHawky Clock.
- Open-Meteo weather data attribution is required by CC BY 4.0, independent of the MIT source license. The free API's non-commercial terms also constrain app distribution.
- Flutter's bundled Material Icons and package-provided assets must be included in notices as their package licenses require. Add custom fonts/images only with documented redistribution and commercial-use rights.
