// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateProfileRequestBodyImpl _$$UpdateProfileRequestBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateProfileRequestBodyImpl(
      userCompanion:
          UserCompanion.fromJson(json['userCompanion'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UpdateProfileRequestBodyImplToJson(
        _$UpdateProfileRequestBodyImpl instance) =>
    <String, dynamic>{
      'userCompanion': instance.userCompanion,
    };
