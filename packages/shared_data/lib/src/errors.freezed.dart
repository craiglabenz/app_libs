// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
InvalidValueError _$InvalidValueErrorFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'invalidApiKey':
      return InvalidApiKey.fromJson(json);
    case 'invalidEmail':
      return InvalidEmail.fromJson(json);
    case 'passwordTooShort':
      return PasswordTooShort.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'InvalidValueError',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$InvalidValueError {
  /// Serializes this InvalidValueError to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InvalidValueError);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'InvalidValueError()';
  }
}

/// @nodoc
class $InvalidValueErrorCopyWith<$Res> {
  $InvalidValueErrorCopyWith(
      InvalidValueError _, $Res Function(InvalidValueError) __);
}

/// @nodoc
@JsonSerializable()
class InvalidApiKey extends InvalidValueError {
  const InvalidApiKey({final String? $type})
      : $type = $type ?? 'invalidApiKey',
        super._();
  factory InvalidApiKey.fromJson(Map<String, dynamic> json) =>
      _$InvalidApiKeyFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$InvalidApiKeyToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InvalidApiKey);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'InvalidValueError.invalidApiKey()';
  }
}

/// @nodoc
@JsonSerializable()
class InvalidEmail extends InvalidValueError {
  const InvalidEmail({final String? $type})
      : $type = $type ?? 'invalidEmail',
        super._();
  factory InvalidEmail.fromJson(Map<String, dynamic> json) =>
      _$InvalidEmailFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$InvalidEmailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is InvalidEmail);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'InvalidValueError.invalidEmail()';
  }
}

/// @nodoc
@JsonSerializable()
class PasswordTooShort extends InvalidValueError {
  const PasswordTooShort(this.minimumLength, {final String? $type})
      : $type = $type ?? 'passwordTooShort',
        super._();
  factory PasswordTooShort.fromJson(Map<String, dynamic> json) =>
      _$PasswordTooShortFromJson(json);

  final int minimumLength;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of InvalidValueError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PasswordTooShortCopyWith<PasswordTooShort> get copyWith =>
      _$PasswordTooShortCopyWithImpl<PasswordTooShort>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PasswordTooShortToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PasswordTooShort &&
            (identical(other.minimumLength, minimumLength) ||
                other.minimumLength == minimumLength));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, minimumLength);

  @override
  String toString() {
    return 'InvalidValueError.passwordTooShort(minimumLength: $minimumLength)';
  }
}

/// @nodoc
abstract mixin class $PasswordTooShortCopyWith<$Res>
    implements $InvalidValueErrorCopyWith<$Res> {
  factory $PasswordTooShortCopyWith(
          PasswordTooShort value, $Res Function(PasswordTooShort) _then) =
      _$PasswordTooShortCopyWithImpl;
  @useResult
  $Res call({int minimumLength});
}

/// @nodoc
class _$PasswordTooShortCopyWithImpl<$Res>
    implements $PasswordTooShortCopyWith<$Res> {
  _$PasswordTooShortCopyWithImpl(this._self, this._then);

  final PasswordTooShort _self;
  final $Res Function(PasswordTooShort) _then;

  /// Create a copy of InvalidValueError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? minimumLength = null,
  }) {
    return _then(PasswordTooShort(
      null == minimumLength
          ? _self.minimumLength
          : minimumLength // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
