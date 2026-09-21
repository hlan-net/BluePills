import 'dart:convert';

import 'package:bluepills/models/app_config.dart';
import 'package:bluepills/services/config_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AppConfig', () {
    test('defaults notificationsEnabled to true', () {
      const config = AppConfig();

      expect(config.notificationsEnabled, isTrue);
    });

    test('copyWith overrides notificationsEnabled', () {
      const config = AppConfig();

      final updated = config.copyWith(notificationsEnabled: false);

      expect(updated.notificationsEnabled, isFalse);
      expect(config.notificationsEnabled, isTrue);
    });

    test('copyWith keeps notificationsEnabled when not provided', () {
      const config = AppConfig(notificationsEnabled: false);

      final updated = config.copyWith(languageCode: 'fi');

      expect(updated.notificationsEnabled, isFalse);
      expect(updated.languageCode, 'fi');
    });

    test('round-trips notificationsEnabled through JSON', () {
      const config = AppConfig(notificationsEnabled: false);

      final restored = AppConfig.fromJson(config.toJson());

      expect(restored.notificationsEnabled, isFalse);
    });

    test('fromJson defaults notificationsEnabled to true when absent', () {
      final restored = AppConfig.fromJson(const <String, dynamic>{});

      expect(restored.notificationsEnabled, isTrue);
    });
  });

  group('ConfigService', () {
    test('updateNotificationsEnabled updates and persists the value', () async {
      final service = ConfigService();
      await service.init();
      expect(service.config.notificationsEnabled, isTrue);

      await service.updateNotificationsEnabled(false);

      expect(service.config.notificationsEnabled, isFalse);

      final prefs = await SharedPreferences.getInstance();
      final storedJson = prefs.getString('app_config');
      expect(storedJson, isNotNull);
      final storedConfig = AppConfig.fromJson(
        jsonDecode(storedJson!) as Map<String, dynamic>,
      );
      expect(storedConfig.notificationsEnabled, isFalse);
    });
  });
}
