import 'package:flutter/material.dart';
import 'domain/standby_models.dart';
import 'features/standby/standby_screen.dart';

class StandbyProApp extends StatelessWidget {
  const StandbyProApp({super.key, this.initialSettings});
  final StandbySettings? initialSettings;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Standby Pro',
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF03060B),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7DD3FC),
        secondary: Color(0xFFA78BFA),
        surface: Color(0xFF0D1119),
        onSurface: Color(0xFFF1F5FA),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF090E16),
        indicatorColor: Color(0xFF243747),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF101720),
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: const Size(48, 52)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
    ),
    home: StandbyScreen(initialSettings: initialSettings),
  );
}
