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

abstract class AuthUserApple
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AuthUserApple._({
    this.id,
    required this.authUserId,
    this.authUser,
    this.email,
    this.givenName,
    this.familyName,
    required this.authorizationCode,
    this.identityToken,
    this.userIdentifier,
  });

  factory AuthUserApple({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUserDb? authUser,
    String? email,
    String? givenName,
    String? familyName,
    required String authorizationCode,
    String? identityToken,
    String? userIdentifier,
  }) = _AuthUserAppleImpl;

  factory AuthUserApple.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUserApple(
      id: jsonSerialization['id'] as int?,
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUserDb.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      email: jsonSerialization['email'] as String?,
      givenName: jsonSerialization['givenName'] as String?,
      familyName: jsonSerialization['familyName'] as String?,
      authorizationCode: jsonSerialization['authorizationCode'] as String,
      identityToken: jsonSerialization['identityToken'] as String?,
      userIdentifier: jsonSerialization['userIdentifier'] as String?,
    );
  }

  static final t = AuthUserAppleTable();

  static const db = AuthUserAppleRepository._();

  @override
  int? id;

  _i1.UuidValue authUserId;

  _i2.AuthUserDb? authUser;

  String? email;

  String? givenName;

  String? familyName;

  String authorizationCode;

  String? identityToken;

  String? userIdentifier;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuthUserApple]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthUserApple copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUserDb? authUser,
    String? email,
    String? givenName,
    String? familyName,
    String? authorizationCode,
    String? identityToken,
    String? userIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (email != null) 'email': email,
      if (givenName != null) 'givenName': givenName,
      if (familyName != null) 'familyName': familyName,
      'authorizationCode': authorizationCode,
      if (identityToken != null) 'identityToken': identityToken,
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static AuthUserAppleInclude include({_i2.AuthUserDbInclude? authUser}) {
    return AuthUserAppleInclude._(authUser: authUser);
  }

  static AuthUserAppleIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthUserAppleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthUserAppleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserAppleTable>? orderByList,
    AuthUserAppleInclude? include,
  }) {
    return AuthUserAppleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthUserApple.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthUserApple.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthUserAppleImpl extends AuthUserApple {
  _AuthUserAppleImpl({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUserDb? authUser,
    String? email,
    String? givenName,
    String? familyName,
    required String authorizationCode,
    String? identityToken,
    String? userIdentifier,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          email: email,
          givenName: givenName,
          familyName: familyName,
          authorizationCode: authorizationCode,
          identityToken: identityToken,
          userIdentifier: userIdentifier,
        );

  /// Returns a shallow copy of this [AuthUserApple]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthUserApple copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? email = _Undefined,
    Object? givenName = _Undefined,
    Object? familyName = _Undefined,
    String? authorizationCode,
    Object? identityToken = _Undefined,
    Object? userIdentifier = _Undefined,
  }) {
    return AuthUserApple(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUserDb? ? authUser : this.authUser?.copyWith(),
      email: email is String? ? email : this.email,
      givenName: givenName is String? ? givenName : this.givenName,
      familyName: familyName is String? ? familyName : this.familyName,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      identityToken:
          identityToken is String? ? identityToken : this.identityToken,
      userIdentifier:
          userIdentifier is String? ? userIdentifier : this.userIdentifier,
    );
  }
}

