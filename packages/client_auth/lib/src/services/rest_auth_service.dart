import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('client_auth.RestAuth');

typedef AuthUserOrError = Either<AuthenticationError, AuthUser>;

/// Handler for authentication set-up with the REST API.
///
/// Authorization is primarily handled with Firebase Auth, for the purposes of
/// social login, password resets, and other complicated machinery available
/// there. However, to then communicate with the REST API that powers Wash Day,
/// successful Firebase authentication requests are synced here, creating
/// two active sessions.
abstract class BaseRestAuth<T extends BaseUser> {
  Future<AuthUserOrError> login({
    required String email,
    required String password,
  });
  Future<AuthUserOrError> register({
    required String email,
    required String password,
  });
  Future<Either<ApiError, T>> loadUserProfile(AuthUser user);
  Future<Either<ApiError, T>> updateUserProfile(AuthUser user, Json newData);
}

class RestAuth<T extends BaseUser> implements BaseRestAuth<T> {
  RestAuth({
    required this.api,
    required this.requestBuilder,
    required this.userBuilder,
  });
  final RestApi api;
  final RestAuthRequestBuilder requestBuilder;
  final T Function(Json) userBuilder;

  @override
  Future<Either<ApiError, T>> loadUserProfile(AuthUser user) async {
    final res = await api.get(
      requestBuilder.buildLoadProfileRequest(user),
    );
    return res.map(
      error: (ApiError res) {
        _log.severe('Profile Error ${res.url} :: ${res.errorString}');
        return Left(res);
      },
      success: (ApiSuccess res) => Right(
        userBuilder(Map<String, dynamic>.from(res.jsonOrRaise)),
      ),
    );
  }

  @override
  Future<Either<ApiError, T>> updateUserProfile(
    AuthUser user,
    Json newData,
  ) async {
    final res = await api.update(
      requestBuilder.buildUpdateProfileRequest(user, newData),
      partial: true,
    );
    return res.map(
      error: (ApiError res) {
        _log.severe('Error updating profile :: ${res.errorString}');
        return Left(res);
      },
      success: (ApiSuccess res) => Right(
        userBuilder(Map<String, dynamic>.from(res.jsonOrRaise)),
      ),
    );
  }

  @override
  Future<AuthUserOrError> login({
    required String email,
    required String password,
  }) async {
    final res = await api.get(
      requestBuilder.buildLoginRequest(email: email, password: password),
    );
    return res.map(
      success: (ApiSuccess res) => Right(
        AuthUser.fromJson(
          Map<String, dynamic>.from(res.jsonOrRaise)
            ..addAll(<String, dynamic>{'isNewUser': false}),
        ),
      ),
      error: (ApiError res) {
        _log.severe('Login Error ${res.url} :: ${res.errorString}');
        return Left(AuthenticationError.fromApiError(res));
      },
    );
  }

  @override
  Future<AuthUserOrError> register({
    required String email,
    required String password,
  }) async {
    final res = await api.post(
      requestBuilder.buildRegisterRequest(email: email, password: password),
    );
    return res.map(
      success: (ApiSuccess res) => Right(
        AuthUser.fromJson(
          Map<String, dynamic>.from(res.jsonOrRaise)
            ..addAll(<String, dynamic>{'isNewUser': true}),
        ),
      ),
      error: (ApiError res) {
        _log.severe('Register Error ${res.url}: ${res.errorString}');
        return Left(AuthenticationError.fromApiError(res));
      },
    );
  }
}

abstract class RestAuthRequestBuilder {
  const RestAuthRequestBuilder();
  ApiUrl loadProfileUrl(AuthUser user);
  ApiUrl updateProfileUrl(AuthUser user);
  ApiUrl get loginUrl;
  ApiUrl get registerUrl;

  LoadProfile buildLoadProfileRequest(AuthUser user) =>
      LoadProfile(url: loadProfileUrl(user), user: user);

  UpdateProfile buildUpdateProfileRequest(AuthUser user, Json data) =>
      UpdateProfile(url: updateProfileUrl(user), user: user, body: data);

  LoginRequest buildLoginRequest({
    required String email,
    required String password,
  }) =>
      LoginRequest(url: loginUrl, email: email, password: password);

  RegisterRequest buildRegisterRequest({
    required String email,
    required String password,
  }) =>
      RegisterRequest(url: registerUrl, email: email, password: password);
}
