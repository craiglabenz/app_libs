import 'package:shared_data/shared_data.dart';

/// {@template Bindings}
/// Holds meta-information for a subclass of data class, making it fully
/// pluggable within any subtype of [DataContract].
/// {@endtemplate}
class Bindings<T> {
  /// {@macro Bindings}
  Bindings({
    required this.fromJson,
    required this.toJson,
    required this.getId,
    required this.getDetailUrl,
    required this.getListUrl,
  });

  /// Extracts the primary key from the object.
  final String? Function(T obj) getId;

  /// Builder for detail [ApiUrl] instances for this data type.
  final ApiUrl Function(String id) getDetailUrl;

  /// Builder for list [ApiUrl] instances for this data type.
  final ApiUrl Function() getListUrl;

  /// Json deserializer for this data type.
  final T Function(Json data) fromJson;

  /// Json deserializer for this data type.
  final Json Function(T obj) toJson;

  /// Overrideable method which returns the creation Url for this data type. By
  /// default, this proxies to [getListUrl].
  ApiUrl getCreateUrl() => getListUrl();
}

/// {@template CreationBindings}
/// [Bindings] for an object that the client can save locally without requiring
/// the use of the server to generate an Id.
/// {@endtemplate}
class CreationBindings<T> extends Bindings<T> {
  /// {@macro CreationBindings}
  CreationBindings({
    required super.getId,
    required super.fromJson,
    required super.toJson,
    required super.getDetailUrl,
    required super.getListUrl,
    required this.save,
  });

  /// Method which takes an unsaved child and locally determines its "id" value.
  T Function(T) save;
}
