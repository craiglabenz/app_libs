import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('client_auth.AuthRepository');

/// Differentiates categories of user interactions to help surrounding code
/// know how to interpret changes in state.
enum AuthEvent {
  /// A new user has appeared because they logged in or signed up. This implies
  /// that sync auth should not be expected to have a valid session.
  authenticated,

  /// An existing user added a new provider. This implies that the sync auth
  /// SHOULD have a valid session.
  addedAuth,

  /// A new user has appeared because the FirebaseAuth service emitted a
  /// standing session. This implies that a sync auth service SHOULD have a
  /// valid session.
  emitted,

  /// A null user has appeared because the account was terminated, either by the
  /// user or programmatically.
  loggedOut,
}

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

  StreamSubscription<(SocialUser?, AuthEvent)>? _socialAuthSubscription;

  AuthUser? _lastUser;

  /// The most recently / current [AuthUser] information. Will be null if the
  /// app is in a logged-out state.
  AuthUser? get lastUser {
    if (!isReady) {
      throw Exception('isready');
    }
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
    _log.info('Publishing $newUser on public stream');
    _userUpdatesController.sink.add(newUser);
    if (isFirstRun) {
      markReady(_lastUser);
    }
    _log.finer('New AuthUser: $newUser');
  }

  final List<Future<void> Function(AuthUser)> _onNewUserCallbacks = [];

  /// Registers a listener to be called and awaited BEFORE a new user is
  /// published. Use this to create any other new records that the app will
  /// assume exist for all [AuthUser] records.
  void addNewUserListener(Future<void> Function(AuthUser) onNewUser) {
    _onNewUserCallbacks.add(onNewUser);
  }

  Future<void> _callNewUserListeners(AuthUser newUser) async {
    _log.info(
      'Invoking ${_onNewUserCallbacks.length} newUserCallbacks for $newUser',
    );
    for (final fn in _onNewUserCallbacks) {
      await fn(newUser);
    }
  }

  Future<void> _syncSocialUser(SocialUser? user, AuthEvent event) async {
    if (user == null) {
      _log.finer('SocialUser: null');
      lastUser = null;
      return;
    }
    _log.finer('Syncing SocialUser: $user');

    switch (event) {
      case AuthEvent.addedAuth || AuthEvent.emitted:
        lastUser = await _syncAuth.verifySocialUserSession(user);

        /// If [_syncAuth] could not verify a session with who Firebase said is
        /// logged in then they are not fully logged in and must be fully logged
        /// out to allow them to completely restore their session.
        if (lastUser == null) {
          _log.finer('Logging out SocialUser $user because syncing failed');
          await logOut();
        }
      case AuthEvent.authenticated || AuthEvent.loggedOut:
      // Nothing to do, because we don't expect to have a standing sync session
      // to verify
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
      _socialAuthSubscription ??= _socialAuth.listen(
        (data) => _syncSocialUser(data.$1, data.$2),
      );
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
    cb(_lastUser);
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
            await _callNewUserListeners(user);
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
        final authResponse =
            await _syncAuth.syncEmailPasswordAuthentication(socialAuthResponse);

        switch (authResponse) {
          case AuthSuccess(:final user):
            // Publish this information.
            await _callNewUserListeners(user);
            lastUser = user;

          case AuthFailure(:final error):
            _log.severe(
              'Failed to signUp SocialUser ${socialAuthResponse.user.id} '
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
            _log.severe(
              'Failed to sync AnonymousAccount ${socialAuthResponse.user.id} '
              'to backup auth :: $error',
            );
        }
        return authResponse;
      case SocialAuthFailure():
        _log.severe(
          'Failed to login new user $email with primary auth $_socialAuth',
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
            if (authResponse.isNewUser) {
              await _callNewUserListeners(user);
            }
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
            if (authResponse.isNewUser) {
              await _callNewUserListeners(user);
            }
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

  /// {@macro disposeAuth}
  void dispose() {
    _socialAuthSubscription?.cancel();
    _socialAuth.dispose();
    _syncAuth.dispose();
  }
}
