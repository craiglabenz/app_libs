// import 'package:dartz/dartz.dart';
import 'package:auth/auth.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart' as pg;

/// {@template db}
/// Database access layer
/// {@endtemplate}
class Db {
  /// {@macro db}
  Db();

  /// ORM for Auth tables.
  late final AuthDb auth = AuthDb(_conn);

  // Shared connection for specific database table properties.
  late final PgDatabase _conn = PgDatabase(
    endpoint: pg.Endpoint(
      host: 'localhost',
      database: 'dart_drift_test',
      username: 'craiglabenz',
      password: '',
    ),
    settings: const pg.ConnectionSettings(
      // If you expect to talk to a Postgres database over a public
      // connection, please use SslMode.verifyFull instead.
      sslMode: pg.SslMode.disable,
    ),
    logStatements: true,
  );
}
