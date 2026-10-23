import 'dart:math' as math;
import 'package:flutter/material.dart';

enum StandbyLayoutMode { duo, single }

enum ClockStyle { digital, analog, flip, text }

enum StandbyWidgetType { clock, weather, calendar, music }

const standbyWeatherCities = <String>['London', 'New York', 'Tokyo', 'Sydney'];

T _enumFromName<T extends Enum>(List<T> values, Object? name, T fallback) {
  if (name is! String) return fallback;
  for (final value in values) {
    if (value.name == name) return value;
  }
  return fallback;
}

class ThemePreset {
  const ThemePreset({
    required this.id,
    required this.name,
    required this.background,
    required this.foreground,
    required this.accent,
    required this.secondary,
    required this.glow,
    required this.weight,
  });

  final String id;
  final String name;
  final int background;
  final int foreground;
  final int accent;
  final int secondary;
  final double glow;
  final int weight;

  Color get backgroundColor => Color(background);
  Color get foregroundColor => Color(foreground);
  Color get accentColor => Color(accent);
  Color get secondaryColor => Color(secondary);
}

const standbyThemes = <ThemePreset>[
  ThemePreset(
    id: 'aurora',
    name: 'Aurora',
    background: 0xFF020207,
    foreground: 0xFFF8FAFC,
    accent: 0xFF7DD3FC,
    secondary: 0xFFA78BFA,
    glow: 0.38,
    weight: 850,
  ),
  ThemePreset(
    id: 'night-red',
    name: 'Night Red',
    background: 0xFF030000,
    foreground: 0xFFFF2424,
    accent: 0xFFFF2D2D,
    secondary: 0xFF7F1D1D,
    glow: 0.22,
    weight: 780,
  ),
  ThemePreset(
    id: 'solar',
    name: 'Solar',
    background: 0xFF070401,
    foreground: 0xFFFFF7ED,
    accent: 0xFFF59E0B,
    secondary: 0xFFEF4444,
    glow: 0.26,
    weight: 820,
  ),
  ThemePreset(
    id: 'matrix',
    name: 'Matrix',
    background: 0xFF000403,
    foreground: 0xFF7CFF8A,
    accent: 0xFF22C55E,
    secondary: 0xFF064E3B,
    glow: 0.32,
    weight: 720,
  ),
];

ThemePreset themeById(String id) {
  return standbyThemes.firstWhere(
    (theme) => theme.id == id,
    orElse: () => standbyThemes.first,
  );
}

@immutable
class StandbySettings {
  const StandbySettings({
    this.layoutMode = StandbyLayoutMode.duo,
    this.activeThemeId = 'aurora',
    this.clockStyle = ClockStyle.digital,
    this.leftWidget = StandbyWidgetType.clock,
    this.rightWidget = StandbyWidgetType.weather,
    this.showSeconds = false,
    this.nightModeEnabled = false,
    this.burnInProtection = true,
    this.keepAwakeWhileCharging = true,
    this.use24HourTime = true,
    this.brightness = 0.72,
    this.nightTintIntensity = 0.65,
    this.animationIntensity = 0.72,
    this.fontScale = 1,
    this.fontWeight = 820,
    this.glowIntensity = 0.28,
    this.weatherEnabled = false,
    this.weatherCity = 'London',
  });

  final StandbyLayoutMode layoutMode;
  final String activeThemeId;
  final ClockStyle clockStyle;
  final StandbyWidgetType leftWidget;
  final StandbyWidgetType rightWidget;
  final bool showSeconds;
  final bool nightModeEnabled;
  final bool burnInProtection;
  final bool keepAwakeWhileCharging;
  final bool use24HourTime;
  final double brightness;
  final double nightTintIntensity;
  final double animationIntensity;
  final double fontScale;
  final int fontWeight;
  final double glowIntensity;
  final bool weatherEnabled;
  final String weatherCity;

  ThemePreset get theme => themeById(activeThemeId);

