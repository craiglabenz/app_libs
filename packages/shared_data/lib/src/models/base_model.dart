import 'package:shared_data/src/types.dart';

/// Base type for all data classes. Contains an optional `String` [id],
/// a [toJson] serializer, and thin serializer, [serializeId], which is used for
/// relations. The deserializer, `fromJson`, is provided elsewhere, due to the
/// limitations of factory constructors on abstract classes.
abstract class Model {
  /// Generative constructor.
  const Model({this.id});

  /// Database primary key for this data class. A non-null value means this
  /// object has been saved to the database on the server.
  final String? id;

  /// Json serializer, likely provided by `freezed` via `json_serializable`.
  Json toJson();

  /// Default thin serializer for relationships.
  Json serializeId() => {'id': id};
}

/// Base data class for types which have a `createdAt` field to track age.
abstract class CreatedAtModel extends Model {
  /// Generative constructor.
  const CreatedAtModel({super.id, this.createdAt});

  /// UTC value when this record was created. This value should be set by the
  /// database. A non-null value here means this record has been saved to the
  /// database.
  final DateTime? createdAt;
}
