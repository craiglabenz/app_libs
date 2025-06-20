import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('client_auth.AuthRepository');

/// {@template BaseAuthRepository}
/// Top level coordinator for app authorization.
/// {@endtemplate}
abstract class BaseAuthRepository
    with SocialAuthService, AnonymousAuthService, ReadinessMixin<AuthUser?>
    implements StreamAuthService {
  /// Most recent [AuthUser] encountered, or `null` if there is no active
  /// session.
  AuthUser? lastUser;
}

/// {@macro BaseAuthRepository}
class AuthRepository
    with ReadinessMixin<AuthUser?>
    implements BaseAuthRepository {
  /// {@macro BaseAuthRepository}
  AuthRepository(
    this._primaryAuth, {
    List<AuthService>? secondaryAuths,
  })  : _secondaryAuths = secondaryAuths ?? const <AuthService>[],
        _userUpdatesController = StreamController<AuthUser?>.broadcast();

  /// Primary authorization driver for the [AuthRepository].
  final AuthService _primaryAuth;

  /// Secondary authorization services which mirror the state of [_primaryAuth].
  /// This allows the client to talk to multiple backend services if necessary.
  final List<AuthService> _secondaryAuths;

  final StreamController<AuthUser?> _userUpdatesController;

  StreamSubscription<AuthUser?>? _primaryAuthSubscription;

  AuthUser? _lastUser;

  @override
  AuthUser? get lastUser {
    assert(
      isReady,
      'Error: You must await `initialize()` before accessing '
      'AuthRepository.lastUser',
    );
    return _lastUser;
  }

  @override
  set lastUser(AuthUser? newUser) {
    final isFirstRun = isNotResolved;
    if (!isFirstRun && newUser == _lastUser) return;

    _lastUser = newUser;
    _userUpdatesController.sink.add(newUser);
    if (isFirstRun) {
      markReady(_lastUser);
    }
  }

  // final _initializationCompleter = Completer<AuthUser?>();

  /// Wires up all listeners and resolves when [_primaryAuth] has yielded some
  /// data, even if that is just to say that definitively no user is logged in.
  ///
  /// This method is close to a no-op if [_primaryAuth] is not a
  /// [StreamAuthService].
  ///
  /// This method is idempotent and can safely be called by any other class.
  @override
  Future<AuthUser?> initialize() async {
    _log.finest('Initializing AuthRepository');
    if (_primaryAuth is StreamAuthService) {
      _primaryAuthSubscription ??= _primaryAuth.listen(
        (AuthUser? user) => lastUser = user,
      );
      // StreamAuthService.initialize also completes when a user is emitted,
      // meaning awaiting it is synonymous with awaiting our own
      // initCompleter.future which is resolved in the [lastUser] setter.
      unawaited(_primaryAuth.initialize());

      return ready;
    } else if (_primaryAuth is RestAuth) {
      // TODO(craiglabenz): Should this still call an `initialize` fnc?
      if (!isNotResolved) {
        markReady(null);
      }
      return ready;
    }
    throw Exception('Unexpected type of _primaryAuth: $_primaryAuth');
  }

  @override
  StreamSubscription<AuthUser?> listen(void Function(AuthUser?) cb) {
    final sub = _userUpdatesController.stream.listen(cb);
    if (_lastUser != null) {
      cb(_lastUser);
    }
    return sub;
  }

  /// {@macro createAnonymousAccount}
  @override
  Future<AuthResponse> createAnonymousAccount() async {
    if (_primaryAuth is! AnonymousAuthService) {
      throw Exception(
        'AuthRepository is not configured for anonymous accounts '
        'because $_primaryAuth does not implement `AnonymousAuthService`.',
      );
    }

    final authResponse =
        await (_primaryAuth as AnonymousAuthService).createAnonymousAccount();

    switch (authResponse) {
      case AuthSuccess():
        for (final secondaryAuth in _secondaryAuths) {
          if (secondaryAuth is! AnonymousAuthService) {
            _log.severe(
              '$secondaryAuth is not configured to sync an anonymous account',
            );
            continue;
          }
          final secondaryAuthResponse =
              await (secondaryAuth as AnonymousAuthService)
                  .syncAnonymousAccount(authResponse);

          if (secondaryAuthResponse is AuthFailure) {
            _log.shout(
              '$secondaryAuth failed to create a matching anonymous account. '
              '${authResponse.user} is likely in a compromised state.',
            );
          }
        }
        // Publish this information.
        lastUser = authResponse.user;
      case AuthFailure():
        _log.shout(
          '$_primaryAuth unable to create new anonymous account. Auth system '
          'may be down entirely.',
        );
        lastUser = null;
    }
    return authResponse;
  }

  @override
  Future<AuthResponse> syncAnonymousAccount(AuthSuccess authSuccess) {
    throw UnimplementedError(
      'syncAnonymousAccount should only be called on the secondaryAuth list.',
    );
  }

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    final authResponse = await _primaryAuth.signUp(
      email: email,
      password: password,
    );

    switch (authResponse) {
      case AuthSuccess():
        for (final secondaryAuth in _secondaryAuths) {
          final syncAuthResponse = await secondaryAuth.signUp(
            email: email,
            password: password,
          );

          // In the case of a failed sync, do not cancel the effort, which
          // would likely necessitate deleting the primaryAuth account.
          // Instead, log the error and allow for `loginWithEmailAndPassword`
          // to attempt to heal the system.
          if (syncAuthResponse is AuthFailure) {
            _log.severe(
              'Failed to sync user $email to $secondaryAuth :: '
              '$syncAuthResponse',
            );
          }
        }

        // Publish this information.
        lastUser = authResponse.user;
      case AuthFailure():
        _log.severe(
          'Failed to signUp new user $email with primary auth $_primaryAuth',
        );
        _lastUser = null;
    }
    return authResponse;
  }

  @override
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authResponse = await _primaryAuth.logInWithEmailAndPassword(
      email: email,
      password: password,
    );
    switch (authResponse) {
      case AuthSuccess():
        for (final secondaryAuth in _secondaryAuths) {
          final syncAuthResponse =
              await secondaryAuth.logInWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (syncAuthResponse is AuthFailure) {
            _log.severe(
              'Failed to login user $email to $secondaryAuth :: '
              '$syncAuthResponse. Attempting to signUp user instead.',
            );

            final syncAuthFallbackResponse = await secondaryAuth.signUp(
              email: email,
              password: password,
            );

            if (syncAuthFallbackResponse is AuthFailure) {
              _log.severe(
                'Failed at fallback signUp of user $email :: '
                '$syncAuthFallbackResponse. Account is likely compromised '
                'state.',
              );
            }
          }
        }

        // Publish this information.
        lastUser = authResponse.user;
      case AuthFailure():
        _log.severe(
          'Failed to signUp new user $email with primary auth $_primaryAuth',
        );
        _lastUser = null;
    }
    return authResponse;
  }

  @override
  Future<AuthResponse> logInWithApple() async {
    if (_primaryAuth is! SocialAuthService) {
      throw Exception(
        'Cannot log in with Apple because $_primaryAuth is not a '
        'SocialAuthService',
      );
    }
    final authResponse =
        await (_primaryAuth as SocialAuthService).logInWithApple();
    switch (authResponse) {
      case AuthSuccess():
        for (final _ in _secondaryAuths) {
          // TODO(craiglabenz): Figure out how to sync accounts when an app
          // actually has >1 auth backends.
          throw UnimplementedError();
        }
        // Publish this information.
        lastUser = authResponse.user;
      case AuthFailure():
        {}
    }
    return authResponse;
  }

  @override
  Future<AuthResponse> logInWithGoogle() async {
    if (_primaryAuth is! SocialAuthService) {
      throw Exception(
        'Cannot log in with Google because $_primaryAuth is not a '
        'SocialAuthService',
      );
    }
    final authResponse =
        await (_primaryAuth as SocialAuthService).logInWithGoogle();
    switch (authResponse) {
      case AuthSuccess():
        for (final _ in _secondaryAuths) {
          // TODO(craiglabenz): Figure out how to sync accounts when an app
          // actually has >1 auth backends.
          throw UnimplementedError();
        }
        // Publish this information.
        lastUser = authResponse.user;
      case AuthFailure():
        {}
    }
    return authResponse;
  }

  @override
  Future<AuthFailure?> logOut() async {
    if (_lastUser == null) return null;

    final failure = await _primaryAuth.logOut();
    if (failure != null) {
      _log.severe(
        'Failed to logout ${lastUser!.email} from $_primaryAuth. Auth system '
        'may be down :: $failure',
      );
    }

    for (final secondaryAuth in _secondaryAuths) {
      final secondaryLogoutFailure = await secondaryAuth.logOut();
      if (secondaryLogoutFailure != null) {
        _log.severe(
          'Failed to logout ${lastUser!.email} from $secondaryAuth. Auth '
          'system may be down :: $secondaryLogoutFailure',
        );
      }
    }
    lastUser = null;
    return failure;
  }

  @override
  void dispose() {
    _primaryAuthSubscription?.cancel();
    _primaryAuth.dispose();
    for (final secondaryAuth in _secondaryAuths) {
      secondaryAuth.dispose();
    }
  }

  @override
  Future<Set<AuthProvider>> getAvailableMethods(String email) {
    assert(
      _primaryAuth is SocialAuthService,
      'AuthRepository is not configured to call getAvailableMethods '
      'because $_primaryAuth is not a `SocialAuthService`.',
    );
    return (_primaryAuth as SocialAuthService).getAvailableMethods(email);
  }
}

