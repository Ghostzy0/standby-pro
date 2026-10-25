import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standby_pro/src/app.dart';
import 'package:standby_pro/src/domain/standby_models.dart';
import 'package:standby_pro/src/features/standby/widgets/clock_faces.dart';
import 'package:standby_pro/src/features/timer/focus_timer_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('display shows current controls and honest weather-off state', (
    tester,
  ) async {
    await tester.pumpWidget(
      const StandbyProApp(
        initialSettings: StandbySettings(
          layoutMode: StandbyLayoutMode.duo,
          activeThemeId: 'aurora',
          leftWidget: StandbyWidgetType.clock,
          rightWidget: StandbyWidgetType.weather,
          clockStyle: ClockStyle.digital,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Standby Pro'), findsOneWidget);
    expect(find.byType(DigitalClockFace), findsOneWidget);
    expect(find.text('Weather'), findsOneWidget);
    expect(find.textContaining('Weather is off'), findsOneWidget);
    expect(find.byTooltip('Quiet display'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('layout presets apply and return to the display', (tester) async {
    await tester.pumpWidget(
      const StandbyProApp(initialSettings: StandbySettings()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Layouts'));
    await tester.pumpAndSettle();
    expect(find.text('Make room for rest.'), findsOneWidget);
    await tester.tap(find.text('Time & weather'));
    await tester.pumpAndSettle();

    expect(find.text('Your bedside, at a glance'), findsOneWidget);
    expect(find.text('Weather'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings flow exposes clock, layout, comfort and data status', (
    tester,
  ) async {
    await tester.pumpWidget(
      const StandbyProApp(initialSettings: StandbySettings()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    expect(find.text('A display that fits you.'), findsOneWidget);
    final settingsScroll = _selectedScrollView(
      tester,
      find.text('A display that fits you.'),
    );
    await _scrollTo(tester, find.text('Clock face'), settingsScroll);
    expect(find.text('Clock face'), findsOneWidget);
    await _scrollTo(tester, find.text('Night tint'), settingsScroll);
    expect(find.text('Night tint'), findsOneWidget);
    await _scrollTo(
      tester,
      find.text('Keep screen on while open'),
      settingsScroll,
    );
    expect(find.text('Keep screen on while open'), findsOneWidget);
    await _scrollTo(
      tester,
      find.text('Enable weather requests'),
      settingsScroll,
    );
    expect(find.text('Enable weather requests'), findsOneWidget);
    await _scrollTo(
      tester,
      find.textContaining(
        'Calendar and audio cards are clearly marked samples',
      ),
      settingsScroll,
    );
    expect(
      find.textContaining(
        'Calendar and audio cards are clearly marked samples',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings clock-face choice updates the display', (tester) async {
    await tester.pumpWidget(
      const StandbyProApp(initialSettings: StandbySettings()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    final settingsScroll = _selectedScrollView(
      tester,
      find.text('A display that fits you.'),
    );
    await _scrollTo(tester, find.text('Clock face'), settingsScroll);
    await tester.tap(find.text('Digital'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Text').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.nightlight_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(TextClockFace), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('about flow states data and platform limits', (tester) async {
    await tester.pumpWidget(
      const StandbyProApp(initialSettings: StandbySettings()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('About and data status'));
    await tester.pumpAndSettle();

    expect(find.text('About Standby Pro'), findsOneWidget);
    expect(
      find.textContaining('does not replace Apple’s system StandBy'),
      findsOneWidget,
    );
    final aboutScroll = _selectedScrollView(
      tester,
      find.text('A quieter place for time.'),
    );
    await _scrollTo(
      tester,
      find.textContaining('Calendar: labelled sample events only.'),
      aboutScroll,
    );
    expect(
      find.textContaining('Calendar: labelled sample events only.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Weather: optional Open-Meteo requests'),
      findsOneWidget,
    );
    await _scrollTo(tester, find.text('Open-source licences'), aboutScroll);
    expect(find.text('Open-source licences'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quiet display hides chrome and restores its controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      const StandbyProApp(initialSettings: StandbySettings()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Quiet display'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Standby Pro'), findsNothing);
    expect(find.byTooltip('Show controls'), findsOneWidget);

    await tester.tap(find.byTooltip('Show controls'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Standby Pro'), findsOneWidget);
    expect(find.byTooltip('Quiet display'), findsOneWidget);
  });

  testWidgets('sample calendar and unavailable audio are labelled as such', (
    tester,
  ) async {
    await tester.pumpWidget(
      const StandbyProApp(
        key: ValueKey('calendar-sample'),
        initialSettings: StandbySettings(
          layoutMode: StandbyLayoutMode.single,
          leftWidget: StandbyWidgetType.calendar,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sample calendar'), findsOneWidget);
    expect(
      find.textContaining('Examples only. Device calendar is not connected'),
      findsOneWidget,
    );

    await tester.pumpWidget(
      const StandbyProApp(
        key: ValueKey('audio-sample'),
        initialSettings: StandbySettings(
          layoutMode: StandbyLayoutMode.single,
          leftWidget: StandbyWidgetType.music,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Audio status'), findsOneWidget);
    expect(
      find.textContaining('Media metadata is not connected'),
      findsOneWidget,
    );
    expect(find.text('No playback is started by Standby Pro.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('all four clock faces render and expose a time semantic', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      for (final style in ClockStyle.values) {
        await tester.pumpWidget(
          StandbyProApp(
            key: ValueKey('clock-${style.name}'),
            initialSettings: StandbySettings(
              layoutMode: StandbyLayoutMode.single,
              clockStyle: style,
              leftWidget: StandbyWidgetType.clock,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.bySemanticsLabel(RegExp(r'^Current time \d{2}:\d{2}$')),
          findsOneWidget,
        );
        switch (style) {
          case ClockStyle.digital:
            expect(find.byType(DigitalClockFace), findsOneWidget);
          case ClockStyle.analog:
            expect(find.byType(AnalogClockFace), findsOneWidget);
          case ClockStyle.flip:
            expect(find.byType(FlipClockFace), findsOneWidget);
          case ClockStyle.text:
            expect(find.byType(TextClockFace), findsOneWidget);
        }
        expect(tester.takeException(), isNull);
      }
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('timer can start, pause without advancing, and reset', (
    tester,
  ) async {
    var timerNow = DateTime(2026, 10, 23, 12);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FocusTimerScreen(timeSource: () => timerNow)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('25:00'), findsOneWidget);
    final timerScroll = _selectedScrollView(
      tester,
      find.text('One thing at a time.'),
    );
    await _scrollTo(tester, find.text('Start focus'), timerScroll);
    await tester.tap(find.text('Start focus'));
    timerNow = timerNow.add(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.text('Pause timer'));
    await tester.pump();
    final paused = tester
        .widget<Text>(
          find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data ?? ''),
          ),
        )
        .data!;
    expect(paused, isNot('25:00'));
    expect(find.text('Paused'), findsOneWidget);
    expect(find.text('Resume focus'), findsOneWidget);
    expect(find.text('Ready when you are'), findsNothing);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text(paused), findsOneWidget);
    expect(find.text('Paused'), findsOneWidget);
    await tester.tap(find.text('Resume focus'));
    timerNow = timerNow.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Pause timer'));
    await tester.pump();
    final resumedAndPaused = tester
        .widget<Text>(
          find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                RegExp(r'^\d{2}:\d{2}$').hasMatch(widget.data ?? ''),
          ),
        )
        .data!;
    expect(resumedAndPaused, isNot(paused));
    expect(find.text('Paused'), findsOneWidget);

    await _scrollTo(tester, find.text('Reset timer'), timerScroll);
    await tester.tap(find.text('Reset timer'));
    await tester.pumpAndSettle();
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('Ready when you are'), findsOneWidget);

    await _scrollTo(tester, find.text('5 min'), timerScroll);
    await tester.tap(find.text('5 min'));
    await tester.pumpAndSettle();
    expect(find.text('05:00'), findsOneWidget);
    expect(find.text('Ready when you are'), findsOneWidget);
    await _scrollTo(tester, find.text('Start focus'), timerScroll);
    await tester.tap(find.text('Start focus'));
    timerNow = timerNow.add(const Duration(minutes: 6));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Session complete. Take a breath.'), findsOneWidget);
    expect(find.text('Start focus'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Finder _selectedScrollView(WidgetTester tester, Finder visibleAnchor) {
  final element = find
      .ancestor(of: visibleAnchor, matching: find.byType(Scrollable))
      .first
      .evaluate()
      .first;
  return find.byElementPredicate(
    (candidate) => identical(candidate, element),
    skipOffstage: false,
  );
}

Future<void> _scrollTo(
  WidgetTester tester,
  Finder target,
  Finder scrollable,
) async {
  await tester.scrollUntilVisible(target, 200, scrollable: scrollable);
  await tester.pumpAndSettle();
}
