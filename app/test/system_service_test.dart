import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:standby_pro/src/services/standby_system_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('standby_pro/system_contract_test');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('forwards system methods with their public payloads', () async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return true;
        });
    final service = StandbySystemService(channel: channel);

    expect(await service.setKeepAwake(true), isTrue);
    expect(await service.setBrightness(0.42), isTrue);
    expect(await service.mediaCommand('play'), isTrue);

    expect(calls.map((call) => call.method), [
      'setKeepAwake',
      'setBrightness',
      'mediaCommand',
    ]);
    expect(calls[0].arguments, {'enabled': true});
    expect(calls[1].arguments, {'value': 0.42});
    expect(calls[2].arguments, {'command': 'play'});
  });

  test('clamps brightness to the platform contract range', () async {
    final brightnessValues = <double>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          brightnessValues.add(
            (call.arguments as Map<Object?, Object?>)['value']! as double,
          );
          return true;
        });
    final service = StandbySystemService(channel: channel);

    await service.setBrightness(-2);
    await service.setBrightness(3);

    expect(brightnessValues, [0.05, 1.0]);
  });

  test('returns false when a platform method is unimplemented', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
          throw MissingPluginException('native handler unavailable');
        });
    final service = StandbySystemService(channel: channel);

    expect(await service.setKeepAwake(true), isFalse);
  });

  test('returns false when the platform method reports an error', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
          throw PlatformException(
            code: 'system_control_failed',
            message: 'not available',
          );
        });
    final service = StandbySystemService(channel: channel);

    expect(await service.setKeepAwake(false), isFalse);
  });

  test('treats a null platform response as unavailable', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => null);
    final service = StandbySystemService(channel: channel);

    expect(await service.mediaCommand('pause'), isFalse);
  });
}
