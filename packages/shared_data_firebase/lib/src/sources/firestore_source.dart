import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:dartz/dartz.dart';
import 'package:shared_data/shared_data.dart';

/// {@template FirestoreSource}
/// {@endtemplate}
class FirestoreSource<T extends Model> extends Source<T> {
  /// {@macro FirestoreSource}
  FirestoreSource({required this.db, required this.bindings});

  /// Live connection to the Firestore database.
  final FirebaseFirestore db;

  /// Meta-data provider for [T].
  final Bindings<T> bindings;

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) async {
    final docRef = db.collection(bindings.getListUrl().path).doc(id);
    return docRef.get().then(
      (doc) {
        final data = doc.data();
        if (data != null && data.isNotEmpty) {
          return Right(ReadSuccess(bindings.fromJson(data), details: details));
        }
        return Right(ReadSuccess(null, details: details));
      },
    );
  }

  @override
  Future<ReadListResult<T>> getByIds(
      Set<String> ids, RequestDetails<T> details) {
    // TODO: implement getByIds
    throw UnimplementedError();
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) {
    // TODO: implement getItems
    throw UnimplementedError();
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) {
    // TODO: implement setItem
    throw UnimplementedError();
  }

  @override
  Future<WriteListResult<T>> setItems(
      List<T> items, RequestDetails<T> details) {
    // TODO: implement setItems
    throw UnimplementedError();
  }

  @override
  // TODO: implement sourceType
  SourceType get sourceType => SourceType.remote;
}
