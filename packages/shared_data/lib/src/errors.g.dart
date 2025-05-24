// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvalidApiKey _$InvalidApiKeyFromJson(Map<String, dynamic> json) =>
    InvalidApiKey(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$InvalidApiKeyToJson(InvalidApiKey instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

InvalidEmail _$InvalidEmailFromJson(Map<String, dynamic> json) => InvalidEmail(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$InvalidEmailToJson(InvalidEmail instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

PasswordTooShort _$PasswordTooShortFromJson(Map<String, dynamic> json) =>
    PasswordTooShort(
      (json['minimumLength'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$PasswordTooShortToJson(PasswordTooShort instance) =>
    <String, dynamic>{
      'minimumLength': instance.minimumLength,
      'runtimeType': instance.$type,
    };
