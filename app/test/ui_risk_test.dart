import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standby_pro/src/app.dart';
import 'package:standby_pro/src/core/burn_in_protection.dart';
import 'package:standby_pro/src/domain/standby_models.dart';
import 'package:standby_pro/src/features/standby/standby_screen.dart';
import 'package:standby_pro/src/features/standby/widgets/clock_faces.dart';
import 'package:standby_pro/src/state/standby_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final size in const [Size(320, 568), Size(844, 390)]) {
    testWidgets('navigation and content fit ${size.width}x${size.height}', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const StandbyProApp(initialSettings: StandbySettings()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Layouts'));
      await tester.pumpAndSettle();
      expect(find.text('Make room for rest.'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Timer'));
      await tester.pumpAndSettle();
      expect(find.text('One thing at a time.'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      expect(find.text('A display that fits you.'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byTooltip('About and data status'));
      await tester.pumpAndSettle();
      expect(find.text('About Standby Pro'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('settings remains usable at 2x system text scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: const StandbyScreen(initialSettings: StandbySettings()),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    expect(find.text('A display that fits you.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final settingsScroll = _selectedScrollView(
      tester,
      find.text('A display that fits you.'),
    );
    await tester.scrollUntilVisible(
      find.text('Clock face'),
      200,
      scrollable: settingsScroll,
    );
    await tester.pumpAndSettle();
    expect(find.text('Clock face'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Keep screen on while open'),
      250,
      scrollable: settingsScroll,
    );
    await tester.pumpAndSettle();
    expect(find.text('Keep screen on while open'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('clock exposes a concise accessible time label', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        const StandbyProApp(
          initialSettings: StandbySettings(
            layoutMode: StandbyLayoutMode.single,
            leftWidget: StandbyWidgetType.clock,
            showSeconds: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(RegExp(r'^Current time \d{2}:\d{2}:\d{2}$')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('quiet controls can be entered and exited with the keyboard', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        const StandbyProApp(initialSettings: StandbySettings()),
      );
      await tester.pumpAndSettle();

      await _tabUntilFocused(tester, find.byTooltip('Quiet display'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Show controls'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      await _tabUntilFocused(tester, find.byTooltip('Show controls'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);

      await _tabUntilFocused(tester, find.text('Layouts'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Make room for rest.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('clock semantics follow 12/24-hour and seconds settings', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final cases = [
        (true, false, 'Current time 00:07'),
        (true, true, 'Current time 00:07:08'),
        (false, false, 'Current time 12:07 AM'),
        (false, true, 'Current time 12:07:08 AM'),
      ];
      for (final (use24HourTime, showSeconds, expected) in cases) {
        final controller = StandbyController(
          initialSettings: StandbySettings(
            layoutMode: StandbyLayoutMode.single,
            leftWidget: StandbyWidgetType.clock,
            use24HourTime: use24HourTime,
            showSeconds: showSeconds,
          ),
          autostartTicker: false,
        )..now = DateTime(2026, 10, 24, 0, 7, 8);
        await tester.pumpWidget(
          MaterialApp(home: StandbyScreen(controller: controller)),
        );
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel(expected), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        controller.dispose();
      }
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('reduced motion suppresses burn-in pixel offset', (tester) async {
    final controller = StandbyController(
      initialSettings: const StandbySettings(
        layoutMode: StandbyLayoutMode.single,
        leftWidget: StandbyWidgetType.clock,
        burnInProtection: true,
      ),
      autostartTicker: false,
    )..burnInTick = 1;
    try {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: false),
            child: child!,
          ),
          home: StandbyScreen(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      final expected = BurnInProtection.offsetForTick(1, controller.settings);
      expect(_displayTranslation(tester), Offset(expected.dx, expected.dy));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: StandbyScreen(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      expect(_displayTranslation(tester), Offset.zero);
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    }
  });

  testWidgets('2x text in short landscape can reach settings controls', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(844, 390);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: const StandbyScreen(initialSettings: StandbySettings()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    expect(find.text('A display that fits you.'), findsOneWidget);
    final settingsScroll = _selectedScrollView(
      tester,
      find.text('A display that fits you.'),
    );
    await tester.scrollUntilVisible(
      find.text('Keep screen on while open'),
      120,
      scrollable: settingsScroll,
    );
    await tester.pumpAndSettle();
    expect(find.text('Keep screen on while open'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Restore default display settings'),
      120,
      scrollable: settingsScroll,
    );
    await tester.pumpAndSettle();
    expect(find.text('Restore default display settings'), findsOneWidget);
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

Future<void> _tabUntilFocused(WidgetTester tester, Finder target) async {
  for (var i = 0; i < 40; i++) {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    if (tester.getSemantics(target).getSemanticsData().hasFlag(
      SemanticsFlag.isFocused,
    )) {
      return;
    }
  }
  fail('Could not reach $target with Tab');
}

Offset _displayTranslation(WidgetTester tester) {
  final clockFace = find.byType(DigitalClockFace);
  final transform = tester.widget<Transform>(
    find.ancestor(of: clockFace, matching: find.byType(Transform)).first,
  );
  final translation = transform.transform.getTranslation();
  return Offset(translation.x, translation.y);
}
