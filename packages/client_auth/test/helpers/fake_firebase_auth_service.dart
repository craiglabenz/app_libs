import 'dart:async';
import 'package:client_auth/client_auth.dart';
import 'package:shared_data/shared_data.dart' show AuthProvider, AuthUser;

/// Pass-thru implementation of [AuthService] with scriptable results.
class FakeFirebaseAuth extends StreamAuthService
    with SocialAuthService, AnonymousAuthService {
  /// The user to be added to the stream during the next login attempt
  /// IFF [error] is null.
  AuthUser? _user;

  /// If not null, the exception to be thrown during the next login attempt.
  /// This value is reset to `null` after each being thrown.
  AuthFailure? error;
  final StreamController<AuthUser?> _controller = StreamController<AuthUser?>();

  /// Sets the user to be yielded by the next login/sign up attempt.
  // ignore: use_setters_to_change_properties
  void prepareLogin(AuthUser? user) => _user = user;

  /// Sets the error to be thrown by the next login/sign up attempt.
  // ignore: use_setters_to_change_properties
  void prepareLoginError(AuthFailure e) => error = e;

  AuthUser? _lastEmittedUser;

  // Centralized place to emit users to the stream.
  void _emitUser() {
    _lastEmittedUser = _user;
    _user = null;
    _controller.sink.add(_lastEmittedUser);
  }

  @override
  Future<Set<AuthProvider>> getAvailableMethods(String email) =>
      Future.value(<AuthProvider>{});

  @override
  Future<AuthResponse> logInWithApple() async => _doLogin();

  @override
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async =>
      _doLogin();

  @override
  Future<AuthResponse> logInWithGoogle() async => _doLogin();

  @override
  Future<AuthFailure?> logOut() async {
    if (error != null) {
      final errorPtr = error!.copyWith();
      error = null;
      return errorPtr;
    }

    _user = null;
    _emitUser();
    return null;
  }

  AuthUser? getStoredUser() => _user;

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async =>
      _doLogin();

  AuthResponse _doLogin() {
    if (error != null) {
      final errorPtr = error!.copyWith();
      error = null;
      return errorPtr;
    }

    final userCopy = _user!.copyWith();
    _emitUser();
    return AuthSuccess(userCopy);
  }

  @override
  StreamSubscription<AuthUser?> listen(void Function(AuthUser? user) cb) {
    final sub = _controller.stream.listen(cb);
    if (_lastEmittedUser != null) {
      // This is the only place it is safe to call _controller.sink.add outside
      // of _emitUser, which we do here merely to immediately publish the last
      // emitted user.
      _controller.sink.add(_lastEmittedUser);
    }
    return sub;
  }

  @override
  Future<AuthResponse> createAnonymousAccount() async => _doLogin();

  @override
  void dispose() {}

  @override
  Future<AuthUser?> initialize() {
    _emitUser();
    return Future<AuthUser?>.value(_user);
  }

  @override
  Future<AuthResponse> syncAnonymousAccount(AuthSuccess authSuccess) {
    throw UnimplementedError('This is not supported for FirebaseAuth');
  }
}