/// {@template FakeAuthRepository}
/// Faked implementation of [BaseAuthRepository] that is helpful when testing
/// objects which depend on a [BaseAuthRepository] but do not want to bother
/// with complicated login mechanics.
///
/// Usage:
/// ```dart
/// final authRepo = FakeAuthRepo(initialUser: authUserOrNull);
///
/// final _sub = authRepo.listen((AuthUser? authUser) {
///   // logic
/// });
///
/// // mimics a successful login flow for `myUser`
/// authRepo.publishNewUser(myUser);
///
/// _sub.cancel();
/// ```
/// {@endtemplate}
class FakeAuthRepository
    with ReadinessMixin<AuthUser?>
    implements BaseAuthRepository {
  /// {@macro FakeAuthRepository}
  FakeAuthRepository({
    AuthUser? initialUser,
    bool shouldMarkReady = true,
  }) {
    _lastUser = initialUser;
    if (shouldMarkReady) {
      markReady(initialUser);
    }
  }

  final _controller = StreamController<AuthUser?>.broadcast();

  AuthUser? _lastUser;

  @override
  AuthUser? get lastUser {
    assert(
      isReady,
      'Must not access AuthRepository.lastUser until the '
      'AuthRepository.initialized future resolves',
    );
    return _lastUser;
  }

  @override
  set lastUser(AuthUser? newUser) {
    _lastUser = newUser;
    _controller.add(newUser);
    if (isNotResolved) {
      markReady(newUser);
    }
  }

  @override
  Future<AuthResponse> createAnonymousAccount() => throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  @override
  Future<Set<AuthProvider>> getAvailableMethods(String email) =>
      throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  @override
  Future<AuthUser?> initialize() => Future.value(lastUser);

  @override
  StreamSubscription<AuthUser?> listen(void Function(AuthUser? p1) cb) {
    final sub = _controller.stream.listen(cb);
    if (_lastUser != null) {
      cb(_lastUser);
    }
    return sub;
  }

  @override
  Future<AuthResponse> logInWithApple() => throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  @override
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  @override
  Future<AuthResponse> logInWithGoogle() => throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  @override
  Future<AuthFailure?> logOut() => throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) =>
      throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  @override
  Future<AuthResponse> syncAnonymousAccount(AuthSuccess authSuccess) =>
      throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  /// The mechanism by which tests emit new users.
  @visibleForTesting
  // Make this more explicit than setting `fakeAuthRepo.lastUser = myUser` since
  // that alternate API is not how to real [AuthRepository] objects work.
  // ignore: use_setters_to_change_properties
  void publishNewUser(AuthUser? user) {
    lastUser = user;
  }

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}
