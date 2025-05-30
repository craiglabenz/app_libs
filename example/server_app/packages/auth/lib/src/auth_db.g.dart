// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_db.dart';

// ignore_for_file: type=lint
class $AuthUsersTable extends AuthUsers
    with TableInfo<$AuthUsersTable, DbAuthUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<UuidValue> uid = GeneratedColumn<UuidValue>(
      'uid', aliasedName, false,
      type: PgTypes.uuid,
      requiredDuringInsert: false,
      defaultValue: genRandomUuid());
  static const VerificationMeta _apiKeyMeta = const VerificationMeta('apiKey');
  @override
  late final GeneratedColumn<String> apiKey = GeneratedColumn<String>(
      'api_key', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 32, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password =
      GeneratedColumn<String>('password', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 40,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _lastLoginMeta =
      const VerificationMeta('lastLogin');
  @override
  late final GeneratedColumn<PgDateTime> lastLogin =
      GeneratedColumn<PgDateTime>('last_login', aliasedName, true,
          type: PgTypes.timestampTimezone, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<PgDateTime> createdAt =
      GeneratedColumn<PgDateTime>('created_at', aliasedName, false,
          type: PgTypes.timestampTimezone,
          requiredDuringInsert: false,
          defaultValue: now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<PgDateTime> updatedAt =
      GeneratedColumn<PgDateTime>('updated_at', aliasedName, false,
          type: PgTypes.timestampTimezone,
          requiredDuringInsert: false,
          defaultValue: now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uid,
        apiKey,
        email,
        isActive,
        password,
        lastLogin,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_users';
  @override
  VerificationContext validateIntegrity(Insertable<DbAuthUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    }
    if (data.containsKey('api_key')) {
      context.handle(_apiKeyMeta,
          apiKey.isAcceptableOrUnknown(data['api_key']!, _apiKeyMeta));
    } else if (isInserting) {
      context.missing(_apiKeyMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('last_login')) {
      context.handle(_lastLoginMeta,
          lastLogin.isAcceptableOrUnknown(data['last_login']!, _lastLoginMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbAuthUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbAuthUser(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uid: attachedDatabase.typeMapping
          .read(PgTypes.uuid, data['${effectivePrefix}uid'])!,
      apiKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_key'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      lastLogin: attachedDatabase.typeMapping.read(
          PgTypes.timestampTimezone, data['${effectivePrefix}last_login']),
      createdAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampTimezone, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping.read(
          PgTypes.timestampTimezone, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AuthUsersTable createAlias(String alias) {
    return $AuthUsersTable(attachedDatabase, alias);
  }
}

class DbAuthUser extends DataClass implements Insertable<DbAuthUser> {
  /// Primary key.
  final int id;

  /// Public-facing pseudo-primary key.
  final UuidValue uid;

  /// Token for requests from the client.
  final String apiKey;

  /// Email of this user.
  final String? email;

  /// Flag to disable accounts.
  final int isActive;

  /// Hashed store of the user's password.
  final String password;

  /// DateTime of user's last activity.
  final PgDateTime? lastLogin;

  /// DateTime of account creation.
  final PgDateTime createdAt;

  /// DateTime of last update.
  final PgDateTime updatedAt;
  const DbAuthUser(
      {required this.id,
      required this.uid,
      required this.apiKey,
      this.email,
      required this.isActive,
      required this.password,
      this.lastLogin,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<UuidValue>(uid, PgTypes.uuid);
    map['api_key'] = Variable<String>(apiKey);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['is_active'] = Variable<int>(isActive);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || lastLogin != null) {
      map['last_login'] =
          Variable<PgDateTime>(lastLogin, PgTypes.timestampTimezone);
    }
    map['created_at'] =
        Variable<PgDateTime>(createdAt, PgTypes.timestampTimezone);
    map['updated_at'] =
        Variable<PgDateTime>(updatedAt, PgTypes.timestampTimezone);
    return map;
  }

  AuthUsersCompanion toCompanion(bool nullToAbsent) {
    return AuthUsersCompanion(
      id: Value(id),
      uid: Value(uid),
      apiKey: Value(apiKey),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      isActive: Value(isActive),
      password: Value(password),
      lastLogin: lastLogin == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLogin),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DbAuthUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbAuthUser(
      id: serializer.fromJson<int>(json['id']),
      uid: serializer.fromJson<UuidValue>(json['uid']),
      apiKey: serializer.fromJson<String>(json['apiKey']),
      email: serializer.fromJson<String?>(json['email']),
      isActive: serializer.fromJson<int>(json['isActive']),
      password: serializer.fromJson<String>(json['password']),
      lastLogin: serializer.fromJson<PgDateTime?>(json['lastLogin']),
      createdAt: serializer.fromJson<PgDateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<PgDateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<UuidValue>(uid),
      'apiKey': serializer.toJson<String>(apiKey),
      'email': serializer.toJson<String?>(email),
      'isActive': serializer.toJson<int>(isActive),
      'password': serializer.toJson<String>(password),
      'lastLogin': serializer.toJson<PgDateTime?>(lastLogin),
      'createdAt': serializer.toJson<PgDateTime>(createdAt),
      'updatedAt': serializer.toJson<PgDateTime>(updatedAt),
    };
  }

  DbAuthUser copyWith(
          {int? id,
          UuidValue? uid,
          String? apiKey,
          Value<String?> email = const Value.absent(),
          int? isActive,
          String? password,
          Value<PgDateTime?> lastLogin = const Value.absent(),
          PgDateTime? createdAt,
          PgDateTime? updatedAt}) =>
      DbAuthUser(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        apiKey: apiKey ?? this.apiKey,
        email: email.present ? email.value : this.email,
        isActive: isActive ?? this.isActive,
        password: password ?? this.password,
        lastLogin: lastLogin.present ? lastLogin.value : this.lastLogin,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('DbAuthUser(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('apiKey: $apiKey, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('password: $password, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uid, apiKey, email, isActive, password,
      lastLogin, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbAuthUser &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.apiKey == this.apiKey &&
          other.email == this.email &&
          other.isActive == this.isActive &&
          other.password == this.password &&
          other.lastLogin == this.lastLogin &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AuthUsersCompanion extends UpdateCompanion<DbAuthUser> {
  final Value<int> id;
  final Value<UuidValue> uid;
  final Value<String> apiKey;
  final Value<String?> email;
  final Value<int> isActive;
  final Value<String> password;
  final Value<PgDateTime?> lastLogin;
  final Value<PgDateTime> createdAt;
  final Value<PgDateTime> updatedAt;
  const AuthUsersCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.apiKey = const Value.absent(),
    this.email = const Value.absent(),
    this.isActive = const Value.absent(),
    this.password = const Value.absent(),
    this.lastLogin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AuthUsersCompanion.insert({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    required String apiKey,
    this.email = const Value.absent(),
    this.isActive = const Value.absent(),
    required String password,
    this.lastLogin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : apiKey = Value(apiKey),
        password = Value(password);
  static Insertable<DbAuthUser> custom({
    Expression<int>? id,
    Expression<UuidValue>? uid,
    Expression<String>? apiKey,
    Expression<String>? email,
    Expression<int>? isActive,
    Expression<String>? password,
    Expression<PgDateTime>? lastLogin,
    Expression<PgDateTime>? createdAt,
    Expression<PgDateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (apiKey != null) 'api_key': apiKey,
      if (email != null) 'email': email,
      if (isActive != null) 'is_active': isActive,
      if (password != null) 'password': password,
      if (lastLogin != null) 'last_login': lastLogin,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AuthUsersCompanion copyWith(
      {Value<int>? id,
      Value<UuidValue>? uid,
      Value<String>? apiKey,
      Value<String?>? email,
      Value<int>? isActive,
      Value<String>? password,
      Value<PgDateTime?>? lastLogin,
      Value<PgDateTime>? createdAt,
      Value<PgDateTime>? updatedAt}) {
    return AuthUsersCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      apiKey: apiKey ?? this.apiKey,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      password: password ?? this.password,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<UuidValue>(uid.value, PgTypes.uuid);
    }
    if (apiKey.present) {
      map['api_key'] = Variable<String>(apiKey.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (lastLogin.present) {
      map['last_login'] =
          Variable<PgDateTime>(lastLogin.value, PgTypes.timestampTimezone);
    }
    if (createdAt.present) {
      map['created_at'] =
          Variable<PgDateTime>(createdAt.value, PgTypes.timestampTimezone);
    }
    if (updatedAt.present) {
      map['updated_at'] =
          Variable<PgDateTime>(updatedAt.value, PgTypes.timestampTimezone);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthUsersCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('apiKey: $apiKey, ')
          ..write('email: $email, ')
          ..write('isActive: $isActive, ')
          ..write('password: $password, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AuthDb extends GeneratedDatabase {
  _$AuthDb(QueryExecutor e) : super(e);
  late final $AuthUsersTable authUsers = $AuthUsersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [authUsers];
}
