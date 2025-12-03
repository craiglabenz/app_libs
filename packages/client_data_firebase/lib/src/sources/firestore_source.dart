import 'package:client_data_firebase/client_data_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:data_layer/data_layer.dart';
import 'package:logging/logging.dart';

final _log = Logger('FirestoreSource');

/// {@template FirestoreSource}
/// {@endtemplate}
class FirestoreSource<T> extends Source<T> {
  /// {@macro FirestoreSource}
  FirestoreSource({
    required super.bindings,
    FirebaseFirestore? db,
    this.idFieldName = 'id',
  }) : db = db ?? FirebaseFirestore.instance;

  /// Live connection to the Firestore database.
  final FirebaseFirestore db;

  /// Field to manage when serializing and deserializing records for Firestore.
  ///
  /// This is important because Firestore uses PKs as special document Ids, not
  /// merely as an "id" field in the Json payload of an object.
  final String idFieldName;

  /// Shortcut to this source's Firestore [CollectionReference].
  CollectionReference<Json> get collection =>
      db.collection(bindings.getListUrl().path);

  /// Shortcut to a given document's [DocumentReference].
  DocumentReference<Json> doc(String id) => collection.doc(id);

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails details) async {
    try {
      final snapshot = await doc(id).get();
      return ReadSuccess<T>(_hydrateDocument(snapshot), details: details);
    } on FirebaseException catch (e) {
      _log.shout('Failed to get $T by Id $id');
      return ReadFailure<T>(FailureReason.badRequest, e.code);
    }
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails details,
  ) async {
    var query = collection.where(FieldPath.documentId, whereIn: ids);
    query = _applyFilters(query, details);
    return query.get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        return ReadListResult.empty(details, missingItemIds: ids);
      }
      final objs = _hydrateQuery(snapshot);
      final nonNullIds = objs
          .map<String?>(bindings.getId)
          .where((id) => id != null)
          .toSet();
      return ReadListResult.fromList(
        objs,
        details,
        ids.difference(nonNullIds),
        bindings.getId,
      );
    });
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails details) async {
    final query = _applyFilters(collection, details);
    try {
      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        return ReadListResult.empty(details);
      }
      return ReadListResult.fromList(
        _hydrateQuery(snapshot),
        details,
        {},
        bindings.getId,
      );
    } on FirebaseException catch (e) {
      _log.shout('Failed to get $T items');
      return ReadListFailure<T>(FailureReason.badRequest, e.code);
    }
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails details) async {
    final (result, itemCopy) = await _setItem(item, details);
    return result;
  }

  Future<(WriteResult<T>, T)> _setItem(T item, RequestDetails details) async {
    final itemId = bindings.getId(item);
    if (itemId != null) {
      final existingItemResult = await getById(itemId, details);
      switch (existingItemResult) {
        case ReadSuccess<T>():
          if (existingItemResult.item != null) {
            final existingItem = existingItemResult.item as T;
            return (
              WriteSuccess<T>(existingItem, details: details),
              existingItem,
            );
          } else {
            // Do nothing - the item did not exist so we would not overwrite
            // anything, and so can continue on to the write.
          }
        case ReadFailure<T>():
          // Uh oh. This does not bode well.
          _log.shout(
            'Failed to read $T $itemId in shouldOverwrite '
            'check',
          );
      }
    }

    if (itemId != null) {
      try {
        await collection.doc(itemId).set(_serializeItem(item));
        return (WriteSuccess(item, details: details), item);
      } on FirebaseException catch (e) {
        _log.shout('Failed to update $item');
        return (WriteFailure<T>(FailureReason.badRequest, e.code), item);
      }
    }

    try {
      final savedItem = await collection.add(_serializeItem(item)).then((
        ref,
      ) async {
        final snapshot = await ref.get();
        return _hydrateDocument(snapshot);
      });

      if (savedItem == null) {
        return (
          WriteFailure<T>(
            FailureReason.serverError,
            'Failed to save ${T.runtimeType}',
          ),
          item,
        );
      }

      return (WriteSuccess(savedItem, details: details), item);
    } on FirebaseException catch (e) {
      _log.shout('Failed to create $item');
      return (WriteFailure<T>(FailureReason.badRequest, e.code), item);
    }
  }

  @override
  Future<WriteListResult<T>> setItems(
    Iterable<T> items,
    RequestDetails details,
  ) async {
    var (savedItems, failedWrites) = await _setItems(items, details);

    var retries = 2;
    while (retries > 0 && failedWrites.isNotEmpty) {
      var retriedSaves = <T>[];
      retries--;
      (retriedSaves, failedWrites) = await _setItems(failedWrites, details);

      savedItems.addAll(retriedSaves);
    }

    if (failedWrites.isNotEmpty) {
      return WriteListFailure<T>(
        FailureReason.serverError,
        'Failed to save ${failedWrites.length} ${T.runtimeType}',
      );
    }

    return WriteListSuccess<T>(savedItems, details: details);
  }

  Future<(List<T>, List<T>)> _setItems(
    Iterable<T> items,
    RequestDetails details,
  ) async {
    final writeFutures = <Future<(WriteResult<T>, T)>>[];
    for (final item in items) {
      writeFutures.add(_setItem(item, details));
    }
    final savedItems = <T>[];
    final failedWrites = <T>[];
    final results = await writeFutures.wait;
    for (final result in results) {
      if (result.$1 is WriteSuccess<T>) {
        savedItems.add(result.$2);
      } else {
        failedWrites.add(result.$2);
      }
    }
    return (savedItems, failedWrites);
  }

  List<T> _hydrateQuery(QuerySnapshot<Json> snapshot) => snapshot.docs
      .map<T?>(_hydrateDocument)
      .where((T? obj) => obj != null)
      .cast<T>()
      .toList();

  T? _hydrateDocument(DocumentSnapshot<Json> snapshot) {
    final data = Map<String, Object?>.from(snapshot.data() ?? {});
    if (data.isEmpty) return null;

    if (!data.containsKey(idFieldName)) {
      data[idFieldName] = snapshot.id;
    }
    if (data.containsKey('createdAt')) {
      final rawCreatedAt = data['createdAt'];
      data['createdAt'] = switch (rawCreatedAt) {
        Timestamp() => rawCreatedAt.toDate().toIso8601String(),
        DateTime() => rawCreatedAt.toIso8601String(),
        String() => rawCreatedAt,
        _ => throw Exception(
          'Unexpected type in FirestoreTimestampConverter: '
          '${rawCreatedAt.runtimeType}',
        ),
      };
    }
    return bindings.fromJson(data);
  }

  Json _serializeItem(T item) {
    final serialized = bindings.toJson(item);
    if (serialized.containsKey(idFieldName)) {
      serialized.remove(idFieldName);
    }
    if (serialized.containsKey('createdAt') &&
        serialized['createdAt'] == null &&
        bindings.getId(item) == null) {
      serialized['createdAt'] = FieldValue.serverTimestamp();
    }
    return serialized;
  }

  Query<Json> _applyFilters(Query<Json> query, RequestDetails details) {
    var q = query;
    if (details.filter != null) {
      if (details.filter is! FirestoreFilter) {
        throw Exception('Unexpected non-FirestoreFilter in FirestoreSource');
      }
      q = (details.filter! as FirestoreFilter).filterQuery(q);
    }
    return q;
  }

  @override
  SourceType get sourceType => SourceType.remote;

  @override
  Future<DeleteResult<T>> delete(String id, RequestDetails details) async {
    try {
      final ref = collection.doc(id);
      await ref.delete();
      return DeleteResult<T>.success(details);
    } on FirebaseException catch (e) {
      _log.shout('Failed to delete $T Id $id');
      return DeleteFailure<T>(FailureReason.badRequest, e.code);
    }
  }
}
