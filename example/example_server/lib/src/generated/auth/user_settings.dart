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

/// Private information about an [AuthUser]. Clients will load this for
/// personalization purposes and always only for the active session; never for
/// other profiles the user may encounter while using the app.
///
/// This is not to be confused with the [AuthProfile] class, which is an
/// account's public information (for leaderboards and such).
///
/// Note that Serverpod's native [UserProfile] model is ignored and left dormant
/// because emails are private information. This also gives us a fresh place to
/// store other information which may be public for different apps, like geo
/// information.
///
/// User settings for the app, prefixed with "App" to align it with the
/// "AppUserSettings" model.
abstract class AppUserSettings
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  AppUserSettings._({
    this.id,
    this.email,
    required this.loggingId,
    required this.updatedAt,
    required this.createdAt,
  });

  factory AppUserSettings({
    _i1.UuidValue? id,
    String? email,
    required _i1.UuidValue loggingId,
    required DateTime updatedAt,
    required DateTime createdAt,
  }) = _AppUserSettingsImpl;

  factory AppUserSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUserSettings(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String?,
      loggingId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['loggingId'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = AppUserSettingsTable();

  static const db = AppUserSettingsRepository._();

  @override
  _i1.UuidValue? id;

  String? email;

  _i1.UuidValue loggingId;

  DateTime updatedAt;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AppUserSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUserSettings copyWith({
    _i1.UuidValue? id,
    String? email,
    _i1.UuidValue? loggingId,
    DateTime? updatedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUserSettings',
      if (id != null) 'id': id?.toJson(),
      if (email != null) 'email': email,
      'loggingId': loggingId.toJson(),
      'updatedAt': updatedAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static AppUserSettingsInclude include() {
    return AppUserSettingsInclude._();
  }

  static AppUserSettingsIncludeList includeList({
    _i1.WhereExpressionBuilder<AppUserSettingsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserSettingsTable>? orderByList,
    AppUserSettingsInclude? include,
  }) {
    return AppUserSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUserSettings.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppUserSettings.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserSettingsImpl extends AppUserSettings {
  _AppUserSettingsImpl({
    _i1.UuidValue? id,
    String? email,
    required _i1.UuidValue loggingId,
    required DateTime updatedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         loggingId: loggingId,
         updatedAt: updatedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AppUserSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUserSettings copyWith({
    Object? id = _Undefined,
    Object? email = _Undefined,
    _i1.UuidValue? loggingId,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return AppUserSettings(
      id: id is _i1.UuidValue? ? id : this.id,
      email: email is String? ? email : this.email,
      loggingId: loggingId ?? this.loggingId,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AppUserSettingsUpdateTable extends _i1.UpdateTable<AppUserSettingsTable> {
  AppUserSettingsUpdateTable(super.table);

  _i1.ColumnValue<String, String> email(String? value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> loggingId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.loggingId,
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

class AppUserSettingsTable extends _i1.Table<_i1.UuidValue?> {
  AppUserSettingsTable({super.tableRelation})
    : super(tableName: 'auth_user_settings') {
    updateTable = AppUserSettingsUpdateTable(this);
    email = _i1.ColumnString(
      'email',
      this,
    );
    loggingId = _i1.ColumnUuid(
      'loggingId',
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

  late final AppUserSettingsUpdateTable updateTable;

  late final _i1.ColumnString email;

  late final _i1.ColumnUuid loggingId;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    email,
    loggingId,
    updatedAt,
    createdAt,
  ];
}

class AppUserSettingsInclude extends _i1.IncludeObject {
  AppUserSettingsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AppUserSettings.t;
}

class AppUserSettingsIncludeList extends _i1.IncludeList {
  AppUserSettingsIncludeList._({
    _i1.WhereExpressionBuilder<AppUserSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppUserSettings.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => AppUserSettings.t;
}

class AppUserSettingsRepository {
  const AppUserSettingsRepository._();

  /// Returns a list of [AppUserSettings]s matching the given query parameters.
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
  Future<List<AppUserSettings>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserSettingsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserSettingsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AppUserSettings>(
      where: where?.call(AppUserSettings.t),
      orderBy: orderBy?.call(AppUserSettings.t),
      orderByList: orderByList?.call(AppUserSettings.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AppUserSettings] matching the given query parameters.
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
  Future<AppUserSettings?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserSettingsTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppUserSettingsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppUserSettingsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AppUserSettings>(
      where: where?.call(AppUserSettings.t),
      orderBy: orderBy?.call(AppUserSettings.t),
      orderByList: orderByList?.call(AppUserSettings.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AppUserSettings] by its [id] or null if no such row exists.
  Future<AppUserSettings?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AppUserSettings>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AppUserSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [AppUserSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AppUserSettings>> insert(
    _i1.Session session,
    List<AppUserSettings> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AppUserSettings>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AppUserSettings] and returns the inserted row.
  ///
  /// The returned [AppUserSettings] will have its `id` field set.
  Future<AppUserSettings> insertRow(
    _i1.Session session,
    AppUserSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppUserSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppUserSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppUserSettings>> update(
    _i1.Session session,
    List<AppUserSettings> rows, {
    _i1.ColumnSelections<AppUserSettingsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppUserSettings>(
      rows,
      columns: columns?.call(AppUserSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUserSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppUserSettings> updateRow(
    _i1.Session session,
    AppUserSettings row, {
    _i1.ColumnSelections<AppUserSettingsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppUserSettings>(
      row,
      columns: columns?.call(AppUserSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppUserSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppUserSettings?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<AppUserSettingsUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppUserSettings>(
      id,
      columnValues: columnValues(AppUserSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppUserSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppUserSettings>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AppUserSettingsUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AppUserSettingsTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppUserSettingsTable>? orderBy,
    _i1.OrderByListBuilder<AppUserSettingsTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppUserSettings>(
      columnValues: columnValues(AppUserSettings.t.updateTable),
      where: where(AppUserSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppUserSettings.t),
      orderByList: orderByList?.call(AppUserSettings.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppUserSettings]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppUserSettings>> delete(
    _i1.Session session,
    List<AppUserSettings> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppUserSettings>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppUserSettings].
  Future<AppUserSettings> deleteRow(
    _i1.Session session,
    AppUserSettings row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppUserSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppUserSettings>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AppUserSettingsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppUserSettings>(
      where: where(AppUserSettings.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AppUserSettingsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppUserSettings>(
      where: where?.call(AppUserSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
