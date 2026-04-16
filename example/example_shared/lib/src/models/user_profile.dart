import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Public information about a user.
///
/// Replaces the default Serverpod `UserProfile` model.
@freezed
sealed class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    /// UserProfiles share a primary key with Serverpod [AuthUser] records
    required String id,
    required String? userName,
    required String? fullName,
    required String? imageUrl,
    required DateTime createdAt,
  }) = UserProfile;

  const factory UserProfileModel.update({
    /// The user's new userName. Only truthy values are considered here. To
    /// delete the `userName` field, set [clearUserName] to true.
    String? userName,

    /// The user's new fullName. Only truthy values are considered here. To
    /// delete the `fullName` field, set [clearFullName] to true.
    String? fullName,

    /// The user's new imageUrl. Only truthy values are considered here. To
    /// delete the `imageUrl` field, set [clearImageUrl] to true.
    String? imageUrl,

    /// If true, delete any userName value from the database.
    @Default(false) bool clearUserName,

    /// If true, delete any fullName value from the database.
    @Default(false) bool clearFullName,

    /// If true, delete any imageUrl value from the database.
    @Default(false) bool clearImageUrl,
  }) = _UserProfileUpdate;

  const UserProfileModel._();

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// {@template UserProfile.displayNamePublic}
  /// Displayable version of this name that does not include the user's email as
  /// an option, which means this can be shown to other users.
  /// {@endtemplate}
  String? get displayNamePublic => userName.isTruthy ? userName! : null;
}

class UserProfileModelConverter
    implements JsonConverter<UserProfileModel, Map<String, dynamic>> {
  const UserProfileModelConverter();

  @override
  UserProfileModel fromJson(Map<String, dynamic> json) =>
      UserProfileModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(UserProfileModel obj) => obj.toJson();
}

///
extension on String? {
  /// Python-style truthy string, where both null and an empty string are false.
  bool get isTruthy => this != null && this!.isNotEmpty;
}
