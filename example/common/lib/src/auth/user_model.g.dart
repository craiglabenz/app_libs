// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
    };

_$UserCompanionImpl _$$UserCompanionImplFromJson(Map<String, dynamic> json) =>
    _$UserCompanionImpl(
      id: json['id'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$$UserCompanionImplToJson(_$UserCompanionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
    };
