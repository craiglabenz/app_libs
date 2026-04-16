// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
  allProviders: (json['allProviders'] as List<dynamic>)
      .map((e) => $enumDecode(_$AuthProviderEnumMap, e))
      .toSet(),
  settings: UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{
      'profile': instance.profile,
      'allProviders': instance.allProviders
          .map((e) => _$AuthProviderEnumMap[e]!)
          .toList(),
      'settings': instance.settings,
    };

const _$AuthProviderEnumMap = {
  AuthProvider.anonymous: 'anonymous',
  AuthProvider.email: 'email',
  AuthProvider.apple: 'apple',
  AuthProvider.google: 'google',
};
