import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:shared_data/shared_data.dart';

class TestModel {
  const TestModel({required this.id, this.msg = defaultMessage});

  factory TestModel.randomId([String msg = defaultMessage]) => TestModel(
        id: Random().nextDouble().toString(),
        msg: msg,
      );

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
        id: json['id'] as String?,
        msg: json['msg'] as String,
      );

  final String? id;
  final String msg;

  static const defaultMessage = 'default';

  Map<String, dynamic> toJson() => {'id': id, 'msg': msg};

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          msg == other.msg;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hashAll([id, msg]);

  @override
  String toString() => 'TestModel(id: $id, msg: $msg)';

  static final bindings = Bindings<TestModel>(
    fromJson: TestModel.fromJson,
    getDetailUrl: (id) => ApiUrl(path: 'test/$id'),
    getListUrl: () => const ApiUrl(path: 'test/'),
    toJson: (TestModel obj) => obj.toJson(),
    getId: (TestModel obj) => obj.id,
  );
}

class MsgStartsWithFilter with EquatableMixin implements RestFilter, Filter {
  const MsgStartsWithFilter(this.value);
  final String value;

  @override
  CacheKey get cacheKey => value;

  @override
  Json toJson() => {'value': value};

  @override
  List<Object?> get props => [value];

  @override
  Map<String, String> toParams() => toJson().cast<String, String>();
}

class FakeSourceList<T> extends SourceList<T> {
  FakeSourceList(Bindings<T> bindings)
      : super(
          bindings: bindings,
          sources: [],
        );
  final objs = <T>[];

  void addObj(T obj) => objs.add(obj);

  @override
  Future<ReadResult<T>> getById(
    String id,
    RequestDetails details,
  ) =>
      Future.value(
        ReadSuccess<T>(objs.first, details: details),
      );

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails details,
  ) =>
      Future.value(
        ReadListResult<T>.fromList([objs.first], details, {}, bindings.getId),
      );

  @override
  Future<ReadListResult<T>> getItems(RequestDetails details) => Future.value(
        ReadListResult<T>.fromList([objs.first], details, {}, bindings.getId),
      );

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails details) =>
      Future.value(WriteSuccess<T>(objs.first, details: details));

  @override
  Future<WriteListResult<T>> setItems(
    Iterable<T> items,
    RequestDetails details,
  ) =>
      Future.value(WriteListSuccess<T>([objs.first], details: details));
}

/// Checks whether a model's given field name equals the given value.
///
/// Not the most performant class, as this re-serializes the model. Best used
/// only for tests.
class FieldEquals<Type, Value> extends Filter with RestFilter, EquatableMixin {
  const FieldEquals(this.fieldName, this.value, this.getValue);
  final String fieldName;
  final Value? value;
  final Value? Function(Type) getValue;

  @override
  List<Object?> get props => [fieldName, value, Type.runtimeType];

  @override
  Map<String, String> toParams() =>
      <String, String>{fieldName: value.toString()};

  @override
  CacheKey get cacheKey => '$fieldName-equals-$value';

  @override
  Json toJson() => toParams();
}
