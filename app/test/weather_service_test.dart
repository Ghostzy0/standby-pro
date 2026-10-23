import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:standby_pro/src/services/weather_service.dart';

void main() {
  test(
    'parses current and real daily temperatures for a supported city',
    () async {
      Uri? requestedUri;
      final client = MockClient((request) async {
        requestedUri = request.url;
        return http.Response('''
        {
          "utc_offset_seconds": 0,
          "current": {
            "temperature_2m": 18.6,
            "weather_code": 2,
            "time": "2026-10-23T13:00"
          },
          "daily": {
            "time": ["2026-10-23"],
            "temperature_2m_max": [21.2],
            "temperature_2m_min": [12.4]
          }
        }
      ''', 200);
      });
      final service = WeatherService(client: client);

      final result = await service.fetchWeather('Tokyo');

      expect(requestedUri!.queryParameters['latitude'], '35.6762');
      expect(requestedUri!.queryParameters['longitude'], '139.6503');
      expect(
        requestedUri!.queryParameters['daily'],
        contains('temperature_2m_max'),
      );
      expect(result.city, 'Tokyo');
      expect(result.temperatureCelsius, 19);
      expect(result.highCelsius, 21);
      expect(result.lowCelsius, 12);
      expect(result.updatedAt, DateTime.utc(2026, 10, 23, 13));
      service.close();
    },
  );

  test('omits malformed daily extremes instead of inventing values', () async {
    final service = WeatherService(
      client: MockClient(
        (_) async => http.Response('''
        {
          "utc_offset_seconds": 0,
          "current": {
            "temperature_2m": 18,
            "weather_code": 0,
            "time": "2026-10-23T13:00"
          },
          "daily": {
            "time": ["2026-10-23"],
            "temperature_2m_max": [null],
            "temperature_2m_min": [12]
          }
        }
      ''', 200),
      ),
    );

    final result = await service.fetchWeather('London');

    expect(result.highCelsius, isNull);
    expect(result.lowCelsius, 12);
    service.close();
  });

  test('rejects missing or invalid current weather fields', () async {
    final service = WeatherService(
      client: MockClient(
        (_) async => http.Response('''
        {"utc_offset_seconds":0,"current":{"temperature_2m":999,"weather_code":101,"time":"bad"}}
      ''', 200),
      ),
    );

    await expectLater(service.fetchWeather('London'), throwsFormatException);
    service.close();
  });

  test('rejects unsupported cities before making a request', () async {
    var requestCount = 0;
    final service = WeatherService(
      client: MockClient((_) async {
        requestCount++;
        return http.Response('{}', 200);
      }),
    );

    await expectLater(service.fetchWeather('Paris'), throwsArgumentError);
    expect(requestCount, 0);
    service.close();
  });

  test(
    'converts remote-city local time with its provider UTC offset',
    () async {
      final service = WeatherService(
        client: MockClient(
          (_) async => http.Response('''
        {
          "utc_offset_seconds": -14400,
          "current": {
            "temperature_2m": 18,
            "weather_code": 0,
            "time": "2026-10-23T23:00"
          },
          "daily": {
            "time": ["2026-10-23", "2026-10-24"],
            "temperature_2m_max": [22, 30],
            "temperature_2m_min": [11, 20]
          }
        }
      ''', 200),
        ),
      );

      final result = await service.fetchWeather('New York');

      expect(result.updatedAt, DateTime.utc(2026, 10, 24, 3));
      expect(result.highCelsius, 22);
      expect(result.lowCelsius, 11);
      service.close();
    },
  );

  test('rejects missing and malformed UTC offsets', () async {
    for (final offset in [null, 'not-a-number']) {
      final service = WeatherService(
        client: MockClient(
          (_) async => http.Response('''
          {
            ${offset == null ? '' : '"utc_offset_seconds":"$offset",'}
            "current": {
              "temperature_2m": 18,
              "weather_code": 0,
              "time": "2026-10-23T13:00"
            }
          }
        ''', 200),
        ),
      );

      await expectLater(
        service.fetchWeather('New York'),
        throwsFormatException,
      );
      service.close();
    }
  });
}
