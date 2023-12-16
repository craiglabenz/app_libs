import 'dart:collection';

import 'package:client_auth/client_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_data/shared_data.dart';

/// Scriptable auth results from the application server.
class FakeRestAuth<T extends BaseUser> implements BaseRestAuth<T> {
  FakeRestAuth({
    Queue<AuthUserOrError>? loginResults,
    Queue<AuthUserOrError>? registerResults,
    Queue<Either<ApiError, T>>? profileResults,
  })  : loginResults = loginResults ?? Queue<AuthUserOrError>(),
        profileResults = profileResults ?? Queue<Either<ApiError, T>>(),
        registerResults = registerResults ?? Queue<AuthUserOrError>();

  final Queue<AuthUserOrError> loginResults;
  final Queue<AuthUserOrError> registerResults;
  final Queue<Either<ApiError, T>> profileResults;

  @override
  Future<AuthUserOrError> login({
    required String email,
    required String password,
  }) =>
      Future.value(loginResults.removeFirst());

  @override
  Future<AuthUserOrError> register({
    required String email,
    required String password,
  }) =>
      Future.value(registerResults.removeFirst());

  @override
  Future<Either<ApiError, T>> loadUserProfile(AuthUser user) =>
      Future.value(profileResults.removeFirst());

  @override
  Future<Either<ApiError, T>> updateUserProfile(AuthUser user, Json newData) =>
      Future.value(profileResults.removeFirst());
}
