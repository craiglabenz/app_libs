// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
      id: json['id'] as String,
      apiKey: json['apiKey'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
      'id': instance.id,
      'apiKey': instance.apiKey,
      'email': instance.email,
    };
