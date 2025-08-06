import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:shared_data/shared_data.dart';

/// Base building block of an [AuthRepository].
abstract class AuthService {
  /// {@template signUp}
  /// Creates a new user with the provided [email] and [password].
  /// {@endtemplate}
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  });

  /// {@template logInWithEmailAndPassword}
  /// Restores the session of an existing user with the provided [email] and
  /// [password].
  /// {@endtemplate}
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// {@template disposeAuth}
  /// Releases any resources.
  /// {@endtemplate}
  void dispose();

  /// {@template logOut}
  /// Terminates any open user session.
  /// {@endtemplate}
  Future<AuthFailure?> logOut();
}

/// Enhanced form of [AuthService] which can rely on third-party identity
/// providers.
abstract class SocialAuthService {
  /// {@template createAnonymousAccount}
  /// Creates a new account without an identifying information, but suitable to
  /// read and write data. The user may or may not one day add identifying
  /// information to make this account recoverable or able to be signed into
  /// from multiple devices.
  /// {@endtemplate}
  Future<SocialAuthResponse> createAnonymousAccount();

  /// {@template logInWithApple}
  /// Starts the Sign In with Apple Flow.
  /// {@endtemplate}
  Future<SocialAuthResponse> logInWithApple();

  /// {@template logInWithGoogle}
  /// Starts the Sign In with Google Flow.
  /// {@endtemplate}
  Future<SocialAuthResponse> logInWithGoogle();

  /// {@macro signUp}
  Future<SocialAuthResponse> signUp({
    required String email,
    required String password,
  });

  /// {@macro logInWithEmailAndPassword}
  Future<SocialAuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// {@template disposeAuth}
  /// Releases any resources.
  /// {@endtemplate}
  void dispose();

  /// {@template logOut}
  /// Terminates any open user session.
  /// {@endtemplate}
  Future<SocialAuthFailure?> logOut();
}

/// Variant of [SocialAuthService] with realtime updates.
abstract class StreamSocialAuthService extends SocialAuthService
    with ReadinessMixin<SocialUser?> {
  /// Registers a callback with the stream of user updates.
  StreamSubscription<SocialUser?> listen(void Function(SocialUser?) cb);
}

/// An auth service which will track users in its own way, but will not
/// necessarily mimic the original login mechanics. Accepts and persists data
/// yielded from a [SocialAuthService].
///
/// This is where a [SocialUser] gets promoted to an [AuthUser].
abstract class SyncAuthService {
  /// Verifies the existence of a session with who Firebase thinks is logged in.
  /// This is likely called on app start-up for users with existing accounts,
  /// since Firebase will emit their [FirebaseUser] record immediately.
  //
  // TODO(craiglabenz): Should [SyncAuthService] be prepared to load a cached
  // version of the [AuthUser] to allow for offline mode to not immediately
  // eject the user?
  Future<AuthUser?> verifySocialUserSession(SocialUser user);

  /// Allows a secondary auth service to create a matching account for a new
  /// anonymous account created by the primary social auth provider.
  Future<AuthResponse> syncAnonymousAccount(SocialAuthSuccess authSuccess);

  /// Allows a secondary auth service to make note of an email/password added
  /// to an existing account.
  Future<AuthResponse> syncEmailPasswordAuthentication(
    SocialAuthSuccess authSuccess,
  );

  /// Allows a secondary auth service to create a new account anchored on email
  /// and password authentication.
  Future<AuthResponse> signUp(SocialAuthSuccess authSuccess);

  /// Allows a secondary auth service
  Future<AuthResponse> logInWithEmailAndPassword(SocialAuthSuccess authSuccess);

  /// Allows a secondary auth service to make note of Apple Id authentication
  /// added to an existing account.
  Future<AuthResponse> syncAppleAuthentication(SocialAuthSuccess authSuccess);

  /// Allows a secondary auth service to make note of Google Id authentication
  /// added to an existing account.
  Future<AuthResponse> syncGoogleAuthentication(SocialAuthSuccess authSuccess);

  /// {@macro logOut}
  Future<AuthFailure?> logOut();

  /// {@macro disposeAuth}
  void dispose();
}
