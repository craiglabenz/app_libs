// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'increment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Increment _$IncrementFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'default':
      return _Increment.fromJson(json);
    case 'create':
      return IncrementCreate.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'Increment',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$Increment {
  int get delta => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, int delta, DateTime createdAt) $default, {
    required TResult Function(int delta, DateTime createdAt) create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, int delta, DateTime createdAt)? $default, {
    TResult? Function(int delta, DateTime createdAt)? create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, int delta, DateTime createdAt)? $default, {
    TResult Function(int delta, DateTime createdAt)? create,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Increment value) $default, {
    required TResult Function(IncrementCreate value) create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Increment value)? $default, {
    TResult? Function(IncrementCreate value)? create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Increment value)? $default, {
    TResult Function(IncrementCreate value)? create,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IncrementCopyWith<Increment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncrementCopyWith<$Res> {
  factory $IncrementCopyWith(Increment value, $Res Function(Increment) then) =
      _$IncrementCopyWithImpl<$Res, Increment>;
  @useResult
  $Res call({int delta, DateTime createdAt});
}

/// @nodoc
class _$IncrementCopyWithImpl<$Res, $Val extends Increment>
    implements $IncrementCopyWith<$Res> {
  _$IncrementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delta = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncrementImplCopyWith<$Res>
    implements $IncrementCopyWith<$Res> {
  factory _$$IncrementImplCopyWith(
          _$IncrementImpl value, $Res Function(_$IncrementImpl) then) =
      __$$IncrementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int delta, DateTime createdAt});
}

/// @nodoc
class __$$IncrementImplCopyWithImpl<$Res>
    extends _$IncrementCopyWithImpl<$Res, _$IncrementImpl>
    implements _$$IncrementImplCopyWith<$Res> {
  __$$IncrementImplCopyWithImpl(
      _$IncrementImpl _value, $Res Function(_$IncrementImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? delta = null,
    Object? createdAt = null,
  }) {
    return _then(_$IncrementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncrementImpl extends _Increment {
  const _$IncrementImpl(
      {required this.id,
      required this.delta,
      required this.createdAt,
      final String? $type})
      : $type = $type ?? 'default',
        super._();

  factory _$IncrementImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncrementImplFromJson(json);

  @override
  final String id;
  @override
  final int delta;
  @override
  final DateTime createdAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Increment(id: $id, delta: $delta, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncrementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, delta, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncrementImplCopyWith<_$IncrementImpl> get copyWith =>
      __$$IncrementImplCopyWithImpl<_$IncrementImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, int delta, DateTime createdAt) $default, {
    required TResult Function(int delta, DateTime createdAt) create,
  }) {
    return $default(id, delta, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, int delta, DateTime createdAt)? $default, {
    TResult? Function(int delta, DateTime createdAt)? create,
  }) {
    return $default?.call(id, delta, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, int delta, DateTime createdAt)? $default, {
    TResult Function(int delta, DateTime createdAt)? create,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, delta, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Increment value) $default, {
    required TResult Function(IncrementCreate value) create,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Increment value)? $default, {
    TResult? Function(IncrementCreate value)? create,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Increment value)? $default, {
    TResult Function(IncrementCreate value)? create,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IncrementImplToJson(
      this,
    );
  }
}

abstract class _Increment extends Increment {
  const factory _Increment(
      {required final String id,
      required final int delta,
      required final DateTime createdAt}) = _$IncrementImpl;
  const _Increment._() : super._();

  factory _Increment.fromJson(Map<String, dynamic> json) =
      _$IncrementImpl.fromJson;

  String get id;
  @override
  int get delta;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$IncrementImplCopyWith<_$IncrementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IncrementCreateImplCopyWith<$Res>
    implements $IncrementCopyWith<$Res> {
  factory _$$IncrementCreateImplCopyWith(_$IncrementCreateImpl value,
          $Res Function(_$IncrementCreateImpl) then) =
      __$$IncrementCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int delta, DateTime createdAt});
}

/// @nodoc
class __$$IncrementCreateImplCopyWithImpl<$Res>
    extends _$IncrementCopyWithImpl<$Res, _$IncrementCreateImpl>
    implements _$$IncrementCreateImplCopyWith<$Res> {
  __$$IncrementCreateImplCopyWithImpl(
      _$IncrementCreateImpl _value, $Res Function(_$IncrementCreateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? delta = null,
    Object? createdAt = null,
  }) {
    return _then(_$IncrementCreateImpl(
      delta: null == delta
          ? _value.delta
          : delta // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncrementCreateImpl extends IncrementCreate {
  const _$IncrementCreateImpl(
      {required this.delta, required this.createdAt, final String? $type})
      : $type = $type ?? 'create',
        super._();

  factory _$IncrementCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncrementCreateImplFromJson(json);

  @override
  final int delta;
  @override
  final DateTime createdAt;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Increment.create(delta: $delta, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncrementCreateImpl &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, delta, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncrementCreateImplCopyWith<_$IncrementCreateImpl> get copyWith =>
      __$$IncrementCreateImplCopyWithImpl<_$IncrementCreateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, int delta, DateTime createdAt) $default, {
    required TResult Function(int delta, DateTime createdAt) create,
  }) {
    return create(delta, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, int delta, DateTime createdAt)? $default, {
    TResult? Function(int delta, DateTime createdAt)? create,
  }) {
    return create?.call(delta, createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, int delta, DateTime createdAt)? $default, {
    TResult Function(int delta, DateTime createdAt)? create,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(delta, createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Increment value) $default, {
    required TResult Function(IncrementCreate value) create,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Increment value)? $default, {
    TResult? Function(IncrementCreate value)? create,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Increment value)? $default, {
    TResult Function(IncrementCreate value)? create,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IncrementCreateImplToJson(
      this,
    );
  }
}

abstract class IncrementCreate extends Increment {
  const factory IncrementCreate(
      {required final int delta,
      required final DateTime createdAt}) = _$IncrementCreateImpl;
  const IncrementCreate._() : super._();

  factory IncrementCreate.fromJson(Map<String, dynamic> json) =
      _$IncrementCreateImpl.fromJson;

  @override
  int get delta;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$IncrementCreateImplCopyWith<_$IncrementCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
