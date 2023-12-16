import 'package:client_auth/client_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

part 'errors.freezed.dart';

final _log = Logger('client_auth.AuthenticationError');

@Freezed()
class AuthenticationError with _$AuthenticationError {
  const AuthenticationError._();
  const factory AuthenticationError.badEmailPassword() = BadEmailPasswordError;
  const factory AuthenticationError.cancelledSocialAuth() =
      CancelledSocialAuthError;
  const factory AuthenticationError.emailTaken() = EmailTakenError;
  const factory AuthenticationError.invalidPassword() = InvalidPasswordError;
  const factory AuthenticationError.invalidCode() = InvalidCodeError;
  const factory AuthenticationError.logoutError() = LogoutError;
  const factory AuthenticationError.missingCredentials({
    required bool missingEmail,
    required bool missingPassword,
  }) = MissingCredentials;

  /// Stores the known/valid sign in methods for a given email address after
  /// a user attempts to sign in via the wrong method.
  const factory AuthenticationError.wrongMethod(Set<LoginType> methods) =
      WrongMethod;
  const factory AuthenticationError.unknownError() = UnknownAuthError;

  factory AuthenticationError.fromFirebaseException(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      return const AuthenticationError.emailTaken();
    } else if (e.code == 'invalid-credential') {
      // Very unfortunate malformed thingy error. Probably Firebase's fault.
      _log.warning('Firebase error: Invalid-credential from $e');
      return const AuthenticationError.unknownError();
    } else if (e.code == 'operation-not-allowed') {
      _log.warning('Attempted login with inactive social auth type. Wat.');
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

  String toDisplay() => map<String>(
        badEmailPassword: (_) => 'Unknown email and password',
        cancelledSocialAuth: (_) => 'Login flow cancelled',
        emailTaken: (_) => 'This email address is already associated with '
            'an account',
        invalidPassword: (_) => 'This password is invalid',
        invalidCode: (_) => 'Failed 2-factor authentication',
        logoutError: (_) => 'Failed to logout',
        missingCredentials: (_) => 'Must supply an email and password',
        wrongMethod: (err) {
          final methods = err.methods
              .map<String>((LoginType type) => _title(type.name))
              .join(', or ');
          return 'Account already exists. Login with $methods';
        },
        unknownError: (_) => 'Unknown login error. Try again later.',
      );
}

String _title(String value) =>
    value.substring(0, 1).toUpperCase() + value.substring(1);
