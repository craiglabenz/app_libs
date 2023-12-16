import 'package:dartz/dartz.dart';
import 'package:db/db.dart' as db;
import 'package:shared_data/shared_data.dart';

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
