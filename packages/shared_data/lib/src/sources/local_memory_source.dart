import 'package:shared_data/shared_data.dart';

/// {@template LocalMemorySource}
/// On-device, in-memory store which caches previously loaded data for
/// instantaneous retrieval. Does not persist any data across sessions.
/// {@endtemplate}
class LocalMemorySource<T extends Model> extends LocalSource<T> {
  /// {@macro LocalMemorySource}
  LocalMemorySource({
    required this.bindings,
    this.canSetIds = false,
  });

  /// Map of the stored items, with database primary keys as map keys.
  Map<String, T> items = {};

  /// Computed set of all known Ids.
  Set<String> get itemIds => items.keys.toSet();

  /// Set of request types known to have no results. This differentiates a
  /// first-time request from a request which has already gone to the server and
  /// returned zero objects.
  Set<int> knownEmptySets = {};

  /// Map of request hashes to the Ids they returned.
  Map<int, Set<String>> requestCache = {};

  @override
  SourceType get sourceType => SourceType.local;

  /// If false, `setItem` will require that new objects have non-null `id`
  /// values.
  bool canSetIds;

  /// Meta-data provider for [T].
  final Bindings<T> bindings;

  /// Returns the object with the given `id`, as long as the item is associated
  /// with the given setName in `details`.
  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) {
    T? item;
    if (!requestCache.containsKey(details.cacheKey)) {
      item = null;
    } else if (!requestCache[details.cacheKey]!.contains(id)) {
      item = null;
    } else {
      item = items[id];
    }
    return Future.value(
      ReadSuccess(item, details: details),
    );
  }

  /// Used for bulk read methods that neither want inner futures nor
  /// ReadResults.
  T? _getByIdSync(String id, RequestDetails<T> details) {
    if (!requestCache.containsKey(details.cacheKey)) return null;
    if (!requestCache[details.cacheKey]!.contains(id)) return null;
    return items[id];
  }

  /// Returns all known items from the set of IDs. Any id values not found
  /// appear in `missingItemIds`.
  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) async {
    details.assertEmpty('getByIds');
    final itemsById = <String, T>{};
    final missingItemIds = <String>{};
    for (final id in ids) {
      final maybeItem = _getByIdSync(id, details);
      if (maybeItem != null) {
        itemsById[id] = maybeItem;
      } else {
        missingItemIds.add(id);
      }
    }
    return ReadListResult<T>.fromMap(itemsById, details, missingItemIds);
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) async {
    if (knownEmptySets.contains(details.cacheKey)) {
      // TODO(craiglabenz): log this behavior
      return ReadListSuccess<T>(
        items: [],
        itemsMap: {},
        details: details,
        missingItemIds: {},
      );
    }
    if (!requestCache.containsKey(details.cacheKey)) {
      return _applyUnseenRequest(details);
    }

    // Assumes all IDs in `details.setName` have a matching object in `items`,
    // because that is the job of `setItem`.
    final itemsIter =
        requestCache[details.cacheKey]!.map<T>((String id) => items[id]!);

    final filteredItemsIter = itemsIter.where(
      (T obj) => _passesAllFilters(obj, details.filters),
    );

    return ReadListResult<T>.fromList(filteredItemsIter.toList(), details, {});
  }

  bool _passesAllFilters(T obj, List<ReadFilter<T>> filters) {
    for (final filter in filters) {
      if (!filter.predicate(obj)) return false;
    }
    return true;
  }

  ReadListResult<T> _applyUnseenRequest(RequestDetails<T> details) {
    // Unseen requests with pagination cannot be fulfilled, as we cannot know we
    // have all the results for that page.
    if (details.pagination != null) {
      return ReadListResult.fromList([], details, <String>{});
    }

    final satisfyingIds = itemIds;
    for (final item in items.values) {
      for (final filter in details.filters) {
        if (!filter.predicate(item)) {
          satisfyingIds.remove(item.id);
        }
      }
    }

    final satisfyingItems = <T>[];
    for (final id in satisfyingIds) {
      satisfyingItems.add(items[id]!);
    }
    return ReadListResult.fromList(satisfyingItems, details, <String>{});
  }

  /// Sets an Id value to this item.
  T setId(T item) {
    assert(
      item.id == null,
      'Unexpectedly called `setId` on item with an `id` value of ${item.id}',
    );
    return bindings.fromJson(item.toJson()..update('id', (value) => 'new'));
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
    assert(
      canSetIds || item.id != null,
      'LocalMemorySource can only persist items with an Id. To allow this '
      'source to set Ids, set `canSetIds` to true.',
    );

    T itemCopy = item;

    if (itemCopy.id == null) {
      itemCopy = setId(itemCopy);
    }

    if (details.shouldOverwrite ||
        (itemCopy.id != null && !items.containsKey(itemCopy.id))) {
      items[itemCopy.id!] = itemCopy;
    }
    if (!requestCache.containsKey(details.cacheKey)) {
      requestCache[details.cacheKey] = <String>{};
    }
    if (!requestCache.containsKey(details.empty.cacheKey)) {
      requestCache[details.empty.cacheKey] = <String>{};
    }
    requestCache[details.cacheKey]!.add(itemCopy.id!);

    if (details.isNotEmpty) {
      requestCache[details.empty.cacheKey]!.add(itemCopy.id!);
    }
    return WriteSuccess<T>(itemCopy, details: details);
  }

  @override
  Future<WriteListResult<T>> setItems(
    Iterable<T> items,
    RequestDetails<T> details,
  ) {
    for (final item in items) {
      setItem(item, details);
    }
    return Future.value(WriteListSuccess<T>(items, details: details));
  }

  @override
  Future<void> clear() async {
    items.clear();
    knownEmptySets.clear();
    requestCache.clear();
  }
}
