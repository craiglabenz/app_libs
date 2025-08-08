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

abstract class AuthUserGoogle
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AuthUserGoogle._({
    this.id,
    required this.authUserId,
    this.authUser,
    this.email,
    this.displayName,
    this.photoUrl,
    this.idToken,
    this.serverAuthCode,
    this.uniqueId,
  });

  factory AuthUserGoogle({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUserDb? authUser,
    String? email,
    String? displayName,
    String? photoUrl,
    String? idToken,
    String? serverAuthCode,
    String? uniqueId,
  }) = _AuthUserGoogleImpl;

  factory AuthUserGoogle.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthUserGoogle(
      id: jsonSerialization['id'] as int?,
      authUserId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['authUserId']),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i2.AuthUserDb.fromJson(
              (jsonSerialization['authUser'] as Map<String, dynamic>)),
      email: jsonSerialization['email'] as String?,
      displayName: jsonSerialization['displayName'] as String?,
      photoUrl: jsonSerialization['photoUrl'] as String?,
      idToken: jsonSerialization['idToken'] as String?,
      serverAuthCode: jsonSerialization['serverAuthCode'] as String?,
      uniqueId: jsonSerialization['uniqueId'] as String?,
    );
  }

  static final t = AuthUserGoogleTable();

  static const db = AuthUserGoogleRepository._();

  @override
  int? id;

  _i1.UuidValue authUserId;

  _i2.AuthUserDb? authUser;

  String? email;

  String? displayName;

  String? photoUrl;

  String? idToken;

  String? serverAuthCode;

  String? uniqueId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AuthUserGoogle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthUserGoogle copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    _i2.AuthUserDb? authUser,
    String? email,
    String? displayName,
    String? photoUrl,
    String? idToken,
    String? serverAuthCode,
    String? uniqueId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      if (email != null) 'email': email,
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (idToken != null) 'idToken': idToken,
      if (serverAuthCode != null) 'serverAuthCode': serverAuthCode,
      if (uniqueId != null) 'uniqueId': uniqueId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {if (id != null) 'id': id};
  }

  static AuthUserGoogleInclude include({_i2.AuthUserDbInclude? authUser}) {
    return AuthUserGoogleInclude._(authUser: authUser);
  }

  static AuthUserGoogleIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthUserGoogleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthUserGoogleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserGoogleTable>? orderByList,
    AuthUserGoogleInclude? include,
  }) {
    return AuthUserGoogleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthUserGoogle.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthUserGoogle.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthUserGoogleImpl extends AuthUserGoogle {
  _AuthUserGoogleImpl({
    int? id,
    required _i1.UuidValue authUserId,
    _i2.AuthUserDb? authUser,
    String? email,
    String? displayName,
    String? photoUrl,
    String? idToken,
    String? serverAuthCode,
    String? uniqueId,
  }) : super._(
          id: id,
          authUserId: authUserId,
          authUser: authUser,
          email: email,
          displayName: displayName,
          photoUrl: photoUrl,
          idToken: idToken,
          serverAuthCode: serverAuthCode,
          uniqueId: uniqueId,
        );

  /// Returns a shallow copy of this [AuthUserGoogle]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthUserGoogle copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    Object? email = _Undefined,
    Object? displayName = _Undefined,
    Object? photoUrl = _Undefined,
    Object? idToken = _Undefined,
    Object? serverAuthCode = _Undefined,
    Object? uniqueId = _Undefined,
  }) {
    return AuthUserGoogle(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser:
          authUser is _i2.AuthUserDb? ? authUser : this.authUser?.copyWith(),
      email: email is String? ? email : this.email,
      displayName: displayName is String? ? displayName : this.displayName,
      photoUrl: photoUrl is String? ? photoUrl : this.photoUrl,
      idToken: idToken is String? ? idToken : this.idToken,
      serverAuthCode:
          serverAuthCode is String? ? serverAuthCode : this.serverAuthCode,
      uniqueId: uniqueId is String? ? uniqueId : this.uniqueId,
    );
  }
}

