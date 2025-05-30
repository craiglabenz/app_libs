import 'package:auth/auth.dart';
import 'package:shared_data/shared_data.dart';

/// App-aware extensions on [AuthUser].
extension AppAuthUser on AuthUser {
  /// Loads an AuthUser instance from the raw database row.
  static AuthUser fromDb(DbAuthUser dbUser) => AuthUser(
        id: dbUser.uid.uuid,
        apiKey: dbUser.apiKey,
      );
}

/// Loads an AuthUser instance from the raw database row.
AuthUser? authUserFromDb(DbAuthUser? dbUser) => dbUser != null
    ? AuthUser(
        id: dbUser.uid.uuid,
        apiKey: dbUser.apiKey,
      )
    : null;
