import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/src/models/user.dart' show AuthProvider;

part 'authentication_errors.freezed.dart';
part 'authentication_errors.g.dart';

/// Possible culprits for an a failed authorization attempt.
@Freezed()
sealed class AuthenticationError
    with _$AuthenticationError
    implements Exception {
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

  /// Forces a full logout to reset the session.
  const factory AuthenticationError.forceLogout() = ForceLogout;

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

  /// Attempting to create authentication data that already exists.
  const factory AuthenticationError.conflict() = AuthConflict;

  /// The API Key or JWT submitted to the server has expired.
  const factory AuthenticationError.expiredCredentials() = ExpiredCredentials;

  /// Stores the known/valid sign in methods for a given email address after
  /// a user attempts to sign in via the wrong method.
  const factory AuthenticationError.wrongMethod(Set<AuthProvider> methods) =
      WrongMethod;

  /// Catch-all for any failure not captured by other [AuthenticationError]
  /// values.
  const factory AuthenticationError.unknownError() = UnknownAuthError;

  factory AuthenticationError.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationErrorFromJson(json);

  const AuthenticationError._();

  /// Converts this error into something we can show to the user.
  String toDisplay() => switch (this) {
        ForceLogout() => throw Exception('Should not display [ForceLogout]'),
        BadEmailPasswordError() => 'Unknown email and password',
        CancelledSocialAuthError() => 'Social login terminated',
        EmailTakenError() => 'This email address is already in use',
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
        UnknownAuthError() => 'Unknown login error. Try again later.',
        ExpiredCredentials() => 'Expired credentials. Login again.',
        AuthConflict() => 'Request conflicts with existing user',
      };
}

String _title(String value) =>
    value.substring(0, 1).toUpperCase() + value.substring(1);
