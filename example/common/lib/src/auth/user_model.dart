import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/shared_data.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// {@template User}
/// Primary data record for users of the application.
///
/// See also:
///  * [UserCompanion] which has optional fields to support creating objects and
///    partial updates.
/// {@endtemplate}
@Freezed()
class User extends BaseUser with _$User {
  /// {@macro User}
  const factory User({
    required String id,
    required String username,
  }) = _User;

  // Hidden `const` constructor which is never used, but exists only to make
  // other methods possible.
  const User._() : super(id: '', username: '');

  /// Json deserializer for [User] instances.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// {@template UserCompanion}
/// Variant of [User] class with optional fields for creating new records and
/// partial updates.
/// {@endtemplate}
@Freezed()
class UserCompanion with _$UserCompanion {
  /// {@macro UserCompanion}
  const factory UserCompanion({
    String? id,
    String? username,
  }) = _UserCompanion;

  /// Json deserializer for [UserCompanion] instances.
  factory UserCompanion.fromJson(Json json) => _$UserCompanionFromJson(json);
}
