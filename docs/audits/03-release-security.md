# Release, security, and licence review

Date: 2026-10-23
Scope: historical source release at `9ce5e1676a1eae2681037d75eb354cd76addf207` and source changes on `codex/bedside-improvements`. Static review only; no build, dependency resolution, test, binary inspection, or device run was performed for this audit.

## Decision

A separate historical-baseline repository can be honest and reasonably safe as a curated source snapshot, provided it contains only the tracked baseline app/source and its original MIT notice, plus concise provenance and limitation records. Preserve the exact source commit ID in the new repository's documentation. Do not copy the existing repository's Git history: competitor Google Play reference captures live in that history, and deleting them from a later tree does not remove them from historical commits or GitHub-generated full-tree archives. Exclude `assets/references/` and any screenshots from the new repository. Do not describe the release as a faithful 1:1 recreation: no authorised competitor binary or runtime was supplied or inspected, and screenshots are inspiration evidence only.

This decision is about redistributing the original MIT source snapshot. It does not certify either platform build for store release. Existing Android release configuration uses the debug signing key. The app also contains synthetic calendar/music examples, unsupported iOS system controls, and a free Open-Meteo API call whose service terms are limited to non-commercial use. Those facts must remain visible to users and release reviewers.

## Provenance and permission

- The designated source is exact commit `9ce5e1676a1eae2681037d75eb354cd76addf207`, historical tag `v1.0.0-baseline.1`; verify both resolve to the same commit before taking a snapshot.
- The repository carries an MIT `LICENSE` naming TheFadGhost and 2026. Keep it verbatim with all substantial source. A new repository should state that the snapshot was copied from that commit and identify later edits as a separate line of work.
- No competitor binary, source, or authorised runtime was provided. The 10 files under `assets/references/` are competitor-store screenshots with unknown redistribution permission. Exclude them from a new repo, releases, demos, and product assets. A fresh root commit or exported source snapshot is required; a branch in the old history is not enough to remove their history.
- No one-to-one/fidelity or compatibility claim is supported by the available evidence. Describe it as an independent Flutter bedside clock inspired by the general category, with the listed integrations and limitations.

## Package, permission, and privacy review

- Android baseline declares `INTERNET`, network-state, coarse/fine location, calendar read, notifications, and wake lock permissions, although the baseline does not read location/calendar, post notifications, or use a background wake-lock service. Keep only permissions required by implemented functions; do not tell users those unfinished integrations work. The improved branch removes the unused declarations (apart from `INTERNET`).
- Baseline iOS Info.plist includes calendar and location purpose strings without corresponding permission-backed data sources. The improved branch removes those descriptions. Confirm the final merged manifests and generated permission set before any store submission.
- In the improved branch, optional weather sends the selected city coordinates and device IP to `api.open-meteo.com`; it does not request GPS. The interface discloses this. The app also stores preferences locally using `shared_preferences`; no analytics/account code or embedded secret was found in this source scan.
- Open-Meteo attribution is present in the improved UI and the research note records CC BY 4.0 attribution for data. The free API service is separately limited to non-commercial use. A commercial/monetized distribution must use a service plan with commercial API rights or omit/disable network weather. Data attribution by itself does not grant commercial access to the free endpoint.
- Android application ID and iOS bundle configuration are still template-like (`com.ytchannel.standbypro` / project settings); confirm ownership and intended public identity before store publication. Android `release` currently selects `signingConfigs.debug`; never distribute that as a production release.

## Dependencies and licences

- `app/pubspec.lock` pins direct Dart packages (`cupertino_icons`, `http`, `intl`, `shared_preferences`) and their transitive packages. Flutter/Dart SDK packages and generated Android/iOS plugin projects also contribute terms. This review did not generate the complete resolved licence report, and package licences can change with dependency updates.
- Before a binary release, generate and archive a licence inventory from the exact locked dependency graph for Flutter/Dart and each platform's resolved native dependencies (including CocoaPods/Gradle). Ship required third-party notices in the app or a clearly linked notices screen/file. Keep Open-Meteo attribution distinct from software notices.
- No bundled fonts or image assets are declared in the baseline Flutter manifest. Recheck icons and generated platform assets if adding or replacing them; do not assume MIT covers third-party artwork.

