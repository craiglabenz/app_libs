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
mixin _$SocialAuthResponse {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SocialAuthResponse);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'SocialAuthResponse()';
  }
}

/// @nodoc
class $SocialAuthResponseCopyWith<$Res> {
  $SocialAuthResponseCopyWith(
      SocialAuthResponse _, $Res Function(SocialAuthResponse) __);
}

/// @nodoc

class SocialAuthSuccess extends SocialAuthResponse {
  const SocialAuthSuccess(this.user, {this.credential}) : super._();

  final SocialUser user;
  final SocialCredential? credential;

  /// Create a copy of SocialAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SocialAuthSuccessCopyWith<SocialAuthSuccess> get copyWith =>
      _$SocialAuthSuccessCopyWithImpl<SocialAuthSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SocialAuthSuccess &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.credential, credential) ||
                other.credential == credential));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, credential);

  @override
  String toString() {
    return 'SocialAuthResponse.success(user: $user, credential: $credential)';
  }
}

/// @nodoc
abstract mixin class $SocialAuthSuccessCopyWith<$Res>
    implements $SocialAuthResponseCopyWith<$Res> {
  factory $SocialAuthSuccessCopyWith(
          SocialAuthSuccess value, $Res Function(SocialAuthSuccess) _then) =
      _$SocialAuthSuccessCopyWithImpl;
  @useResult
  $Res call({SocialUser user, SocialCredential? credential});

  $SocialCredentialCopyWith<$Res>? get credential;
}

/// @nodoc
class _$SocialAuthSuccessCopyWithImpl<$Res>
    implements $SocialAuthSuccessCopyWith<$Res> {
  _$SocialAuthSuccessCopyWithImpl(this._self, this._then);

  final SocialAuthSuccess _self;
  final $Res Function(SocialAuthSuccess) _then;

  /// Create a copy of SocialAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = null,
    Object? credential = freezed,
  }) {
    return _then(SocialAuthSuccess(
      null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as SocialUser,
      credential: freezed == credential
          ? _self.credential
          : credential // ignore: cast_nullable_to_non_nullable
              as SocialCredential?,
    ));
  }

  /// Create a copy of SocialAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SocialCredentialCopyWith<$Res>? get credential {
    if (_self.credential == null) {
      return null;
    }

    return $SocialCredentialCopyWith<$Res>(_self.credential!, (value) {
      return _then(_self.copyWith(credential: value));
    });
  }
}

/// @nodoc

class SocialAuthFailure extends SocialAuthResponse {
  const SocialAuthFailure(this.error) : super._();

  final AuthenticationError error;

  /// Create a copy of SocialAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SocialAuthFailureCopyWith<SocialAuthFailure> get copyWith =>
      _$SocialAuthFailureCopyWithImpl<SocialAuthFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SocialAuthFailure &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'SocialAuthResponse.failure(error: $error)';
  }
}

/// @nodoc
abstract mixin class $SocialAuthFailureCopyWith<$Res>
    implements $SocialAuthResponseCopyWith<$Res> {
  factory $SocialAuthFailureCopyWith(
          SocialAuthFailure value, $Res Function(SocialAuthFailure) _then) =
      _$SocialAuthFailureCopyWithImpl;
  @useResult
  $Res call({AuthenticationError error});

  $AuthenticationErrorCopyWith<$Res> get error;
}

/// @nodoc
class _$SocialAuthFailureCopyWithImpl<$Res>
    implements $SocialAuthFailureCopyWith<$Res> {
  _$SocialAuthFailureCopyWithImpl(this._self, this._then);

  final SocialAuthFailure _self;
  final $Res Function(SocialAuthFailure) _then;

  /// Create a copy of SocialAuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(SocialAuthFailure(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as AuthenticationError,
    ));
  }

  /// Create a copy of SocialAuthResponse
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
