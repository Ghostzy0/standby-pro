# UI/UX source review

Reviewed 2026-10-23 against `app/lib/src/app.dart`, `features/standby/standby_screen.dart`, `features/standby/widgets/integration_cards.dart`, `features/timer/focus_timer_screen.dart`, the current tests, and four Flutter widget-runtime captures at `docs/assets/{display,layouts,timer,settings}.png` (1200×700, synthetic settings, SDK Roboto and Material Icons). This is a source and rendered-widget review. It does not establish physical-device, screen-reader, or release acceptance.

## Rendered review and resolution

The four captures share a restrained black/navy palette, cyan accent, readable card contrast, consistent rounded surfaces, and clear navigation. The clock is the visual anchor on Display; the disabled-weather explanation is legible in the second panel. Layout presets are scannable and describe their outcomes in plain language. The timer gives its duration, state, controls, and foreground-only limitation a clear hierarchy. Settings has a useful title/subtitle and well-labeled controls. No blocking visual issue is evident at this captured size.

Layout and Settings are long scrolling pages under a fixed bottom navigation bar. In the 1200×700 captures, the next Layout card and the lower edge of the visible Settings list continue below the viewport, so a user has to scroll for remaining choices. The content is in scrollable lists with bottom padding; the partial next card provides a visual cue. Small-screen and maximum-text use should still be checked for reachable controls and navigation overlap.

The initial 2× text-scale/320×568 test had reported a 24-pixel bottom `RenderFlex` overflow. The log did not identify the overflowing widget. The leading suspect is the `_Display` vertical layout (its `Column` and compact portrait card stack) under the short Scaffold viewport: the correction makes the Display content scroll and scales its minimum height above 1.4× text. No navigation-bar height change was needed, so the earlier navigation-bar guess is unsupported. The exact RenderFlex remains unconfirmed without a widget-tree trace. The 2× test now reports no layout exception, and the supplied full run reports all 34 tests passed with analysis clean (`../work/improvement-checks-8.log`). The risk assertion remains active. The accommodation trades a fully visible bedside dashboard for vertical scrolling at larger text sizes; test that compromise on actual compact devices.

## Findings

- The app now has a coherent four-destination structure: Display, Layouts, Timer, Settings. Quiet display has an explicit “Show controls” affordance, and the About page explains major platform and integration limits. This is clearer than the previous customization-sheet assumptions in `standby_widget_test.dart`.
- Device calendar access and audio metadata are not implemented, and their panels now say so. Keep those labels visible wherever the cards are offered; they are key expectation-setting for people choosing layouts.
- Weather is off by default, city selection is explicit, and the card provides refresh, timestamp, error/loading states, provider attribution, and a no-GPS statement. Verify that the chosen city and returned snapshot remain in sync after rapid changes or failed refreshes; controller tests cover response races, while widget tests should retain the visible states.
- The display wraps the clock in a semantic time label that now includes seconds when `showSeconds` is enabled. The custom pixel shift now checks Android's reduced-animation setting and iOS Reduce Motion and removes the offset when motion reduction is requested. These are source-level accommodations; confirm them with VoiceOver, TalkBack, and actual OS accessibility settings.
- Pixel shifting advances only when the controller observes a minute change, even when the clock face refreshes each second. Reduced-motion settings suppress the display offset. This avoids visible second-by-second drift in the source; a device run is still needed to judge the shift cadence and whether pixel shifting helps on actual OLED panels.
- Settings use standard labeled controls and the app theme sets minimum sizes for buttons. Dense pages and the four-item bottom navigation still need small-screen and large-text runtime checks. A widget test can catch many Flutter layout exceptions, but cannot establish legibility or usability at distance.
- Timer behavior is explicitly foreground-only with no sound, notification, or background promise. Lifecycle callbacks stop ticker scheduling while backgrounded and update remaining time on resume. Exercise interruption/resume and completion timing on a device before making reliability claims.
- `StandbyProApp` has no `builder` or accessibility overrides, which keeps Flutter's normal platform text scaling and semantics behavior in place. The important acceptance check is how the long Settings screen scrolls and how controls fit at large text sizes.

## Requested automated coverage added

`app/test/standby_widget_test.dart` now covers the current screen rather than the retired Customize sheet: display/weather-off state, a layout preset, Settings, About/data disclosures, quiet-mode restoration, sample calendar and audio labels, all four face widgets and a semantic time label, plus timer start/pause/reset behavior.

`app/test/ui_risk_test.dart` exercises Display → Layouts → Timer → Settings → About at 320×568 and 844×390 logical pixels, checks a 320×568 Settings page at 2× text scale, and checks the seconds-bearing clock semantics node. These tests assert that Flutter does not report layout/runtime exceptions while each view is built.

The earlier overflow is recorded above as resolved in the current supplied automated run. The current suite exercises Display → Layouts → Timer → Settings → About at 320×568 and 844×390 logical pixels, Settings at 320×568 with 2× text scale, all four clock faces, clock semantics with seconds, and timer start/pause/reset. A widget-test pass does not verify physical dimensions, visual distance readability, actual system font scaling, or assistive-technology behavior.

## Manual verification targets

1. On a small Android phone, test 320×568-like portrait and short landscape, default and maximum system text, TalkBack navigation order, touch target reachability, and keyboard/switch access where available. Confirm the scrollable Display still supports an at-a-glance bedside use.
2. On an iPhone with VoiceOver and Reduce Motion enabled, confirm time/seconds announcements, custom clock face layout, settings navigation, and no disorienting motion. This does not certify Apple system StandBy integration or an iOS widget extension.
3. On real Android hardware, test foreground keep-screen-on, app switching, screen lock, unplugging, battery saver, and vendor battery restrictions. The setting requests screen-on for the visible Activity only.
4. Test the timer after backgrounding/foregrounding, rotating if supported, pausing/resuming, and reaching completion. Verify the documented foreground-only behavior and that no alert is expected.
5. Inspect visual contrast and distance legibility at each night tint/brightness theme, then run a long-duration OLED panel check before claiming burn-in safety; pixel shift is only a mitigation.