## Source security and changed-code findings

- Static text scan found no API key, credential, private key, or embedded token. The only outbound endpoint found is the public Open-Meteo forecast API. This is not a dependency, privacy, or runtime security certification.
- At the initial review snapshot, the improved Android release build used the debug keystore (`app/android/app/build.gradle.kts`). The later recheck below confirms that explicit debug signing was removed; a production signature remains unverified.
- The improved weather service validates response structure, numeric values, weather codes, and selected daily extrema; it uses fixed coordinates for four user-selected cities and applies a six-second request timeout. Requests use HTTPS and are client-side. There is no API key to protect.
- The improved timer explicitly says it has no sound, notification, or background alarm and resets on process close. Its completion guarantee applies only while the app remains open; do not market it as an alarm.
- No critical/high source defect was established in the changed Dart/Kotlin code by this read-only review. The improved Android native bridge still dispatches media key events and cannot establish that a player accepted them; the interface should continue to identify metadata as unavailable/sample and avoid promising playback control. iOS has no corresponding native handler, so system display controls remain unavailable there.
- Settings persistence now serializes writes and catches malformed preference data; weather request revisions prevent an older city response overwriting a newer selection. Static review did not validate these paths at runtime.

## Clean-clone and release criteria

For a separate baseline repository:

1. Create a new clean repository snapshot from the exact source commit, with no inherited commits or refs that contain `assets/references/`; verify the screenshot files are absent from the working tree, Git objects reachable from published refs, source archive, and release attachments.
2. Preserve the original `LICENSE`, app source, lockfile, and baseline README. Add a provenance note naming the exact upstream commit, snapshot date, screenshot exclusion, and independent/incomplete feature status. Do not call it a 1:1 recreation.
3. Inspect the final tracked file list and secret scan, then perform a clean clone and run the documented locked Flutter checks in the stated SDK version. Record commands and results without implying a store-ready binary.

Before any improved app binary/store release:

1. Resolve the Open-Meteo commercial-use question against the actual distribution model; retain free endpoint only for non-commercial use or switch to licensed commercial access.
2. Configure protected production signing outside source control. Verify package/bundle IDs, version, permissions, and signed artifact from a clean clone.
3. Generate third-party licence notices for the exact Flutter, Gradle, and CocoaPods resolution; preserve MIT attribution and Open-Meteo data attribution.
4. Verify Android and iOS builds and supported behavior on real devices. Clearly document unsupported iOS controls, synthetic calendar/audio content, visual-timer limitations, and any permissions/data transfers.
5. Keep screenshots and promotional materials original or explicitly licensed; do not use competitor captures as product imagery.

## Evidence boundary

This is a source, history, and manifest review. No build, app launch, network request, store upload, licence scanner, signing operation, or device behavior was exercised. See `docs/audits/01-baseline-source.md` and `docs/releases/v1.0.0-baseline.1.md` for the earlier baseline source audit and recorded historical verification.

## Baseline repository packaging recheck — 2026-10-23

The separate repository is now published at `https://github.com/Ghostzy0/standby-pro-baseline`, tag `v1.0.0-baseline.2`. The remote annotated tag peels to commit `c6c7d41da1e5c6d765531d210a77a3ae00691520`. It adds the three omitted upstream Gradle wrapper files through a packaging-only PR; the earlier `v1.0.0-baseline.1` tag/history was not rewritten.

The repaired provenance verifier reports 83 pinned app files at upstream commit `9ce5e1676a1eae2681037d75eb354cd76addf207`. Independently, all 83 SHA256 entries in `PROVENANCE.json` matched both the upstream Git blobs and the v2 source archive. The restored wrapper JAR hash also matches upstream. The remote recovery checkout is clean and detached at its snapshot; no app source was modified by the packaging patch.

