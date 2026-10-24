# Preview 2 publication receipt review — 24 October 2026

Reviewed the prepared final acceptance note, recovery/live receipts, preview.2 artifact audit and release notes, plus the current project context and published-facing guide/index/privacy copy. This was read-only; no tests, builds, or UI actions were run.

## Findings

No substantive publication-scope or evidence-boundary defect found.

- The acceptance note identifies the exact release tag/source SHA and app version. Its source-CI statement points to the notice-fix source run, while the final Android/iOS runs are separately scoped to the release SHA. A local Git comparison confirms the release merge from `2b03046` to `1a21922` changes no `app/` or `.github/` inputs, supporting that distinction.
- The recovery receipt says eight assets, all manifest hashes and uploaded bytes match; its archive counts match the independent 162-file source / 37-file web checks. It does not broaden this to native binaries.
- The live HTTP receipt covers the landing page, guide, privacy page, demo, build metadata and MIT asset. Its metadata and MIT hashes agree with the release evidence. The browser receipt limits its claim to Chrome headless, weather-off license-route verification, no page errors, and the preview host only.
- Native sections distinguish hosted compilation from install/runtime acceptance. The debug APK checksum is explicitly not a download or recovery mechanism, no native binary is claimed as published, and physical phone, signing/update, TalkBack/VoiceOver, power/display and simulator-runtime gates remain open. The SPM experiment is separately identified as modified, arm64-only and minimum iOS 15, with ad-hoc signing and no developer/store identity.
- The pending simulator-runtime sentence is accurate and appropriately limits current acceptance to compilation; it should remain pending until the bounded runtime check has actually produced evidence.
- The current guide/index are aligned with preview.2: they point to the new tag, say no APK/IPA is attached, direct users to the SHA256 manifest, and preserve platform limitations. The privacy copy continues to disclose optional weather's IP/city-coordinate transfer and noncommercial service constraint. No local host paths, private capture locations, or credentials appeared in the reviewed public-facing receipts/copy.

The one publication hygiene step is operational rather than a defect: if the pending simulator-runtime result changes the accepted evidence, append a dated update with its exact scope and source; do not silently rewrite compile-only claims as runtime acceptance.
