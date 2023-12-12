import 'package:shared_data/shared_data.dart';

/// {@template Bindings}
/// Holds meta-information for a subclass of [Model], making subtypes truly
/// pluggable within any subtype of [DataContract].
/// {@endtemplate}
class Bindings<T extends Model> {
  /// {@macro Bindings}
  Bindings({
    required this.fromJson,
    required this.getDetailUrl,
    required this.getListUrl,
  });

  /// Builder for detail [ApiUrl] instances for this data type.
  final ApiUrl Function(String id) getDetailUrl;

  /// Builder for list [ApiUrl] instances for this data type.
  final ApiUrl Function() getListUrl;

  /// Json deserializer for this data type.
  final T Function(Map<String, dynamic> data) fromJson;

  /// Overrideable method which returns the creation Url for this data type. By
  /// default, this proxies to [getListUrl].
  ApiUrl getCreateUrl() => getListUrl();
}
