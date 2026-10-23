// Explicit screenshot harness. Run with --update-goldens; not a device test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:standby_pro/src/app.dart';
import 'package:standby_pro/src/domain/standby_models.dart';

void main() {
  testWidgets('capture actual app views with synthetic settings', (
    tester,
  ) async {
    final sdk = Platform.environment['STANDBY_FLUTTER_ROOT'];
    if (sdk == null) {
      throw StateError(
        'Set STANDBY_FLUTTER_ROOT to the Flutter SDK for real-font captures.',
      );
    }
    await tester.runAsync(() async {
      final fonts = FontLoader('Roboto');
      for (final name in ['Roboto-Regular.ttf', 'Roboto-Bold.ttf']) {
        fonts.addFont(
          File(
            '$sdk/bin/cache/artifacts/material_fonts/$name',
          ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
      }
      await fonts.load();
      final icons = FontLoader('MaterialIcons');
      icons.addFont(
        File(
          '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
        ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
      );
      await icons.load();
    });
    tester.view.physicalSize = const Size(1200, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const StandbyProApp(initialSettings: StandbySettings(brightness: 1)),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(StandbyProApp),
      matchesGoldenFile('../../docs/assets/display.png'),
    );
    await tester.tap(find.text('Layouts'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(StandbyProApp),
      matchesGoldenFile('../../docs/assets/layouts.png'),
    );
    await tester.tap(find.text('Timer'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(StandbyProApp),
      matchesGoldenFile('../../docs/assets/timer.png'),
    );
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(StandbyProApp),
      matchesGoldenFile('../../docs/assets/settings.png'),
    );
    expect(tester.takeException(), isNull);
  });
}
