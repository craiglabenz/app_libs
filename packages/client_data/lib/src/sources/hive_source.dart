import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

abstract class HiveInitializer {
  const HiveInitializer();
  Future<bool> get initialized;
}

/// {@template HiveSource}
/// {@endtemplate}
class HiveSource<T extends Model> extends Source<T> {
  /// {@macro HiveSource}
  HiveSource({required this.bindings});

  final Bindings<T> bindings;

  final _log = Logger('HiveSource<$T>');

  final _initialized = Completer<bool>();

  late final Box<T> _box;

  Future<void> initialize() async {
    final hiveInit = await GetIt.I<HiveInitializer>().initialized;

    if (!hiveInit) {
      throw Exception('Failed to initialize Hive');
    }

    _box = await Hive.openBox<T>(bindings.getListUrl().path);
    return _initialized.complete(true);
  }

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) async {
    await _initialized.future;
    try {
      return ReadSuccess<T>(_box.get(id), details: details);
    } on Exception catch (e, st) {
      _log.severe(
        'Failed to read $T with id $id from Hive: $e\nStack Trace: $st',
      );
      return ReadFailure<T>(FailureReason.badRequest, 'Problem reading data');
    }
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) async {
    await _initialized.future;
    final foundItems = <T>[];
    final foundIds = <String>{};
    try {
      for (final id in ids) {
        final object = _box.get(id);
        if (object != null) {
          foundItems.add(object);
          foundIds.add(id);
        }
      }

      final missingIds = ids.difference(foundIds);
      return ReadListResult<T>.fromList(foundItems, details, missingIds);
    } on Exception catch (e, st) {
      _log.severe(
        'Failed to read $T with ids $ids from Hive: $e\nStack Trace: $st',
      );
      return ReadListFailure<T>(
        FailureReason.badRequest,
        'Problem reading data',
      );
    }
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) async {
    await _initialized.future;
    try {
      Iterable<T> values = _box.values;
      for (final filter in details.filters) {
        values = values.where(filter.predicate);
      }
      return ReadListResult<T>.fromList(values.toList(), details, {});
    } on Exception catch (e, st) {
      _log.severe('Failed to read $T list from Hive: $e\nStack Trace: $st');
      return ReadListFailure<T>(
        FailureReason.badRequest,
        'Problem reading data',
      );
    }
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
    await _initialized.future;
    assert(item.id != null, 'Must only write objects with Ids to HiveSources');
    try {
      await _box.put(item.id, item);
      return WriteSuccess<T>(item, details: details);
    } on Exception catch (e, st) {
      _log.severe('Failed to read $T list from Hive: $e\nStack Trace: $st');
      return WriteFailure<T>(FailureReason.badRequest, 'Problem writing data');
    }
  }

  @override
  Future<WriteListResult<T>> setItems(
    Iterable<T> items,
    RequestDetails<T> details,
  ) async {
    try {
      await _initialized.future;
      for (final item in items) {
        assert(
          item.id != null,
          'Must only write objects with Ids to HiveSources',
        );
        await _box.put(item.id, item);
      }
      return WriteListSuccess<T>(items, details: details);
    } on Exception catch (e, st) {
      _log.severe('Failed to read $T list from Hive: $e\nStack Trace: $st');
      return WriteListFailure<T>(
        FailureReason.badRequest,
        'Problem writing data',
      );
    }
  }

  @override
  SourceType sourceType = SourceType.local;
}