  StandbySettings copyWith({
    StandbyLayoutMode? layoutMode,
    String? activeThemeId,
    ClockStyle? clockStyle,
    StandbyWidgetType? leftWidget,
    StandbyWidgetType? rightWidget,
    bool? showSeconds,
    bool? nightModeEnabled,
    bool? burnInProtection,
    bool? keepAwakeWhileCharging,
    bool? use24HourTime,
    double? brightness,
    double? nightTintIntensity,
    double? animationIntensity,
    double? fontScale,
    int? fontWeight,
    double? glowIntensity,
    bool? weatherEnabled,
    String? weatherCity,
  }) {
    return StandbySettings(
      layoutMode: layoutMode ?? this.layoutMode,
      activeThemeId: activeThemeId ?? this.activeThemeId,
      clockStyle: clockStyle ?? this.clockStyle,
      leftWidget: leftWidget ?? this.leftWidget,
      rightWidget: rightWidget ?? this.rightWidget,
      showSeconds: showSeconds ?? this.showSeconds,
      nightModeEnabled: nightModeEnabled ?? this.nightModeEnabled,
      burnInProtection: burnInProtection ?? this.burnInProtection,
      keepAwakeWhileCharging:
          keepAwakeWhileCharging ?? this.keepAwakeWhileCharging,
      use24HourTime: use24HourTime ?? this.use24HourTime,
      brightness: brightness ?? this.brightness,
      nightTintIntensity: nightTintIntensity ?? this.nightTintIntensity,
      animationIntensity: animationIntensity ?? this.animationIntensity,
      fontScale: fontScale ?? this.fontScale,
      fontWeight: fontWeight ?? this.fontWeight,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      weatherEnabled: weatherEnabled ?? this.weatherEnabled,
      weatherCity: weatherCity ?? this.weatherCity,
    );
  }

  Map<String, Object> toJson() {
    return {
      'layoutMode': layoutMode.name,
      'activeThemeId': activeThemeId,
      'clockStyle': clockStyle.name,
      'leftWidget': leftWidget.name,
      'rightWidget': rightWidget.name,
      'showSeconds': showSeconds,
      'nightModeEnabled': nightModeEnabled,
      'burnInProtection': burnInProtection,
      'keepAwakeWhileCharging': keepAwakeWhileCharging,
      'use24HourTime': use24HourTime,
      'brightness': brightness,
      'nightTintIntensity': nightTintIntensity,
      'animationIntensity': animationIntensity,
      'fontScale': fontScale,
      'fontWeight': fontWeight,
      'glowIntensity': glowIntensity,
      'weatherEnabled': weatherEnabled,
      'weatherCity': weatherCity,
    };
  }

  factory StandbySettings.fromJson(Map<String, Object?> json) {
    const defaults = StandbySettings();
    double finiteDouble(String key, double fallback, double min, double max) {
      final value = json[key];
      if (value is! num || !value.toDouble().isFinite) return fallback;
      return value.toDouble().clamp(min, max).toDouble();
    }

    bool boolValue(String key, bool fallback) =>
        json[key] is bool ? json[key] as bool : fallback;

    final requestedCity = json['weatherCity'];
    final city =
        requestedCity is String && standbyWeatherCities.contains(requestedCity)
        ? requestedCity
        : defaults.weatherCity;
    final requestedTheme = json['activeThemeId'];
    final themeId =
        requestedTheme is String &&
            standbyThemes.any((theme) => theme.id == requestedTheme)
        ? requestedTheme
        : defaults.activeThemeId;

    return StandbySettings(
      layoutMode: _enumFromName(
        StandbyLayoutMode.values,
        json['layoutMode'],
        defaults.layoutMode,
      ),
      activeThemeId: themeId,
      clockStyle: _enumFromName(
        ClockStyle.values,
        json['clockStyle'],
        defaults.clockStyle,
      ),
      leftWidget: _enumFromName(
        StandbyWidgetType.values,
        json['leftWidget'],
        defaults.leftWidget,
      ),
      rightWidget: _enumFromName(
        StandbyWidgetType.values,
        json['rightWidget'],
        defaults.rightWidget,
      ),
      showSeconds: boolValue('showSeconds', defaults.showSeconds),
      nightModeEnabled: boolValue(
        'nightModeEnabled',
        defaults.nightModeEnabled,
      ),
      burnInProtection: boolValue(
        'burnInProtection',
        defaults.burnInProtection,
      ),
      keepAwakeWhileCharging: boolValue(
        'keepAwakeWhileCharging',
        defaults.keepAwakeWhileCharging,
      ),
      use24HourTime: boolValue('use24HourTime', defaults.use24HourTime),
      brightness: finiteDouble('brightness', defaults.brightness, 0.05, 1),
      nightTintIntensity: finiteDouble(
        'nightTintIntensity',
        defaults.nightTintIntensity,
        0,
        1,
      ),
      animationIntensity: finiteDouble(
        'animationIntensity',
        defaults.animationIntensity,
        0,
        1,
      ),
      fontScale: finiteDouble('fontScale', defaults.fontScale, 0.5, 2),
      fontWeight:
          (json['fontWeight'] is num && (json['fontWeight'] as num).isFinite)
          ? (json['fontWeight'] as num).round().clamp(100, 900).toInt()
          : defaults.fontWeight,
      glowIntensity: finiteDouble(
        'glowIntensity',
        defaults.glowIntensity,
        0,
        1,
      ),
      weatherEnabled: boolValue('weatherEnabled', defaults.weatherEnabled),
      weatherCity: city,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StandbySettings &&
        other.layoutMode == layoutMode &&
        other.activeThemeId == activeThemeId &&
        other.clockStyle == clockStyle &&
        other.leftWidget == leftWidget &&
        other.rightWidget == rightWidget &&
        other.showSeconds == showSeconds &&
        other.nightModeEnabled == nightModeEnabled &&
        other.burnInProtection == burnInProtection &&
        other.keepAwakeWhileCharging == keepAwakeWhileCharging &&
        other.use24HourTime == use24HourTime &&
        _sameDouble(other.brightness, brightness) &&
        _sameDouble(other.nightTintIntensity, nightTintIntensity) &&
        _sameDouble(other.animationIntensity, animationIntensity) &&
        _sameDouble(other.fontScale, fontScale) &&
        other.fontWeight == fontWeight &&
        _sameDouble(other.glowIntensity, glowIntensity) &&
        other.weatherEnabled == weatherEnabled &&
        other.weatherCity == weatherCity;
  }

  @override
  int get hashCode => Object.hash(
    layoutMode,
    activeThemeId,
    clockStyle,
    leftWidget,
    rightWidget,
    showSeconds,
    nightModeEnabled,
    burnInProtection,
    keepAwakeWhileCharging,
    use24HourTime,
    brightness,
    nightTintIntensity,
    animationIntensity,
    fontScale,
    fontWeight,
    glowIntensity,
    weatherEnabled,
    weatherCity,
  );
}

bool _sameDouble(double a, double b) => (a - b).abs() < 0.000001;

class StandbyWidgetConfig {
  const StandbyWidgetConfig({
    required this.type,
    required this.slot,
    required this.refreshCadence,
  });

