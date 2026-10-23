import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/standby_models.dart';

class WeatherService {
  WeatherService({http.Client? client})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;

  final http.Client _client;
  final bool _ownsClient;
  bool _closed = false;

  static const _locations = <String, (String, String)>{
    'London': ('51.5072', '-0.1276'),
    'New York': ('40.7128', '-74.0060'),
    'Tokyo': ('35.6762', '139.6503'),
    'Sydney': ('-33.8688', '151.2093'),
  };
  static const _weatherCodes = <int>{
    0,
    1,
    2,
    3,
    45,
    48,
    51,
    53,
    55,
    56,
    57,
    61,
    63,
    65,
    66,
    67,
    71,
    73,
    75,
    77,
    80,
    81,
    82,
    85,
    86,
    95,
    96,
    99,
  };

  Future<WeatherSnapshot> fetchWeather(String city) async {
    if (_closed) throw StateError('WeatherService is closed.');
    final coordinates = _locations[city];
    if (coordinates == null) throw ArgumentError.value(city, 'city');
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': coordinates.$1,
      'longitude': coordinates.$2,
      'current': 'temperature_2m,weather_code',
      'daily': 'temperature_2m_max,temperature_2m_min',
      'timezone': 'auto',
      'forecast_days': '1',
    });

    final response = await _client.get(uri).timeout(const Duration(seconds: 6));
    if (response.statusCode != 200) {
      throw StateError('Weather request failed: ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Weather response must be an object.');
    }
    final current = decoded['current'];
    if (current is! Map<String, dynamic>) {
      throw const FormatException(
        'Weather response has no current conditions.',
      );
    }
    final temperature = _number(current['temperature_2m']);
    final weatherCode = _wholeNumber(current['weather_code']);
    final currentTime = current['time'];
    final providerLocalTime = currentTime is String
        ? _parseProviderLocalTime(currentTime)
        : null;
    final offsetSeconds = _integer(decoded['utc_offset_seconds']);
    if (temperature == null ||
        temperature < -100 ||
        temperature > 70 ||
        weatherCode == null ||
        !_weatherCodes.contains(weatherCode) ||
        providerLocalTime == null ||
        offsetSeconds == null ||
        offsetSeconds < -43200 ||
        offsetSeconds > 50400) {
      throw const FormatException('Weather response has invalid current data.');
    }

    final daily = decoded['daily'];
    final (high, low) = daily is Map<String, dynamic>
        ? _dailyExtremes(daily, providerLocalTime)
        : (null, null);
    return WeatherSnapshot(
      city: city,
      condition: _conditionForCode(weatherCode),
      temperatureCelsius: temperature.round(),
      highCelsius: high,
      lowCelsius: low,
      updatedAt: providerLocalTime.subtract(Duration(seconds: offsetSeconds)),
    );
  }

  Future<WeatherSnapshot> fetchLondonWeather() => fetchWeather('London');

  (int?, int?) _dailyExtremes(
    Map<String, dynamic> daily,
    DateTime currentTime,
  ) {
    final dates = daily['time'];
    final highs = daily['temperature_2m_max'];
    final lows = daily['temperature_2m_min'];
    if (dates is! List || highs is! List || lows is! List || dates.isEmpty) {
      return (null, null);
    }
    final date =
        '${currentTime.year.toString().padLeft(4, '0')}-'
        '${currentTime.month.toString().padLeft(2, '0')}-'
        '${currentTime.day.toString().padLeft(2, '0')}';
    final index = dates.indexOf(date);
    if (index < 0 || index >= highs.length || index >= lows.length) {
      return (null, null);
    }
    final rawHigh = _number(highs[index]);
    final rawLow = _number(lows[index]);
    final high = rawHigh != null && rawHigh >= -100 && rawHigh <= 70
        ? rawHigh
        : null;
    final low = rawLow != null && rawLow >= -100 && rawLow <= 70
        ? rawLow
        : null;
    if (high != null && low != null && high < low) return (null, null);
    return (high?.round(), low?.round());
  }

  DateTime? _parseProviderLocalTime(String value) {
    final match = RegExp(
      r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?$',
    ).firstMatch(value);
    if (match == null) return null;
    final parts = [for (var i = 1; i <= 6; i++) int.tryParse(match[i] ?? '0')];
    if (parts.any((part) => part == null)) return null;
    final time = DateTime.utc(
      parts[0]!,
      parts[1]!,
      parts[2]!,
      parts[3]!,
      parts[4]!,
      parts[5]!,
    );
    if (time.year != parts[0] ||
        time.month != parts[1] ||
        time.day != parts[2] ||
        time.hour != parts[3] ||
        time.minute != parts[4] ||
        time.second != parts[5]) {
      return null;
    }
    return time;
  }

  double? _number(Object? value) {
    if (value is! num || !value.toDouble().isFinite) return null;
    return value.toDouble();
  }

  int? _wholeNumber(Object? value) {
    final integer = _integer(value);
    return integer != null && integer >= 0 && integer <= 99 ? integer : null;
  }

  int? _integer(Object? value) {
    final number = _number(value);
    if (number == null || number != number.round()) return null;
    return number.toInt();
  }

  String _conditionForCode(int code) {
    if (code == 0) return 'Clear';
    if (code <= 3) return 'Partly cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 67 || (code >= 80 && code <= 82)) return 'Rain';
    if ((code >= 71 && code <= 77) || (code >= 85 && code <= 86)) {
      return 'Snow';
    }
    if (code >= 95) return 'Thunderstorms';
    return 'Unsettled';
  }

  void close() {
    if (_closed) return;
    _closed = true;
    if (_ownsClient) _client.close();
  }
}
