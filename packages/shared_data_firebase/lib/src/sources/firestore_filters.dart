import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_data/shared_data.dart';

/// Adds the ability for a [ReadFilter] to impact a Firestore [Query].
mixin FirestoreFilter<T extends Model> on ReadFilter<T> {
  /// Calls appropriate [Query.where] methods to enforce the filter logic.
  Query<Json> filterQuery(Query<Json> query);
}
