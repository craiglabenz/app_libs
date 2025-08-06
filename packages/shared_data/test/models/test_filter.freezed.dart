// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
TestFilter _$TestFilterFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'messageEquals':
      return MsgEqualsFilter.fromJson(json);
    case 'messageStartsWith':
      return MsgStartsWithFilter.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'TestFilter',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$TestFilter {
  String get needle;

  /// Create a copy of TestFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestFilterCopyWith<TestFilter> get copyWith =>
      _$TestFilterCopyWithImpl<TestFilter>(this as TestFilter, _$identity);

  /// Serializes this TestFilter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestFilter &&
            (identical(other.needle, needle) || other.needle == needle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, needle);

  @override
  String toString() {
    return 'TestFilter(needle: $needle)';
  }
}

/// @nodoc
abstract mixin class $TestFilterCopyWith<$Res> {
  factory $TestFilterCopyWith(
          TestFilter value, $Res Function(TestFilter) _then) =
      _$TestFilterCopyWithImpl;
  @useResult
  $Res call({String needle});
}

/// @nodoc
class _$TestFilterCopyWithImpl<$Res> implements $TestFilterCopyWith<$Res> {
  _$TestFilterCopyWithImpl(this._self, this._then);

  final TestFilter _self;
  final $Res Function(TestFilter) _then;

  /// Create a copy of TestFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? needle = null,
  }) {
    return _then(_self.copyWith(
      needle: null == needle
          ? _self.needle
          : needle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class MsgEqualsFilter extends TestFilter {
  const MsgEqualsFilter(this.needle, {final String? $type})
      : $type = $type ?? 'messageEquals',
        super._();
  factory MsgEqualsFilter.fromJson(Map<String, dynamic> json) =>
      _$MsgEqualsFilterFromJson(json);

  @override
  final String needle;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of TestFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MsgEqualsFilterCopyWith<MsgEqualsFilter> get copyWith =>
      _$MsgEqualsFilterCopyWithImpl<MsgEqualsFilter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MsgEqualsFilterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MsgEqualsFilter &&
            (identical(other.needle, needle) || other.needle == needle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, needle);

  @override
  String toString() {
    return 'TestFilter.messageEquals(needle: $needle)';
  }
}

/// @nodoc
abstract mixin class $MsgEqualsFilterCopyWith<$Res>
    implements $TestFilterCopyWith<$Res> {
  factory $MsgEqualsFilterCopyWith(
          MsgEqualsFilter value, $Res Function(MsgEqualsFilter) _then) =
      _$MsgEqualsFilterCopyWithImpl;
  @override
  @useResult
  $Res call({String needle});
}

/// @nodoc
class _$MsgEqualsFilterCopyWithImpl<$Res>
    implements $MsgEqualsFilterCopyWith<$Res> {
  _$MsgEqualsFilterCopyWithImpl(this._self, this._then);

  final MsgEqualsFilter _self;
  final $Res Function(MsgEqualsFilter) _then;

  /// Create a copy of TestFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? needle = null,
  }) {
    return _then(MsgEqualsFilter(
      null == needle
          ? _self.needle
          : needle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class MsgStartsWithFilter extends TestFilter {
  const MsgStartsWithFilter(this.needle, {final String? $type})
      : $type = $type ?? 'messageStartsWith',
        super._();
  factory MsgStartsWithFilter.fromJson(Map<String, dynamic> json) =>
      _$MsgStartsWithFilterFromJson(json);

  @override
  final String needle;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of TestFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MsgStartsWithFilterCopyWith<MsgStartsWithFilter> get copyWith =>
      _$MsgStartsWithFilterCopyWithImpl<MsgStartsWithFilter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MsgStartsWithFilterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MsgStartsWithFilter &&
            (identical(other.needle, needle) || other.needle == needle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, needle);

  @override
  String toString() {
    return 'TestFilter.messageStartsWith(needle: $needle)';
  }
}

/// @nodoc
abstract mixin class $MsgStartsWithFilterCopyWith<$Res>
    implements $TestFilterCopyWith<$Res> {
  factory $MsgStartsWithFilterCopyWith(
          MsgStartsWithFilter value, $Res Function(MsgStartsWithFilter) _then) =
      _$MsgStartsWithFilterCopyWithImpl;
  @override
  @useResult
  $Res call({String needle});
}

/// @nodoc
class _$MsgStartsWithFilterCopyWithImpl<$Res>
    implements $MsgStartsWithFilterCopyWith<$Res> {
  _$MsgStartsWithFilterCopyWithImpl(this._self, this._then);

  final MsgStartsWithFilter _self;
  final $Res Function(MsgStartsWithFilter) _then;

  /// Create a copy of TestFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? needle = null,
  }) {
    return _then(MsgStartsWithFilter(
      null == needle
          ? _self.needle
          : needle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
