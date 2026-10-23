# Preview artifact verification

Date: 2026-10-23
Source revision: `756bcdc94280fedb93d3f8fe2fb9b4843e66e280`
Scope: static packaging, checksum, source-tree, web-build, and disclosure review of `outputs/improved/`. No build, UI, or test job was run by this review.

## Integrity and tree coverage

All six entries in `SHA256SUMS` verify: `BUILD-INFO.json`, `CLEAN-CLONE-CHECKS.txt`, `RELEASE-NOTES.md`, `THIRD-PARTY-NOTICES.txt`, the source archive, and the web-preview archive.

The source archive `standby-pro-v1.1.0-preview.1-source.tar.gz` has SHA256 `2a460063417248a4a0441170f50ad882e2495420c91b205872af7a75b2a0c7f3`. Its 150 regular files exactly match the 150 tracked paths at the stated source commit; every archived file's bytes also match that commit's Git blob. It contains no `.git` directory/object, symlinks, `assets/references` competitor captures, `.dart_tool`, `node_modules`, `DerivedData`, or app build output. The Roboto font files, bundled Apache 2.0 text, and `THIRD-PARTY-NOTICES.txt` are present.

The web-preview archive `standby-pro-v1.1.0-preview.1-web-preview.tar.gz` has SHA256 `661a70a5dc85b72f5bf579a9eb793b20d4063cacb75808e8fe1c99b240b8580d`. It has no `.git` data or symlinks. All 36 files under its `demo/` directory match the corresponding files in `work/final-clean/app/build/web` byte for byte. Its embedded `BUILD-INFO.json` identifies the same source commit as the separate build-info file. The tar includes the expected static site imagery and compiled demo assets; no competitor-reference directory or `Screenshot_2026-05-02...` file appears.

Static scans of source and web archives found no private-key markers, credential-like assignments, or local workspace/home paths. This is a heuristic scan and does not establish a general security certification.

## Font and network boundary

The four bundled Roboto weights and Apache 2.0 licence match the Flutter SDK cache files, as detailed in `docs/audits/03-release-security.md`. The web archive bundles the font assets and bundled licence notice.

The compiled Flutter web runtime contains its built-in `fonts.gstatic.com/s/` fallback base URL for glyphs absent from local fonts. The recorded Chrome run exercised Latin UI with weather disabled and saw requests only to the preview origin. The fallback URL was not requested during that run; arbitrary missing-glyph egress remains unverified and is disclosed as a limitation. Weather-on requests go to Open-Meteo and the free endpoint remains restricted to non-commercial use.

## Verification claims and remaining limits

`CLEAN-CLONE-CHECKS.txt` records locked dependency resolution, `flutter analyze` without issues, all 34 tests passing, and a web release build using Flutter 3.41.9/Dart 3.11.5. `BUILD-INFO.json` records the same checks and preview host details. The runtime summary and release notes describe the browser navigation/countdown/settings walkthrough, weather-off request hosts, and Latin UI scope. These are browser-preview results, not Android/iOS binary acceptance.

No production signed APK/IPA is included. Production signing/update identity, Android and iOS clean release builds, platform permission inspection, physical-phone behavior, native assistive technology, battery/thermal behavior, and commercial weather-service rights remain open. This document was added after source commit `756bcdc...`; it is an audit record and is intentionally not represented as part of the source archive.
