# Packaged simulator workflows — 25 October 2026

This is partial runtime evidence for an isolated Swift Package Manager experiment: app1.1.0/build3, arm64 simulator only, minimum iOS15 override, ad-hoc linker signature without developer/store identity or sealed-resource verification. It differs from the unchanged CocoaPods CI project. App inputs match release1a21922f5d49790257c01e2106104f4acdd155f3. The private QA archive SHA256 is545f1ab1c448e70524ed96bba5534c795e388d53d14ca2eeec9e685561373966; all62 files and executable modes were downloaded/restored and matched before installation.

## Observed first slice

On an owned fresh iPhone17/iOS27.0 simulator (402×874 logical points), the restored package installed. The first Mobile launch reported success but subsequent observation showed SpringBoard. No crash report was returned; direct relaunch displayed Standby normally. Cause of that initial foreground change is unconfirmed. It is not established as an application crash.

The actual UI showed weather off, a labelled local clock and reachable Timer navigation. Five-minute selection/start displayed05:00; a later pause showed04:54; reset restored05:00. Termination/relaunch returned Display with the default25-minute timer. Quiet entry by a coordinate tap hid header/navigation and exposed an exit control. A prior reference tap did not establish that transition; automation dump/reference ambiguity remains separate from app behavior.

The timer pause screenshot and accessibility output exposed a concrete copy defect:04:54 retained while status said Ready when you are and action said Start focus. Source build4 fixes this to Paused/Resume focus, with an expanded injected-clock regression and independent review. The fixed artifact has not yet completed native validation.

Settings persistence was not established: the toggle result was not observed before immediate termination. Quiet exit, About/licences, large text/landscape and assistive-technology behavior were not completed. The next remaining-only test must verify those paths and the changed timer feedback; passing mechanics above does not close them.

## Evidence and teardown

[Actual simulator Display capture](../assets/simulator-display-2026-10-25.png). The own timer capture is held locally as a before-fix diagnostic rather than promoted as a finished interface. Tool/state/console logs remain private; raw environment/session details are excluded from public documentation.

The300second guardian ended its180second post-boot interaction window before the next call. It recorded expiry, not a full-flow pass. App terminate, simulator shutdown and delete each returned0; subsequent inventory confirmed that device absent. UI/heavy leases were released. No owner permission prompt appeared and no personal device/account was accessed.

Physical-phone, production signing/update, VoiceOver/TalkBack and long-run power/display acceptance remain open in issue4. Source/widget/browser checks and this experimental simulator slice do not establish those gates.