class AuthUserGoogleTable extends _i1.Table<int?> {
  AuthUserGoogleTable({super.tableRelation})
      : super(tableName: 'auth_users_google') {
    authUserId = _i1.ColumnUuid(
      'authUserId',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
    photoUrl = _i1.ColumnString(
      'photoUrl',
      this,
    );
    idToken = _i1.ColumnString(
      'idToken',
      this,
    );
    serverAuthCode = _i1.ColumnString(
      'serverAuthCode',
      this,
    );
    uniqueId = _i1.ColumnString(
      'uniqueId',
      this,
    );
  }

  late final _i1.ColumnUuid authUserId;

  _i2.AuthUserDbTable? _authUser;

  late final _i1.ColumnString email;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString photoUrl;

  late final _i1.ColumnString idToken;

  late final _i1.ColumnString serverAuthCode;

  late final _i1.ColumnString uniqueId;

  _i2.AuthUserDbTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: AuthUserGoogle.t.authUserId,
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
        displayName,
        photoUrl,
        idToken,
        serverAuthCode,
        uniqueId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class AuthUserGoogleInclude extends _i1.IncludeObject {
  AuthUserGoogleInclude._({_i2.AuthUserDbInclude? authUser}) {
    _authUser = authUser;
  }

  _i2.AuthUserDbInclude? _authUser;

  @override
  Map<String, _i1.Include?> get includes => {'authUser': _authUser};

  @override
  _i1.Table<int?> get table => AuthUserGoogle.t;
}

class AuthUserGoogleIncludeList extends _i1.IncludeList {
  AuthUserGoogleIncludeList._({
    _i1.WhereExpressionBuilder<AuthUserGoogleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthUserGoogle.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuthUserGoogle.t;
}

class AuthUserGoogleRepository {
  const AuthUserGoogleRepository._();

  final attachRow = const AuthUserGoogleAttachRowRepository._();

  /// Returns a list of [AuthUserGoogle]s matching the given query parameters.
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
  Future<List<AuthUserGoogle>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserGoogleTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthUserGoogleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserGoogleTable>? orderByList,
    _i1.Transaction? transaction,
    AuthUserGoogleInclude? include,
  }) async {
    return session.db.find<AuthUserGoogle>(
      where: where?.call(AuthUserGoogle.t),
      orderBy: orderBy?.call(AuthUserGoogle.t),
      orderByList: orderByList?.call(AuthUserGoogle.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AuthUserGoogle] matching the given query parameters.
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
  Future<AuthUserGoogle?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserGoogleTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthUserGoogleTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthUserGoogleTable>? orderByList,
    _i1.Transaction? transaction,
    AuthUserGoogleInclude? include,
  }) async {
    return session.db.findFirstRow<AuthUserGoogle>(
      where: where?.call(AuthUserGoogle.t),
      orderBy: orderBy?.call(AuthUserGoogle.t),
      orderByList: orderByList?.call(AuthUserGoogle.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AuthUserGoogle] by its [id] or null if no such row exists.
  Future<AuthUserGoogle?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AuthUserGoogleInclude? include,
  }) async {
    return session.db.findById<AuthUserGoogle>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AuthUserGoogle]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthUserGoogle]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AuthUserGoogle>> insert(
    _i1.Session session,
    List<AuthUserGoogle> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AuthUserGoogle>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AuthUserGoogle] and returns the inserted row.
  ///
  /// The returned [AuthUserGoogle] will have its `id` field set.
  Future<AuthUserGoogle> insertRow(
    _i1.Session session,
    AuthUserGoogle row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthUserGoogle>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuthUserGoogle]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuthUserGoogle>> update(
    _i1.Session session,
    List<AuthUserGoogle> rows, {
    _i1.ColumnSelections<AuthUserGoogleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthUserGoogle>(
      rows,
      columns: columns?.call(AuthUserGoogle.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthUserGoogle]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthUserGoogle> updateRow(
    _i1.Session session,
    AuthUserGoogle row, {
    _i1.ColumnSelections<AuthUserGoogleTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthUserGoogle>(
      row,
      columns: columns?.call(AuthUserGoogle.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AuthUserGoogle]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuthUserGoogle>> delete(
    _i1.Session session,
    List<AuthUserGoogle> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthUserGoogle>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuthUserGoogle].
  Future<AuthUserGoogle> deleteRow(
    _i1.Session session,
    AuthUserGoogle row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthUserGoogle>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuthUserGoogle>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AuthUserGoogleTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthUserGoogle>(
      where: where(AuthUserGoogle.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AuthUserGoogleTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthUserGoogle>(
      where: where?.call(AuthUserGoogle.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AuthUserGoogleAttachRowRepository {
  const AuthUserGoogleAttachRowRepository._();

  /// Creates a relation between the given [AuthUserGoogle] and [AuthUserDb]
  /// by setting the [AuthUserGoogle]'s foreign key `authUserId` to refer to the [AuthUserDb].
  Future<void> authUser(
    _i1.Session session,
    AuthUserGoogle authUserGoogle,
    _i2.AuthUserDb authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (authUserGoogle.id == null) {
      throw ArgumentError.notNull('authUserGoogle.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $authUserGoogle = authUserGoogle.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AuthUserGoogle>(
      $authUserGoogle,
      columns: [AuthUserGoogle.t.authUserId],
      transaction: transaction,
    );
  }
}
