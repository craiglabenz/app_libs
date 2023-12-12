import 'package:equatable/equatable.dart';
import 'package:shared_data/shared_data.dart';

/// {@template ReadFilter}
/// Interface for filters on requests for data which will be applied inside
/// [Source] objects. Local sources will use [predicate], since that is a
/// function they can run on each instance; whereas remote sources will use
/// [toParams] to include these filters in the [ApiRequest].
/// {@endtemplate}
abstract class ReadFilter<T extends Model> extends Equatable {
  /// {@macro ReadFilter}
  const ReadFilter();

  /// Discriminating method a local [Source] can run on instances of [T] to
  /// apply this filter.
  bool predicate(T obj);

  /// Query parameters form of this filter to be included in an [ApiRequest] and
  /// applied by the server.
  Map<String, String> toParams();
}

/// Filter for objects created since a given [DateTime].
class CreatedSinceFilter<T extends CreatedAtModel> extends ReadFilter<T> {
  /// Filter for objects created since a given [DateTime].
  const CreatedSinceFilter(this.createdCutoff);

  /// Earliest possibe creation time of satisfying instances.
  final DateTime createdCutoff;

  @override
  bool predicate(T obj) =>
      obj.createdAt != null &&
      obj.createdAt!.difference(createdCutoff) > Duration.zero;

  @override
  Map<String, String> toParams() =>
      {'createdSince': createdCutoff.toIso8601String()};

  @override
  List<Object?> get props => [createdCutoff.toIso8601String()];
}
