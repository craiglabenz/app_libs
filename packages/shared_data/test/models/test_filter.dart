import 'package:data_layer/data_layer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_filter.freezed.dart';
part 'test_filter.g.dart';

/// {@template TestFilter}
///
/// {@endtemplate}
@Freezed()
sealed class TestFilter with _$TestFilter implements Filter {
  /// {@macro TestFilter}
  const factory TestFilter.messageEquals(String needle) = MsgEqualsFilter;
  const factory TestFilter.messageStartsWith(String needle) =
      MsgStartsWithFilter;
  const TestFilter._();

  factory TestFilter.fromJson(Json json) => _$TestFilterFromJson(json);

  @override
  CacheKey get cacheKey => switch (this) {
        MsgEqualsFilter() => 'msg-equals-$needle',
        MsgStartsWithFilter() => 'msg-startswith-$needle',
      };
}

class TestFilterConverter implements JsonConverter<TestFilter, Json> {
  const TestFilterConverter();

  @override
  TestFilter fromJson(Json json) => TestFilter.fromJson(json);

  @override
  Json toJson(TestFilter obj) => obj.toJson();
}
