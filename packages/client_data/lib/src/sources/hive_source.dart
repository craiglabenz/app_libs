import 'dart:async';

import 'package:get_it/get_it.dart';
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
    IdBuilder<T>? idBuilder,
  }) {
    final hiveItemsPersistence = HiveItemsPersistence<T>(
      bindings.getListUrl().path,
      bindings.getId,
    );
    final hiveCachePersistence = HiveCachePersistence(
      bindings.getListUrl().path,
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
  HiveItemsPersistence(this.name, this.getId);

  final String name;
  String? Function(T) getId;

  late final Box<T> _itemsBox;

  @override
  Future<void> performInitialization() async {
    final hiveInit = await GetIt.I<HiveInitializer>().ready;
    if (!hiveInit) {
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
  HiveCachePersistence(this.name) {
    _log = Logger('HiveCachePersistence($name)');
  }

  /// Namespace for Hive box name prefixes.
  final String name;

  late final Box<Set<String>> _requestCacheBox;

  // Cannot pre-type Maps with Hive
  // ignore: strict_raw_type
  late final Box<Map> _paginationCacheBox;

  late final Logger _log;

  @override
  Future<void> performInitialization() async {
    final hiveInit = await GetIt.I<HiveInitializer>().ready;
    if (!hiveInit) {
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

/// {@template HiveSource}
/// {@endtemplate}
// class HiveSource<T> extends LocalSource<T> {
//   /// {@macro HiveSource}
//   // HiveSource({required this.bindings});

//   final Bindings<T> bindings;

//   final _log = Logger('HiveSource<$T>');

//   final _initialized = Completer<bool>();

//   late final Box<T> _box;

//   Future<void> initialize() async {
//     final hiveInit = await GetIt.I<HiveInitializer>().initialized;

//     if (!hiveInit) {
//       throw Exception('Failed to initialize Hive');
//     }

//     _box = await Hive.openBox<T>(bindings.getListUrl().path);
//     return _initialized.complete(true);
//   }

//   @override
//   Future<ReadResult<T>> getById(String id, RequestDetails<T> details) async {
//     await _initialized.future;
//     try {
//       return ReadSuccess<T>(_box.get(id), details: details);
//     } on Exception catch (e, st) {
//       _log.severe(
//         'Failed to read $T with id $id from Hive: $e\nStack Trace: $st',
//       );
//       return ReadFailure<T>(FailureReason.badRequest, 'Problem reading data');
//     }
//   }

//   @override
//   Future<ReadListResult<T>> getByIds(
//     Set<String> ids,
//     RequestDetails<T> details,
//   ) async {
//     await _initialized.future;
//     final foundItems = <T>[];
//     final foundIds = <String>{};
//     try {
//       for (final id in ids) {
//         final object = _box.get(id);
//         if (object != null) {
//           foundItems.add(object);
//           foundIds.add(id);
//         }
//       }

//       final missingIds = ids.difference(foundIds);
//       return ReadListResult<T>.fromList(foundItems, details, missingIds);
//     } on Exception catch (e, st) {
//       _log.severe(
//         'Failed to read $T with ids $ids from Hive: $e\nStack Trace: $st',
//       );
//       return ReadListFailure<T>(
//         FailureReason.badRequest,
//         'Problem reading data',
//       );
//     }
//   }

//   @override
//   Future<ReadListResult<T>> getItems(RequestDetails<T> details) async {
//     await _initialized.future;
//     try {
//       Iterable<T> values = _box.values;
//       for (final filter in details.filters) {
//         values = values.where(filter.predicate);
//       }
//       return ReadListResult<T>.fromList(values.toList(), details, {});
//     } on Exception catch (e, st) {
//       _log.severe('Failed to read $T list from Hive: $e\nStack Trace: $st');
//       return ReadListFailure<T>(
//         FailureReason.badRequest,
//         'Problem reading data',
//       );
//     }
//   }

//   @override
//   Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
//     await _initialized.future;
//     assert(bindings.getId(item) != null, 'Must only write objects with Ids to HiveSources');
//     try {
//       await _box.put(bindings.getId(item), item);
//       return WriteSuccess<T>(item, details: details);
//     } on Exception catch (e, st) {
//       _log.severe('Failed to read $T list from Hive: $e\nStack Trace: $st');
//       return WriteFailure<T>(FailureReason.badRequest, 'Problem writing data');
//     }
//   }

//   @override
//   Future<WriteListResult<T>> setItems(
//     Iterable<T> items,
//     RequestDetails<T> details,
//   ) async {
//     try {
//       await _initialized.future;
//       for (final item in items) {
//         assert(
//           bindings.getId(item) != null,
//           'Must only write objects with Ids to HiveSources',
//         );
//         await _box.put(bindings.getId(item), item);
//       }
//       return WriteListSuccess<T>(items, details: details);
//     } on Exception catch (e, st) {
//       _log.severe('Failed to read $T list from Hive: $e\nStack Trace: $st');
//       return WriteListFailure<T>(
//         FailureReason.badRequest,
//         'Problem writing data',
//       );
//     }
//   }

//   @override
//   Future<void> clear() => _box.clear();
// }
