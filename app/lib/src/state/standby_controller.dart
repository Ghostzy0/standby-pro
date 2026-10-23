import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/clock_cadence.dart';
import '../data/settings_repository.dart';
import '../domain/standby_models.dart';
import '../services/standby_system_service.dart';
import '../services/weather_service.dart';

class StandbyController extends ChangeNotifier with WidgetsBindingObserver {
  StandbyController({
    StandbySettings? initialSettings,
    IntegrationSnapshotBundle? snapshots,
    SettingsRepository? settingsRepository,
    StandbySystemService? systemService,
    WeatherService? weatherService,
    bool autostartTicker = true,
  }) : settings = initialSettings ?? const StandbySettings(),
       snapshots =
           snapshots ?? IntegrationSnapshotBundle.fallback(now: DateTime.now()),
       _settingsRepository = settingsRepository,
       _systemService = systemService ?? StandbySystemService(),
       _weatherService = weatherService ?? WeatherService(),
       _ownsWeatherService = weatherService == null,
       _autostartTicker = autostartTicker,
       now = DateTime.now();

  StandbySettings settings;
  IntegrationSnapshotBundle snapshots;
  DateTime now;
  bool appVisible = true;
  int burnInTick = 0;
  bool weatherIsLive = false;
  bool weatherLoading = false;
  String? weatherError;
  String? persistenceError;
  String? systemError;

  final SettingsRepository? _settingsRepository;
  final StandbySystemService _systemService;
  final WeatherService _weatherService;
  final bool _ownsWeatherService;
  final bool _autostartTicker;
  late final Future<SettingsRepository> _repositoryFuture =
      _settingsRepository != null
      ? Future.value(_settingsRepository)
      : SharedPreferences.getInstance().then(SettingsRepository.new);

  Timer? _timer;
  Future<void> _settingsWriteTail = Future<void>.value();
  Future<void>? _initializing;
  int _settingsRevision = 0;
  int _weatherRequestRevision = 0;
  bool _observingLifecycle = false;
  bool _disposed = false;

  Future<void> initialize() => _initializing ??= _initialize();

  Future<void> _initialize() async {
    if (_disposed) return;
    if (!_observingLifecycle) {
      WidgetsBinding.instance.addObserver(this);
      _observingLifecycle = true;
    }
    final revisionAtLoad = _settingsRevision;
    try {
      final repository = await _repositoryFuture;
      final loaded = await repository.load();
      if (_disposed) return;
      if (_settingsRevision == revisionAtLoad) settings = loaded;
    } catch (error) {
      if (!_disposed) persistenceError = 'Could not load settings: $error';
    }
    if (_disposed) return;
    await _applySystemSettings();
    if (settings.weatherEnabled) unawaited(refreshWeather());
    if (_autostartTicker) _scheduleNextTick();
    _notifyListeners();
  }

  void initializeForTest() {
    if (_autostartTicker) _scheduleNextTick();
  }

  Future<void> refreshWeather() async {
    if (_disposed || !settings.weatherEnabled) return;
    final requestRevision = ++_weatherRequestRevision;
    final requestedCity = settings.weatherCity;
    weatherLoading = true;
    weatherError = null;
    _notifyListeners();
    try {
      final weather = await _weatherService.fetchWeather(requestedCity);
      if (!_isCurrentWeatherRequest(requestRevision, requestedCity)) return;
      snapshots = IntegrationSnapshotBundle(
        weather: weather,
        calendar: snapshots.calendar,
        nowPlaying: snapshots.nowPlaying,
      );
      weatherIsLive = true;
      weatherLoading = false;
      weatherError = null;
      _notifyListeners();
    } catch (error) {
      if (!_isCurrentWeatherRequest(requestRevision, requestedCity)) return;
      weatherIsLive = false;
      weatherLoading = false;
      weatherError = 'Weather could not be refreshed: $error';
      _notifyListeners();
    }
  }

  bool _isCurrentWeatherRequest(int revision, String city) =>
      !_disposed &&
      revision == _weatherRequestRevision &&
      settings.weatherEnabled &&
      settings.weatherCity == city;

  Future<void> updateSettings(StandbySettings value) async {
    if (_disposed) return;
    final previous = settings;
    settings = value;
    _settingsRevision++;
    now = DateTime.now();
    _scheduleNextTick();
    if (!value.weatherEnabled) {
      if (previous.weatherEnabled || weatherLoading) {
        _weatherRequestRevision++;
        weatherLoading = false;
        weatherIsLive = false;
        weatherError = null;
      }
    } else if (!previous.weatherEnabled ||
        previous.weatherCity != value.weatherCity) {
      unawaited(refreshWeather());
    }
    _notifyListeners();

    final write = _settingsWriteTail.then((_) async {
      try {
        final repository = await _repositoryFuture;
        await repository.save(value);
        if (!_disposed) persistenceError = null;
      } catch (error) {
        if (!_disposed) persistenceError = 'Could not save settings: $error';
      }
      _notifyListeners();
    });
    _settingsWriteTail = write;
    await write;

    if (_disposed) return;
    await _applySystemSettings();
    _notifyListeners();
  }

  void toggleLayout() {
    final next = settings.layoutMode == StandbyLayoutMode.duo
        ? StandbyLayoutMode.single
        : StandbyLayoutMode.duo;
    unawaited(updateSettings(settings.copyWith(layoutMode: next)));
  }

  void cycleTheme() {
    final index = standbyThemes.indexWhere(
      (theme) => theme.id == settings.activeThemeId,
    );
    final next = standbyThemes[(index + 1) % standbyThemes.length];
    unawaited(updateSettings(settings.copyWith(activeThemeId: next.id)));
  }

  void cycleClockStyle() {
    final styles = ClockStyle.values;
    final next = styles[(settings.clockStyle.index + 1) % styles.length];
    unawaited(updateSettings(settings.copyWith(clockStyle: next)));
  }

  Future<bool> sendMediaCommand(String command) =>
      _systemService.mediaCommand(command);

  Future<void> _applySystemSettings() async {
    try {
      await SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      final awakeApplied = await _systemService.setKeepAwake(
        settings.keepAwakeWhileCharging,
      );
      final brightnessApplied = await _systemService.setBrightness(
        settings.brightness,
      );
      systemError = awakeApplied && brightnessApplied
          ? null
          : 'One or more display controls are unavailable on this platform.';
    } on PlatformException catch (error) {
      systemError = 'Display controls could not be applied: ${error.message}';
    } catch (error) {
      systemError = 'Display controls could not be applied: $error';
    }
  }

  void _scheduleNextTick() {
    _timer?.cancel();
    _timer = null;
    if (_disposed || !appVisible || !_autostartTicker) return;
    _timer = Timer(ClockCadence.nextDelay(now, settings), () {
      if (_disposed || !appVisible) return;
      final previousMinute = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );
      now = DateTime.now();
      final currentMinute = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );
      if (currentMinute != previousMinute) burnInTick++;
      _notifyListeners();
      _scheduleNextTick();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    appVisible = state == AppLifecycleState.resumed;
    if (appVisible) now = DateTime.now();
    _scheduleNextTick();
    _notifyListeners();
  }

  void _notifyListeners() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    if (_observingLifecycle) WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _weatherRequestRevision++;
    if (_ownsWeatherService) _weatherService.close();
    super.dispose();
  }
}