The released source archive is `standby-pro-baseline.2-source.tar.gz`, SHA256 `51adb31a29637adb776705664b388598cc7e6cda2d66255ee2ea13ae3cb90f14`. It contains 93 regular files: all 83 manifest-pinned app files and 10 expected root metadata/docs files. A static archive scan found no competitor reference screenshots, no other JPG/JPEG capture, no links, and no credential-like matches. The archive includes the original platform app icons/launch assets as part of the pinned baseline source. These checks support the curated source packaging claim; they are not an app-binary or runtime check.

`THIRD-PARTY-NOTICES.txt` now includes the resolved Flutter/Dart package licence texts (48 packages, including build/test dependencies); no missing licence files were reported for that generation. It does not replace review of native Gradle/CocoaPods dependencies for any future binary. The baseline's MIT notice and provenance remain included. The original baseline still declares unused Android location/calendar/notifications/wake-lock permissions and iOS location/calendar purpose strings; these describe unfinished baseline features and remain a disclosure/release limitation of the archival source.

## Improved repository permissions and signing recheck — 2026-10-23

In the current improved branch, the Android main manifest now retains only `INTERNET`, and the iOS Info.plist no longer contains location/calendar purpose strings. The Android Gradle release block explicitly sets `signingConfig = null` and says to configure signing locally; this removes the prior debug-key release setting, but no production signature or signed artifact has been built or verified. Therefore the improved branch still does not establish a signed production release.

The improved README and settings UI disclose that weather requests expose the device IP and selected public-city coordinates to Open-Meteo, identify CC BY 4.0 data attribution, and state that the free endpoint is non-commercial. This is suitable only if the actual distribution remains within those service terms; monetized use still requires commercial API rights or removal of the request.

No builds, UI jobs, or tests were run for this recheck. Before distributing a binary, still verify clean-clone builds and resulting permission manifests, obtain/verify production signing, inventory exact native as well as Dart dependency licences/notices, resolve the weather service rights for the distribution model, and perform platform/device acceptance. Do not describe the baseline source tag as a production-signed release.

## Bundled font security/licence recheck — 2026-10-23

PR #7 commit `6708f28bd14dbbc1e7d8c84a395f6da3cffa3dec` adds four Roboto weights (Regular, Medium, Bold, Black), their Apache License 2.0 full text, Flutter asset/font declarations, and a `LicenseRegistry` entry. Each TTF is byte-for-byte identical to the corresponding `work/flutter/bin/cache/artifacts/material_fonts` file. Their SHA256 values are: Regular `79e851404657dac2106b3d22ad256d47824a9a5765458edb72c9102a45816d95`; Medium `f205cc511821ea56078a105557fcea6253129404d411c997e1866fbd006abb68`; Bold `7d0b991ee3e0be7af01ad7ea8cd2beea6c00a25e679a0226b6737f079aafff86`; Black `3872e9b39760a1b59ac1e192633dbb3b58e595b4d423930ac7ded525e9ae25e0`. The committed license is byte-identical to the Flutter cache's `Roboto_LICENSE.txt`; `pubspec.yaml` bundles the text and the app registers it through Flutter's license registry. The existing source & licences UI opens Flutter's license page, making the registered text discoverable. The commit changes no credentials, external endpoints, provenance metadata, or non-font artwork.

The coordinating agent reports that a clean clone at this commit passed locked dependency resolution, analysis, all 34 tests, and a web release build. This independent audit did not rerun those jobs. A network retest was still in progress at review time. These checks do not establish Android/iOS native release acceptance, production signing, or physical-device behavior; those remain open gates alongside exact native dependency notices and weather-service rights.

## Parent retest after font review

The final Chrome headless walkthrough on the newly built font-bundled source passed all app flows and recorded only the preview origin in request hosts while weather was disabled; no page errors. This covers the tested Latin UI path, not arbitrary missing-glyph fallback or native egress. Public-safe browser metrics and command summaries are in docs/evidence. Parent review retains native signing, physical device and commercial-service rights as explicit unaccepted gates.
