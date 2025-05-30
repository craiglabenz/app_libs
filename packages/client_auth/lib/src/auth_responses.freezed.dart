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

/// @nodoc
mixin _$AuthResponse {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthResponse);
  }

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

class AuthSuccess extends AuthResponse {
  const AuthSuccess(this.user, {this.apiToken}) : super._();

  final AuthUser user;
  final String? apiToken;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthSuccessCopyWith<AuthSuccess> get copyWith =>
      _$AuthSuccessCopyWithImpl<AuthSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthSuccess &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.apiToken, apiToken) ||
                other.apiToken == apiToken));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, apiToken);

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
  $Res call({AuthUser user, String? apiToken});

  $AuthUserCopyWith<$Res> get user;
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
    Object? user = null,
    Object? apiToken = freezed,
  }) {
    return _then(AuthSuccess(
      null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as AuthUser,
      apiToken: freezed == apiToken
          ? _self.apiToken
          : apiToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthUserCopyWith<$Res> get user {
    return $AuthUserCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc

class AuthFailure extends AuthResponse {
  const AuthFailure(this.error) : super._();

  final AuthenticationError error;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthFailureCopyWith<AuthFailure> get copyWith =>
      _$AuthFailureCopyWithImpl<AuthFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthFailure &&
            (identical(other.error, error) || other.error == error));
  }

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

/// @nodoc
mixin _$AuthenticationError {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthenticationError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError()';
  }
}

/// @nodoc
class $AuthenticationErrorCopyWith<$Res> {
  $AuthenticationErrorCopyWith(
      AuthenticationError _, $Res Function(AuthenticationError) __);
}

/// @nodoc

class BadEmailPasswordError extends AuthenticationError {
  const BadEmailPasswordError() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BadEmailPasswordError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.badEmailPassword()';
  }
}

/// @nodoc

class CancelledSocialAuthError extends AuthenticationError {
  const CancelledSocialAuthError() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CancelledSocialAuthError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.cancelledSocialAuth()';
  }
}

/// @nodoc

class EmailTakenError extends AuthenticationError {
  const EmailTakenError() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EmailTakenError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.emailTaken()';
  }
}

/// @nodoc

class InvalidPasswordError extends AuthenticationError {
  const InvalidPasswordError() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InvalidPasswordError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.invalidPassword()';
  }
}

/// @nodoc

class InvalidCodeError extends AuthenticationError {
  const InvalidCodeError() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InvalidCodeError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.invalidCode()';
  }
}

/// @nodoc

class LogoutError extends AuthenticationError {
  const LogoutError() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LogoutError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.logoutError()';
  }
}

/// @nodoc

class MissingCredentials extends AuthenticationError {
  const MissingCredentials(
      {required this.missingEmail, required this.missingPassword})
      : super._();

  final bool missingEmail;
  final bool missingPassword;

  /// Create a copy of AuthenticationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MissingCredentialsCopyWith<MissingCredentials> get copyWith =>
      _$MissingCredentialsCopyWithImpl<MissingCredentials>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MissingCredentials &&
            (identical(other.missingEmail, missingEmail) ||
                other.missingEmail == missingEmail) &&
            (identical(other.missingPassword, missingPassword) ||
                other.missingPassword == missingPassword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, missingEmail, missingPassword);

  @override
  String toString() {
    return 'AuthenticationError.missingCredentials(missingEmail: $missingEmail, missingPassword: $missingPassword)';
  }
}

/// @nodoc
abstract mixin class $MissingCredentialsCopyWith<$Res>
    implements $AuthenticationErrorCopyWith<$Res> {
  factory $MissingCredentialsCopyWith(
          MissingCredentials value, $Res Function(MissingCredentials) _then) =
      _$MissingCredentialsCopyWithImpl;
  @useResult
  $Res call({bool missingEmail, bool missingPassword});
}

/// @nodoc
class _$MissingCredentialsCopyWithImpl<$Res>
    implements $MissingCredentialsCopyWith<$Res> {
  _$MissingCredentialsCopyWithImpl(this._self, this._then);

  final MissingCredentials _self;
  final $Res Function(MissingCredentials) _then;

  /// Create a copy of AuthenticationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? missingEmail = null,
    Object? missingPassword = null,
  }) {
    return _then(MissingCredentials(
      missingEmail: null == missingEmail
          ? _self.missingEmail
          : missingEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      missingPassword: null == missingPassword
          ? _self.missingPassword
          : missingPassword // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class WrongMethod extends AuthenticationError {
  const WrongMethod(final Set<AuthProvider> methods)
      : _methods = methods,
        super._();

  final Set<AuthProvider> _methods;
  Set<AuthProvider> get methods {
    if (_methods is EqualUnmodifiableSetView) return _methods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_methods);
  }

  /// Create a copy of AuthenticationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WrongMethodCopyWith<WrongMethod> get copyWith =>
      _$WrongMethodCopyWithImpl<WrongMethod>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WrongMethod &&
            const DeepCollectionEquality().equals(other._methods, _methods));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_methods));

  @override
  String toString() {
    return 'AuthenticationError.wrongMethod(methods: $methods)';
  }
}

/// @nodoc
abstract mixin class $WrongMethodCopyWith<$Res>
    implements $AuthenticationErrorCopyWith<$Res> {
  factory $WrongMethodCopyWith(
          WrongMethod value, $Res Function(WrongMethod) _then) =
      _$WrongMethodCopyWithImpl;
  @useResult
  $Res call({Set<AuthProvider> methods});
}

/// @nodoc
class _$WrongMethodCopyWithImpl<$Res> implements $WrongMethodCopyWith<$Res> {
  _$WrongMethodCopyWithImpl(this._self, this._then);

  final WrongMethod _self;
  final $Res Function(WrongMethod) _then;

  /// Create a copy of AuthenticationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? methods = null,
  }) {
    return _then(WrongMethod(
      null == methods
          ? _self._methods
          : methods // ignore: cast_nullable_to_non_nullable
              as Set<AuthProvider>,
    ));
  }
}

/// @nodoc

class UnknownAuthError extends AuthenticationError {
  const UnknownAuthError() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UnknownAuthError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.unknownError()';
  }
}

// dart format on
