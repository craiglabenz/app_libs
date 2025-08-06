// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadEmailPasswordError _$BadEmailPasswordErrorFromJson(
        Map<String, dynamic> json) =>
    BadEmailPasswordError(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$BadEmailPasswordErrorToJson(
        BadEmailPasswordError instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

CancelledSocialAuthError _$CancelledSocialAuthErrorFromJson(
        Map<String, dynamic> json) =>
    CancelledSocialAuthError(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$CancelledSocialAuthErrorToJson(
        CancelledSocialAuthError instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

EmailTakenError _$EmailTakenErrorFromJson(Map<String, dynamic> json) =>
    EmailTakenError(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$EmailTakenErrorToJson(EmailTakenError instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

InvalidPasswordError _$InvalidPasswordErrorFromJson(
        Map<String, dynamic> json) =>
    InvalidPasswordError(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$InvalidPasswordErrorToJson(
        InvalidPasswordError instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

InvalidCodeError _$InvalidCodeErrorFromJson(Map<String, dynamic> json) =>
    InvalidCodeError(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$InvalidCodeErrorToJson(InvalidCodeError instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

LogoutError _$LogoutErrorFromJson(Map<String, dynamic> json) => LogoutError(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$LogoutErrorToJson(LogoutError instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

MissingCredentials _$MissingCredentialsFromJson(Map<String, dynamic> json) =>
    MissingCredentials(
      missingEmail: json['missingEmail'] as bool,
      missingPassword: json['missingPassword'] as bool,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MissingCredentialsToJson(MissingCredentials instance) =>
    <String, dynamic>{
      'missingEmail': instance.missingEmail,
      'missingPassword': instance.missingPassword,
      'runtimeType': instance.$type,
    };

AuthConflict _$AuthConflictFromJson(Map<String, dynamic> json) => AuthConflict(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$AuthConflictToJson(AuthConflict instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

ExpiredCredentials _$ExpiredCredentialsFromJson(Map<String, dynamic> json) =>
    ExpiredCredentials(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ExpiredCredentialsToJson(ExpiredCredentials instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

WrongMethod _$WrongMethodFromJson(Map<String, dynamic> json) => WrongMethod(
      (json['methods'] as List<dynamic>)
          .map((e) => $enumDecode(_$AuthProviderEnumMap, e))
          .toSet(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WrongMethodToJson(WrongMethod instance) =>
    <String, dynamic>{
      'methods': instance.methods.toList(),
      'runtimeType': instance.$type,
    };

const _$AuthProviderEnumMap = {
  AuthProvider.anonymous: 'anonymous',
  AuthProvider.google: 'google',
  AuthProvider.apple: 'apple',
  AuthProvider.email: 'email',
};

UnknownAuthError _$UnknownAuthErrorFromJson(Map<String, dynamic> json) =>
    UnknownAuthError(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UnknownAuthErrorToJson(UnknownAuthError instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };
