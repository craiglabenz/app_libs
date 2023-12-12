import 'package:shared_data/shared_data.dart';

/// Outline of core methods to which all data loaders must adhere.
abstract class DataContract<T extends Model> {
  /// Loads the instance of [T] whose primary key is [id].
  Future<ReadResult<T>> getById(
    String id,
    RequestDetails<T> details,
  );

  /// Loads all instances of [T] whose primary key is in the set [ids].
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  );

  /// Loads all instances of [T] that satisfy any filtes or pagination on
  /// [details].
  Future<ReadListResult<T>> getItems(RequestDetails<T> details);

  /// Persists [item].
  Future<WriteResult<T>> setItem(
    T item,
    RequestDetails<T> details,
  );

  /// Persists all [items].
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  );
}
