import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standby_pro/src/data/settings_repository.dart';
import 'package:standby_pro/src/domain/standby_models.dart';
import 'package:standby_pro/src/services/weather_service.dart';
import 'package:standby_pro/src/state/standby_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'controller serializes settings through the injected repository',
    () async {
      final preferences = await SharedPreferences.getInstance();
      final repository = _TrackingRepository(preferences);
      final controller = StandbyController(
        settingsRepository: repository,
        autostartTicker: false,
      );

      await Future.wait([
        controller.updateSettings(
          const StandbySettings(activeThemeId: 'solar'),
        ),
        controller.updateSettings(
          const StandbySettings(activeThemeId: 'matrix'),
        ),
      ]);

      expect(repository.saved.map((settings) => settings.activeThemeId), [
        'solar',
        'matrix',
      ]);
      expect(controller.settings.activeThemeId, 'matrix');
      expect(controller.persistenceError, isNull);
      controller.dispose();
    },
  );

  test(
    'persistence failure is exposed without reverting the current setting',
    () async {
      final preferences = await SharedPreferences.getInstance();
      final controller = StandbyController(
        settingsRepository: _FailingRepository(preferences),
        autostartTicker: false,
      );

      await controller.updateSettings(
        const StandbySettings(activeThemeId: 'solar'),
      );

      expect(controller.settings.activeThemeId, 'solar');
      expect(controller.persistenceError, contains('Could not save settings'));
      controller.dispose();
    },
  );

  test(
    'newer city response wins when weather requests complete out of order',
    () async {
      final weather = _PendingWeatherService();
      final controller = StandbyController(
        initialSettings: const StandbySettings(
          weatherEnabled: true,
          weatherCity: 'London',
        ),
        weatherService: weather,
        autostartTicker: false,
      );

      final firstRequest = controller.refreshWeather();
      expect(controller.weatherLoading, isTrue);
      expect(weather.pending, hasLength(1));

      await controller.updateSettings(
        controller.settings.copyWith(weatherCity: 'Sydney'),
      );
      expect(weather.pending, hasLength(2));

      weather.pending[1].complete(_snapshot('Sydney', 24));
      await Future<void>.delayed(Duration.zero);
      expect(controller.snapshots.weather.city, 'Sydney');
      expect(controller.weatherIsLive, isTrue);

      weather.pending[0].complete(_snapshot('London', 12));
      await firstRequest;
      await Future<void>.delayed(Duration.zero);
      expect(controller.snapshots.weather.city, 'Sydney');
      expect(controller.snapshots.weather.temperatureCelsius, 24);
      controller.dispose();
    },
  );

  test('disabled weather never starts a network request', () async {
    final weather = _PendingWeatherService();
    final controller = StandbyController(
      weatherService: weather,
      autostartTicker: false,
    );

    await controller.refreshWeather();

    expect(weather.pending, isEmpty);
    expect(controller.weatherLoading, isFalse);
    controller.dispose();
  });

  test(
    'turning weather off invalidates a pending request immediately',
    () async {
      final weather = _PendingWeatherService();
      final controller = StandbyController(
        initialSettings: const StandbySettings(weatherEnabled: true),
        weatherService: weather,
        autostartTicker: false,
      );
      final request = controller.refreshWeather();

      final update = controller.updateSettings(
        controller.settings.copyWith(weatherEnabled: false),
      );
      expect(controller.weatherLoading, isFalse);
      weather.pending.single.complete(_snapshot('London', 20));
      await Future.wait([request, update]);

      expect(controller.weatherIsLive, isFalse);
      expect(controller.snapshots.weather.city, 'London');
      controller.dispose();
    },
  );

  test('disposed controller ignores pending weather completion', () async {
    final weather = _PendingWeatherService();
    final controller = StandbyController(
      initialSettings: const StandbySettings(weatherEnabled: true),
      weatherService: weather,
      autostartTicker: false,
    );
    var notifications = 0;
    controller.addListener(() => notifications++);
    final request = controller.refreshWeather();
    final countAtDispose = notifications;

    controller.dispose();
    weather.pending.single.complete(_snapshot('London', 20));
    await request;

    expect(weather.wasClosed, isFalse);
    expect(notifications, countAtDispose);
  });
}

WeatherSnapshot _snapshot(String city, int temperature) => WeatherSnapshot(
  city: city,
  condition: 'Clear',
  temperatureCelsius: temperature,
  updatedAt: DateTime(2026, 10, 23, 12),
);

class _TrackingRepository extends SettingsRepository {
  _TrackingRepository(super.preferences);

  final saved = <StandbySettings>[];

  @override
  Future<void> save(StandbySettings settings) async {
    saved.add(settings);
  }
}

class _FailingRepository extends SettingsRepository {
  _FailingRepository(super.preferences);

  @override
  Future<void> save(StandbySettings settings) async {
    throw StateError('storage unavailable');
  }
}

class _PendingWeatherService extends WeatherService {
  final pending = <Completer<WeatherSnapshot>>[];
  bool wasClosed = false;

  @override
  Future<WeatherSnapshot> fetchWeather(String city) {
    final completer = Completer<WeatherSnapshot>();
    pending.add(completer);
    return completer.future;
  }

  @override
  void close() {
    wasClosed = true;
    super.close();
  }
}
