// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSuccess _$AuthSuccessFromJson(Map<String, dynamic> json) => AuthSuccess(
      const AuthUserConverter().fromJson(json['user'] as Map<String, Object?>),
      apiToken: json['apiToken'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$AuthSuccessToJson(AuthSuccess instance) =>
    <String, dynamic>{
      'user': const AuthUserConverter().toJson(instance.user),
      'apiToken': instance.apiToken,
      'runtimeType': instance.$type,
    };

AuthFailure _$AuthFailureFromJson(Map<String, dynamic> json) => AuthFailure(
      AuthenticationError.fromJson(json['error'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$AuthFailureToJson(AuthFailure instance) =>
    <String, dynamic>{
      'error': instance.error,
      'runtimeType': instance.$type,
    };
