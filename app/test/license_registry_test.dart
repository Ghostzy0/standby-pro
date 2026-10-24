import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:standby_pro/main.dart' as app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('registers the Standby Pro MIT and Roboto licenses', () async {
    app.registerAppLicenses();

    final entries = await LicenseRegistry.licenses.toList();
    final appLicense = entries.singleWhere(
      (entry) => entry.packages.contains('Standby Pro'),
    );
    final appText = appLicense.paragraphs
        .map((paragraph) => paragraph.text)
        .join('\n');

    expect(appText, contains('MIT License'));
    expect(appText, contains('Copyright (c) 2026 TheFadGhost'));
    expect(appText, contains('Permission is hereby granted, free of charge'));
    expect(appText, contains('THE SOFTWARE IS PROVIDED "AS IS"'));

    expect(entries.any((entry) => entry.packages.contains('Roboto')), isTrue);
    expect(
      await rootBundle.loadString('assets/licenses/standby-pro-MIT.txt'),
      contains('Copyright (c) 2026 TheFadGhost'),
    );
  });
}
