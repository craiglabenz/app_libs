import 'package:example_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

class AuthSessionController {
  static Future<void> onAfterAuthUserCreated(
    Session session,
    AuthUserModel authUser, {
    required Transaction transaction,
  }) async {
    print('CREATING USER PROFILE AND SETTINGS FOR ${authUser.id}');
    return DatabaseUtil.runInTransactionOrSavepoint(
      session.db,
      transaction,
      (transaction) async {
        try {
          final now = DateTime.now().toUtc();
          final profile = AppUserProfile(
            id: authUser.id,
            updatedAt: now,
            createdAt: now,
          );
          await AppUserProfile.db.insertRow(session, profile);

          final settings = AppUserSettings(
            id: authUser.id,
            loggingId: UuidValue.fromString(const Uuid().v4()),
            updatedAt: now,
            createdAt: now,
          );
          await AppUserSettings.db.insertRow(session, settings);

          session.log(
            'Creating UserProfile and UserSettings for AuthUser${authUser.id}',
            level: LogLevel.debug,
          );
        } catch (e) {
          session.log(
            'Failed to create UserProfile and UserSettings for '
            'AuthUser${authUser.id}: $e',
            level: LogLevel.error,
          );
        }
      },
    );
  }
}
