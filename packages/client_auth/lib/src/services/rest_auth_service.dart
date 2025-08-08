import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('client_auth.RestAuth');

/// {@template RestAuth}
/// Handler for authentication set-up with the REST API.
///
/// Authorization is primarily handled with Firebase Auth, for the purposes of
/// social login, password resets, and other complicated machinery available
/// there. However, to then communicate with the REST API that powers Wash Day,
/// successful Firebase authentication requests are synced here, creating
/// two active sessions.
/// {@endtemplate}
class RestAuth<T extends AuthUser> implements AuthService {
  /// {@macro RestAuth}
  RestAuth({
    required this.api,
    required this.logInUrl,
    required this.logOutUrl,
    required this.registerUrl,
  });

  /// Communicator with the RESTful API this app needs to communicate with.
  final RestApi api;

  /// Location of the login resource.
  final ApiUrl logInUrl;

  /// Location of the logOut resource.
  final ApiUrl logOutUrl;

  /// Location of the registration resource.
  final ApiUrl registerUrl;

  @override
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final res = await api.get(
      LoginRequest(url: logInUrl, email: email, password: password),
    );
    switch (res) {
      case ApiSuccess():
        {
          return AuthSuccess(
            AuthUser.fromJson(
              Map<String, dynamic>.from(res.jsonOrRaise)
                ..addAll(<String, dynamic>{'isNewUser': false}),
            ),
            isNewUser: false,
          );
        }
      case ApiError():
        {
          return AuthResponse.fromApiError(res);
        }
    }
  }

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    final res = await api.post(
        RegisterRequest(url: registerUrl, email: email, password: password));
    switch (res) {
      case ApiSuccess():
        {
          return AuthSuccess(
            AuthUser.fromJson(
              Map<String, dynamic>.from(res.jsonOrRaise)
                ..addAll(<String, dynamic>{'isNewUser': true}),
            ),
            isNewUser: true,
          );
        }
      case ApiError():
        {
          return AuthResponse.fromApiError(res);
        }
    }
  }

  @override
  void dispose() {}

  @override
  Future<AuthFailure?> logOut() async {
    final res = await api.post(LogoutRequest(url: logOutUrl));
    if (res is ApiError) {
      _log.severe('Failed to logout user from $this');
      return const AuthFailure(AuthenticationError.logoutError());
    }
    return null;
  }

  // @override
  // Future<ReadResult<T>> loadUserProfile(
  //   AuthUser user,
  //   RequestDetails<T> details,
  // ) async {
  //   final res = await api.get(
  //     requestBuilder.buildLoadProfileRequest(user),
  //   );

  //   switch (res) {
  //     case ApiSuccess():
  //       {
  //         return ReadSuccess<T>(
  //           userBuilder(Map<String, dynamic>.from(res.jsonOrRaise)),
  //           details: details,
  //         );
  //       }
  //     case ApiError():
  //       {
  //         _log.severe('Error loading profile :: ${res.errorString}');
  //         return ReadResult.fromApiError(res);
  //       }
  //   }
  // }

  // @override
  // Future<WriteResult<T>> updateUserProfile(
  //   AuthUser user,
  //   BaseUser profile,
  //   RequestDetails<T> details,
  // ) async {
  //   final res = await api.update(
  //     requestBuilder.buildUpdateProfileRequest(user, profile),
  //     partial: true,
  //   );
  //   switch (res) {
  //     case ApiSuccess():
  //       {
  //         return WriteSuccess<T>(
  //           userBuilder(Map<String, dynamic>.from(res.jsonOrRaise)),
  //           details: details,
  //         );
  //       }
  //     case ApiError():
  //       {
  //         _log.severe('Error updating profile :: ${res.errorString}');
  //         return WriteResult.fromApiError(res);
  //       }
  //   }
  // }
}
