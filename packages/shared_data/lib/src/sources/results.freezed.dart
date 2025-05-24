// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WriteResult<T extends Model> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WriteResult<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WriteResult<$T>()';
  }
}

/// @nodoc
class $WriteResultCopyWith<T extends Model, $Res> {
  $WriteResultCopyWith(WriteResult<T> _, $Res Function(WriteResult<T>) __);
}

/// @nodoc

class WriteSuccess<T extends Model> extends WriteResult<T> {
  const WriteSuccess(this.item, {required this.details}) : super._();

  final T item;
  final RequestDetails<T> details;

  /// Create a copy of WriteResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WriteSuccessCopyWith<T, WriteSuccess<T>> get copyWith =>
      _$WriteSuccessCopyWithImpl<T, WriteSuccess<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WriteSuccess<T> &&
            const DeepCollectionEquality().equals(other.item, item) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(item), details);

  @override
  String toString() {
    return 'WriteResult<$T>.success(item: $item, details: $details)';
  }
}

/// @nodoc
abstract mixin class $WriteSuccessCopyWith<T extends Model, $Res>
    implements $WriteResultCopyWith<T, $Res> {
  factory $WriteSuccessCopyWith(
          WriteSuccess<T> value, $Res Function(WriteSuccess<T>) _then) =
      _$WriteSuccessCopyWithImpl;
  @useResult
  $Res call({T item, RequestDetails<T> details});
}

/// @nodoc
class _$WriteSuccessCopyWithImpl<T extends Model, $Res>
    implements $WriteSuccessCopyWith<T, $Res> {
  _$WriteSuccessCopyWithImpl(this._self, this._then);

  final WriteSuccess<T> _self;
  final $Res Function(WriteSuccess<T>) _then;

  /// Create a copy of WriteResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? item = null,
    Object? details = null,
  }) {
    return _then(WriteSuccess<T>(
      null == item
          ? _self.item
          : item // ignore: cast_nullable_to_non_nullable
              as T,
      details: null == details
          ? _self.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ));
  }
}

/// @nodoc

class WriteFailure<T extends Model> extends WriteResult<T> {
  const WriteFailure(this.reason, this.message) : super._();

  final FailureReason reason;
  final String message;

  /// Create a copy of WriteResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WriteFailureCopyWith<T, WriteFailure<T>> get copyWith =>
      _$WriteFailureCopyWithImpl<T, WriteFailure<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WriteFailure<T> &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason, message);

  @override
  String toString() {
    return 'WriteResult<$T>.failure(reason: $reason, message: $message)';
  }
}

/// @nodoc
abstract mixin class $WriteFailureCopyWith<T extends Model, $Res>
    implements $WriteResultCopyWith<T, $Res> {
  factory $WriteFailureCopyWith(
          WriteFailure<T> value, $Res Function(WriteFailure<T>) _then) =
      _$WriteFailureCopyWithImpl;
  @useResult
  $Res call({FailureReason reason, String message});
}

/// @nodoc
class _$WriteFailureCopyWithImpl<T extends Model, $Res>
    implements $WriteFailureCopyWith<T, $Res> {
  _$WriteFailureCopyWithImpl(this._self, this._then);

  final WriteFailure<T> _self;
  final $Res Function(WriteFailure<T>) _then;

  /// Create a copy of WriteResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reason = null,
    Object? message = null,
  }) {
    return _then(WriteFailure<T>(
      null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as FailureReason,
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$WriteListResult<T extends Model> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WriteListResult<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WriteListResult<$T>()';
  }
}

/// @nodoc
class $WriteListResultCopyWith<T extends Model, $Res> {
  $WriteListResultCopyWith(
      WriteListResult<T> _, $Res Function(WriteListResult<T>) __);
}

/// @nodoc

class WriteListSuccess<T extends Model> extends WriteListResult<T> {
  const WriteListSuccess(final List<T> items, {required this.details})
      : _items = items,
        super._();

  final List<T> _items;
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final RequestDetails<T> details;

  /// Create a copy of WriteListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WriteListSuccessCopyWith<T, WriteListSuccess<T>> get copyWith =>
      _$WriteListSuccessCopyWithImpl<T, WriteListSuccess<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WriteListSuccess<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), details);

  @override
  String toString() {
    return 'WriteListResult<$T>.success(items: $items, details: $details)';
  }
}

/// @nodoc
abstract mixin class $WriteListSuccessCopyWith<T extends Model, $Res>
    implements $WriteListResultCopyWith<T, $Res> {
  factory $WriteListSuccessCopyWith(
          WriteListSuccess<T> value, $Res Function(WriteListSuccess<T>) _then) =
      _$WriteListSuccessCopyWithImpl;
  @useResult
  $Res call({List<T> items, RequestDetails<T> details});
}

