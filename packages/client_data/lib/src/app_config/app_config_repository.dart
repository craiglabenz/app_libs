import 'dart:async';
import 'package:client_data/client_data.dart';
import 'package:meta/meta.dart';

/// {@template AppConfigRepository}
/// Repository which manages determining whether the application
/// is in maintenance mode or needs to be force upgraded.
///
/// [AppConfigRepository] listens to a stream of Maps from its supplied
/// [BaseAppConfigService] and converts each yielded entry into updates for
/// the app.
/// {@endtemplate}
class AppConfigRepository {
  /// {@macro AppConfigInterface}
  AppConfigRepository({
    required BaseAppConfigService service,
    required AppDetails details,
  }) : _appDetails = details,
       _service = service,
       _maintenanceController = StreamController<bool>(),
       _upgradeController = StreamController<ForceUpgrade>() {
    _service.appConfig().listen(_onAppConfig);
  }

  final BaseAppConfigService _service;
  final AppDetails _appDetails;

  bool? _lastDownForMaintenance;
  ForceUpgrade? _lastForceUpgrade;

  /// Pass-thru stream from underlying `_service.appConfig()`
  final StreamController<bool> _maintenanceController;

  /// Pass-thru stream from underlying `_service.appConfig()`
  final StreamController<ForceUpgrade> _upgradeController;

  @visibleForTesting
  void publishRequiredMaintenance() => _maintenanceController.add(true);

  @visibleForTesting
  void publishUpgradeStatus(ForceUpgrade forceUpgrade) =>
      _upgradeController.add(forceUpgrade);

  void _onAppConfig(Map<String, dynamic> configData) {
    try {
      final config = AppConfig.fromJson(configData);
      if (config.downForMaintenance != _lastDownForMaintenance) {
        _lastDownForMaintenance = config.downForMaintenance;
        _maintenanceController.add(_lastDownForMaintenance!);
      }

      final upgrade = ForceUpgrade.fromAppConfig(
        config,
        appDetails: _appDetails,
      );
      if (upgrade != _lastForceUpgrade) {
        _lastForceUpgrade = upgrade;
        _upgradeController.add(_lastForceUpgrade!);
      }
    } catch (e) {
      _lastDownForMaintenance = false;
      _maintenanceController.add(_lastDownForMaintenance!);
      _lastForceUpgrade = const ForceUpgrade(isUpgradeRequired: false);
      _upgradeController.add(_lastForceUpgrade!);
    }
  }

  /// Returns a [Stream<bool>] which indicates whether the current application
  /// status is down for maintenance.
  ///
  /// By default, [isDownForMaintenance] will emit `false` if unable to connect
  /// to the backend.
  Stream<bool> get isDownForMaintenance => _maintenanceController.stream
      .transform<bool>(
        StreamTransformer.fromHandlers(
          handleError: (obj, stackTrace, sink) {
            // ignore: avoid_print
            print(stackTrace);
            sink.add(false);
          },
        ),
      )
      .asBroadcastStream();

  /// Returns a [Stream<ForceUpgrade>] which indicates whether the current
  /// application requires a force upgrade.
  ///
  /// By default, [isForceUpgradeRequired] will emit `false` if unable to
  /// connect to the backend.
  Stream<ForceUpgrade> get isForceUpgradeRequired => _upgradeController.stream
      .transform<ForceUpgrade>(
        StreamTransformer.fromHandlers(
          handleError: (obj, stacktrace, sink) {
            // ignore: avoid_print
            print(stacktrace);
            sink.add(const ForceUpgrade(isUpgradeRequired: false));
          },
        ),
      )
      .asBroadcastStream();
}
