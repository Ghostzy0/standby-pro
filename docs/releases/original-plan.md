# Implementation Plan: Standby Pro

## Phase 1: Rebuild Foundation
- [x] Replace the broken Capacitor app with a clean Flutter project.
- [x] Generate Android and iOS targets.
- [x] Set Android package id to `com.ytchannel.standbypro`.
- [x] Add native Android system bridge for keep-awake, brightness, and media commands.

## Phase 2: Core StandBy Experience
- [x] Build Single Focus and Duo layouts.
- [x] Add digital, analog, flip, and text clock faces.
- [x] Add weather, calendar, and music widget panels with fallback data.
- [x] Add customization controls for layout, widgets, clock face, size, glow, dimming, seconds, night mode, burn-in protection, and keep-awake.

## Phase 3: Performance & Bedside Safety
- [x] Add adaptive clock cadence to avoid wasteful 60/120Hz idle updates.
- [x] Add app lifecycle pause behavior for background state.
- [x] Add night mode policy and OLED burn-in pixel shifting.
- [x] Avoid continuous blur/glow animation loops; reserve motion for interactions.

## Phase 4: Verification
- [x] Add domain and widget tests.
- [x] Run `flutter test`.
- [x] Run `flutter analyze`.
- [x] Build Android debug APK.
- [ ] Test on a physical Android phone.
- [ ] Build/sign on iOS using macOS and Xcode.

## Phase 5: Next Features
- [ ] Add runtime permission flows for calendar, location, and notifications.
- [ ] Replace fallback calendar data with real device calendar events.
- [ ] Add user-selectable city/location weather.
- [ ] Expand Android now-playing metadata support beyond transport controls.
- [ ] Add photo frame mode and timer/stopwatch widgets.
