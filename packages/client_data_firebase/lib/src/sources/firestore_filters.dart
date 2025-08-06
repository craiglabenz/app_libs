import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:shared_data/shared_data.dart';

/// Adds the ability for a [Filter] to impact a Firestore [Query].
mixin FirestoreFilter on Filter {
  /// Calls appropriate [Query.where] methods to enforce the filter logic.
  Query<Json> filterQuery(Query<Json> query);
}
