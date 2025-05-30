import 'package:auth/auth.dart';
import 'package:common/common.dart';
import 'package:dartz/dartz.dart';
import 'package:db/db.dart' as db;
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';

part 'auth_db.g.dart';

/// Either a successfully loaded [User] or a fatal error.
typedef UserOrDatabaseError = Either<db.DatabaseError, User>;

/// {@template AuthDb}
/// {@endtemplate}
@DriftDatabase(tables: [AuthUsers])
class AuthDb extends _$AuthDb {
  /// {@macro AuthDb}
  AuthDb(super.e);

  @override
  int get schemaVersion => 1;
}

/// Auth-related functions for the Database object.
// class AuthDb {
  // Future<UserOrDatabaseError> getUserByApiKey(String apiKey) {}
  // Future<UserOrDatabaseError> getUserByEmail(String email) {}
  // Future<UserOrDatabaseError> loadUserWithPassword({
  //   required String email,
  //   required String hashedPassword,
  // }) {}
  // Future<UserOrDatabaseError> createUser({
  //   required String? apiKey,
  //   required String email,
  //   required String hashedPassword,
  // }) {}
  // Future<UserOrDatabaseError> updateUser({
  //   required int id,
  //   String? email,
  //   String? apiKey,
  //   DateTime? lastLogin,
  // }) {}
// }
