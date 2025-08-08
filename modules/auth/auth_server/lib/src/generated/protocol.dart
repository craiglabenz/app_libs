/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'auth_user.dart' as _i3;
import 'auth_user_apple.dart' as _i4;
import 'auth_user_email.dart' as _i5;
import 'auth_user_failed_logins.dart' as _i6;
import 'auth_user_google.dart' as _i7;
import 'package:shared_data/shared_data.dart' as _i8;
export 'auth_user.dart';
export 'auth_user_apple.dart';
export 'auth_user_email.dart';
export 'auth_user_failed_logins.dart';
export 'auth_user_google.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'auth_user_failed_logins',
      dartName: 'AuthUserFailedLogin',
      schema: 'public',
      module: 'auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'auth_user_failed_logins_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'auth_user_failed_logins_fk_0',
          columns: ['authUserId'],
          referenceTable: 'auth_users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auth_user_failed_logins_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auth_users',
      dartName: 'AuthUserDb',
      schema: 'public',
      module: 'auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'socialId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'lastAuthProvider',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'allProviders',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Set<String>',
        ),
        _i2.ColumnDefinition(
          name: 'loggingId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auth_users_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'social_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'socialId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'email_auth_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auth_users_apple',
      dartName: 'AuthUserApple',
      schema: 'public',
      module: 'auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'auth_users_apple_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'givenName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'familyName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'authorizationCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'identityToken',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'auth_users_apple_fk_0',
          columns: ['authUserId'],
          referenceTable: 'auth_users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auth_users_apple_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auth_users_email',
      dartName: 'AuthUserEmail',
      schema: 'public',
      module: 'auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'auth_users_email_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'password',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'auth_users_email_fk_0',
          columns: ['authUserId'],
          referenceTable: 'auth_users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auth_users_email_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'email_auth_user_email_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'auth_users_google',
      dartName: 'AuthUserGoogle',
      schema: 'public',
      module: 'auth',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'auth_users_google_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'displayName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'photoUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'idToken',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'serverAuthCode',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'uniqueId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'auth_users_google_fk_0',
          columns: ['authUserId'],
          referenceTable: 'auth_users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'auth_users_google_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'email_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.AuthUserDb) {
      return _i3.AuthUserDb.fromJson(data) as T;
    }
    if (t == _i4.AuthUserApple) {
      return _i4.AuthUserApple.fromJson(data) as T;
    }
    if (t == _i5.AuthUserEmail) {
      return _i5.AuthUserEmail.fromJson(data) as T;
    }
    if (t == _i6.AuthUserFailedLogin) {
      return _i6.AuthUserFailedLogin.fromJson(data) as T;
    }
    if (t == _i7.AuthUserGoogle) {
      return _i7.AuthUserGoogle.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.AuthUserDb?>()) {
      return (data != null ? _i3.AuthUserDb.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthUserApple?>()) {
      return (data != null ? _i4.AuthUserApple.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AuthUserEmail?>()) {
      return (data != null ? _i5.AuthUserEmail.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AuthUserFailedLogin?>()) {
      return (data != null ? _i6.AuthUserFailedLogin.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.AuthUserGoogle?>()) {
      return (data != null ? _i7.AuthUserGoogle.fromJson(data) : null) as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == _i8.AuthUser) {
      return _i8.AuthUser.fromJson(data) as T;
    }
    if (t == _i8.AuthResponse) {
      return _i8.AuthResponse.fromJson(data) as T;
    }
    if (t == _i8.AuthenticationError) {
      return _i8.AuthenticationError.fromJson(data) as T;
    }
    if (t == _i8.AuthProvider) {
      return _i8.AuthProvider.fromJson(data) as T;
    }
    if (t == _i8.AppleCredential) {
      return _i8.AppleCredential.fromJson(data) as T;
    }
    if (t == _i8.EmailCredential) {
      return _i8.EmailCredential.fromJson(data) as T;
    }
    if (t == _i8.GoogleCredential) {
      return _i8.GoogleCredential.fromJson(data) as T;
    }
    if (t == _i1.getType<_i8.AuthUser?>()) {
      return (data != null ? _i8.AuthUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AuthResponse?>()) {
      return (data != null ? _i8.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AuthenticationError?>()) {
      return (data != null ? _i8.AuthenticationError.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.AuthProvider?>()) {
      return (data != null ? _i8.AuthProvider.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AppleCredential?>()) {
      return (data != null ? _i8.AppleCredential.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.EmailCredential?>()) {
      return (data != null ? _i8.EmailCredential.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.GoogleCredential?>()) {
      return (data != null ? _i8.GoogleCredential.fromJson(data) : null) as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i8.AuthUser) {
      return 'AuthUser';
    }
    if (data is _i8.AuthResponse) {
      return 'AuthResponse';
    }
    if (data is _i8.AuthenticationError) {
      return 'AuthenticationError';
    }
    if (data is _i8.AuthProvider) {
      return 'AuthProvider';
    }
    if (data is _i8.AppleCredential) {
      return 'AppleCredential';
    }
    if (data is _i8.EmailCredential) {
      return 'EmailCredential';
    }
    if (data is _i8.GoogleCredential) {
      return 'GoogleCredential';
    }
    if (data is _i3.AuthUserDb) {
      return 'AuthUserDb';
    }
    if (data is _i4.AuthUserApple) {
      return 'AuthUserApple';
    }
    if (data is _i5.AuthUserEmail) {
      return 'AuthUserEmail';
    }
    if (data is _i6.AuthUserFailedLogin) {
      return 'AuthUserFailedLogin';
    }
    if (data is _i7.AuthUserGoogle) {
      return 'AuthUserGoogle';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthUser') {
      return deserialize<_i8.AuthUser>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i8.AuthResponse>(data['data']);
    }
    if (dataClassName == 'AuthenticationError') {
      return deserialize<_i8.AuthenticationError>(data['data']);
    }
    if (dataClassName == 'AuthProvider') {
      return deserialize<_i8.AuthProvider>(data['data']);
    }
    if (dataClassName == 'AppleCredential') {
      return deserialize<_i8.AppleCredential>(data['data']);
    }
    if (dataClassName == 'EmailCredential') {
      return deserialize<_i8.EmailCredential>(data['data']);
    }
    if (dataClassName == 'GoogleCredential') {
      return deserialize<_i8.GoogleCredential>(data['data']);
    }
    if (dataClassName == 'AuthUserDb') {
      return deserialize<_i3.AuthUserDb>(data['data']);
    }
    if (dataClassName == 'AuthUserApple') {
      return deserialize<_i4.AuthUserApple>(data['data']);
    }
    if (dataClassName == 'AuthUserEmail') {
      return deserialize<_i5.AuthUserEmail>(data['data']);
    }
    if (dataClassName == 'AuthUserFailedLogin') {
      return deserialize<_i6.AuthUserFailedLogin>(data['data']);
    }
    if (dataClassName == 'AuthUserGoogle') {
      return deserialize<_i7.AuthUserGoogle>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i3.AuthUserDb:
        return _i3.AuthUserDb.t;
      case _i4.AuthUserApple:
        return _i4.AuthUserApple.t;
      case _i5.AuthUserEmail:
        return _i5.AuthUserEmail.t;
      case _i6.AuthUserFailedLogin:
        return _i6.AuthUserFailedLogin.t;
      case _i7.AuthUserGoogle:
        return _i7.AuthUserGoogle.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'auth';
}
