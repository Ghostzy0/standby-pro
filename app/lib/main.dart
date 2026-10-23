import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Roboto',
    ], await rootBundle.loadString('assets/fonts/LICENSE.txt'));
  });
  runApp(const StandbyProApp());
}
