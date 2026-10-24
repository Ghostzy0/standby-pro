# Native compilation — 24 October 2026

## Notice-fixed final source

The final app1.1.0+3 source, master `1a21922f5d49790257c01e2106104f4acdd155f3`, compiled again after the MIT notice fix and Node24 checkout update:

- [Android run40120081277](https://github.com/Ghostzy0/standby-pro/actions/runs/40120081277): locked dependencies, clean analysis, all44 tests and debug APK compilation passed. Build-time APK SHA256 `f41058a82c82b376a3efb156ae15cce2d13907de005634be5e8f8dc0aa5ca68b`.
- [iOS simulator run40120575397](https://github.com/Ghostzy0/standby-pro/actions/runs/40120575397): locked dependencies, clean analysis, all44 tests, CocoaPods1.17.0 and Xcode16.4 compilation passed; `Runner.app` was produced.

The parent verified native build lines in the full raw log archives. These outputs were also disposable, uninstalled CI binaries with no download/distribution or signing acceptance. The checksums are build observations, not recoverable release assets. No iOS bundle checksum was captured. The local arm64/minimum-iOS15 SPM experiment is a different configuration and is described separately.

## Initial native compilation before the notice fix

Both native project targets compiled from unchanged master `4c74a64417a61ff65ccb3e7f0d7973ce99329d48`, using pinned Flutter3.41.9/Dart3.11.5. This is compilation evidence, with no device installation or production signing acceptance.

| Target | Configuration | Observed result |
| --- | --- | --- |
| Android | Standard Ubuntu24.04 hosted runner, JDK17, API36/build tools36.0.0, NDK28.2.13676358; `flutter build apk --debug --no-pub` | [Run40118119312](https://github.com/Ghostzy0/standby-pro/actions/runs/40118119312) passed. `assembleDebug` built `build/app/outputs/flutter-apk/app-debug.apk`. The build also resolved CMake3.22.1. |
| iOS simulator | Standard macOS15 hosted runner, Xcode16.4 build16F6, CocoaPods1.17.0; `flutter build ios --simulator --debug --no-pub` | [Run40118546032](https://github.com/Ghostzy0/standby-pro/actions/runs/40118546032) passed. Pod installation and Xcode build completed; `build/ios/iphonesimulator/Runner.app` was produced. |

Both jobs also passed locked dependency resolution, analysis and all43 tests. The Android debug APK's build-time SHA256 was:

```text
a3cbc97e8699db16b03f1c92d26cf8b5ed705d7b3e657dcfa09978dfe1b57d84
```

**The compiled binaries were disposable hosted-runner outputs. They were not uploaded, retained, downloaded, installed or reviewed as distributable packages.** The Android checksum records what that build produced; it cannot recover the APK, and a future debug build may use a different ephemeral signing key. No iOS bundle hash was captured. Rebuild from the pinned source for a new artifact; do not treat this checksum as a release download manifest.

The parent inspected the actual native-step logs in the raw Actions log archives. The CLI's initial combined log view omitted native steps while job-step metadata was stale; the green job status alone was not used as proof. Independent assisted review confirmed the Android build line/checksum and this artifact-retention limitation. These runs used the earlier checkout-v4 action; the Node24 checkout-v6 follow-up has separate source CI evidence, with unchanged app/Flutter inputs.

No production signing credential, binary release, artifact upload, cache or deployment was added. Physical Android/iPhone behavior, install/update signing continuity, TalkBack/VoiceOver, background/lock/unplug behavior and long-run power/thermal/OLED checks remain [open](https://github.com/Ghostzy0/standby-pro/issues/4). Simulator compilation establishes none of those results.
