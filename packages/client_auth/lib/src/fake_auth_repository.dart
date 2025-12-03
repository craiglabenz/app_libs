import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:data_layer/data_layer.dart';
import 'package:meta/meta.dart';
import 'package:shared_data/shared_data.dart';

/// {@template FakeAuthRepository}
/// Faked implementation of [AuthRepository] that is helpful when testing
/// objects which depend on a [AuthRepository] but do not want to bother
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
    implements AuthRepository {
  /// {@macro FakeAuthRepository}
  FakeAuthRepository({
    AuthUser? initialUser,
    bool shouldMarkReady = true,
  }) {
    _lastUser = initialUser;
    if (shouldMarkReady) {
      _initCompleter.complete(initialUser);
      readiness = Readiness.ready;
    }
  }

  final _controller = StreamController<AuthUser?>.broadcast();

  final _initCompleter = Completer<AuthUser?>();

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
    if (isNotReady) {
      _initCompleter.complete(newUser);
      readiness = Readiness.ready;
    }
  }

  @override
  Future<AuthResponse> createAnonymousAccount() => throw Exception(
        'Do not call real methods on FakeAuthRepository. '
        'Only call `publishNewUser`.',
      );

  @override
  Future<AuthUser?> performInitialization() => Future.value(lastUser);

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

  @override
  void addNewUserListener(Future<void> Function(AuthUser p1) onNewUser) {
    // No need for this in tests.
  }
}
