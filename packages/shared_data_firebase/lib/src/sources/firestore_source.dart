import 'package:cloud_firestore/cloud_firestore.dart' hide Source;
import 'package:shared_data/shared_data.dart';
import 'package:shared_data_firebase/shared_data_firebase.dart';

/// {@template FirestoreSource}
/// {@endtemplate}
class FirestoreSource<T extends Model> extends Source<T> {
  /// {@macro FirestoreSource}
  FirestoreSource({
    required this.db,
    required this.bindings,
    this.idFieldName = 'id',
  });

  /// Live connection to the Firestore database.
  final FirebaseFirestore db;

  /// Meta-data provider for [T].
  final Bindings<T> bindings;

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
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) async =>
      doc(id).get().then(
            (snapshot) =>
                ReadSuccess<T>(_hydrateDocument(snapshot), details: details),
          );

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) async {
    var query = collection.where(FieldPath.documentId, whereIn: ids);
    query = _applyFilters(query, details);
    return query.get().then(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          return ReadListResult.empty(details, missingItemIds: ids);
        }
        final objs = _hydrateQuery(snapshot);
        final nonNullIds = objs
            .map<String?>((obj) => obj.id)
            .where((id) => id != null)
            .toSet();
        return ReadListResult.fromList(
          objs,
          details,
          ids.difference(nonNullIds),
        );
      },
    );
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) async {
    final query = _applyFilters(collection, details);
    return query.get().then(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          return ReadListResult.empty(details);
        }
        return ReadListResult.fromList(
          _hydrateQuery(snapshot),
          details,
          {},
        );
      },
    );
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
    final (result, itemCopy) = await _setItem(item, details);
    return result;
  }

  Future<(WriteResult<T>, T)> _setItem(
      T item, RequestDetails<T> details) async {
    if (item.id != null) {
      await collection.doc(item.id).set(_serializeItem(item));
      return (
        WriteSuccess(
          item,
          details: details,
        ),
        item
      );
    }

    final savedItem = await collection.add(_serializeItem(item)).then(
      (ref) async {
        final snapshot = await ref.get();
        return _hydrateDocument(snapshot);
      },
    );

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
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
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
    List<T> items,
    RequestDetails<T> details,
  ) async {
    final writeFutures = <Future<(WriteResult, T)>>[];
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
    return bindings.fromJson(data);
  }

  Json _serializeItem(T item) {
    final serialized = item.toJson();
    if (serialized.containsKey(idFieldName)) {
      serialized.remove(idFieldName);
    }
    return serialized;
  }

  Query<Json> _applyFilters(Query<Json> query, RequestDetails<T> details) {
    var q = query;
    for (final filter in details.filters) {
      if (filter is! FirestoreFilter<T>) {
        throw Exception('Unexpected non-FirestoreFilter in FirestoreSource');
      }
      q = filter.filterQuery(q);
    }
    return q;
  }

  @override
  SourceType get sourceType => SourceType.remote;
}
