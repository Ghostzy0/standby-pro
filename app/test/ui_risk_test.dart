import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standby_pro/src/app.dart';
import 'package:standby_pro/src/domain/standby_models.dart';
import 'package:standby_pro/src/features/standby/standby_screen.dart';

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
