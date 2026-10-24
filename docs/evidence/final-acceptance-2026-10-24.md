# Parent acceptance — 24 October 2026

Accepted scope: source and compiled browser preview `v1.1.0-preview.2`, app `1.1.0+3`, exact release source `1a21922f5d49790257c01e2106104f4acdd155f3`. Android debug and default CocoaPods iOS simulator compilation are verified separately. Physical-phone, production signing, native assistive technology and long-run power/display acceptance remain open in [issue 4](https://github.com/Ghostzy0/standby-pro/issues/4).

## Source and review

Pinned Flutter 3.41.9 / Dart 3.11.5. Source CI at `2b03046e5945832be77727b6aee23f0e91c7231f` passed analysis, all 44 tests and web compilation; the release merge changes no app or CI inputs. Final native CI at the release SHA also passed analysis and all 44 tests each. PRs [10](https://github.com/Ghostzy0/standby-pro/pull/10) and [11](https://github.com/Ghostzy0/standby-pro/pull/11) include focused UI/channel/licence regressions and assisted independent reviews. Parent review fixed deprecated test semantics; artifact review identified the missing full app MIT notice, which was bundled and registered before final builds. Existing Roboto and dependency notices remain.

Assisted/static review is not human approval or native runtime acceptance. Historical baseline tags, prior preview assets, repository history and package identities were preserved. No third-party replica fidelity is asserted.

## Release recovery and browser runtime

[Published release](https://github.com/Ghostzy0/standby-pro/releases/tag/v1.1.0-preview.2): all eight assets were independently downloaded into a fresh directory. Every manifest checksum passed; all files match the uploads. Safe archive inspection matched all 162 source files to Git blobs at the release SHA and all 37 web files to the clean-clone release build. No extra/missing paths, traversal, symlinks or special files were found. [Recovery receipt](preview2-remote-recovery.json), [independent artifact review](../audits/preview2-artifacts-2026-10-24.md).

Pages deployment `b185c02ccb3c4c8cedc971b19bb34bff5944f0af` completed. [Live preview](https://ghostzy0.github.io/standby-pro/demo/), landing, guide, privacy, build metadata and MIT asset returned HTTP 200. Live build metadata names the release SHA; the served MIT asset matches root LICENSE. Chrome headless exercised About → Open-source licences → Standby Pro and displayed the exact MIT/copyright text, with no page errors and only the preview origin requested while weather was off. [HTTP receipt](preview2-live-http.json), [browser receipt](preview2-live-license-browser.json), [actual browser capture](../assets/browser-licenses-preview2.png). Temporary browser/server processes were closed.

Earlier preview.1 browser workflow results remain dated evidence for unchanged presets, countdown/pause/reset, settings/back, quiet restore and narrow navigation. Preview.2 targeted runtime verification covers its added licence route. Widget tests include large-text, semantics, reduced motion and narrow layouts; these do not establish VoiceOver/TalkBack behavior.

## Native evidence

[Final hosted builds](native-hosted-builds-2026-10-24.md): Android run 40120081277 produced a debug APK with observed SHA-256 `f41058a82c82b376a3efb156ae15cce2d13907de005634be5e8f8dc0aa5ca68b`; iOS run 40120575397 produced a simulator Runner.app using Xcode 16.4/CocoaPods 1.17.0. Both used the release SHA. The parent read actual native-step lines in raw Actions log archives. Outputs were disposable, unretained and uninstalled; no iOS bundle hash exists. The debug checksum cannot recover its APK. No native binary is distributed.

A separate local SPM experiment used Xcode 27.1 and an isolated project configuration, arm64 only and minimum iOS 15. Its app inputs were refreshed to the notice-fix source, version 1.1.0/build 3; the MIT asset matches LICENSE. The 62-file bundle tree digest is `426fe841caafe4cd55342be97245fcdd2280adcc35cb5b85a7b0261476771e92`. It has ad-hoc/linker signing and no developer/store identity. This differs from the unchanged CocoaPods project and does not validate universal simulator or original iOS 13 behavior. [Configuration boundary](native-readiness-2026-10-24.md).

Simulator runtime status will be recorded after the bounded shared test slot; compilation alone is not runtime acceptance.

## Remaining gate

No physical phone was tested. Signing/install-update identity, TalkBack/VoiceOver, charger/lock/unplug/battery-saver/background behavior, thermal/battery/OLED and arbitrary missing-glyph font fallback remain unaccepted. The timer is foreground visual feedback, not a background alarm. Weather is optional city data, with service rights required for commercial use. No account, analytics, paid fallback, calendar/media integration or system StandBy/WidgetKit is claimed.

Next action: run issue 4 when a physical phone and controlled signing route are available. Retain unique local experiment logs/configuration until a reviewed remote recovery route exists; this release backs up source/web artifacts, not all private host evidence. No unrelated cleanup or social publishing was performed by this chat.
