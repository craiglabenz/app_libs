/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:shared_data/src/models/auth_responses.dart' as _i3;
import 'package:shared_data/src/models/user.dart' as _i4;

/// Access point for user authentication.
/// {@category Endpoint}
class EndpointAuthUser extends _i1.EndpointRef {
  EndpointAuthUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth.authUser';

  /// Loads user information for the currently authenticated user.
  _i2.Future<_i3.AuthResponse> validateKey() =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth.authUser',
        'validateKey',
        {},
      );

  /// Creates a new anonymous user.
  _i2.Future<_i3.AuthResponse> createAnonymousUser(
          {required String socialId}) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth.authUser',
        'createAnonymousUser',
        {'socialId': socialId},
      );

  /// Attempts to verify an existing user account by email and password.
  _i2.Future<_i3.AuthResponse> logInEmailUser({
    required String socialId,
    required _i4.EmailCredential credential,
  }) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth.authUser',
        'logInEmailUser',
        {
          'socialId': socialId,
          'credential': credential,
        },
      );

  /// Adds an [AuthUserEmail] record to the associated [AuthUserDb].
  _i2.Future<_i3.AuthResponse> addEmailToUser({
    required String socialId,
    required _i4.EmailCredential credential,
  }) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth.authUser',
        'addEmailToUser',
        {
          'socialId': socialId,
          'credential': credential,
        },
      );

  /// Attempts to create a new account secured by an email and password.
  _i2.Future<_i3.AuthResponse> createUserWithEmailAndPassword({
    required String socialId,
    required _i4.EmailCredential credential,
  }) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth.authUser',
        'createUserWithEmailAndPassword',
        {
          'socialId': socialId,
          'credential': credential,
        },
      );

  /// Adds an [AuthUserApple] record to the associated [AuthUserDb].
  _i2.Future<_i3.AuthResponse> addAppleToUser({
    required String socialId,
    required _i4.AppleCredential credential,
  }) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth.authUser',
        'addAppleToUser',
        {
          'socialId': socialId,
          'credential': credential,
        },
      );

  /// Adds an [AuthUserGoogle] record to the associated [AuthUserDb].
  _i2.Future<_i3.AuthResponse> addGoogleToUser({
    required String socialId,
    required _i4.GoogleCredential credential,
  }) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth.authUser',
        'addGoogleToUser',
        {
          'socialId': socialId,
          'credential': credential,
        },
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    authUser = EndpointAuthUser(this);
  }

  late final EndpointAuthUser authUser;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup =>
      {'auth.authUser': authUser};
}
