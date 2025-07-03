import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

abstract class HiveInitializer with ReadinessMixin<bool> {
  HiveInitializer();
}

/// {@template HiveSource}
/// {@endtemplate}
class HiveSource<T> extends LocalSource<T> with ReadinessMixin<void> {
  /// {@macro HiveSource}
  factory HiveSource({
    required Bindings<T> bindings,
    required Future<bool> hiveInit,
    IdBuilder<T>? idBuilder,
  }) {
    final hiveItemsPersistence = HiveItemsPersistence<T>(
      bindings.getListUrl().path,
      bindings.getId,
      hiveInit,
    );
    final hiveCachePersistence = HiveCachePersistence(
      bindings.getListUrl().path,
      hiveInit,
    );
    return HiveSource._(
        hiveItemsPersistence,
        hiveCachePersistence,
        idBuilder: idBuilder,
        bindings: bindings,
      )
      .._hiveItemsPersistence = hiveItemsPersistence
      .._hiveCachePersistence = hiveCachePersistence;
  }

  // ignore: use_super_parameters
  HiveSource._(
    HiveItemsPersistence<T> itemsPersistence,
    HiveCachePersistence cachePersistence, {
    required super.bindings,
    super.idBuilder,
  }) : super(itemsPersistence, cachePersistence);

  late HiveItemsPersistence<T> _hiveItemsPersistence;
  late HiveCachePersistence _hiveCachePersistence;

  @override
  Future<void> performInitialization() async {
    await Future.wait([
      _hiveItemsPersistence.initialize(),
      _hiveCachePersistence.initialize(),
    ]);
    markReady(null);
  }
}

class HiveItemsPersistence<T> extends LocalSourcePersistence<T>
    with ReadinessMixin<void> {
  HiveItemsPersistence(this.name, this.getId, this.hiveInit);

  final String name;
  String? Function(T) getId;

  final Future<bool> hiveInit;

  late final Box<T> _itemsBox;

  @override
  Future<void> performInitialization() async {
    final hiveInitialized = await hiveInit;
    if (!hiveInitialized) {
      throw Exception('Failed to initialize Hive');
    }
    _itemsBox = await Hive.openBox<T>('${name}_items');
    markReady(null);
  }

  @override
  void clear() => _itemsBox.clear();

  @override
  void deleteIds(Set<String> ids) => ids.forEach(_itemsBox.delete);

  @override
  T? getById(String id) => _itemsBox.get(id);

  @override
  Iterable<T> getByIds(Set<String> ids) sync* {
    for (final id in ids) {
      yield _itemsBox.get(id)!;
    }
  }

  @override
  void setItem(T item, {required bool shouldOverwrite}) {
    assert(
      getId(item) != null,
      'Checking for null Id in Hive box - unsafe!',
    );
    if (shouldOverwrite || _itemsBox.get(getId(item)) == null) {
      _itemsBox.put(getId(item), item);
    }
  }

  @override
  void setItems(Iterable<T> items, {required bool shouldOverwrite}) {
    for (final item in items) {
      setItem(item, shouldOverwrite: shouldOverwrite);
    }
  }
}

class HiveCachePersistence extends CachePersistence with ReadinessMixin<void> {
  HiveCachePersistence(this.name, this.hiveInit) {
    _log = Logger('HiveCachePersistence($name)');
  }

  /// Namespace for Hive box name prefixes.
  final String name;

  final Future<bool> hiveInit;

  late final Box<Set<String>> _requestCacheBox;

  // Cannot pre-type Maps with Hive
  // ignore: strict_raw_type
  late final Box<Map> _paginationCacheBox;

  late final Logger _log;

  @override
  Future<void> performInitialization() async {
    final hiveInitialized = await hiveInit;
    if (!hiveInitialized) {
      throw Exception('Failed to initialize Hive');
    }
    _requestCacheBox = await Hive.openBox<Set<String>>('${name}_requestCache');
    // Cannot pre-type Maps with Hive
    // ignore: strict_raw_type
    _paginationCacheBox = await Hive.openBox<Map>(
      '${name}_paginationRequestCache',
    );
    markReady(null);
  }

  @override
  void clear() {
    assert(
      isReady,
      'Must complete initialization before calling HiveCachePersistence.clear',
    );
    _requestCacheBox.clear();
    _paginationCacheBox.clear();
  }

  @override
  void clearCacheKey(CacheKey key) => _requestCacheBox.delete(key);

  @override
  void clearPaginatedCacheKey({required CacheKey noPaginationCacheKey}) =>
      _paginationCacheBox.delete(noPaginationCacheKey);

  @override
  Set<String>? getCacheKey(CacheKey key) {
    final result = _requestCacheBox.get(key);
    _log.finest('Loading $key - found $result');
    return result;
  }

  @override
  Set<String>? getPaginatedCacheKey({
    required CacheKey noPaginationCacheKey,
    required CacheKey cacheKey,
  }) {
    final pagesMetadata = _paginationCacheBox
        .get(noPaginationCacheKey)
        ?.cast<CacheKey, Set<String>>();
    _log.finest(
      'Loading $noPaginationCacheKey::$cacheKey - found $pagesMetadata',
    );
    return pagesMetadata != null ? pagesMetadata[cacheKey] : null;
  }

  @override
  void setCacheKey(CacheKey key, Set<String> ids) {
    _log.finest('Writing $ids to $key');
    _requestCacheBox.put(key, ids);
  }

  @override
  void setPaginatedCacheKey({
    required CacheKey noPaginationCacheKey,
    required CacheKey cacheKey,
    required Set<String> ids,
  }) {
    _log.finest('Writing $ids to $noPaginationCacheKey::$cacheKey');
    final pagesMetadata =
        _paginationCacheBox.get(noPaginationCacheKey) ??
        <CacheKey, Set<String>>{};

    pagesMetadata[cacheKey] = ids;
    _paginationCacheBox.put(noPaginationCacheKey, pagesMetadata);
  }

  @override
  Iterable<CacheKey> getRequestCacheKeys() =>
      _requestCacheBox.keys.cast<CacheKey>();

  @override
  Iterable<CacheKey> noPaginationCacheKeys() =>
      _paginationCacheBox.keys.cast<CacheKey>();

  @override
  Iterable<CacheKey> noPaginationInnerKeys(CacheKey noPaginationCacheKey) {
    final innerMap =
        _paginationCacheBox.get(noPaginationCacheKey) ??
        <CacheKey, Set<String>>{};
    return innerMap.keys.cast<CacheKey>();
  }
}
