// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
      id: json['id'] as String,
      jwt: json['jwt'] as String?,
      loggingId: json['loggingId'] as String,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAuthProvider:
          $enumDecode(_$AuthProviderEnumMap, json['lastAuthProvider']),
      allProviders: (json['allProviders'] as List<dynamic>)
          .map((e) => $enumDecode(_$AuthProviderEnumMap, e))
          .toSet(),
    );

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'jwt': instance.jwt,
      'loggingId': instance.loggingId,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastAuthProvider': _$AuthProviderEnumMap[instance.lastAuthProvider]!,
      'allProviders':
          instance.allProviders.map((e) => _$AuthProviderEnumMap[e]!).toList(),
    };

const _$AuthProviderEnumMap = {
  AuthProvider.anonymous: 'anonymous',
  AuthProvider.google: 'google',
  AuthProvider.apple: 'apple',
  AuthProvider.email: 'email',
};

EmailCredential _$EmailCredentialFromJson(Map<String, dynamic> json) =>
    EmailCredential(
      userId: json['userId'] as String,
      email: json['email'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$EmailCredentialToJson(EmailCredential instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'runtimeType': instance.$type,
    };

AppleCredential _$AppleCredentialFromJson(Map<String, dynamic> json) =>
    AppleCredential(
      userId: json['userId'] as String,
      userIdentifier: json['userIdentifier'] as String,
      givenName: json['givenName'] as String?,
      familyName: json['familyName'] as String?,
      email: json['email'] as String?,
      authorizationCode: json['authorizationCode'] as String,
      identityToken: json['identityToken'] as String?,
      state: json['state'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$AppleCredentialToJson(AppleCredential instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userIdentifier': instance.userIdentifier,
      'givenName': instance.givenName,
      'familyName': instance.familyName,
      'email': instance.email,
      'authorizationCode': instance.authorizationCode,
      'identityToken': instance.identityToken,
      'state': instance.state,
      'runtimeType': instance.$type,
    };

GoogleCredential _$GoogleCredentialFromJson(Map<String, dynamic> json) =>
    GoogleCredential(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String?,
      email: json['email'] as String,
      uniqueId: json['uniqueId'] as String,
      photoUrl: json['photoUrl'] as String?,
      idToken: json['idToken'] as String?,
      serverAuthCode: json['serverAuthCode'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$GoogleCredentialToJson(GoogleCredential instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'email': instance.email,
      'uniqueId': instance.uniqueId,
      'photoUrl': instance.photoUrl,
      'idToken': instance.idToken,
      'serverAuthCode': instance.serverAuthCode,
      'runtimeType': instance.$type,
    };
