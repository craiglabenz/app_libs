import 'dart:async';
import 'package:client_auth/client_auth.dart';
import 'package:shared_data/shared_data.dart';

/// Pass-thru implementation of [AuthService] with scriptable results.
class FakeFirebaseAuth extends StreamSocialAuthService {
  /// The user to be added to the stream during the next login attempt
  /// IFF [error] is null.
  SocialUser? _stagedUser;

  /// If not null, the exception to be thrown during the next login attempt.
  /// This value is reset to `null` after each being thrown.
  SocialAuthFailure? error;
  final StreamController<SocialUser?> _controller =
      StreamController<SocialUser?>();

  /// Sets the user to be yielded by the next login/sign up attempt.
  // ignore: use_setters_to_change_properties
  void prepareLogin(SocialUser? user) => _stagedUser = user;

  /// Sets the error to be thrown by the next login/sign up attempt.
  // ignore: use_setters_to_change_properties
  void prepareLoginError(SocialAuthFailure e) => error = e;

  SocialUser? _lastEmittedUser;

  @override
  Future<SocialUser?> performInitialization() {
    _emitUser();
    return Future<SocialUser?>.value(_lastEmittedUser);
  }

  // Centralized place to emit users to the stream.
  void _emitUser() {
    _lastEmittedUser = _stagedUser;
    _stagedUser = null;
    _controller.sink.add(_lastEmittedUser);
    markReady(_lastEmittedUser);
  }

  @override
  Future<SocialAuthResponse> logInWithApple() async => _doLogin();

  @override
  Future<SocialAuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async =>
      _doLogin();

  @override
  Future<SocialAuthResponse> logInWithGoogle() async => _doLogin();

  @override
  Future<SocialAuthFailure?> logOut() async {
    if (error != null) {
      final errorPtr = error!.copyWith();
      error = null;
      return errorPtr;
    }

    _stagedUser = null;
    _emitUser();
    return null;
  }

  SocialUser? getStoredUser() => _stagedUser;

  @override
  Future<SocialAuthResponse> signUp({
    required String email,
    required String password,
  }) async =>
      _doLogin();

  SocialAuthResponse _doLogin() {
    if (error != null) {
      final errorPtr = error!.copyWith();
      error = null;
      return errorPtr;
    }

    final userCopy = _stagedUser!.copyWith();
    _emitUser();
    return SocialAuthSuccess(userCopy);
  }

  @override
  StreamSubscription<SocialUser?> listen(void Function(SocialUser? user) cb) {
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
  Future<SocialAuthResponse> createAnonymousAccount() async => _doLogin();

  @override
  void dispose() {}
}
