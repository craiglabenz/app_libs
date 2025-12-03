import 'package:data_layer/data_layer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:matcher/matcher.dart';
import 'package:shared_data/shared_data.dart';

part 'auth_responses.freezed.dart';
part 'auth_responses.g.dart';

final _log = Logger('client_auth.AuthResponse');

/// Union type for authorization attempts, always appearing in the form of
/// either an [AuthSuccess] or an [AuthFailure].
@Freezed()
sealed class AuthResponse with _$AuthResponse {
  /// Container for a successful authorization attempt.
  const factory AuthResponse.success(
    @AuthUserConverter() AuthUser user, {
    required bool isNewUser,
    String? apiToken,
  }) = AuthSuccess;

  /// Container for a failed authorization attempt.
  const factory AuthResponse.failure(AuthenticationError error) = AuthFailure;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  const AuthResponse._();

  /// Builder for an AuthFailure from an [ApiError].
  factory AuthResponse.fromApiError(ApiError e) {
    return AuthFailure(authenticationErrorFromApiError(e));
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

/// Builder for an AuthenticationError from an [ApiError].
AuthenticationError authenticationErrorFromApiError(ApiError error) {
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
