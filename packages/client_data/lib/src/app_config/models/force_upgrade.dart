import 'package:client_data/client_data.dart';
import 'package:equatable/equatable.dart';

/// {@template force_upgrade}
/// Model used to encapsulate configuration information
/// regarding force upgrade.
///
/// Includes a `bool` [isUpgradeRequired] which determines if
/// the current application requires a force upgrade as well as
/// an [upgradeUrl] to link to the latest version of the application.
/// {@endtemplate}
class ForceUpgrade extends Equatable {
  /// {@macro force_upgrade}
  const ForceUpgrade({required this.isUpgradeRequired, this.upgradeUrl});

  factory ForceUpgrade.yes(String upgradeUrl) =>
      ForceUpgrade(isUpgradeRequired: true, upgradeUrl: upgradeUrl);
  factory ForceUpgrade.no() => const ForceUpgrade(isUpgradeRequired: false);

  factory ForceUpgrade.fromAppConfig(
    AppConfig config, {
    required AppDetails appDetails,
  }) {
    // TODO(craiglabenz): Ensure this is tested.
    int minBuildNumber;
    String upgradeUrl;
    if (appDetails.isAndroid) {
      minBuildNumber = config.minAndroidBuildNumber;
      upgradeUrl = config.androidUpgradeUrl;
    } else if (appDetails.isIos) {
      minBuildNumber = config.minIosBuildNumber;
      upgradeUrl = config.iosUpgradeUrl;
    } else {
      throw Exception(
        'Could not determine platform for $appDetails in '
        'ForceUpgrade.fromAppConfig',
      );
    }
    return ForceUpgrade(
      isUpgradeRequired: appDetails.buildNumber < minBuildNumber,
      upgradeUrl: upgradeUrl,
    );
  }

  /// Whether an upgrade is required.
  final bool isUpgradeRequired;

  /// The url where users can upgrade the application.
  final String? upgradeUrl;

  @override
  List<Object?> get props => [isUpgradeRequired, upgradeUrl];
}
