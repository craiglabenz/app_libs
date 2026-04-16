/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// User profile for the app, hence "App"UserProfile to differentiate from
/// Serverpod's native models.
///
/// Public information about an [AuthUser]. Clients will load this for
/// personalization purposes and always only for the active session; never for
/// other profiles the user may encounter while using the app.
///
/// This is not to be confused with the [AppAuthSettings] class, which is an
/// account's private information.
abstract class AppUserProfile
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AppUserProfile._({
    this.id,
    this.userName,
    this.fullName,
    this.imageUrl,
    required this.updatedAt,
    required this.createdAt,
  });

  factory AppUserProfile({
    _i1.UuidValue? id,
    String? userName,
    String? fullName,
    String? imageUrl,
    required DateTime updatedAt,
    required DateTime createdAt,
  }) = _AppUserProfileImpl;

  factory AppUserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUserProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AppUserProfileTable();

  static const db = AppUserProfileRepository._();

  @override
  _i1.UuidValue? id;

  String? userName;

  String? fullName;

  String? imageUrl;

  DateTime updatedAt;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AppUserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUserProfile copyWith({
    _i1.UuidValue? id,
    String? userName,
    String? fullName,
    String? imageUrl,
    DateTime? updatedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUserProfile',
      if (id != null) 'id': id?.toJson(),
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'updatedAt': updatedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AppUserProfileInclude include() {
    return AppUserProfileInclude._();
  }

  static AppUserProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<AppUserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserProfileTable>? orderByList,
    AppUserProfileInclude? include,
  }) {
    return AppUserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUserProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppUserProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserProfileImpl extends AppUserProfile {
  _AppUserProfileImpl({
    _i1.UuidValue? id,
    String? userName,
    String? fullName,
    String? imageUrl,
    required DateTime updatedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userName: userName,
         fullName: fullName,
         imageUrl: imageUrl,
         updatedAt: updatedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AppUserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUserProfile copyWith({
    Object? id = _Undefined,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? imageUrl = _Undefined,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return AppUserProfile(
      id: id is _i1.UuidValue? ? id : this.id,
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AppUserProfileUpdateTable extends _i1.UpdateTable<AppUserProfileTable> {
  AppUserProfileUpdateTable(super.table);

  _i1.ColumnValue<String, String> userName(String? value) => _i1.ColumnValue(
    table.userName,
    value,
  );

  _i1.ColumnValue<String, String> fullName(String? value) => _i1.ColumnValue(
    table.fullName,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String? value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AppUserProfileTable extends _i1.Table<_i1.UuidValue?> {
  AppUserProfileTable({super.tableRelation})
    : super(tableName: 'auth_user_profile') {
    updateTable = AppUserProfileUpdateTable(this);
    userName = _i1.ColumnString(
      'userName',
      this,
    );
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AppUserProfileUpdateTable updateTable;

  late final _i1.ColumnString userName;

  late final _i1.ColumnString fullName;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userName,
    fullName,
    imageUrl,
    updatedAt,
    createdAt,
  ];
}

class AppUserProfileInclude extends _i1.IncludeObject {
  AppUserProfileInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AppUserProfile.t;
}

class AppUserProfileIncludeList extends _i1.IncludeList {
  AppUserProfileIncludeList._({
    _i1.WhereExpressionBuilder<AppUserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppUserProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AppUserProfile.t;
}

class AppUserProfileRepository {
  const AppUserProfileRepository._();

  /// Returns a list of [AppUserProfile]s matching the given query parameters.
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
  Future<List<AppUserProfile>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AppUserProfile>(
      where: where?.call(AppUserProfile.t),
      orderBy: orderBy?.call(AppUserProfile.t),
      orderByList: orderByList?.call(AppUserProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AppUserProfile] matching the given query parameters.
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
  Future<AppUserProfile?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppUserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AppUserProfile>(
      where: where?.call(AppUserProfile.t),
      orderBy: orderBy?.call(AppUserProfile.t),
      orderByList: orderByList?.call(AppUserProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AppUserProfile] by its [id] or null if no such row exists.
  Future<AppUserProfile?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AppUserProfile>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AppUserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [AppUserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AppUserProfile>> insert(
    _i1.Session session,
    List<AppUserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AppUserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AppUserProfile] and returns the inserted row.
  ///
  /// The returned [AppUserProfile] will have its `id` field set.
  Future<AppUserProfile> insertRow(
    _i1.Session session,
    AppUserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppUserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppUserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppUserProfile>> update(
    _i1.Session session,
    List<AppUserProfile> rows, {
    _i1.ColumnSelections<AppUserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppUserProfile>(
      rows,
      columns: columns?.call(AppUserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppUserProfile> updateRow(
    _i1.Session session,
    AppUserProfile row, {
    _i1.ColumnSelections<AppUserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppUserProfile>(
      row,
      columns: columns?.call(AppUserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUserProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppUserProfile?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AppUserProfileUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppUserProfile>(
      id,
      columnValues: columnValues(AppUserProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppUserProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppUserProfile>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AppUserProfileUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppUserProfileTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserProfileTable>? orderBy,
    _i1.OrderByListBuilder<AppUserProfileTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppUserProfile>(
      columnValues: columnValues(AppUserProfile.t.updateTable),
      where: where(AppUserProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUserProfile.t),
      orderByList: orderByList?.call(AppUserProfile.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppUserProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppUserProfile>> delete(
    _i1.Session session,
    List<AppUserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppUserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppUserProfile].
  Future<AppUserProfile> deleteRow(
    _i1.Session session,
    AppUserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppUserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppUserProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AppUserProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppUserProfile>(
      where: where(AppUserProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppUserProfile>(
      where: where?.call(AppUserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
