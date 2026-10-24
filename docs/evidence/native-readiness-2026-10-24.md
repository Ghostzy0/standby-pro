# Native build readiness

The initial read-only assessment on 24 October 2026 found Flutter3.41.9/Dart3.11.5, Xcode27.1 and installed simulator runtimes locally. CocoaPods and a complete Android SDK were absent; JDK17 was available when explicitly selected. The app's only iOS native plugin includes a Swift Package manifest. During an Android CLI help probe, the executable unexpectedly bootstrapped/downloaded its command-line CLI; no SDK components or app packages were installed and no terms were explicitly accepted. A detailed host-only inventory is retained locally.

Subsequently, both unchanged native projects [compiled on hosted runners](native-hosted-builds-2026-10-24.md). No native source packaging fix was needed. The default iOS CocoaPods route compiled with Xcode16.4; this does not establish compatibility with every newer Xcode image.

A separate local experiment used Flutter3.41.9's opt-in Swift Package Manager integration in an isolated checkout. It removed the Podfile and optional Pods xcconfig includes, generated SPM project integration, selected simulator arm64 only to avoid a multi-architecture verifier failure, and overrode the deployment minimum from13 to15 for Xcode27.1. That configuration produced an arm64 simulator debug app with ad-hoc signing and no developer/store identity. These experimental configuration changes were not copied into the active project; the artifact does not represent an unchanged universal/iOS13 build.

Issue4 remains open for physical-device behavior, accessibility, signing/update continuity and long-run power/display checks. A debug or simulator artifact cannot replace those gates.