/// @nodoc
class _$WriteListSuccessCopyWithImpl<T extends Model, $Res>
    implements $WriteListSuccessCopyWith<T, $Res> {
  _$WriteListSuccessCopyWithImpl(this._self, this._then);

  final WriteListSuccess<T> _self;
  final $Res Function(WriteListSuccess<T>) _then;

  /// Create a copy of WriteListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? details = null,
  }) {
    return _then(WriteListSuccess<T>(
      null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      details: null == details
          ? _self.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ));
  }
}

/// @nodoc

class WriteListFailure<T extends Model> extends WriteListResult<T> {
  const WriteListFailure(this.reason, this.message) : super._();

  final FailureReason reason;
  final String message;

  /// Create a copy of WriteListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WriteListFailureCopyWith<T, WriteListFailure<T>> get copyWith =>
      _$WriteListFailureCopyWithImpl<T, WriteListFailure<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WriteListFailure<T> &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason, message);

  @override
  String toString() {
    return 'WriteListResult<$T>.failure(reason: $reason, message: $message)';
  }
}

/// @nodoc
abstract mixin class $WriteListFailureCopyWith<T extends Model, $Res>
    implements $WriteListResultCopyWith<T, $Res> {
  factory $WriteListFailureCopyWith(
          WriteListFailure<T> value, $Res Function(WriteListFailure<T>) _then) =
      _$WriteListFailureCopyWithImpl;
  @useResult
  $Res call({FailureReason reason, String message});
}

/// @nodoc
class _$WriteListFailureCopyWithImpl<T extends Model, $Res>
    implements $WriteListFailureCopyWith<T, $Res> {
  _$WriteListFailureCopyWithImpl(this._self, this._then);

  final WriteListFailure<T> _self;
  final $Res Function(WriteListFailure<T>) _then;

  /// Create a copy of WriteListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reason = null,
    Object? message = null,
  }) {
    return _then(WriteListFailure<T>(
      null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as FailureReason,
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ReadResult<T extends Model> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReadResult<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReadResult<$T>()';
  }
}

/// @nodoc
class $ReadResultCopyWith<T extends Model, $Res> {
  $ReadResultCopyWith(ReadResult<T> _, $Res Function(ReadResult<T>) __);
}

/// @nodoc

class ReadSuccess<T extends Model> extends ReadResult<T> {
  const ReadSuccess(this.item, {required this.details}) : super._();

  final T? item;
  final RequestDetails<T> details;

  /// Create a copy of ReadResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadSuccessCopyWith<T, ReadSuccess<T>> get copyWith =>
      _$ReadSuccessCopyWithImpl<T, ReadSuccess<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadSuccess<T> &&
            const DeepCollectionEquality().equals(other.item, item) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(item), details);

  @override
  String toString() {
    return 'ReadResult<$T>.success(item: $item, details: $details)';
  }
}

/// @nodoc
abstract mixin class $ReadSuccessCopyWith<T extends Model, $Res>
    implements $ReadResultCopyWith<T, $Res> {
  factory $ReadSuccessCopyWith(
          ReadSuccess<T> value, $Res Function(ReadSuccess<T>) _then) =
      _$ReadSuccessCopyWithImpl;
  @useResult
  $Res call({T? item, RequestDetails<T> details});
}

/// @nodoc
class _$ReadSuccessCopyWithImpl<T extends Model, $Res>
    implements $ReadSuccessCopyWith<T, $Res> {
  _$ReadSuccessCopyWithImpl(this._self, this._then);

  final ReadSuccess<T> _self;
  final $Res Function(ReadSuccess<T>) _then;

  /// Create a copy of ReadResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? item = freezed,
    Object? details = null,
  }) {
    return _then(ReadSuccess<T>(
      freezed == item
          ? _self.item
          : item // ignore: cast_nullable_to_non_nullable
              as T?,
      details: null == details
          ? _self.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ));
  }
}

/// @nodoc

class ReadFailure<T extends Model> extends ReadResult<T> {
  const ReadFailure(this.reason, this.message) : super._();

  final FailureReason reason;
  final String message;

  /// Create a copy of ReadResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadFailureCopyWith<T, ReadFailure<T>> get copyWith =>
      _$ReadFailureCopyWithImpl<T, ReadFailure<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadFailure<T> &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason, message);

  @override
  String toString() {
    return 'ReadResult<$T>.failure(reason: $reason, message: $message)';
  }
}

/// @nodoc
abstract mixin class $ReadFailureCopyWith<T extends Model, $Res>
    implements $ReadResultCopyWith<T, $Res> {
  factory $ReadFailureCopyWith(
          ReadFailure<T> value, $Res Function(ReadFailure<T>) _then) =
      _$ReadFailureCopyWithImpl;
  @useResult
  $Res call({FailureReason reason, String message});
}

