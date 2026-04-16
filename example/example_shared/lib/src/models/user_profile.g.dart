// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
  id: json['id'] as String,
  userName: json['userName'] as String?,
  fullName: json['fullName'] as String?,
  imageUrl: json['imageUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'fullName': instance.fullName,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'runtimeType': instance.$type,
    };

_UserProfileUpdate _$UserProfileUpdateFromJson(Map<String, dynamic> json) =>
    _UserProfileUpdate(
      userName: json['userName'] as String?,
      fullName: json['fullName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      clearUserName: json['clearUserName'] as bool? ?? false,
      clearFullName: json['clearFullName'] as bool? ?? false,
      clearImageUrl: json['clearImageUrl'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UserProfileUpdateToJson(_UserProfileUpdate instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'fullName': instance.fullName,
      'imageUrl': instance.imageUrl,
      'clearUserName': instance.clearUserName,
      'clearFullName': instance.clearFullName,
      'clearImageUrl': instance.clearImageUrl,
      'runtimeType': instance.$type,
    };