  final StandbyWidgetType type;
  final String slot;
  final Duration refreshCadence;
}

class WeatherSnapshot {
  const WeatherSnapshot({
    required this.city,
    required this.condition,
    required this.temperatureCelsius,
    this.highCelsius,
    this.lowCelsius,
    required this.updatedAt,
  });

  final String city;
  final String condition;
  final int temperatureCelsius;
  final int? highCelsius;
  final int? lowCelsius;
  final DateTime updatedAt;
}

class CalendarEventSnapshot {
  const CalendarEventSnapshot({
    required this.title,
    required this.startsAt,
    required this.endsAt,
    this.isNow = false,
  });

  final String title;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool isNow;
}

class CalendarSnapshot {
  const CalendarSnapshot({required this.events});

  final List<CalendarEventSnapshot> events;
}

class NowPlayingSnapshot {
  const NowPlayingSnapshot({
    required this.title,
    required this.artist,
    required this.source,
    required this.progress,
    required this.isPlaying,
    required this.isControllable,
  });

  final String title;
  final String artist;
  final String source;
  final double progress;
  final bool isPlaying;
  final bool isControllable;
}

class IntegrationSnapshotBundle {
  const IntegrationSnapshotBundle({
    required this.weather,
    required this.calendar,
    required this.nowPlaying,
  });

  final WeatherSnapshot weather;
  final CalendarSnapshot calendar;
  final NowPlayingSnapshot nowPlaying;

  factory IntegrationSnapshotBundle.fallback({
    required DateTime now,
    String city = 'London',
  }) {
    final seed = math.max(city.length, 1);
    return IntegrationSnapshotBundle(
      weather: WeatherSnapshot(
        city: city,
        condition: 'Mostly cloudy',
        temperatureCelsius: 16 + seed % 8,
        highCelsius: 21 + seed % 6,
        lowCelsius: 10 + seed % 5,
        updatedAt: now,
      ),
      calendar: CalendarSnapshot(
        events: [
          CalendarEventSnapshot(
            title: 'Focus block',
            startsAt: now.add(const Duration(minutes: 20)),
            endsAt: now.add(const Duration(hours: 1, minutes: 20)),
          ),
          CalendarEventSnapshot(
            title: 'Wind down',
            startsAt: DateTime(now.year, now.month, now.day, 22),
            endsAt: DateTime(now.year, now.month, now.day, 22, 30),
          ),
        ],
      ),
      nowPlaying: const NowPlayingSnapshot(
        title: 'Ambient Focus',
        artist: 'Standby Pro',
        source: 'Local fallback',
        progress: 0.42,
        isPlaying: false,
        isControllable: false,
      ),
    );
  }
}
