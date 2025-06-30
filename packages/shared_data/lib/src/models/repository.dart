import 'package:meta/meta.dart';
import 'package:shared_data/shared_data.dart';

/// {@template repo}
/// Data abstraction most likely to be exposed to other layers of the
/// application. Subclasses of this are where domain-specific logic should live.
/// {@endtemplate}
class Repository<T> extends DataContract<T> {
  /// {@macro repo}
  Repository(this.sourceList);

  /// Generates a stock Repository with a typical [SourceList].
  static Repository<T> create<T>(Bindings<T> bindings, RestApi api) {
    return Repository(
      SourceList<T>(
        bindings: bindings,
        sources: [
          LocalMemorySource(bindings: bindings),
          ApiSource(
            bindings: bindings,
            restApi: api,
          )
        ],
      ),
    );
  }

  /// Data loader within a [Repository] which can cascade through a list of data
  /// sources, treating each as a write-through cache.
  final SourceList<T> sourceList;

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) =>
      sourceList.getById(id, details);

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) =>
      sourceList.getByIds(ids, details);

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) =>
      sourceList.getItems(details);

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) =>
      sourceList.setItem(item, details);

  @override
  Future<WriteListResult<T>> setItems(
    Iterable<T> items,
    RequestDetails<T> details,
  ) =>
      sourceList.setItems(items, details);

  /// Clears all local data. Does not delete anything from any remote sources.
  Future<void> clear() => sourceList.clear();

  /// Clears all local data cached against this request.
  Future<void> clearForRequest(RequestDetails<T> details) =>
      sourceList.clearForRequest(details);

  /// Releases any open resources like stream subscriptions.
  @mustCallSuper
  void close() {}

  @override
  Future<DeleteResult<T>> delete(String id, RequestDetails<T> details) =>
      sourceList.delete(id, details);
}