class AuthUserAppleTable extends _i1.Table<int?> {
  AuthUserAppleTable({super.tableRelation})
      : super(tableName: 'auth_users_apple') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    givenName = _i1.ColumnString(
      'givenName',
      this,
    );
    familyName = _i1.ColumnString(
      'familyName',
      this,
    );
    authorizationCode = _i1.ColumnString(
      'authorizationCode',
      this,
    );
    identityToken = _i1.ColumnString(
      'identityToken',
      this,
    );
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
  }

  late final _i1.ColumnUuid authUserId;

  _i2.AuthUserDbTable? _authUser;

  late final _i1.ColumnString email;

  late final _i1.ColumnString givenName;

  late final _i1.ColumnString familyName;

  late final _i1.ColumnString authorizationCode;

  late final _i1.ColumnString identityToken;

  late final _i1.ColumnString userIdentifier;

  _i2.AuthUserDbTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: AuthUserApple.t.authUserId,
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
        email,
        givenName,
        familyName,
        authorizationCode,
        identityToken,
        userIdentifier,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class AuthUserAppleInclude extends _i1.IncludeObject {
  AuthUserAppleInclude._({_i2.AuthUserDbInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserDbInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<int?> get table => AuthUserApple.t;
}

class AuthUserAppleIncludeList extends _i1.IncludeList {
  AuthUserAppleIncludeList._({
    _i1.WhereExpressionBuilder<AuthUserAppleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthUserApple.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuthUserApple.t;
}

class AuthUserAppleRepository {
  const AuthUserAppleRepository._();

  final attachRow = const AuthUserAppleAttachRowRepository._();

  /// Returns a list of [AuthUserApple]s matching the given query parameters.
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
  Future<List<AuthUserApple>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserAppleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthUserAppleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserAppleTable>? orderByList,
    _i1.Transaction? transaction,
    AuthUserAppleInclude? include,
  }) async {
    return session.db.find<AuthUserApple>(
      where: where?.call(AuthUserApple.t),
      orderBy: orderBy?.call(AuthUserApple.t),
      orderByList: orderByList?.call(AuthUserApple.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AuthUserApple] matching the given query parameters.
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
  Future<AuthUserApple?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserAppleTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthUserAppleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserAppleTable>? orderByList,
    _i1.Transaction? transaction,
    AuthUserAppleInclude? include,
  }) async {
    return session.db.findFirstRow<AuthUserApple>(
      where: where?.call(AuthUserApple.t),
      orderBy: orderBy?.call(AuthUserApple.t),
      orderByList: orderByList?.call(AuthUserApple.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AuthUserApple] by its [id] or null if no such row exists.
  Future<AuthUserApple?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AuthUserAppleInclude? include,
  }) async {
    return session.db.findById<AuthUserApple>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AuthUserApple]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthUserApple]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AuthUserApple>> insert(
    _i1.Session session,
    List<AuthUserApple> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuthUserApple>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AuthUserApple] and returns the inserted row.
  ///
  /// The returned [AuthUserApple] will have its `id` field set.
  Future<AuthUserApple> insertRow(
    _i1.Session session,
    AuthUserApple row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthUserApple>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuthUserApple]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuthUserApple>> update(
    _i1.Session session,
    List<AuthUserApple> rows, {
    _i1.ColumnSelections<AuthUserAppleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthUserApple>(
      rows,
      columns: columns?.call(AuthUserApple.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthUserApple]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthUserApple> updateRow(
    _i1.Session session,
    AuthUserApple row, {
    _i1.ColumnSelections<AuthUserAppleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthUserApple>(
      row,
      columns: columns?.call(AuthUserApple.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AuthUserApple]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuthUserApple>> delete(
    _i1.Session session,
    List<AuthUserApple> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthUserApple>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuthUserApple].
  Future<AuthUserApple> deleteRow(
    _i1.Session session,
    AuthUserApple row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthUserApple>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuthUserApple>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuthUserAppleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthUserApple>(
      where: where(AuthUserApple.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserAppleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthUserApple>(
      where: where?.call(AuthUserApple.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AuthUserAppleAttachRowRepository {
  const AuthUserAppleAttachRowRepository._();

  /// Creates a relation between the given [AuthUserApple] and [AuthUserDb]
  /// by setting the [AuthUserApple]'s foreign key `authUserId` to refer to the [AuthUserDb].
  Future<void> authUser(
    _i1.Session session,
    AuthUserApple authUserApple,
    _i2.AuthUserDb authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (authUserApple.id == null) {
      throw ArgumentError.notNull('authUserApple.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $authUserApple = authUserApple.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AuthUserApple>(
      $authUserApple,
      columns: [AuthUserApple.t.authUserId],
      transaction: transaction,
    );
  }
}
