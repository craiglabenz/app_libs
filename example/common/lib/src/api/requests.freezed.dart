// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UpdateProfileRequestBody _$UpdateProfileRequestBodyFromJson(
    Map<String, dynamic> json) {
  return _UpdateProfileRequestBody.fromJson(json);
}

/// @nodoc
mixin _$UpdateProfileRequestBody {
  UserCompanion get userCompanion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UpdateProfileRequestBodyCopyWith<UpdateProfileRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProfileRequestBodyCopyWith<$Res> {
  factory $UpdateProfileRequestBodyCopyWith(UpdateProfileRequestBody value,
          $Res Function(UpdateProfileRequestBody) then) =
      _$UpdateProfileRequestBodyCopyWithImpl<$Res, UpdateProfileRequestBody>;
  @useResult
  $Res call({UserCompanion userCompanion});

  $UserCompanionCopyWith<$Res> get userCompanion;
}

/// @nodoc
class _$UpdateProfileRequestBodyCopyWithImpl<$Res,
        $Val extends UpdateProfileRequestBody>
    implements $UpdateProfileRequestBodyCopyWith<$Res> {
  _$UpdateProfileRequestBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userCompanion = null,
  }) {
    return _then(_value.copyWith(
      userCompanion: null == userCompanion
          ? _value.userCompanion
          : userCompanion // ignore: cast_nullable_to_non_nullable
              as UserCompanion,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCompanionCopyWith<$Res> get userCompanion {
    return $UserCompanionCopyWith<$Res>(_value.userCompanion, (value) {
      return _then(_value.copyWith(userCompanion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UpdateProfileRequestBodyImplCopyWith<$Res>
    implements $UpdateProfileRequestBodyCopyWith<$Res> {
  factory _$$UpdateProfileRequestBodyImplCopyWith(
          _$UpdateProfileRequestBodyImpl value,
          $Res Function(_$UpdateProfileRequestBodyImpl) then) =
      __$$UpdateProfileRequestBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserCompanion userCompanion});

  @override
  $UserCompanionCopyWith<$Res> get userCompanion;
}

/// @nodoc
class __$$UpdateProfileRequestBodyImplCopyWithImpl<$Res>
    extends _$UpdateProfileRequestBodyCopyWithImpl<$Res,
        _$UpdateProfileRequestBodyImpl>
    implements _$$UpdateProfileRequestBodyImplCopyWith<$Res> {
  __$$UpdateProfileRequestBodyImplCopyWithImpl(
      _$UpdateProfileRequestBodyImpl _value,
      $Res Function(_$UpdateProfileRequestBodyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userCompanion = null,
  }) {
    return _then(_$UpdateProfileRequestBodyImpl(
      userCompanion: null == userCompanion
          ? _value.userCompanion
          : userCompanion // ignore: cast_nullable_to_non_nullable
              as UserCompanion,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateProfileRequestBodyImpl implements _UpdateProfileRequestBody {
  const _$UpdateProfileRequestBodyImpl({required this.userCompanion});

  factory _$UpdateProfileRequestBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateProfileRequestBodyImplFromJson(json);

  @override
  final UserCompanion userCompanion;

  @override
  String toString() {
    return 'UpdateProfileRequestBody(userCompanion: $userCompanion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileRequestBodyImpl &&
            (identical(other.userCompanion, userCompanion) ||
                other.userCompanion == userCompanion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userCompanion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileRequestBodyImplCopyWith<_$UpdateProfileRequestBodyImpl>
      get copyWith => __$$UpdateProfileRequestBodyImplCopyWithImpl<
          _$UpdateProfileRequestBodyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateProfileRequestBodyImplToJson(
      this,
    );
  }
}

abstract class _UpdateProfileRequestBody implements UpdateProfileRequestBody {
  const factory _UpdateProfileRequestBody(
          {required final UserCompanion userCompanion}) =
      _$UpdateProfileRequestBodyImpl;

  factory _UpdateProfileRequestBody.fromJson(Map<String, dynamic> json) =
      _$UpdateProfileRequestBodyImpl.fromJson;

  @override
  UserCompanion get userCompanion;
  @override
  @JsonKey(ignore: true)
  _$$UpdateProfileRequestBodyImplCopyWith<_$UpdateProfileRequestBodyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
