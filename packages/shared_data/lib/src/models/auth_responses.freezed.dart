// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_responses.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'success':
      return AuthSuccess.fromJson(json);
    case 'failure':
      return AuthFailure.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AuthResponse',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AuthResponse {
  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthResponse);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthResponse()';
  }
}

/// @nodoc
class $AuthResponseCopyWith<$Res> {
  $AuthResponseCopyWith(AuthResponse _, $Res Function(AuthResponse) __);
}

/// @nodoc
@JsonSerializable()
class AuthSuccess extends AuthResponse {
  const AuthSuccess(@AuthUserConverter() this.user,
      {this.apiToken, final String? $type})
      : $type = $type ?? 'success',
        super._();
  factory AuthSuccess.fromJson(Map<String, dynamic> json) =>
      _$AuthSuccessFromJson(json);

  @AuthUserConverter()
  final AuthUser user;
  final String? apiToken;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthSuccessCopyWith<AuthSuccess> get copyWith =>
      _$AuthSuccessCopyWithImpl<AuthSuccess>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthSuccessToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthSuccess &&
            const DeepCollectionEquality().equals(other.user, user) &&
            (identical(other.apiToken, apiToken) ||
                other.apiToken == apiToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(user), apiToken);

  @override
  String toString() {
    return 'AuthResponse.success(user: $user, apiToken: $apiToken)';
  }
}

/// @nodoc
abstract mixin class $AuthSuccessCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory $AuthSuccessCopyWith(
          AuthSuccess value, $Res Function(AuthSuccess) _then) =
      _$AuthSuccessCopyWithImpl;
  @useResult
  $Res call({@AuthUserConverter() AuthUser user, String? apiToken});
}

/// @nodoc
class _$AuthSuccessCopyWithImpl<$Res> implements $AuthSuccessCopyWith<$Res> {
  _$AuthSuccessCopyWithImpl(this._self, this._then);

  final AuthSuccess _self;
  final $Res Function(AuthSuccess) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = freezed,
    Object? apiToken = freezed,
  }) {
    return _then(AuthSuccess(
      freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUser,
      apiToken: freezed == apiToken
          ? _self.apiToken
          : apiToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class AuthFailure extends AuthResponse {
  const AuthFailure(this.error, {final String? $type})
      : $type = $type ?? 'failure',
        super._();
  factory AuthFailure.fromJson(Map<String, dynamic> json) =>
      _$AuthFailureFromJson(json);

  final AuthenticationError error;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthFailureCopyWith<AuthFailure> get copyWith =>
      _$AuthFailureCopyWithImpl<AuthFailure>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthFailureToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthFailure &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'AuthResponse.failure(error: $error)';
  }
}

/// @nodoc
abstract mixin class $AuthFailureCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory $AuthFailureCopyWith(
          AuthFailure value, $Res Function(AuthFailure) _then) =
      _$AuthFailureCopyWithImpl;
  @useResult
  $Res call({AuthenticationError error});

  $AuthenticationErrorCopyWith<$Res> get error;
}

/// @nodoc
class _$AuthFailureCopyWithImpl<$Res> implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._self, this._then);

  final AuthFailure _self;
  final $Res Function(AuthFailure) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(AuthFailure(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as AuthenticationError,
    ));
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthenticationErrorCopyWith<$Res> get error {
    return $AuthenticationErrorCopyWith<$Res>(_self.error, (value) {
      return _then(_self.copyWith(error: value));
    });
  }
}

// dart format on
