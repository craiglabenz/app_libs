/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'auth_user.dart' as _i2;

abstract class AuthUserFailedLogin
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AuthUserFailedLogin._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.createdAt,
  });

  factory AuthUserFailedLogin({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUserDb? authUser,
    required DateTime createdAt,
  }) = _AuthUserFailedLoginImpl;

  factory AuthUserFailedLogin.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUserFailedLogin(
      id: jsonSerialization['id'] as int?,
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUserDb.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AuthUserFailedLoginTable();

  static const db = AuthUserFailedLoginRepository._();

  @override
  int? id;

  _i1.UuidValue authUserId;

  _i2.AuthUserDb? authUser;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuthUserFailedLogin]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthUserFailedLogin copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUserDb? authUser,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static AuthUserFailedLoginInclude include({_i2.AuthUserDbInclude? authUser}) {
    return AuthUserFailedLoginInclude._(authUser: authUser);
  }

  static AuthUserFailedLoginIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthUserFailedLoginTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthUserFailedLoginTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserFailedLoginTable>? orderByList,
    AuthUserFailedLoginInclude? include,
  }) {
    return AuthUserFailedLoginIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthUserFailedLogin.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthUserFailedLogin.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthUserFailedLoginImpl extends AuthUserFailedLogin {
  _AuthUserFailedLoginImpl({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUserDb? authUser,
    required DateTime createdAt,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [AuthUserFailedLogin]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthUserFailedLogin copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    DateTime? createdAt,
  }) {
    return AuthUserFailedLogin(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUserDb? ? authUser : this.authUser?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuthUserFailedLoginTable extends _i1.Table<int?> {
  AuthUserFailedLoginTable({super.tableRelation})
      : super(tableName: 'auth_user_failed_logins') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final _i1.ColumnUuid authUserId;

  _i2.AuthUserDbTable? _authUser;

  late final _i1.ColumnDateTime createdAt;

  _i2.AuthUserDbTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: AuthUserFailedLogin.t.authUserId,
      foreignField: _i2.AuthUserDb.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AuthUserDbTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        authUserId,
        createdAt,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class AuthUserFailedLoginInclude extends _i1.IncludeObject {
  AuthUserFailedLoginInclude._({_i2.AuthUserDbInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserDbInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<int?> get table => AuthUserFailedLogin.t;
}

class AuthUserFailedLoginIncludeList extends _i1.IncludeList {
  AuthUserFailedLoginIncludeList._({
    _i1.WhereExpressionBuilder<AuthUserFailedLoginTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthUserFailedLogin.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuthUserFailedLogin.t;
}

class AuthUserFailedLoginRepository {
  const AuthUserFailedLoginRepository._();

  final attachRow = const AuthUserFailedLoginAttachRowRepository._();

  /// Returns a list of [AuthUserFailedLogin]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<AuthUserFailedLogin>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserFailedLoginTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthUserFailedLoginTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserFailedLoginTable>? orderByList,
    _i1.Transaction? transaction,
    AuthUserFailedLoginInclude? include,
  }) async {
    return session.db.find<AuthUserFailedLogin>(
      where: where?.call(AuthUserFailedLogin.t),
      orderBy: orderBy?.call(AuthUserFailedLogin.t),
      orderByList: orderByList?.call(AuthUserFailedLogin.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AuthUserFailedLogin] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<AuthUserFailedLogin?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserFailedLoginTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthUserFailedLoginTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserFailedLoginTable>? orderByList,
    _i1.Transaction? transaction,
    AuthUserFailedLoginInclude? include,
  }) async {
    return session.db.findFirstRow<AuthUserFailedLogin>(
      where: where?.call(AuthUserFailedLogin.t),
      orderBy: orderBy?.call(AuthUserFailedLogin.t),
      orderByList: orderByList?.call(AuthUserFailedLogin.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AuthUserFailedLogin] by its [id] or null if no such row exists.
  Future<AuthUserFailedLogin?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AuthUserFailedLoginInclude? include,
  }) async {
    return session.db.findById<AuthUserFailedLogin>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AuthUserFailedLogin]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthUserFailedLogin]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AuthUserFailedLogin>> insert(
    _i1.Session session,
    List<AuthUserFailedLogin> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuthUserFailedLogin>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AuthUserFailedLogin] and returns the inserted row.
  ///
  /// The returned [AuthUserFailedLogin] will have its `id` field set.
  Future<AuthUserFailedLogin> insertRow(
    _i1.Session session,
    AuthUserFailedLogin row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthUserFailedLogin>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuthUserFailedLogin]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuthUserFailedLogin>> update(
    _i1.Session session,
    List<AuthUserFailedLogin> rows, {
    _i1.ColumnSelections<AuthUserFailedLoginTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthUserFailedLogin>(
      rows,
      columns: columns?.call(AuthUserFailedLogin.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthUserFailedLogin]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthUserFailedLogin> updateRow(
    _i1.Session session,
    AuthUserFailedLogin row, {
    _i1.ColumnSelections<AuthUserFailedLoginTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthUserFailedLogin>(
      row,
      columns: columns?.call(AuthUserFailedLogin.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AuthUserFailedLogin]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuthUserFailedLogin>> delete(
    _i1.Session session,
    List<AuthUserFailedLogin> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthUserFailedLogin>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuthUserFailedLogin].
  Future<AuthUserFailedLogin> deleteRow(
    _i1.Session session,
    AuthUserFailedLogin row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthUserFailedLogin>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuthUserFailedLogin>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuthUserFailedLoginTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthUserFailedLogin>(
      where: where(AuthUserFailedLogin.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserFailedLoginTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthUserFailedLogin>(
      where: where?.call(AuthUserFailedLogin.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AuthUserFailedLoginAttachRowRepository {
  const AuthUserFailedLoginAttachRowRepository._();

  /// Creates a relation between the given [AuthUserFailedLogin] and [AuthUserDb]
  /// by setting the [AuthUserFailedLogin]'s foreign key `authUserId` to refer to the [AuthUserDb].
  Future<void> authUser(
    _i1.Session session,
    AuthUserFailedLogin authUserFailedLogin,
    _i2.AuthUserDb authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (authUserFailedLogin.id == null) {
      throw ArgumentError.notNull('authUserFailedLogin.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $authUserFailedLogin =
        authUserFailedLogin.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AuthUserFailedLogin>(
      $authUserFailedLogin,
      columns: [AuthUserFailedLogin.t.authUserId],
      transaction: transaction,
    );
  }
}
