import 'package:common/common.dart';
import 'package:dartz/dartz.dart';
import 'package:db/db.dart' as db;

/// Either a successfully loaded [User] or a fatal error.
typedef UserOrDatabaseError = Either<db.DatabaseError, User>;

/// Auth-related functions for the Database object.
mixin AuthDb on db.Db {
  Future<UserOrDatabaseError> getUserByApiKey(String apiKey);
  Future<UserOrDatabaseError> getUserByEmail(String email);
  Future<UserOrDatabaseError> loadUserWithPassword({
    required String email,
    required String hashedPassword,
  });
  Future<UserOrDatabaseError> createUser({
    required String? apiKey,
    required String email,
    required String hashedPassword,
  });
  Future<UserOrDatabaseError> updateUser({
    required int id,
    String? email,
    String? apiKey,
    DateTime? lastLogin,
  });
}