/// @nodoc
class _$ReadFailureCopyWithImpl<T extends Model, $Res>
    implements $ReadFailureCopyWith<T, $Res> {
  _$ReadFailureCopyWithImpl(this._self, this._then);

  final ReadFailure<T> _self;
  final $Res Function(ReadFailure<T>) _then;

  /// Create a copy of ReadResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reason = null,
    Object? message = null,
  }) {
    return _then(ReadFailure<T>(
      null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as FailureReason,
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ReadListResult<T extends Model> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReadListResult<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ReadListResult<$T>()';
  }
}

/// @nodoc
class $ReadListResultCopyWith<T extends Model, $Res> {
  $ReadListResultCopyWith(
      ReadListResult<T> _, $Res Function(ReadListResult<T>) __);
}

/// @nodoc

class ReadListSuccess<T extends Model> extends ReadListResult<T> {
  const ReadListSuccess(
      {required final List<T> items,
      required final Map<String, T> itemsMap,
      required final Set<String> missingItemIds,
      required this.details})
      : _items = items,
        _itemsMap = itemsMap,
        _missingItemIds = missingItemIds,
        super._();

  final List<T> _items;
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final Map<String, T> _itemsMap;
  Map<String, T> get itemsMap {
    if (_itemsMap is EqualUnmodifiableMapView) return _itemsMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_itemsMap);
  }

  final Set<String> _missingItemIds;
  Set<String> get missingItemIds {
    if (_missingItemIds is EqualUnmodifiableSetView) return _missingItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_missingItemIds);
  }

  final RequestDetails<T> details;

  /// Create a copy of ReadListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadListSuccessCopyWith<T, ReadListSuccess<T>> get copyWith =>
      _$ReadListSuccessCopyWithImpl<T, ReadListSuccess<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadListSuccess<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._itemsMap, _itemsMap) &&
            const DeepCollectionEquality()
                .equals(other._missingItemIds, _missingItemIds) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_itemsMap),
      const DeepCollectionEquality().hash(_missingItemIds),
      details);

  @override
  String toString() {
    return 'ReadListResult<$T>(items: $items, itemsMap: $itemsMap, missingItemIds: $missingItemIds, details: $details)';
  }
}

/// @nodoc
abstract mixin class $ReadListSuccessCopyWith<T extends Model, $Res>
    implements $ReadListResultCopyWith<T, $Res> {
  factory $ReadListSuccessCopyWith(
          ReadListSuccess<T> value, $Res Function(ReadListSuccess<T>) _then) =
      _$ReadListSuccessCopyWithImpl;
  @useResult
  $Res call(
      {List<T> items,
      Map<String, T> itemsMap,
      Set<String> missingItemIds,
      RequestDetails<T> details});
}

/// @nodoc
class _$ReadListSuccessCopyWithImpl<T extends Model, $Res>
    implements $ReadListSuccessCopyWith<T, $Res> {
  _$ReadListSuccessCopyWithImpl(this._self, this._then);

  final ReadListSuccess<T> _self;
  final $Res Function(ReadListSuccess<T>) _then;

  /// Create a copy of ReadListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? itemsMap = null,
    Object? missingItemIds = null,
    Object? details = null,
  }) {
    return _then(ReadListSuccess<T>(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      itemsMap: null == itemsMap
          ? _self._itemsMap
          : itemsMap // ignore: cast_nullable_to_non_nullable
              as Map<String, T>,
      missingItemIds: null == missingItemIds
          ? _self._missingItemIds
          : missingItemIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      details: null == details
          ? _self.details
          : details // ignore: cast_nullable_to_non_nullable
              as RequestDetails<T>,
    ));
  }
}

/// @nodoc

class ReadListFailure<T extends Model> extends ReadListResult<T> {
  const ReadListFailure(this.reason, this.message) : super._();

  final FailureReason reason;
  final String message;

  /// Create a copy of ReadListResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadListFailureCopyWith<T, ReadListFailure<T>> get copyWith =>
      _$ReadListFailureCopyWithImpl<T, ReadListFailure<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadListFailure<T> &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason, message);

  @override
  String toString() {
    return 'ReadListResult<$T>.failure(reason: $reason, message: $message)';
  }
}

/// @nodoc
abstract mixin class $ReadListFailureCopyWith<T extends Model, $Res>
    implements $ReadListResultCopyWith<T, $Res> {
  factory $ReadListFailureCopyWith(
          ReadListFailure<T> value, $Res Function(ReadListFailure<T>) _then) =
      _$ReadListFailureCopyWithImpl;
  @useResult
  $Res call({FailureReason reason, String message});
}

/// @nodoc
class _$ReadListFailureCopyWithImpl<T extends Model, $Res>
    implements $ReadListFailureCopyWith<T, $Res> {
  _$ReadListFailureCopyWithImpl(this._self, this._then);

  final ReadListFailure<T> _self;
  final $Res Function(ReadListFailure<T>) _then;

  /// Create a copy of ReadListResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reason = null,
    Object? message = null,
  }) {
    return _then(ReadListFailure<T>(
      null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as FailureReason,
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
