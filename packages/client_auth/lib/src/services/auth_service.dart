import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:shared_data/shared_data.dart';

/// Base building block of an [AuthRepository].
///
/// Analogous to a [Source] for regular [Repository] classes.
abstract class AuthService {
  /// Releases any resources.
  void dispose();

  /// Creates a new user with the provided [email] and [password].
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  });

  /// Restores the session of an existing user with the provided [email] and
  /// [password].
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Terminates any open user session.
  Future<AuthFailure?> logOut();
}

/// Variant of [AuthService] with realtime updates.
abstract class StreamAuthService extends AuthService
    with ReadinessMixin<AuthUser?> {
  /// Registers a callback with the stream of user updates.
  StreamSubscription<AuthUser?> listen(void Function(AuthUser?) cb);
}

/// Mixin for social-powered auth on an [AuthService].
mixin SocialAuthService {
  /// Starts the Sign In with Apple Flow.
  Future<AuthResponse> logInWithApple();

  /// Starts the Sign In with Google Flow.
  Future<AuthResponse> logInWithGoogle();

  /// Returns the set of social auth methods tied to this email address.
  Future<Set<AuthProvider>> getAvailableMethods(String email);
}

/// Indicates that an [AuthService] supports anonymous user sessions.
mixin AnonymousAuthService {
  /// Creates a new account without an identifying information, but suitable to
  /// read and write data. The user may or may not one day add identifying
  /// information to make this account recoverable or able to signed into from
  /// multiple devices.
  Future<AuthResponse> createAnonymousAccount();

  /// Allows a secondary [AuthService] to create a matching account for a new
  /// anonymous account created by the primary [AuthService].
  Future<AuthResponse> syncAnonymousAccount(AuthSuccess authSuccess);
}
