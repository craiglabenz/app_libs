import 'package:equatable/equatable.dart';
import 'package:shared_data/shared_data.dart';

/// {@template Filter}
/// Interface for filters on requests for data which will be applied inside
/// [Source] objects.
/// {@endtemplate}
abstract class Filter {
  /// {@macro Filter}
  const Filter();

  /// Deserializes this [Filter] for full-stack Dart endpoints.
  // ignore: avoid_unused_constructor_parameters
  factory Filter.fromJson(Json data) => throw UnimplementedError();

  /// Variant of [hashCode] with persistent Ids across application launches.
  CacheKey get cacheKey;

  /// Serializes this [Filter] full-stack Dart endpoints.
  Json toJson();
}

/// Form of [Filter] meant to be shared with a Rest backend; the expectation
/// being that this filter must be able to fully represent itself in querystring
/// format.
mixin RestFilter on Filter {
  /// Query parameters form of this filter to be included in an [ApiRequest] and
  /// applied by the server.
  Map<String, String> toParams();
}

/// Flavors of combination logic for multiple filters.
enum BooleanLogic {
  /// All filters must apply.
  and,

  /// Either filter must apply.
  or;
}

/// {@template ComboFilter}
/// Specialized filter meant to combine multiple children filters.
/// {@endtemplate}
class ComboFilter extends Filter with EquatableMixin {
  /// {@macro ComboFilter}
  const ComboFilter(this.children, this.logic);

  /// Nested filters to be evaluated.
  final List<Filter> children;

  /// Governing logic for how many of [children] must pass.
  final BooleanLogic logic;

  @override
  CacheKey get cacheKey =>
      '${logic.name}--${children.map<String>((c) => c.cacheKey).join('-')}';

  @override
  List<Object?> get props => [logic, ...children];

  @override
  Json toJson() {
    throw UnimplementedError();
  }
}
