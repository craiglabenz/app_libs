import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('client_auth.AuthRepository');

/// {@template AuthRepository}
/// Creates and manages user accounts.
///
/// Coordinates infromation between a [SocialAuthService] and a
/// [SyncAuthService].
/// {@endtemplate}
class AuthRepository with ReadinessMixin<AuthUser?> {
  /// {@macro AuthRepository}
  AuthRepository(
    this._socialAuth, {
    required SyncAuthService syncAuth,
  })  : _syncAuth = syncAuth,
        _userUpdatesController = StreamController<AuthUser?>.broadcast();

  /// Primary identity provider for the [AuthRepository].
  final SocialAuthService _socialAuth;

  /// Secondary authorization services which mirror the state of [_socialAuth].
  /// This allows the client to talk to multiple backend services if necessary.
  final SyncAuthService _syncAuth;

  final StreamController<AuthUser?> _userUpdatesController;

  StreamSubscription<SocialUser?>? _socialAuthSubscription;

  AuthUser? _lastUser;

  /// The most recently / current [AuthUser] information. Will be null if the
  /// app is in a logged-out state.
  AuthUser? get lastUser {
    assert(
      isReady,
      'Error: You must await `initialize()` before accessing '
      'AuthRepository.lastUser',
    );
    return _lastUser;
  }

  set lastUser(AuthUser? newUser) {
    final isFirstRun = isNotResolved;
    if (!isFirstRun && newUser == _lastUser) return;

    _lastUser = newUser;
    _userUpdatesController.sink.add(newUser);
    if (isFirstRun) {
      markReady(_lastUser);
    }
  }

  Future<void> _syncSocialUser(SocialUser? user) async {
    if (user == null) {
      lastUser = null;
      return;
    }
    lastUser = await _syncAuth.verifySocialUserSession(user);

    /// If [_syncAuth] could not verify a session with who Firebase said is
    /// logged in then they are not fully logged in and must be fully logged out
    /// to allow them to completely restore their session.
    if (lastUser == null) {
      await logOut();
    }
  }

  /// Wires up all listeners and resolves when [_socialAuth] has yielded some
  /// data, even if that is just to say that definitively no user is logged in.
  ///
  /// This method is close to a no-op if [_socialAuth] is not a
  /// [StreamSocialAuthService].
  ///
  /// This method is idempotent and can safely be called by any other class.
  @override
  Future<AuthUser?> performInitialization() async {
    _log.finest('Initializing AuthRepository');
    if (_socialAuth is StreamSocialAuthService) {
      _socialAuthSubscription ??= _socialAuth.listen(_syncSocialUser);
      // StreamAuthService.initialize also completes when a user is emitted,
      // meaning awaiting it is synonymous with awaiting our own
      // initCompleter.future which is resolved in the [lastUser] setter.
      unawaited(_socialAuth.initialize());

      return ready;
    }
    throw Exception('Unexpected type of _socialAuth: $_socialAuth');
  }

  /// Accepts a callback to invoke on every new [AuthUser]. Immediately calls
  /// new subscriptions if [lastUser] is not null.
  StreamSubscription<AuthUser?> listen(void Function(AuthUser?) cb) {
    final sub = _userUpdatesController.stream.listen(cb);
    if (_lastUser != null) {
      cb(_lastUser);
    }
    return sub;
  }

  /// {@macro createAnonymousAccount}
  Future<AuthResponse> createAnonymousAccount() async {
    final socialAuthResponse = await _socialAuth.createAnonymousAccount();

    switch (socialAuthResponse) {
      case SocialAuthSuccess():
        final authResponse = await _syncAuth.syncAnonymousAccount(
          socialAuthResponse,
        );

        switch (authResponse) {
          case AuthSuccess(:final user):
            // Publish this information.
            lastUser = user;

          case AuthFailure(:final error):
            _log.severe(
              'Failed to sync AnonymousAccount ${socialAuthResponse.user.id} '
              'to backup auth :: $error',
            );
        }
        return authResponse;

      case SocialAuthFailure():
        _log.shout(
          '$_socialAuth unable to create new anonymous account. Auth system '
          'may be down entirely.',
        );
        lastUser = null;

        return AuthFailure(socialAuthResponse.error);
    }
  }

  /// {@macro signUp}
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    final socialAuthResponse = await _socialAuth.signUp(
      email: email,
      password: password,
    );

