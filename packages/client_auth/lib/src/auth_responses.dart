import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:matcher/matcher.dart';
import 'package:shared_data/shared_data.dart';

part 'auth_responses.freezed.dart';

final _log = Logger('client_auth.AuthResponse');

/// Union type for authorization attempts, always appearing in the form of
/// either an [AuthSuccess] or an [AuthFailure].
@Freezed()
abstract class AuthResponse with _$AuthResponse {
  /// Container for a successful authorization attempt.
  const factory AuthResponse.success(
    AuthUser user, {
    String? apiToken,
  }) = AuthSuccess;

  /// Container for a failed authorization attempt.
  const factory AuthResponse.failure(AuthenticationError error) = AuthFailure;
  const AuthResponse._();

  /// Builder for an AuthFailure from an [auth.FirebaseAuthException].
  factory AuthResponse.fromFirebaseException(auth.FirebaseAuthException e) {
    return AuthFailure(AuthenticationError.fromFirebaseException(e));
  }

  /// Builder for an AuthFailure from an [ApiError].
  factory AuthResponse.fromApiError(ApiError e) {
    return AuthFailure(AuthenticationError.fromApiError(e));
  }

  /// Convenience getter for the [AuthUser]. Only call this after ruling out the
  /// possibility of an [AuthFailure].
  AuthUser getOrRaise() {
    if (this is AuthFailure) {
      throw Exception('Unexpected AuthFailure in getOrRaise');
    }
    return (this as AuthSuccess).user;
  }
}

/// Testing matcher for whether this was a success.
const Matcher isAuthSuccess = _IsSuccess();

class _IsSuccess extends Matcher {
  const _IsSuccess();
  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is AuthSuccess;

  @override
  Description describe(Description description) =>
      description.add('is-auth-success');
}

/// Testing matcher for whether this was a success.
const Matcher isAuthFailure = _IsFailure();

class _IsFailure extends Matcher {
  const _IsFailure();
  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is AuthFailure;

  @override
  Description describe(Description description) =>
      description.add('is-auth-failure');
}

/// Possible culprits for an [AuthFailure].
@Freezed()
sealed class AuthenticationError with _$AuthenticationError {
  /// The user's submitted email and password were unknown. Only returned from
  /// login attempts, as similar errors during user sign up use different
  /// values.
  const factory AuthenticationError.badEmailPassword() = BadEmailPasswordError;

  /// The user cancelled out of their social auth flow. Not actually a problem.
  const factory AuthenticationError.cancelledSocialAuth() =
      CancelledSocialAuthError;

  /// The user's attempted email address is already taken. Should only appear
  /// during user sign up or when syncing an account to secondary auth services.  ///
  const factory AuthenticationError.emailTaken() = EmailTakenError;

  /// The user's password fails to meet some criteria.
  const factory AuthenticationError.invalidPassword() = InvalidPasswordError;

  /// Two-factor authorization failed.
  const factory AuthenticationError.invalidCode() = InvalidCodeError;

  /// An auth service failed to terminate a user's session. This is likely the
  /// result of a very serious error in that system - possibly an outage.
  const factory AuthenticationError.logoutError() = LogoutError;

  /// The user's login or sign up attempt did not include an email address
  /// and/or did not include a password.
  const factory AuthenticationError.missingCredentials({
    required bool missingEmail,
    required bool missingPassword,
  }) = MissingCredentials;

  /// Stores the known/valid sign in methods for a given email address after
  /// a user attempts to sign in via the wrong method.
  const factory AuthenticationError.wrongMethod(Set<AuthProvider> methods) =
      WrongMethod;

  /// Catch-all for any failure not captured by other [AuthenticationError]
  /// values.
  const factory AuthenticationError.unknownError() = UnknownAuthError;

  const AuthenticationError._();

  /// Builder for an AuthenticationError from an [auth.FirebaseAuthException].
  factory AuthenticationError.fromFirebaseException(
    auth.FirebaseAuthException e,
  ) {
    if (e.code == 'account-exists-with-different-credential') {
      return const AuthenticationError.emailTaken();
    } else if (e.code == 'invalid-credential') {
      // Very unfortunate malformed thingy error. Probably Firebase's fault.
      _log.warning('Firebase error: Invalid-credential from $e');
      return const AuthenticationError.unknownError();
    } else if (e.code == 'operation-not-allowed') {
      _log.warning(
        'Attempted login with inactive social auth type. '
        'Activate desired type in Firebase console.',
      );
      return const AuthenticationError.unknownError();
    } else if (e.code == 'user-disabled') {
      _log.fine('Disabled user');
      return const AuthenticationError.badEmailPassword();
    } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      // Normal failed login type stuff
      _log.finer('Failed login: ${e.code}');
      return const AuthenticationError.badEmailPassword();
    } else if (e.code == 'invalid-verification-code' ||
        e.code == 'invalid-verification-id') {
      _log.info('2FA error: ${e.code} :: from $e');
      return const AuthenticationError.invalidCode();
    }
    _log.warning(
      'Unexpected FirebaseAuthException.code value: '
      '"${e.code}" :: $e',
    );
    return const AuthenticationError.unknownError();
  }

  /// Builder for an AuthenticationError from an [ApiError].
  factory AuthenticationError.fromApiError(ApiError error) {
    if (error.statusCode == 500) {
      _log.severe('Server error: $error');
      return const AuthenticationError.unknownError();
    } else if (error.statusCode == 409) {
      _log.fine('Email taken: $error');
      return const AuthenticationError.emailTaken();
    } else if (error.statusCode == 400 || error.statusCode == 404) {
      _log.fine('Failed rest authentication: $error');
      return const AuthenticationError.badEmailPassword();
    }
    _log.severe('Unanticipated ApiError: $error');
    return const AuthenticationError.unknownError();
  }

  /// Converts this error into something we can show to the user.
  String toDisplay() => switch (this) {
        BadEmailPasswordError() => 'Unknown email and password',
        CancelledSocialAuthError() => 'Social login terminated',
        EmailTakenError() => 'This email address is already associated with '
            'an account',
        InvalidPasswordError() => 'This password is invalid',
        InvalidCodeError() => 'Failed 2-factor authentication',
        LogoutError() => 'Failed to logout user',
        MissingCredentials(:final missingEmail, :final missingPassword) =>
          'Must supply '
              '${missingEmail ? "an email address" : ""}'
              '${missingEmail && missingPassword ? " and " : ""}'
              '${missingPassword ? "a password" : ""}',
        WrongMethod(:final methods) => 'Invalid authentication attempt. '
            'Account already exists. Login with '
            '${methods.map<String>(
                  (AuthProvider type) => _title(type.name),
                ).join(', or ')}',
        UnknownAuthError() => 'Unknown login error. Try again later.'
      };
}

String _title(String value) =>
    value.substring(0, 1).toUpperCase() + value.substring(1);
