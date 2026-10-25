# Preview 3 publication-document review — 25 October 2026

Scope: the README, changelog, CONTEXT, site index/setup guide, preview.3 release note, paused-timer browser evidence JSON, and the new paused-browser screenshot. This was a static documentation/evidence review; no tests, builds, or UI flows were run. The screenshot was visually inspected.

## Findings

- The docs consistently describe preview.3 as a source/web preview, with no production APK/IPA, phone acceptance, production signing, VoiceOver/TalkBack, or long-run display/power acceptance. They correctly distinguish the build3 private SPM simulator observation and build4 compile/restoration from the still-pending native4 workflows. The release note also explicitly keeps earlier Android/default CocoaPods compilation attached to preview.2 rather than presenting it as new validation.
- The pinned source-build commands consistently use `v1.1.0-preview.3`; that tag is not present in this local checkout yet. These changes are publication preparation and should be published atomically with the tag and matching source/web archives. Until then, commands and page links to that tag are prospective.
- `preview3-timer-browser.json` identifies app source commit `8ce8581c26e6d4ea68a38d6509eb835f8858ecfe`, which matches the pre-publication branch head tested in the supplied evidence. If the eventual tag uses a later documentation-only commit, keep the field understood as the tested app/source commit or rename it to `app_source_commit`; do not imply the entire final tagged tree was the browser-run input. The request host is loopback with an ephemeral port; no external host is listed.
- The 390×844 screenshot shows the paused timer with `Paused`, `Resume focus`, reset, and the foreground-only/no-alarm notice. It contains no browser chrome, source path, or private URL. The evidence JSON records five-minute start/wait, pause, resume, reset assertions and no page errors; it is bounded browser evidence, not native acceptance.
- No local workspace paths, credentials, or account tokens were found in the reviewed docs. The public GitHub and GitHub Pages URLs are expected. The only loopback address appears in the browser evidence JSON. No license or notice files are changed.
- One line in the changelog says “Native simulator validation is recorded separately.” Since native build4 workflows are pending, consider “Native validation remains pending and is recorded separately” to remove any ambiguity. The release note already states this boundary accurately.

No release/publication was made. No source changes were made by this review.
