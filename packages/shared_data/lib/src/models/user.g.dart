// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
      id: json['id'] as String,
      privateId: json['privateId'] as String,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      provider: $enumDecode(_$AuthProviderEnumMap, json['provider']),
      allProviders: (json['allProviders'] as List<dynamic>)
          .map((e) => $enumDecode(_$AuthProviderEnumMap, e))
          .toSet(),
    );

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'privateId': instance.privateId,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'provider': _$AuthProviderEnumMap[instance.provider]!,
      'allProviders':
          instance.allProviders.map((e) => _$AuthProviderEnumMap[e]!).toList(),
    };

const _$AuthProviderEnumMap = {
  AuthProvider.anonymous: 'anonymous',
  AuthProvider.google: 'google',
  AuthProvider.apple: 'apple',
  AuthProvider.email: 'email',
};
