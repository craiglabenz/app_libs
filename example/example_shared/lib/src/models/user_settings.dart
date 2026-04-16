import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// Private information about a user.
@freezed
sealed class UserSettingsModel with _$UserSettingsModel {
  const factory UserSettingsModel({
    /// User email address, possibly sourced from a variety of places.
    required String? email,

    /// Uuid prefixed to all logging statemenets to allow per-user filtering
    /// in logging backends.
    required String loggingId,
  }) = UserSettings;

  const factory UserSettingsModel.update({
    /// The user's new email. Only truthy values are considered here. To
    /// delete the `email` field, set [clearEmail] to true.
    String? email,

    /// Whether to clear the user's email address.
    @Default(false) bool clearEmail,
  }) = UserSettingsUpdate;

  const UserSettingsModel._();

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);
}

class UserSettingsModelConverter
    implements JsonConverter<UserSettingsModel, Map<String, dynamic>> {
  const UserSettingsModelConverter();

  @override
  UserSettingsModel fromJson(Map<String, dynamic> json) =>
      UserSettingsModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(UserSettingsModel obj) => obj.toJson();
}
