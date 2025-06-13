import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('client_auth.AuthRepository');

/// {@template AuthRepository}
/// {@endtemplate}
class AuthRepository
    with SocialAuthService, AnonymousAuthService
    implements StreamAuthService {
  /// {@macro AuthRepository}
  AuthRepository(
    this.primaryAuth, {
    this.secondaryAuths = const <AuthService>[],
  }) : _userUpdatesController = StreamController<AuthUser?>.broadcast();

  /// Primary authorization driver for the [AuthRepository].
  final AuthService primaryAuth;

  /// Secondary authorization services which mirror the state of [primaryAuth].
  /// This allows the client to talk to multiple backend services if necessary.
  final List<AuthService> secondaryAuths;

  final StreamController<AuthUser?> _userUpdatesController;

  StreamSubscription<AuthUser?>? _primaryAuthSubscription;

  AuthUser? _lastUser;

  /// Container for the most recent [AuthUser] value to come off the stream.
  AuthUser? get lastUser {
    assert(
      _initializationCompleter.isCompleted,
      'Error: You must await `initialize()` before accessing '
      'AuthRepository.lastUser',
    );
    return _lastUser;
  }

  set lastUser(AuthUser? newUser) {
    final isFirstRun = !_initializationCompleter.isCompleted;
    if (!isFirstRun && newUser == _lastUser) return;

    _lastUser = newUser;
    _userUpdatesController.sink.add(newUser);
    if (isFirstRun) {
      _initializationCompleter.complete(_lastUser);
    }
  }

  final _initializationCompleter = Completer<AuthUser?>();

  /// Wires up all listeners and resolves when [primaryAuth] has yielded some
  /// data, even if that is just to say that definitively no user is logged in.
  ///
  /// This method is close to a no-op if [primaryAuth] is not a
  /// [StreamAuthService].
  ///
  /// This method is idempotent and can safely be called by any other class.
  @override
  Future<AuthUser?> initialize() async {
    _log.finest('Initializing AuthRepository');
    if (primaryAuth is StreamAuthService) {
      _primaryAuthSubscription ??= (primaryAuth as StreamAuthService).listen(
        (AuthUser? user) => lastUser = user,
      );
      // StreamAuthService.initialize also completes when a user is emitted,
      // meaning awaiting it is synonymous with awaiting our own
      // initCompleter.future which is resolved in the [lastUser] setter.
      unawaited((primaryAuth as StreamAuthService).initialize());

      return _initializationCompleter.future;
    } else if (primaryAuth is RestAuth) {
      // TODO(craiglabenz): Should this still call an `initialize` fnc?
      if (!_initializationCompleter.isCompleted) {
        _initializationCompleter.complete();
      }
      return _initializationCompleter.future;
    }
    throw Exception('Unexpected type of primaryAuth: $primaryAuth');
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
    if (primaryAuth is! AnonymousAuthService) {
      throw Exception(
        'AuthRepository is not configured for anonymous accounts '
        'because $primaryAuth does not implement `AnonymousAuthService`.',
      );
    }

    final authResponse =
        await (primaryAuth as AnonymousAuthService).createAnonymousAccount();

    switch (authResponse) {
      case AuthSuccess():
        for (final secondaryAuth in secondaryAuths) {
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
          '$primaryAuth unable to create new anonymous account. Auth system '
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
    final authResponse = await primaryAuth.signUp(
      email: email,
      password: password,
    );

    switch (authResponse) {
      case AuthSuccess():
        for (final secondaryAuth in secondaryAuths) {
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
          'Failed to signUp new user $email with primary auth $primaryAuth',
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
    final authResponse = await primaryAuth.logInWithEmailAndPassword(
      email: email,
      password: password,
    );

    switch (authResponse) {
      case AuthSuccess():
        for (final secondaryAuth in secondaryAuths) {
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
          'Failed to signUp new user $email with primary auth $primaryAuth',
        );
        _lastUser = null;
    }
    return authResponse;
  }

  @override
  Future<AuthResponse> logInWithApple() async {
    if (primaryAuth is! SocialAuthService) {
      throw Exception(
        'Cannot log in with Apple because $primaryAuth is not a '
        'SocialAuthService',
      );
    }
    final authResponse =
        await (primaryAuth as SocialAuthService).logInWithApple();
    switch (authResponse) {
      case AuthSuccess():
        for (final _ in secondaryAuths) {
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
    if (primaryAuth is! SocialAuthService) {
      throw Exception(
        'Cannot log in with Google because $primaryAuth is not a '
        'SocialAuthService',
      );
    }
    final authResponse =
        await (primaryAuth as SocialAuthService).logInWithGoogle();
    switch (authResponse) {
      case AuthSuccess():
        for (final _ in secondaryAuths) {
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

    final failure = await primaryAuth.logOut();
    if (failure != null) {
      _log.severe(
        'Failed to logout ${lastUser!.email} from $primaryAuth. Auth system '
        'may be down :: $failure',
      );
    }

    for (final secondaryAuth in secondaryAuths) {
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
    primaryAuth.dispose();
    for (final secondaryAuth in secondaryAuths) {
      secondaryAuth.dispose();
    }
  }

  @override
  Future<Set<AuthProvider>> getAvailableMethods(String email) {
    assert(
      primaryAuth is SocialAuthService,
      'AuthRepository is not configured to call getAvailableMethods '
      'because $primaryAuth is not a `SocialAuthService`.',
    );
    return (primaryAuth as SocialAuthService).getAvailableMethods(email);
  }
}
