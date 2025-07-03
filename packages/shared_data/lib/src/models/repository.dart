import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:shared_data/shared_data.dart';

/// {@template repo}
/// Data abstraction most likely to be exposed to other layers of the
/// application. Subclasses of this are where domain-specific logic should live.
/// {@endtemplate}
class Repository<T> {
  /// {@macro repo}
  Repository(this.sourceList, [String? loggerName])
      : _log = Logger(
          loggerName ?? 'Repository<$T>',
        );

  /// Data loader within a [Repository] which can cascade through a list of data
  /// sources, treating each as a write-through cache.
  final SourceList<T> sourceList;

  late final Logger _log;

  /// Loads an item by the given [id] if it exists.
  Future<T?> getById(String id, [RequestDetails<T>? details]) async {
    final result = await sourceList.getById(
      id,
      details ?? RequestDetails.read(),
    );
    switch (result) {
      case ReadSuccess<T>():
        return result.itemOrRaise();
      case ReadFailure<T>():
        _log.info('Failed to read $T with Id $id :: $result.error');
        return null;
    }
  }

  /// Loads all items in the given Id set. If any Ids were not fulfilled, they
  /// are included in `missingIds`.
  Future<(List<T> items, Set<String> missingIds)> getByIds(
    Set<String> ids, [
    RequestDetails<T>? details,
  ]) async {
    final result = await sourceList.getByIds(
      ids,
      details ?? RequestDetails.read(),
    );
    switch (result) {
      case ReadListSuccess<T>():
        final success = result.getOrRaise();
        return (success.items.toList(), success.missingItemIds);
      case ReadListFailure<T>():
        _log.info(
          'Failed to load $T with Ids $ids :: ${result.errorOrRaise()}',
        );
        return (<T>[], ids);
    }
  }

  /// Loads all items that match the given request [details], or the default
  /// [RequestDetails.read] object if not given.
  Future<List<T>> getItems([RequestDetails<T>? details]) async {
    final result = await sourceList.getItems(details ?? RequestDetails.read());
    switch (result) {
      case ReadListSuccess<T>():
        return result.itemsOrRaise();
      case ReadListFailure<T>():
        return <T>[];
    }
  }

  /// Persists the given item and returns the saved value if the write was
  /// successful.
  Future<T?> setItem(T item, [RequestDetails<T>? details]) async {
    final result = await sourceList.setItem(
      item,
      details ?? RequestDetails.write(),
    );
    switch (result) {
      case WriteSuccess<T>():
        return result.item;
      case WriteFailure<T>():
        return null;
    }
  }

  /// Persists all [items].
  Future<List<T>> setItems(
    Iterable<T> items, [
    RequestDetails<T>? details,
  ]) async {
    final result = await sourceList.setItems(
      items,
      details ?? RequestDetails.write(),
    );
    switch (result) {
      case WriteListSuccess<T>():
        return result.items.toList();
      case WriteListFailure<T>():
        return <T>[];
    }
  }

  /// Removes the item associated with the given [id] from persistence.
  Future<void> delete(String id, [RequestDetails<T>? details]) =>
      sourceList.delete(id, details ?? RequestDetails.write());

  /// Clears all local data. Does not delete anything from any remote sources.
  Future<void> clear() => sourceList.clear();

  /// Clears all local data cached against this request.
  Future<void> clearForRequest(RequestDetails<T> details) =>
      sourceList.clearForRequest(details);

  /// Releases any open resources like stream subscriptions.
  @mustCallSuper
  void close() {}
}
