// import 'package:example_client/example_client.dart';
import 'package:example_shared/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

// Update this per-app to include whatever Idps are supported.
/// The IdPs that the user can connect.
enum AuthProvider { anonymous, email, apple, google }

/// Contains all information about the active user.
@freezed
abstract class AuthSession with _$AuthSession {
  /// Creates a new [AuthSession].
  const factory AuthSession({
    /// The active user's profile.
    required UserProfile profile,

    /// All Idps the user has connected.
    required Set<AuthProvider> allProviders,

    /// The active user's settings.
    required UserSettings settings,
  }) = _AuthSession;
  const AuthSession._();

  /// Json serializer.
  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  /// The unique identifier for the authenticated user.
  String get authUserId => profile.id;

  /// True if the user has connected an Idp other than the AnonymousIdp.
  bool get isNotAnonymous =>
      allProviders.where((p) => p != .anonymous).isNotEmpty;

  /// True if the user has ONLY connected the anonymous Idp.
  bool get isAnonymous => !isNotAnonymous;

  /// Displayable version of this name that includes the user's email as an
  /// option, which means this should only be shown to the user themselves.
  String? get displayNamePrivate {
    if (profile.userName.isTruthy) {
      return profile.userName!;
    }
    if (settings.email.isTruthy) {
      return settings.email!;
    }
    return null;
  }

  /// {@macro UserProfile.displayNamePublic}
  String? get displayNamePublic => profile.displayNamePublic;

  /// True if the user's email address is known.
  bool get hasEmail => settings.email.isTruthy;
}

///
extension on String? {
  /// Python-style truthy string, where both null and an empty string are false.
  bool get isTruthy => this != null && this!.isNotEmpty;
}
