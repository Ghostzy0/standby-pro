import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/app.dart';

void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Standby Pro',
    ], await rootBundle.loadString('assets/licenses/standby-pro-MIT.txt'));
    yield LicenseEntryWithLineBreaks([
      'Roboto',
    ], await rootBundle.loadString('assets/fonts/LICENSE.txt'));
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  registerAppLicenses();
  runApp(const StandbyProApp());
}
