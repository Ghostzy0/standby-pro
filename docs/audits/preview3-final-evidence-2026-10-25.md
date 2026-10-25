# Preview3 final evidence review — 25 October 2026

Scope: read-only review of the current Standby Pro diff, `docs/evidence/preview3-final-acceptance-2026-10-25.md`, `work/preview3-publication-verified-2026-10-25.json`, and `work/simulator-slice2-review-2026-10-25.md`, with the linked simulator workflow record. No tests, builds, UI, source edits, or publication actions were performed.

## Assessment

The public preview3 claims are appropriately bounded overall. Preview3 is consistently described as a source/web preview; the live timer evidence is scoped to a clean headless Chrome session at 390×844 with weather off; the recovered release receipt records all eight assets and matching 178-file source/37-file web archives. I confirmed the app subtree has no diff between source commit `8ce8581c26e6d4ea68a38d6509eb835f8858ecfe` used for preview3 CI/browser evidence and publication source `f7d72ab4bb1df766723ac1094daece49cb46f087`; thus the “identical app/CI inputs” statement is consistent with the checked Git tree, even though publication adds later documentation.

The native boundary is also explicit in the main acceptance page: historical default CocoaPods/Android hosted compilation belongs to preview2 at `1a21922`, while preview3’s build4 runtime observations use an experimental SPM, arm64-only, iOS-15-minimum simulator build. Slice2 is reported as partial: pause/resume/reset, Quiet exit, Tokyo preference persistence after relaunch, About and opening the Licenses list were observed; the full Standby MIT entry/back path, final Back, large-text/landscape, accessibility, physical phone, signing and power tests remain open. App/simulator teardown and absence are reported separately. No physical-device or production-signing acceptance is implied.

The platform worker’s public-safety review of the three new build4 screenshots is consistent with the prose. The evidence does not suggest account/calendar data or credentials; simulator provenance and non-phone limitations are stated. Raw simulator/session records are kept private. No public source/web release artifact or historical tag is represented as a signed native binary.

## Corrections recommended before treating this as a final receipt

1. `work/preview3-publication-verified-2026-10-25.json` still has `native_boundary: "Build4 experimental simulator workflow check pending; ..."`. That is stale: build4 simulator workflow evidence was collected and reviewed in slice2. Change it to state that partial build4 simulator workflows were observed/reviewed while full native acceptance remains open.
2. `CONTEXT.md` says “Native validation is still pending” immediately after listing actual restored build4 simulator observations. Clarify this as “Full native acceptance remains incomplete” and name the remaining unaccepted paths. The rest of CONTEXT already lists Back/large-text/license-detail limits and is consistent.
3. The acceptance page says “No signed native binary is distributed.” This is understandable in context but risks implying no signature of any kind when the local simulator app has an ad-hoc linker signature. Prefer “No native binary is distributed; the experimental simulator app had only an ad-hoc signature with no developer/store identity.” This preserves the distinction from production signing.

The chronological first-slice section in `simulator-workflows-2026-10-25.md` says its next remaining-only test “must verify” timer feedback and several paths, followed later by the completed partial build4 slice. Because the report clearly labels these as first and restored build4 slices, this reads as history rather than an acceptance contradiction; no correction is required there.

## Evidence limit

This was a static document/source-diff review. The parent receipts and platform review are treated as supplied evidence; I did not rerun any remote downloads, tests, browser session, build, or simulator workflow. The report recommends only wording corrections, not new validation.

## Parent resolution

The publication JSON now records partial observed build4 workflows and remaining acceptance gates. CONTEXT already contains the completed partial-slice observations and now consistently labels remaining full acceptance. Public wording explicitly says no public native binary, and describes the private experimental ad-hoc signature without developer/store identity. These are documentation corrections; unchanged app inputs do not require another test/build run.
