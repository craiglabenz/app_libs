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
sealed class SocialAuthResponse with _$SocialAuthResponse {
  /// Container for a successful authorization attempt.
  const factory SocialAuthResponse.success(
    SocialUser user, {
    SocialCredential? credential,
  }) = SocialAuthSuccess;

  /// Container for a failed authorization attempt.
  const factory SocialAuthResponse.failure(AuthenticationError error) =
      SocialAuthFailure;
  const SocialAuthResponse._();

  /// Builder for an AuthFailure from an [auth.FirebaseAuthException].
  factory SocialAuthResponse.fromFirebaseException(
    auth.FirebaseAuthException e, [
    AuthenticationError? invalidCredentialResult,
  ]) {
    return SocialAuthFailure(
      authErrorfromFirebaseException(e, invalidCredentialResult),
    );
  }

  /// Convenience getter for the [SocialUser]. Only call this after ruling out
  /// the possibility of an [SocialAuthFailure].
  SocialUser getOrRaise() {
    if (this is SocialAuthFailure) {
      throw Exception('Unexpected AuthFailure in getOrRaise');
    }
    return (this as SocialAuthSuccess).user;
  }
}

/// Testing matcher for whether this was a success.
const Matcher isSocialAuthSuccess = _IsSuccess();

class _IsSuccess extends Matcher {
  const _IsSuccess();
  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is SocialAuthSuccess;

  @override
  Description describe(Description description) =>
      description.add('is-social-auth-success');
}

/// Testing matcher for whether this was a success.
const Matcher isSocialAuthFailure = _IsFailure();

class _IsFailure extends Matcher {
  const _IsFailure();
  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is SocialAuthFailure;

  @override
  Description describe(Description description) =>
      description.add('is-social-auth-failure');
}

/// Builder for an AuthenticationError from an [auth.FirebaseAuthException].
AuthenticationError authErrorfromFirebaseException(
  auth.FirebaseAuthException e, [
  AuthenticationError? invalidCredentialResult,
]) {
  if (e.code == 'account-exists-with-different-credential' ||
      e.code == 'email-already-in-use') {
    return const AuthenticationError.emailTaken();
  } else if (e.code == 'invalid-credential') {
    // Very unfortunate malformed thingy error. Probably Firebase's fault.
    _log.warning('Firebase error: Invalid-credential from $e');
    return invalidCredentialResult ?? const AuthenticationError.unknownError();
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
