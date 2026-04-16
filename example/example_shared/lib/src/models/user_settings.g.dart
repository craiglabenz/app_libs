// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
  email: json['email'] as String?,
  loggingId: json['loggingId'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'email': instance.email,
      'loggingId': instance.loggingId,
      'runtimeType': instance.$type,
    };

UserSettingsUpdate _$UserSettingsUpdateFromJson(Map<String, dynamic> json) =>
    UserSettingsUpdate(
      email: json['email'] as String?,
      clearEmail: json['clearEmail'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UserSettingsUpdateToJson(UserSettingsUpdate instance) =>
    <String, dynamic>{
      'email': instance.email,
      'clearEmail': instance.clearEmail,
      'runtimeType': instance.$type,
    };
