// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AuthenticationError _$AuthenticationErrorFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'badEmailPassword':
      return BadEmailPasswordError.fromJson(json);
    case 'cancelledSocialAuth':
      return CancelledSocialAuthError.fromJson(json);
    case 'emailTaken':
      return EmailTakenError.fromJson(json);
    case 'invalidPassword':
      return InvalidPasswordError.fromJson(json);
    case 'invalidCode':
      return InvalidCodeError.fromJson(json);
    case 'logoutError':
      return LogoutError.fromJson(json);
    case 'missingCredentials':
      return MissingCredentials.fromJson(json);
    case 'conflict':
      return AuthConflict.fromJson(json);
    case 'expiredCredentials':
      return ExpiredCredentials.fromJson(json);
    case 'wrongMethod':
      return WrongMethod.fromJson(json);
    case 'unknownError':
      return UnknownAuthError.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AuthenticationError',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AuthenticationError {
  /// Serializes this AuthenticationError to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthenticationError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()
class BadEmailPasswordError extends AuthenticationError {
  const BadEmailPasswordError({final String? $type})
      : $type = $type ?? 'badEmailPassword',
        super._();
  factory BadEmailPasswordError.fromJson(Map<String, dynamic> json) =>
      _$BadEmailPasswordErrorFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$BadEmailPasswordErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BadEmailPasswordError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.badEmailPassword()';
  }
}

/// @nodoc
@JsonSerializable()
class CancelledSocialAuthError extends AuthenticationError {
  const CancelledSocialAuthError({final String? $type})
      : $type = $type ?? 'cancelledSocialAuth',
        super._();
  factory CancelledSocialAuthError.fromJson(Map<String, dynamic> json) =>
      _$CancelledSocialAuthErrorFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$CancelledSocialAuthErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CancelledSocialAuthError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.cancelledSocialAuth()';
  }
}

/// @nodoc
@JsonSerializable()
class EmailTakenError extends AuthenticationError {
  const EmailTakenError({final String? $type})
      : $type = $type ?? 'emailTaken',
        super._();
  factory EmailTakenError.fromJson(Map<String, dynamic> json) =>
      _$EmailTakenErrorFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$EmailTakenErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is EmailTakenError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.emailTaken()';
  }
}

/// @nodoc
@JsonSerializable()
class InvalidPasswordError extends AuthenticationError {
  const InvalidPasswordError({final String? $type})
      : $type = $type ?? 'invalidPassword',
        super._();
  factory InvalidPasswordError.fromJson(Map<String, dynamic> json) =>
      _$InvalidPasswordErrorFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$InvalidPasswordErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InvalidPasswordError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.invalidPassword()';
  }
}

/// @nodoc
@JsonSerializable()
class InvalidCodeError extends AuthenticationError {
  const InvalidCodeError({final String? $type})
      : $type = $type ?? 'invalidCode',
        super._();
  factory InvalidCodeError.fromJson(Map<String, dynamic> json) =>
      _$InvalidCodeErrorFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$InvalidCodeErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InvalidCodeError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.invalidCode()';
  }
}

/// @nodoc
@JsonSerializable()
class LogoutError extends AuthenticationError {
  const LogoutError({final String? $type})
      : $type = $type ?? 'logoutError',
        super._();
  factory LogoutError.fromJson(Map<String, dynamic> json) =>
      _$LogoutErrorFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$LogoutErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LogoutError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.logoutError()';
  }
}

/// @nodoc
@JsonSerializable()
class MissingCredentials extends AuthenticationError {
  const MissingCredentials(
      {required this.missingEmail,
      required this.missingPassword,
      final String? $type})
      : $type = $type ?? 'missingCredentials',
        super._();
  factory MissingCredentials.fromJson(Map<String, dynamic> json) =>
      _$MissingCredentialsFromJson(json);

  final bool missingEmail;
  final bool missingPassword;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AuthenticationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MissingCredentialsCopyWith<MissingCredentials> get copyWith =>
      _$MissingCredentialsCopyWithImpl<MissingCredentials>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MissingCredentialsToJson(
      this,
    );
  }

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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()
class AuthConflict extends AuthenticationError {
  const AuthConflict({final String? $type})
      : $type = $type ?? 'conflict',
        super._();
  factory AuthConflict.fromJson(Map<String, dynamic> json) =>
      _$AuthConflictFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$AuthConflictToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthConflict);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.conflict()';
  }
}

/// @nodoc
@JsonSerializable()
class ExpiredCredentials extends AuthenticationError {
  const ExpiredCredentials({final String? $type})
      : $type = $type ?? 'expiredCredentials',
        super._();
  factory ExpiredCredentials.fromJson(Map<String, dynamic> json) =>
      _$ExpiredCredentialsFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$ExpiredCredentialsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ExpiredCredentials);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.expiredCredentials()';
  }
}

/// @nodoc
@JsonSerializable()
class WrongMethod extends AuthenticationError {
  const WrongMethod(final Set<AuthProvider> methods, {final String? $type})
      : _methods = methods,
        $type = $type ?? 'wrongMethod',
        super._();
  factory WrongMethod.fromJson(Map<String, dynamic> json) =>
      _$WrongMethodFromJson(json);

  final Set<AuthProvider> _methods;
  Set<AuthProvider> get methods {
    if (_methods is EqualUnmodifiableSetView) return _methods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_methods);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of AuthenticationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WrongMethodCopyWith<WrongMethod> get copyWith =>
      _$WrongMethodCopyWithImpl<WrongMethod>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WrongMethodToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WrongMethod &&
            const DeepCollectionEquality().equals(other._methods, _methods));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
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
@JsonSerializable()
class UnknownAuthError extends AuthenticationError {
  const UnknownAuthError({final String? $type})
      : $type = $type ?? 'unknownError',
        super._();
  factory UnknownAuthError.fromJson(Map<String, dynamic> json) =>
      _$UnknownAuthErrorFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$UnknownAuthErrorToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UnknownAuthError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthenticationError.unknownError()';
  }
}

// dart format on
