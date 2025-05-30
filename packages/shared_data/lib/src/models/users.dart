// ignore_for_file: always_put_required_named_parameters_first

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/shared_data.dart';

part 'users.freezed.dart';
part 'users.g.dart';

/// {@template AuthUser}
/// Container for the active user's information. Only used for authorization and
/// permission things; the active user is likely to also appear in the set of
/// [BaseUser] objects.
///
/// It is typical for applications to add an extension method to [AuthUser]
/// which loads that application's concrete version of [BaseUser]. Such an
/// extension method may look like this:
///
/// ```dart
/// RelatedUser get user => RelatedModel<User>(id, repository: ...);
/// ```
///
/// See also:
///   [BaseUser] - The container for users of the app regardless of whether or
///                not they are the active user.
/// {@endtemplate}
@Freezed()
abstract class AuthUser extends Model with _$AuthUser {
  /// {@macro AuthUser}
  const factory AuthUser({
    /// Unique identifier.
    required String id,

    /// User's email address. Null for anonymous users and possibly some social
    /// auth situations.
    String? email,

    /// Origin timestamp of the user.
    required DateTime createdAt,

    /// Identity verifying provider for this session.
    required AuthProvider provider,

    /// All providers the user has attached to their account.
    required Set<AuthProvider> allProviders,
  }) = _AuthUser;

  const AuthUser._();

  /// Deserializes a raw data into an [AuthUser] instance.
  factory AuthUser.fromJson(Json json) => _$AuthUserFromJson(json);

  /// True if the original source of this user's session was
  /// [AuthProvider.anonymous]. This means a user's session cannot be recovered
  /// if they lose access to their device.
  bool get isAnonymous => provider == AuthProvider.anonymous;

  /// True if the original source of this user's session was something other
  /// than [AuthProvider.anonymous]. This means a user's session CAN be
  /// recovered if they lose access to their device.
  bool get isNotAnonymous => provider != AuthProvider.anonymous;
}

/// Sources of user authentication.
enum AuthProvider {
  /// Indicates a user's account was not verified by any third party service
  /// or even an email and password combination. The app knows close to nothing
  /// about these users.
  @JsonValue('anonymous')
  anonymous,

  /// Auth provided by Google SSO.
  @JsonValue('google')
  google,

  /// Auth provided by Apple SSO.
  @JsonValue('apple')
  apple,

  /// Auth provided by an email and password.
  @JsonValue('email')
  email,
}

/// {@template BaseUser}
/// Container for all users of the app in relation to activities like posts,
/// likes, or similar.
///
/// Apps should extend this class with their own `User` model and supply that
/// as the generic type whenever they see `Class<T extends BaseUser>`.
/// {@endtemplate}
abstract class BaseUser extends Model {
  /// {@macro BaseUser}
  const BaseUser({
    required super.id,
    required this.username,
    this.photo,
  });

  /// Social handle of this [BaseUser] in the app.
  final String username;

  /// Cloud location of this user's profile photo.
  final String? photo;
}
