import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

/// Schema definition for AuthUsers.
@DataClassName('DbAuthUser')
class AuthUsers extends Table {
  /// Primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Public-facing pseudo-primary key.
  UuidColumn get uid => customType(PgTypes.uuid).withDefault(genRandomUuid())();

  /// Token for requests from the client.
  TextColumn get apiKey => text().withLength(min: 32, max: 32)();

  /// Email of this user.
  TextColumn get email => text().nullable()();

  /// Flag to disable accounts.
  IntColumn get isActive => integer().withDefault(const Constant<int>(1))();

  /// Hashed store of the user's password.
  TextColumn get password => text().withLength(min: 40)();

  /// DateTime of user's last activity.
  TimestampColumn get lastLogin =>
      customType(PgTypes.timestampTimezone).nullable()();

  /// DateTime of account creation.
  TimestampColumn get createdAt =>
      customType(PgTypes.timestampTimezone).withDefault(now())();

  /// DateTime of last update.
  TimestampColumn get updatedAt =>
      customType(PgTypes.timestampTimezone).withDefault(now())();
}
