// import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/shared_data.dart';

/// {@template LogoutRequest}
/// {@endtemplate}
class LogoutRequest extends WriteApiRequest {
  /// {@macro LogoutRequest}
  const LogoutRequest({required super.url})
      : super(
          body: const <String, Object?>{},
        );
}

/// {@template LoginRequest}
/// Submits a login request to a [RestApi].
/// {@endtemplate}
class LoginRequest extends ReadApiRequest {
  /// {@macro LoginRequest}
  LoginRequest({
    required super.url,
    required String email,
    required String password,
  }) : super(params: {'email': email, 'password': password});
}

/// {@template LoadProfileRequest}
/// Submits a load profile request to a [RestApi].
/// {@endtemplate}
class LoadProfileRequest extends AuthenticatedReadApiRequest {
  /// {@macro LoadProfileRequest}
  const LoadProfileRequest({required super.url, required super.user});
}

/// {@template RegisterRequest}
/// Submits a user creation request to a [RestApi].
/// {@endtemplate}
class RegisterRequest extends WriteApiRequest {
  /// {@macro RegisterRequest}
  RegisterRequest({
    required super.url,
    required String email,
    required String password,
  }) : super(body: {'email': email, 'password': password});
}
