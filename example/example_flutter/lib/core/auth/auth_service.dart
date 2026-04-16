import 'dart:async';

import 'package:example_client/example_client.dart' show Client;
import 'package:example_shared/models.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
    hide UserProfile;

/// Abstraction around actual authentication mechanisms.
abstract class AuthService {
  /// Stream which emits new [AuthSession] models, or [null] if a user logs out.
  ///
  /// The subscribing function is called immediately with the current value.
  StreamSubscription<AuthSession?> listen(
    Function(AuthSession? session) onUserChanged,
  );

  /// Most recent session.
  AuthSession? session;

  /// Terminates the active session. If there was an active session, this will
  /// lead to any callbacks registered via [listen] to receive a `null` value.
  Future<void> logOut();

  /// Closes the service, releasing any resources.
  void close();
}

/// Serverpod implementation of auth mechanisms.
class ServerpodAuthService implements AuthService {
  /// Instantiates a new [ServerpodAuthService].
  ServerpodAuthService(this._client) {
    _client.authSessionManager.authInfoListenable.addListener(
      _onServerpodAuthChanged,
    );
  }

  @override
  AuthSession? session;
  final Client _client;

  final StreamController<AuthSession?> _controller =
      StreamController<AuthSession?>.broadcast();

  @override
  StreamSubscription<AuthSession?> listen(
    Function(AuthSession? profile) onUserChanged,
  ) {
    final sub = _controller.stream.listen(onUserChanged);
    // Emit the current value immediately.
    onUserChanged(session);
    return sub;
  }

  Future<void> _onServerpodAuthChanged() async {
    if (_client.authSessionManager.isAuthenticated) {
      print('AUTHENTICATED :: ${_client.authSessionManager.authInfo}');
      final results = await Future.wait([
        _client.session.getCurrentUserProfile(),
        _client.session.getCurrentUserSettings(),
        _client.auth.idp.getConnectedIdps(),
      ]);
      final profile = results[0] as UserProfile;
      final settings = results[1] as UserSettings;
      final connectedIdps = results[2] as ConnectedIdps;

      final allProviders = <AuthProvider>{};
      if (connectedIdps.hasAnonymous) {
        allProviders.add(.anonymous);
      }
      if (connectedIdps.hasEmail) {
        allProviders.add(.email);
      }
      if (connectedIdps.hasApple) {
        allProviders.add(.apple);
      }
      if (connectedIdps.hasGoogle) {
        allProviders.add(.google);
      }
      session = AuthSession(
        profile: profile,
        settings: settings,
        allProviders: allProviders,
      );
    } else {
      session = null;
    }
    _controller.add(session);
  }

  @override
  Future<void> logOut() async {
    await _client.authSessionManager.signOutDevice();
  }

  @override
  void close() {
    _client.authSessionManager.authInfoListenable.removeListener(
      _onServerpodAuthChanged,
    );
    _controller.close();
  }
}
