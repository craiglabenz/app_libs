import 'package:shared_data/shared_data.dart';

/// {@template LocalMemorySource}
/// On-device, in-memory store which caches previously loaded data for
/// instantaneous retrieval. Does not persist any data across sessions.
/// {@endtemplate}
class LocalMemorySource<T extends Model> extends LocalSource<T> {
  /// {@macro LocalMemorySource}
  LocalMemorySource({required super.bindings, super.idBuilder})
      : super(InMemorySourcePersistence(), InMemoryCachePersistence());
}

/// In-memory storage for a [LocalSource]. This is a glorified [Map].
class InMemorySourcePersistence<T extends Model>
    extends LocalSourcePersistence<T> {
  final _items = <String, T>{};

  @override
  void clear() => _items.clear();

  @override
  T? getById(String id) => _items[id];

  @override
  Iterable<T> getByIds(Set<String> ids) =>
      ids.map<T?>(getById).where((T? obj) => obj != null).cast<T>();

  @override
  void setItem(T item, {required bool shouldOverwrite}) =>
      shouldOverwrite || !_items.containsKey(item.id)
          ? _items[item.id!] = item
          : null;

  @override
  void setItems(Iterable<T> items, {required bool shouldOverwrite}) =>
      // ignore: avoid_function_literals_in_foreach_calls
      items.forEach(
        (item) => setItem(item, shouldOverwrite: shouldOverwrite),
      );

  @override
  void deleteIds(Set<String> ids) => ids.forEach(_items.remove);
}

/// In memory storage for caching metadata of a [LocalSource] object. Naturally,
/// this caching strategy does not persist any information across unique
/// launches of the application.
class InMemoryCachePersistence extends CachePersistence {
  /// Map of request hashes to the Ids they returned. This cache is only used
  /// for requests *without* any pagination.
  final Map<CacheKey, Set<String>> _requestCache = {};

  /// Map of request hashes to the Ids they returned. This cache is used for
  /// requests *with* pagination.
  ///
  /// The outermost [CacheKey] is the parent cache key - essentially the
  /// paginated request's cache key after its pagination is removed. The
  /// secondary [CacheKey] is full cache key with pagination. This allows for
  /// refreshes of data loaded with pagination to clear all pages of its data.
  final Map<CacheKey, Map<CacheKey, Set<String>>> _paginatedCache = {};

  @override
  void clear() {
    _requestCache.clear();
    _paginatedCache.clear();
  }

  @override
  void clearCacheKey(CacheKey key) => _requestCache.remove(key);

  @override
  void clearPaginatedCacheKey({required CacheKey noPaginationCacheKey}) =>
      _paginatedCache.remove(noPaginationCacheKey);

  @override
  Set<String>? getCacheKey(CacheKey key) => _requestCache[key];

  @override
  Set<String>? getPaginatedCacheKey({
    required CacheKey noPaginationCacheKey,
    required CacheKey cacheKey,
  }) {
    return (_paginatedCache[noPaginationCacheKey] ??
        <CacheKey, Set<String>>{})[cacheKey];
  }

  @override
  void setCacheKey(CacheKey key, Set<String> ids) => _requestCache[key] = ids;

  @override
  void setPaginatedCacheKey({
    required CacheKey noPaginationCacheKey,
    required CacheKey cacheKey,
    required Set<String> ids,
  }) {
    if (!_paginatedCache.containsKey(noPaginationCacheKey)) {
      _paginatedCache[noPaginationCacheKey] = <CacheKey, Set<String>>{};
    }
    _paginatedCache[noPaginationCacheKey]![cacheKey] = ids;
  }

  /// Hopefully dead code to delete after LocalSource.deleteItems is more
  /// confidently trusted
  void deleteIds(Set<String> ids) {
    final requestCacheCopy = Map<CacheKey, Set<String>>.from(_requestCache);
    for (final cacheKey in _requestCache.keys) {
      requestCacheCopy[cacheKey]!.removeAll(ids);
      if (requestCacheCopy[cacheKey]!.isEmpty) {
        requestCacheCopy.remove(cacheKey);
      }
    }
    _requestCache.clear();
    for (final key in requestCacheCopy.keys) {
      _requestCache[key] = requestCacheCopy[key]!;
    }

    final paginatedCacheCopy = <CacheKey, Map<CacheKey, Set<String>>>{};
    for (final key in _paginatedCache.keys) {
      paginatedCacheCopy[key] =
          Map<CacheKey, Set<String>>.from(_paginatedCache[key]!);
    }

    for (final noPaginationCacheKey in _paginatedCache.keys) {
      for (final cacheKey in _paginatedCache[noPaginationCacheKey]!.keys) {
        paginatedCacheCopy[noPaginationCacheKey]![cacheKey]!.removeAll(ids);
        if (paginatedCacheCopy[noPaginationCacheKey]![cacheKey]!.isEmpty) {
          paginatedCacheCopy[noPaginationCacheKey]!.remove(cacheKey);
        }
        if (paginatedCacheCopy[noPaginationCacheKey]!.isEmpty) {
          paginatedCacheCopy.remove(noPaginationCacheKey);
        }
      }
    }
    _paginatedCache.clear();
    for (final key in paginatedCacheCopy.keys) {
      _paginatedCache[key] = paginatedCacheCopy[key]!;
    }
  }

  @override
  Iterable<CacheKey> getRequestCacheKeys() => _requestCache.keys;

  @override
  Iterable<CacheKey> noPaginationCacheKeys() => _paginatedCache.keys;

  @override
  Iterable<CacheKey> noPaginationInnerKeys(CacheKey noPaginationCacheKey) =>
      _paginatedCache[noPaginationCacheKey]!.keys;
}
