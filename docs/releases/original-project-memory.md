# Project Memory: Standby Mode App

## State Matrix
- **Project:** Standby Mode App / Standby Pro
- **Status:** Flutter core built and locally verified
- **Current Phase:** Device validation
- **Next Action:** Test `app/build/app/outputs/flutter-apk/app-debug.apk` on a real Android phone and tune the standby UX from device feedback.
- **Blockers:** iOS device build/signing requires macOS and Xcode. Android device UX still needs hands-on testing.
- **Last Verification:** 2026-05-13: `flutter test` and `flutter analyze` passed from `app`.
- **Git Policy:** Child git repo with GitHub remote. Safe autonomous checkpoint allowed only after tests, diff review, secret scan, explicit staging, and version/memory update.
- **Version:** 1.00

## Key Decisions
- Tech Stack: Flutter + Dart with generated Android/iOS projects.
- Android Package: `com.ytchannel.standbypro`.
- Core Engine: Adaptive clock cadence, OLED burn-in offsets, night mode tint policy, native keep-awake/brightness/media channel.
- Integrations: Calendar/weather/music have useful fallback states; Android media commands use a native MethodChannel.
- Product Direction: Inspired original StandBy experience, not a literal clone; no ads or in-app purchases in the first build.

## Do Not Touch / User Constraints
- Do not add ads or in-app purchases to the first build.
- Do not claim iOS device readiness until built/signed on macOS with Xcode.
- Do not claim Android UX is final until tested on a physical phone.

## Recent Actions (Max 3)
1. Standardized memory for Claude-centric operating policy and added project versioning.
2. Verified `flutter test` and `flutter analyze` on 2026-05-13.
3. Rebuilt the broken Capacitor/React app as a clean Flutter project in `app`.
