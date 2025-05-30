import 'package:auth/auth.dart';
import 'package:dartz/dartz.dart';
import 'package:db/db.dart' as db;
import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:shared_data/shared_data.dart';

/// {@template AuthDbSource}
/// {@endtemplate}
class AuthDbSource<T extends AuthUser> extends Source<T> {
  /// {@macro AuthDbSource}
  AuthDbSource(db.Db db) : _db = db;

  final db.Db _db;

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) async {
    final result = _db.auth.select(_db.auth.authUsers)
      ..where((u) => u.uid.equals(UuidValue.fromString(id)));
    final user = await result.getSingleOrNull();
    return Right(ReadSuccess<T>(authUserFromDb(user) as T?, details: details));
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) {
    // TODO: implement getByIds
    throw UnimplementedError();
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) async {
    final result = _db.auth.select(_db.auth.authUsers);
    final users = await result.get();
    return Right(
      ReadListSuccess<T>.fromList(
        users.map<T>((item) => authUserFromDb(item)! as T).cast<T>().toList(),
        details,
        const {},
      ),
    );
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
    await _db.auth.into(_db.auth.authUsers).insert(
          AuthUsersCompanion(
            uid: Value<UuidValue>(UuidValue.fromString(item.id)),
            email: item.email != null
                ? Value<String>(item.email!)
                : const Value<String>.absent(),
            apiKey: Value<String>(item.apiKey),
            password: Value<String>(
              (Password('abcdef')..validate()).secureForDb(salt: 'salt'),
            ),
            lastLogin: const Value<PgDateTime>.absent(),
            createdAt: Value<PgDateTime>(PgDateTime(DateTime.now())),
            updatedAt: Value<PgDateTime>(PgDateTime(DateTime.now())),
          ),
        );
    return Right(WriteSuccess<T>(item, details: details));
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  ) {
    // TODO: implement setItems
    throw UnimplementedError();
  }

  @override
  SourceType sourceType = SourceType.remote;
}

///
extension EasyAuthUsersCompanion on AuthUsersCompanion {
  /// Creates an [AuthUsersCompanion]. Coerces plain data and delegates to
  static AuthUsersCompanion create() {
    return const AuthUsersCompanion();
  }
}
