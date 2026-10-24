# Preview 2 artifact independent review — 24 October 2026

Read-only verification of the prepared `v1.1.0-preview.2` source and web archives, metadata/notices, and retained final native CI logs. No builds, browser/UI actions, installs, or binary downloads were performed.

## Results

- All seven entries listed in `SHA256SUMS` verified successfully.
- The source archive contains exactly 162 regular files, matching all 162 Git tree files at `1a21922f5d49790257c01e2106104f4acdd155f3`. Every archived file's bytes match its Git blob; no missing or extra files.
- The web archive contains exactly 37 regular files, matching all 37 files under the clean-clone compiled `app/build/web` output byte-for-byte.
- Both archives have normalized relative member names, no path traversal/absolute paths, duplicate entries, symlinks, or special files. Their contents contain no `.git`, build caches, ignored local configuration, competitor-reference capture paths, or detected private workspace paths. A filename and content scan found no private-key or common credential-token patterns. Source images are the app icons/launch images and project documentation captures; no competitor reference captures are packaged.
- The bundled app MIT notice in both archives is byte-identical to root `LICENSE`, SHA-256 `3bedf0f7ad7c9ad5ec9d320457a72a065fff9749b879b9c30e067ce4fb24841d`. Source third-party notices are included, and the web archive includes Flutter's generated dependency notices plus Roboto's Apache 2.0 text.
- `BUILD-INFO.json` names source `1a21922f5d49790257c01e2106104f4acdd155f3`, app `1.1.0+3`, Flutter 3.41.9/Dart 3.11.5, and the expected 162/37 counts. The release scope correctly excludes native binaries and leaves device/signing/accessibility/power gates open.

## Native compile evidence boundary

The retained Android and iOS logs/JSON both report successful jobs on source commit `1a21922f5d49790257c01e2106104f4acdd155f3`, each with analysis and all 44 tests passing. The Android log contains the debug APK build line and SHA-256 `f41058a82c82b376a3efb156ae15cce2d13907de005634be5e8f8dc0aa5ca68b`; the iOS log contains the simulator `Runner.app` build line. These are evidence that the hosted jobs compiled the selected targets. The outputs were not retained/uploaded/installed, and there is no iOS bundle hash; the Android hash cannot recover its APK. These results do not establish phone installation/runtime, native assistive technology, production signing/update identity, or battery/thermal/OLED acceptance.

The release notes link the earlier native compilation receipt, whose scope is explicitly the first builds at commit `4c74a64417a61ff65ccb3e7f0d7973ce99329d48`; that is accurate as an “initial” receipt, but distinct from the final 1a21922 reruns listed in `BUILD-INFO.json`. Keep that source distinction visible in any final release summary.

Finalization: this independent report replaces the provisional receipt. The release manifest was regenerated after report and release-note updates; all final manifest entries were verified before publication. Source and web archives were unchanged by these documentation updates.
