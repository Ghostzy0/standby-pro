# Preview3 source/web acceptance — 25 October2026

The parent acceptance passes the published source/web-preview scope. It does not accept physical-phone, production-signing, native assistive-technology or long-run power/display behavior. The historical baseline and earlier release tags/assets remain unchanged.

Preview3/app1.1.0+4 source isf7d72ab4bb1df766723ac1094daece49cb46f087; its compiled web source is8ce8581c26e6d4ea68a38d6509eb835f8858ecfe, with identical app/CI inputs. PR13 fixes paused timer feedback and expands the existing injected-time regression. CI40170456120 passed44 tests, analysis and web compilation. PR14 publishes the reviewed preview.

All8 published assets were downloaded afresh and matched uploads/SHA256SUMS. Source178 files match the tagged Git content and executable modes; web37 files match the compiled artifact. The source tar metadata was normalized before publication. See [recovery receipt](preview3-remote-recovery.json).

Pages commitf029309ad1b5afbca102c7ac6122a7b360b3752d built successfully. Live HTTPS Chrome headless at390×844 observed five-minute start/countdown, Paused/Resume focus, resumed Focus in progress and reset toReady/Start focus. No page errors or external request host appeared on the tested weather-off path; see [targeted browser receipt](preview3-live-timer-browser.json). Site root BUILD-INFO.json identifies preview3/f7d72ab/app1.1.0+4; landing, guide, demo and bundled MIT routes returned200, and the MIT bytes exactly match LICENSE.

[Experimental simulator evidence](simulator-workflows-2026-10-25.md) separately records actual restored build4 pause/resume/reset, Quiet exit, city persistence, About and licence-list observations and its incomplete final Back/large-text paths. The default CocoaPods/Android hosted native compile evidence belongs to preview2/1a21922, not preview3. No public native binary is distributed; the private experimental simulator app has only an ad-hoc signature without developer/store identity.

The owner confirmed no physical phone is available. Issue4 remains the device/signing/accessibility/power gate. No additional paid or remote-device route was used. Temporary browser/server and owned simulator processes were closed. Selected private evidence recovery and targeted local cleanup are documented in the local handoff; raw session-bearing logs remain local and excluded from public release assets.
