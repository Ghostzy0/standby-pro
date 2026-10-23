# Contributing

Use the existing Ghostzy0/standby-pro repository for improvements. The historical baseline is pinned separately at Ghostzy0/standby-pro-baseline. Preserve MIT notices, package identity and the original clock/theme choices. No third-party art or copied proprietary UI expression; new assets need provenance and redistribution rights.

Use a focused issue, `codex/` or another descriptive branch, a small PR, and clear before/after behaviour. Explain permission/network/data changes. Do not add accounts, telemetry, paid API fallbacks, fabricated live data or production signing secrets.

```sh
cd app
flutter --version # recorded toolchain: 3.41.9 / Dart3.11.5
flutter pub get --enforce-lockfile
flutter analyze
flutter test
flutter build web --release --base-href /standby-pro/demo/ --no-web-resources-cdn
```

Native Android additionally requires JDK17 and compatible SDK/Gradle. iOS needs Xcode/CocoaPods and a signing setup for physical devices. Read docs/releases for the actual release's build and device evidence. A passing widget test is not phone acceptance.

Test important risks: corrupt/old preference data; storage failure; async completion after disposal; city changes and weather disabled mid-request; small/landscape/large-text layouts; keyboard/focus and reduced motion. Keep sample events unmistakably labelled. Never use a real user's private calendar or media to make public screenshots.

Regenerate package licences with `python3 scripts/dependency_notices.py` after dependency changes. Record runtime captures with dimensions, synthetic-data status and host/tool versions. Describe remaining limitations honestly; assisted code review is not human approval.
