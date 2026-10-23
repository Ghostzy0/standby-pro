import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standby_pro/src/core/burn_in_protection.dart';
import 'package:standby_pro/src/core/clock_cadence.dart';
import 'package:standby_pro/src/core/night_mode_policy.dart';
import 'package:standby_pro/src/data/settings_repository.dart';
import 'package:standby_pro/src/domain/standby_models.dart';

void main() {
  test('settings serialize all user-facing customization choices', () {
    const settings = StandbySettings(
      layoutMode: StandbyLayoutMode.single,
      activeThemeId: 'night-red',
      clockStyle: ClockStyle.flip,
      leftWidget: StandbyWidgetType.music,
      rightWidget: StandbyWidgetType.calendar,
      showSeconds: true,
      nightModeEnabled: true,
      burnInProtection: false,
      keepAwakeWhileCharging: false,
      brightness: 0.42,
      nightTintIntensity: 0.74,
      animationIntensity: 0.33,
      fontScale: 1.18,
      fontWeight: 820,
      glowIntensity: 0.61,
      weatherEnabled: true,
      weatherCity: 'Tokyo',
    );

    final roundTrip = StandbySettings.fromJson(settings.toJson());

    expect(roundTrip, settings);
    expect(
      roundTrip.copyWith(layoutMode: StandbyLayoutMode.duo).layoutMode,
      StandbyLayoutMode.duo,
    );
  });

  test('settings repository persists and restores settings', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = SettingsRepository(
      await SharedPreferences.getInstance(),
    );
    const expected = StandbySettings(
      activeThemeId: 'solar',
      clockStyle: ClockStyle.analog,
      brightness: 0.36,
    );

    await repository.save(expected);

    expect(await repository.load(), expected);
  });

  test('settings repository recovers from corrupted stored JSON', () async {
    SharedPreferences.setMockInitialValues({'standby_settings_v1': '{broken'});
    final repository = SettingsRepository(
      await SharedPreferences.getInstance(),
    );

    expect(await repository.load(), const StandbySettings());
  });

  test('settings loading clamps invalid values and defaults unknown city', () {
    final settings = StandbySettings.fromJson({
      'brightness': 4,
      'fontScale': -1,
      'fontWeight': 4000,
      'weatherEnabled': 'yes',
      'weatherCity': 'Somewhere',
      'activeThemeId': 'untrusted-theme',
    });

    expect(settings.brightness, 1);
    expect(settings.fontScale, 0.5);
    expect(settings.fontWeight, 900);
    expect(settings.weatherEnabled, isFalse);
    expect(settings.weatherCity, 'London');
    expect(settings.activeThemeId, 'aurora');
  });

  test(
    'clock cadence slows down when seconds are hidden or app is backgrounded',
    () {
      const hiddenSeconds = StandbySettings(showSeconds: false);
      const visibleSeconds = StandbySettings(showSeconds: true);
      final now = DateTime(2026, 5, 3, 18, 42, 17, 500);

      expect(
        ClockCadence.nextDelay(now, hiddenSeconds),
        const Duration(seconds: 43),
      );
      expect(
        ClockCadence.nextDelay(now, visibleSeconds),
        const Duration(milliseconds: 500),
      );
      expect(
        ClockCadence.nextDelay(now, visibleSeconds, appVisible: false),
        const Duration(minutes: 5),
      );
    },
  );

  test('burn-in protection produces bounded, repeatable OLED-safe offsets', () {
    const disabled = StandbySettings(burnInProtection: false);
    const enabled = StandbySettings(burnInProtection: true);

    expect(BurnInProtection.offsetForTick(8, disabled), OffsetSnapshot.zero);

    final first = BurnInProtection.offsetForTick(8, enabled);
    final same = BurnInProtection.offsetForTick(8, enabled);
    final next = BurnInProtection.offsetForTick(9, enabled);

    expect(first, same);
    expect(first, isNot(next));
    expect(first.dx.abs(), lessThanOrEqualTo(10));
    expect(first.dy.abs(), lessThanOrEqualTo(10));
  });

  test(
    'integration fallback snapshots are useful without phone permissions',
    () {
      final bundle = IntegrationSnapshotBundle.fallback(
        now: DateTime(2026, 5, 3, 18, 42),
        city: 'London',
      );

      expect(bundle.weather.city, 'London');
      expect(bundle.weather.temperatureCelsius, isNonNegative);
      expect(bundle.calendar.events, isNotEmpty);
      expect(bundle.nowPlaying.title, isNotEmpty);
      expect(bundle.nowPlaying.isControllable, isFalse);
    },
  );

  test('night mode can auto-tint only during bedside hours', () {
    const enabled = StandbySettings(nightModeEnabled: true);
    const disabled = StandbySettings(nightModeEnabled: false);

    expect(
      NightModePolicy.shouldTint(DateTime(2026, 5, 3, 21), enabled),
      isTrue,
    );
    expect(
      NightModePolicy.shouldTint(DateTime(2026, 5, 3, 4), enabled),
      isTrue,
    );
    expect(
      NightModePolicy.shouldTint(DateTime(2026, 5, 3, 12), enabled),
      isFalse,
    );
    expect(
      NightModePolicy.shouldTint(DateTime(2026, 5, 3, 22), disabled),
      isFalse,
    );
  });

  test('theme presets expose distinct visual identities', () {
    final ids = standbyThemes.map((theme) => theme.id).toSet();

    expect(ids, containsAll(['aurora', 'night-red', 'solar', 'matrix']));
    expect(themeById('missing').id, 'aurora');
    expect(
      standbyThemes.map((theme) => theme.accent).toSet().length,
      standbyThemes.length,
    );
  });
}
