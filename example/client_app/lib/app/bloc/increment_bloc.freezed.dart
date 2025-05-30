// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'increment_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IncrementEvent _$IncrementEventFromJson(Map<String, dynamic> json) {
  return _IncrementEvent.fromJson(json);
}

/// @nodoc
mixin _$IncrementEvent {
  @IncrementConverter()
  IncrementCreate get incr => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IncrementEventCopyWith<IncrementEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncrementEventCopyWith<$Res> {
  factory $IncrementEventCopyWith(
          IncrementEvent value, $Res Function(IncrementEvent) then) =
      _$IncrementEventCopyWithImpl<$Res, IncrementEvent>;
  @useResult
  $Res call({@IncrementConverter() IncrementCreate incr});
}

/// @nodoc
class _$IncrementEventCopyWithImpl<$Res, $Val extends IncrementEvent>
    implements $IncrementEventCopyWith<$Res> {
  _$IncrementEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incr = null,
  }) {
    return _then(_value.copyWith(
      incr: null == incr
          ? _value.incr
          : incr // ignore: cast_nullable_to_non_nullable
              as IncrementCreate,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncrementEventImplCopyWith<$Res>
    implements $IncrementEventCopyWith<$Res> {
  factory _$$IncrementEventImplCopyWith(_$IncrementEventImpl value,
          $Res Function(_$IncrementEventImpl) then) =
      __$$IncrementEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@IncrementConverter() IncrementCreate incr});
}

/// @nodoc
class __$$IncrementEventImplCopyWithImpl<$Res>
    extends _$IncrementEventCopyWithImpl<$Res, _$IncrementEventImpl>
    implements _$$IncrementEventImplCopyWith<$Res> {
  __$$IncrementEventImplCopyWithImpl(
      _$IncrementEventImpl _value, $Res Function(_$IncrementEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incr = null,
  }) {
    return _then(_$IncrementEventImpl(
      null == incr
          ? _value.incr
          : incr // ignore: cast_nullable_to_non_nullable
              as IncrementCreate,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncrementEventImpl extends _IncrementEvent {
  const _$IncrementEventImpl(@IncrementConverter() this.incr) : super._();

  factory _$IncrementEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncrementEventImplFromJson(json);

  @override
  @IncrementConverter()
  final IncrementCreate incr;

  @override
  String toString() {
    return 'IncrementEvent(incr: $incr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncrementEventImpl &&
            (identical(other.incr, incr) || other.incr == incr));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, incr);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncrementEventImplCopyWith<_$IncrementEventImpl> get copyWith =>
      __$$IncrementEventImplCopyWithImpl<_$IncrementEventImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncrementEventImplToJson(
      this,
    );
  }
}

abstract class _IncrementEvent extends IncrementEvent {
  const factory _IncrementEvent(
      @IncrementConverter() final IncrementCreate incr) = _$IncrementEventImpl;
  const _IncrementEvent._() : super._();

  factory _IncrementEvent.fromJson(Map<String, dynamic> json) =
      _$IncrementEventImpl.fromJson;

  @override
  @IncrementConverter()
  IncrementCreate get incr;
  @override
  @JsonKey(ignore: true)
  _$$IncrementEventImplCopyWith<_$IncrementEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IncrementState _$IncrementStateFromJson(Map<String, dynamic> json) {
  return _IncrementState.fromJson(json);
}

/// @nodoc
mixin _$IncrementState {
  List<Increment> get log => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IncrementStateCopyWith<IncrementState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncrementStateCopyWith<$Res> {
  factory $IncrementStateCopyWith(
          IncrementState value, $Res Function(IncrementState) then) =
      _$IncrementStateCopyWithImpl<$Res, IncrementState>;
  @useResult
  $Res call({List<Increment> log});
}

/// @nodoc
class _$IncrementStateCopyWithImpl<$Res, $Val extends IncrementState>
    implements $IncrementStateCopyWith<$Res> {
  _$IncrementStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? log = null,
  }) {
    return _then(_value.copyWith(
      log: null == log
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as List<Increment>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncrementStateImplCopyWith<$Res>
    implements $IncrementStateCopyWith<$Res> {
  factory _$$IncrementStateImplCopyWith(_$IncrementStateImpl value,
          $Res Function(_$IncrementStateImpl) then) =
      __$$IncrementStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Increment> log});
}

/// @nodoc
class __$$IncrementStateImplCopyWithImpl<$Res>
    extends _$IncrementStateCopyWithImpl<$Res, _$IncrementStateImpl>
    implements _$$IncrementStateImplCopyWith<$Res> {
  __$$IncrementStateImplCopyWithImpl(
      _$IncrementStateImpl _value, $Res Function(_$IncrementStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? log = null,
  }) {
    return _then(_$IncrementStateImpl(
      log: null == log
          ? _value._log
          : log // ignore: cast_nullable_to_non_nullable
              as List<Increment>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncrementStateImpl extends _IncrementState {
  const _$IncrementStateImpl({required final List<Increment> log})
      : _log = log,
        super._();

  factory _$IncrementStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncrementStateImplFromJson(json);

  final List<Increment> _log;
  @override
  List<Increment> get log {
    if (_log is EqualUnmodifiableListView) return _log;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_log);
  }

  @override
  String toString() {
    return 'IncrementState(log: $log)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncrementStateImpl &&
            const DeepCollectionEquality().equals(other._log, _log));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_log));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncrementStateImplCopyWith<_$IncrementStateImpl> get copyWith =>
      __$$IncrementStateImplCopyWithImpl<_$IncrementStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncrementStateImplToJson(
      this,
    );
  }
}

abstract class _IncrementState extends IncrementState {
  const factory _IncrementState({required final List<Increment> log}) =
      _$IncrementStateImpl;
  const _IncrementState._() : super._();

  factory _IncrementState.fromJson(Map<String, dynamic> json) =
      _$IncrementStateImpl.fromJson;

  @override
  List<Increment> get log;
  @override
  @JsonKey(ignore: true)
  _$$IncrementStateImplCopyWith<_$IncrementStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
