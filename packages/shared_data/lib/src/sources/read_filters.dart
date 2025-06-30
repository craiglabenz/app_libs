import 'package:equatable/equatable.dart';
import 'package:shared_data/shared_data.dart';

/// {@template ReadFilter}
/// Interface for filters on requests for data which will be applied inside
/// [Source] objects. Local sources will use [predicate], since that is a
/// function they can run on each instance; whereas remote sources will use
/// [toParams] to include these filters in the [ApiRequest].
/// {@endtemplate}
abstract class ReadFilter<T> extends Equatable {
  /// {@macro ReadFilter}
  const ReadFilter();

  /// Discriminating method a local [Source] can run on instances of [T] to
  /// apply this filter.
  bool predicate(T obj);

  /// Query parameters form of this filter to be included in an [ApiRequest] and
  /// applied by the server.
  Map<String, String> toParams();

  /// Variant of [hashCode] with persistent Ids across application launches.
  CacheKey get cacheKey;
}