    switch (socialAuthResponse) {
      case SocialAuthSuccess():
        final authResponse = await _syncAuth.signUp(
          socialAuthResponse,
        );

        switch (authResponse) {
          case AuthSuccess(:final user):
            // Publish this information.
            lastUser = user;

          case AuthFailure(:final error):
            _log.severe(
              'Failed to sync AnonymousAccount ${socialAuthResponse.user.id} '
              'to backup auth :: $error',
            );
        }
        return authResponse;
      case SocialAuthFailure():
        _log.severe(
          'Failed to signUp new user $email with primary auth $_socialAuth',
        );
        _lastUser = null;
        return AuthFailure(socialAuthResponse.error);
    }
  }

  /// {@macro logInWithEmailAndPassword}
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final socialAuthResponse = await _socialAuth.logInWithEmailAndPassword(
      email: email,
      password: password,
    );
    switch (socialAuthResponse) {
      case SocialAuthSuccess():
        final authResponse = await _syncAuth.logInWithEmailAndPassword(
          socialAuthResponse,
        );

        // Publish this information.
        switch (authResponse) {
          case AuthSuccess(:final user):
            // Publish this information.
            lastUser = user;

          case AuthFailure(:final error):

            // Is this a good idea?
            // final syncAuthFallbackResponse = await secondaryAuth.signUp(
            //   email: email,
            //   password: password,
            // );

            _log.severe(
              'Failed to sync AnonymousAccount ${socialAuthResponse.user.id} '
              'to backup auth :: $error',
            );
        }
        return authResponse;
      case SocialAuthFailure():
        _log.severe(
          'Failed to signUp new user $email with primary auth $_socialAuth',
        );
        _lastUser = null;
        return AuthFailure(socialAuthResponse.error);
    }
  }

  /// {@macro logInWithApple}
  Future<AuthResponse> logInWithApple() async {
    final socialAuthResponse = await _socialAuth.logInWithApple();
    switch (socialAuthResponse) {
      case SocialAuthSuccess():
        final authResponse =
            await _syncAuth.syncAppleAuthentication(socialAuthResponse);
        switch (authResponse) {
          case AuthSuccess(:final user):
            // Publish this information.
            lastUser = user;

          case AuthFailure(:final error):
            _log.severe(
              'Failed to sync AnonymousAccount ${socialAuthResponse.user.id} '
              'to backup auth :: $error',
            );
        }
        return authResponse;
      case SocialAuthFailure():
        _log.severe(
          'Failed to logInWithApple',
        );
        _lastUser = null;
        return AuthFailure(socialAuthResponse.error);
    }
  }

  /// {@macro logInWithGoogle}
  Future<AuthResponse> logInWithGoogle() async {
    final socialAuthResponse = await _socialAuth.logInWithGoogle();
    switch (socialAuthResponse) {
      case SocialAuthSuccess():
        final authResponse =
            await _syncAuth.syncGoogleAuthentication(socialAuthResponse);
        switch (authResponse) {
          case AuthSuccess(:final user):
            // Publish this information.
            lastUser = user;

          case AuthFailure(:final error):
            _log.severe(
              'Failed to sync AnonymousAccount ${socialAuthResponse.user.id} '
              'to backup auth :: $error',
            );
        }
        return authResponse;
      case SocialAuthFailure():
        _log.severe(
          'Failed to logInWithGoogle',
        );
        _lastUser = null;
        return AuthFailure(socialAuthResponse.error);
    }
  }

  /// {@macro logOut}
  Future<AuthFailure?> logOut() async {
    if (_lastUser == null) return null;

    final failure = await _socialAuth.logOut();
    if (failure != null) {
      _log.severe(
        'Failed to logout ${lastUser!.email} from $_socialAuth. Auth system '
        'may be down :: $failure',
      );
    }

    final syncAuthFailure = await _syncAuth.logOut();
    if (syncAuthFailure != null) {
      _log.severe(
        'Failed to logout ${lastUser!.email} from $_syncAuth. This should not '
        'have been possible - all we need to do is remove API keys from '
        'local storage. :: $syncAuthFailure',
      );
    }

    lastUser = null;
    return failure != null ? AuthFailure(failure.error) : syncAuthFailure;
  }

  // Future<AuthUser?> _loadUserWithExpectations(
  //   String id,
  //   String originMethod, {
  //   /// If true, the user is expected to exist.
  //   /// If false, the user is expected to not exist (it is being created).
  //   /// If null, no assumption is made.
  //   bool? exists = true,
  //   Set<AuthProvider> expectedProviders = const {},
  //   Set<AuthProvider> unexpectedProviders = const {},
  // }) async {
  //   final loadedUser = await _authUserRepo.getById(
  //     id,
  //     RequestDetails.read(requestType: RequestType.refresh),
  //   );

  //   if (exists != null) {
  //     if (!exists && loadedUser != null) {
  //       _log.shout(
  //         'Found unexpected existing AuthUser in $originMethod with Id $id',
  //       );
  //     }
  //     if (exists && loadedUser == null) {
  //       _log.shout(
  //         'Did not find expected AuthUser in $originMethod with Id $id',
  //       );
  //     }
  //   }
  //   if (loadedUser != null) {
  //     if (expectedProviders.isNotEmpty) {
  //       final missingProviders =
  //           loadedUser.allProviders.difference(expectedProviders);
  //       if (missingProviders.isNotEmpty) {
  //         _log.shout(
  //           'Expected to find AuthUser in $originMethod with Id $id and at '
  //           'least $expectedProviders. Instead, found AuthUser with '
  //           '${loadedUser.allProviders}',
  //         );
  //       }
  //       if (unexpectedProviders.isNotEmpty) {
  //         final surprisingProviders =
  //             loadedUser.allProviders.intersection(unexpectedProviders);
  //         if (surprisingProviders.isNotEmpty) {
  //           _log.shout(
  //             'Found AuthUser in $originMethod with Id $id which '
  //             'unexpectedly already had $surprisingProviders.',
  //           );
  //         }
  //       }
  //     }
  //   }
  //   return loadedUser;
  // }

  /// {@macro disposeAuth}
  void dispose() {
    _socialAuthSubscription?.cancel();
    _socialAuth.dispose();
    _syncAuth.dispose();
  }
}
