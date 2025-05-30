// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthUser {
  /// Unique identifier.
  String get id;

  /// User's email address. Null for anonymous users and possibly some social
  /// auth situations.
  String? get email;

  /// Origin timestamp of the user.
  DateTime get createdAt;

  /// Identity verifying provider for this session.
  AuthProvider get provider;

  /// All providers the user has attached to their account.
  Set<AuthProvider> get allProviders;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<AuthUser> get copyWith =>
      _$AuthUserCopyWithImpl<AuthUser>(this as AuthUser, _$identity);

  /// Serializes this AuthUser to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            const DeepCollectionEquality()
                .equals(other.allProviders, allProviders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, createdAt, provider,
      const DeepCollectionEquality().hash(allProviders));

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, createdAt: $createdAt, provider: $provider, allProviders: $allProviders)';
  }
}

/// @nodoc
abstract mixin class $AuthUserCopyWith<$Res> {
  factory $AuthUserCopyWith(AuthUser value, $Res Function(AuthUser) _then) =
      _$AuthUserCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? email,
      DateTime createdAt,
      AuthProvider provider,
      Set<AuthProvider> allProviders});
}

/// @nodoc
class _$AuthUserCopyWithImpl<$Res> implements $AuthUserCopyWith<$Res> {
  _$AuthUserCopyWithImpl(this._self, this._then);

  final AuthUser _self;
  final $Res Function(AuthUser) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? createdAt = null,
    Object? provider = null,
    Object? allProviders = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      provider: null == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as AuthProvider,
      allProviders: null == allProviders
          ? _self.allProviders
          : allProviders // ignore: cast_nullable_to_non_nullable
              as Set<AuthProvider>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AuthUser extends AuthUser {
  const _AuthUser(
      {required this.id,
      this.email,
      required this.createdAt,
      required this.provider,
      required final Set<AuthProvider> allProviders})
      : _allProviders = allProviders,
        super._();
  factory _AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  /// Unique identifier.
  @override
  final String id;

  /// User's email address. Null for anonymous users and possibly some social
  /// auth situations.
  @override
  final String? email;

  /// Origin timestamp of the user.
  @override
  final DateTime createdAt;

  /// Identity verifying provider for this session.
  @override
  final AuthProvider provider;

  /// All providers the user has attached to their account.
  final Set<AuthProvider> _allProviders;

  /// All providers the user has attached to their account.
  @override
  Set<AuthProvider> get allProviders {
    if (_allProviders is EqualUnmodifiableSetView) return _allProviders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_allProviders);
  }

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthUserCopyWith<_AuthUser> get copyWith =>
      __$AuthUserCopyWithImpl<_AuthUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthUserToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            const DeepCollectionEquality()
                .equals(other._allProviders, _allProviders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, createdAt, provider,
      const DeepCollectionEquality().hash(_allProviders));

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, createdAt: $createdAt, provider: $provider, allProviders: $allProviders)';
  }
}

/// @nodoc
abstract mixin class _$AuthUserCopyWith<$Res>
    implements $AuthUserCopyWith<$Res> {
  factory _$AuthUserCopyWith(_AuthUser value, $Res Function(_AuthUser) _then) =
      __$AuthUserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? email,
      DateTime createdAt,
      AuthProvider provider,
      Set<AuthProvider> allProviders});
}

/// @nodoc
class __$AuthUserCopyWithImpl<$Res> implements _$AuthUserCopyWith<$Res> {
  __$AuthUserCopyWithImpl(this._self, this._then);

  final _AuthUser _self;
  final $Res Function(_AuthUser) _then;

  /// Create a copy of AuthUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? createdAt = null,
    Object? provider = null,
    Object? allProviders = null,
  }) {
    return _then(_AuthUser(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      provider: null == provider
          ? _self.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as AuthProvider,
      allProviders: null == allProviders
          ? _self._allProviders
          : allProviders // ignore: cast_nullable_to_non_nullable
              as Set<AuthProvider>,
    ));
  }
}

// dart format on
