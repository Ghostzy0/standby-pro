# Packaged simulator workflows — 25 October 2026

This is partial runtime evidence for an isolated Swift Package Manager experiment: app1.1.0/build3, arm64 simulator only, minimum iOS15 override, ad-hoc linker signature without developer/store identity or sealed-resource verification. It differs from the unchanged CocoaPods CI project. App inputs match release1a21922f5d49790257c01e2106104f4acdd155f3. The private QA archive SHA256 is545f1ab1c448e70524ed96bba5534c795e388d53d14ca2eeec9e685561373966; all62 files and executable modes were downloaded/restored and matched before installation.

## Observed first slice

On an owned fresh iPhone17/iOS27.0 simulator (402×874 logical points), the restored package installed. The first Mobile launch reported success but subsequent observation showed SpringBoard. No crash report was returned; direct relaunch displayed Standby normally. Cause of that initial foreground change is unconfirmed. It is not established as an application crash.

The actual UI showed weather off, a labelled local clock and reachable Timer navigation. Five-minute selection/start displayed05:00; a later pause showed04:54; reset restored05:00. Termination/relaunch returned Display with the default25-minute timer. Quiet entry by a coordinate tap hid header/navigation and exposed an exit control. A prior reference tap did not establish that transition; automation dump/reference ambiguity remains separate from app behavior.

The timer pause screenshot and accessibility output exposed a concrete copy defect:04:54 retained while status said Ready when you are and action said Start focus. Source build4 fixes this to Paused/Resume focus, with an expanded injected-clock regression and independent review. The changed feedback was subsequently observed in the restored build4 slice below.

Settings persistence was not established: the toggle result was not observed before immediate termination. Quiet exit, About/licences, large text/landscape and assistive-technology behavior were not completed. The next remaining-only test must verify those paths and the changed timer feedback; passing mechanics above does not close them.

## Evidence and teardown

[Actual simulator Display capture](../assets/simulator-display-2026-10-25.png). The own timer capture is held locally as a before-fix diagnostic rather than promoted as a finished interface. Tool/state/console logs remain private; raw environment/session details are excluded from public documentation.

The300second guardian ended its180second post-boot interaction window before the next call. It recorded expiry, not a full-flow pass. App terminate, simulator shutdown and delete each returned0; subsequent inventory confirmed that device absent. UI/heavy leases were released. No owner permission prompt appeared and no personal device/account was accessed.

Physical-phone, production signing/update, VoiceOver/TalkBack and long-run power/display acceptance remain open in issue4. Source/widget/browser checks and this experimental simulator slice do not establish those gates.

## Restored build4 slice

The separately compiled app1.1.0/build4 uses runtime app inputs9ba9adab5eeaa1b8144334e6099df13267c8c3b1, the same modified SPM/arm64/minimum-iOS15 configuration, and private archive SHA256e10ae8a608ed77739529b9f628e4c31d21524c46e12dcd31dc8241277978cd3b. All62 files and executable modes matched a fresh private download/restore before installation. The owned iPhone17/iOS27.0 slice ran07:57:34–08:00:55UTC.

After warming the mobile automation agent on Home, install/launch displayed the app directly. Five-minute countdown paused at04:57 with **Paused** and **Resume focus**. A separate coordinate start/pause/resume sequence showed04:59, Paused/Resume focus, then Focus in progress/Pause timer; reset returned05:00/Ready. One reference tap unexpectedly reset rather than resuming; the explicit coordinate sequence established the transition independently. The automation dump includes offstage routes and changing reference positions, so that tap alone does not establish an app defect.

Quiet entry hid app chrome; the exit control restored navigation and allowed Settings to open. With weather requests still off, the selected city changed from London to Tokyo. After app termination and relaunch, Settings still showed Tokyo. This verifies that preference only; seconds/24-hour toggles were not completed. About opened and scrolled, and Open-source licences opened the actual Licenses list. The full native Standby Pro MIT entry was not opened; exact bundled MIT text is separately verified in the live web preview.

[Paused timer](../assets/simulator-paused-build4-2026-10-25.png) · [Quiet display](../assets/simulator-quiet-build4-2026-10-25.png) · [Licences list](../assets/simulator-licenses-build4-2026-10-25.png). These are actual restored experimental simulator captures, not phone screenshots.

The guardian expired before the final Back call and before a structured interaction receipt was written; this remains a partial workflow slice, reviewed from individual tool outputs and original captures afterward. App terminate, simulator shutdown and delete each returned0; inventory verified the device absent and matching UI/heavy leases were released. No owner permission prompt appeared. Final Back, large text/landscape, native assistive technology, physical phone, production signing and long-run power/display gates remain unaccepted. No additional simulator slice is queued.
