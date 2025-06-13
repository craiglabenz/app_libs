import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template FirestoreTimestampConverter}
/// {@endtemplate}
class FirestoreTimestampConverter extends JsonConverter<DateTime, Object> {
  /// {@macro FirestoreTimestampConverter}
  const FirestoreTimestampConverter();

  @override
  DateTime fromJson(Object json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is DateTime) {
      return json;
    } else if (json is String) {
      return DateTime.parse(json);
    }
    throw Exception(
      'Unexpected type in FirestoreTimestampConverter: ${json.runtimeType}',
    );
  }

  @override
  Timestamp toJson(Object object) => Timestamp.now();
}
