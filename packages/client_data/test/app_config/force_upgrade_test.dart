import 'package:client_data/client_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform/platform.dart';

void main() {
  group('ForceUpgrade', () {
    test('supports value equality', () {
      expect(
        const ForceUpgrade(isUpgradeRequired: false),
        const ForceUpgrade(isUpgradeRequired: false),
      );
      expect(
        const ForceUpgrade(isUpgradeRequired: true),
        const ForceUpgrade(isUpgradeRequired: true),
      );
      expect(
        const ForceUpgrade(isUpgradeRequired: true),
        isNot(const ForceUpgrade(isUpgradeRequired: false)),
      );
    });

    test('builds from AppConfig', () {
      ForceUpgrade.fromAppConfig(
        const AppConfig(
          androidUpgradeUrl: 'android',
          minAndroidBuildNumber: 11,
        ),

        appDetails: AppDetails.fake(
          os: Platform.android,
          buildNumber: 10,
        ),
      );
    });
  });
}
