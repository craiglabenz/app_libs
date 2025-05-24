import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:shared_data/shared_data.dart';

/// {@template ApiSource}
/// Subtype of [Source] which knows how to make network requests to load data.
/// {@endtemplate}
class ApiSource<T extends Model> extends Source<T> {
  /// {@macro ApiSource}
  ApiSource({
    required this.bindings,
    required RestApi restApi,
    ITimer? timer,
  })  : api = restApi,
        idsCurrentlyBeingFetched = <String>{},
        loadedItems = {},
        timer = timer ?? BatchTimer(),
        queuedIds = <String>{};

  /// Meta-data provider for [T].
  final Bindings<T> bindings;

  /// Utility able to send network requests.
  final RestApi api;

  /// Clock-aware object used to batch Ids.
  final ITimer timer;

  /// Ids set to be loaded during the next batch.
  Set<String> queuedIds;

  /// Set of Ids currently being loaded, but which have not yet been resolved.
  Set<String> idsCurrentlyBeingFetched;

  /// Id-keyed store of [Completer] instances which are individually resolved
  /// when a batch is returned from the server.
  final Map<String, Completer<T?>> loadedItems;

  // ignore: avoid_print
  void _print(String msg) => ApiSource._shouldPrint ? print(msg) : null;

  static const _shouldPrint = false;

  @override
  SourceType get sourceType => SourceType.remote;

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) async {
    if (!loadedItems.containsKey(id) || !loadedItems[id]!.isCompleted) {
      _print('Maybe queuing Id $id');
      queueId(id);
    }
    return Right(
      ReadSuccess(await loadedItems[id]!.future, details: details),
    );
  }

  @override
  Future<ReadListResult<T>> getItems(
    RequestDetails<T> details,
  ) async {
    final Params params = <String, String>{};

    // Add all specified filters as query parameters
    for (final filter in details.filters) {
      params.addAll(filter.toParams());
    }

    final result = await fetchItems(params);

    return result.map(
      success: (s) => Right(
        ReadListSuccess.fromList(
          hydrateListResponse(s),
          details,
          {},
        ),
      ),
      error: (e) => Left(ReadFailure.fromApiError(e)),
    );
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) async {
    assert(details.filters.isEmpty, 'Must not supply filters to `getByIds`');

    if (ids.isEmpty) {
      return Right(ReadListSuccess<T>.fromList([], details, {}));
    }
    final Params params = <String, String>{
      'id__in': ids.join(','),
    };

    final result = await fetchItems(params);

    return result.map(
      success: (s) {
        final items = hydrateListResponse(result as ApiSuccess);
        final itemsById = <String, T>{};
        for (final item in items) {
          // Objects from the server must always have an Id set.
          itemsById[item.id!] = item;
        }

        final missingItemIds = <String>{};
        for (final id in ids) {
          if (!itemsById.containsKey(id)) {
            missingItemIds.add(id);
          }
        }

        return Right(
          ReadListSuccess<T>.fromMap(itemsById, details, missingItemIds),
        );
      },
      error: (e) => Left(ReadFailure.fromApiError(e)),
    );
  }

  /// Prepares an Id to be loaded in the next batch.
  void queueId(String id) {
    if (!queuedIds.contains(id) && !idsCurrentlyBeingFetched.contains(id)) {
      _print('Id $id not yet queued - adding to queue now');
      loadedItems[id] = Completer<T?>();
      queuedIds.add(id);
      timer
        ..cancel()
        ..start(const Duration(milliseconds: 1), loadDeferredIds);
    }
  }

  /// Submits any Ids currently in the queue for loading.
  Future<void> loadDeferredIds() async {
    _print('Starting to load deferred ids: $queuedIds');
    queuedIds.forEach(idsCurrentlyBeingFetched.add);
    final ids = Set<String>.from(queuedIds);
    queuedIds.clear();
    final byIds = await getByIds(
      ids,
      RequestDetails<T>(),
    );
    byIds.fold(
      (ReadFailure<T> l) {
        for (final id in ids) {
          loadedItems[id]!.complete(null);
        }
      },
      (ReadListSuccess<T> r) {
        for (final id in r.missingItemIds) {
          loadedItems[id]!.complete(null);
        }
        for (final id in r.itemsMap.keys) {
          if (!loadedItems.containsKey(id)) {
            continue;
          }
          if (!loadedItems[id]!.isCompleted) {
            idsCurrentlyBeingFetched.remove(id);
            loadedItems[id]!.complete(r.itemsMap[id]!);
            loadedItems.remove(id);
          }
        }
      },
    );
  }

  /// Submits a network request for data.
  Future<ApiResult> fetchItems(Params? params) async {
    final request = ReadApiRequest(
      url: bindings.getListUrl(),
      params: params,
    );
    return api.get(request);
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
    final request = WriteApiRequest(
      url: item.id == null
          ? bindings.getCreateUrl()
          : bindings.getDetailUrl(item.id!),
      body: item.toJson(),
    );

    final result = await (item.id == null //
            ? api.post(request)
            : api.update(request) //
        );

    return result.map(
      success: (s) {
        return Right(
          WriteSuccess(hydrateItemResponse(s)!, details: details),
        );
      },
      error: (e) => Left(WriteFailure.fromApiError(e)),
    );
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  ) =>
      throw Exception('Should never call ApiSource.setItems');

  /// Deserializes the result of a network request into the actual object(s).
  T? hydrateItemResponse(ApiSuccess success) => success.body.map(
        html: (HtmlApiResultBody body) => null,
        json: (JsonApiResultBody body) {
          if (body.data.containsKey('results')) {
            // TODO(craiglabenz): log that this is unexpected for [result.url]
            if ((body.data['results']! as List).length != 1) {
              // TODO(craiglabenz): log that this is even more unexpected
            }
            final items = (body.data['results']! as List)
                .cast<Json>()
                .map<T>(bindings.fromJson)
                .toList();
            return items.first;
          } else {
            return bindings.fromJson(body.data);
          }
        },
        plainText: (PlainTextApiResultBody body) => null,
      );

  /// Deserializes the results of a network request into the actual object(s).
  List<T> hydrateListResponse(ApiSuccess success) => success.body.map(
        html: (HtmlApiResultBody body) => <T>[],
        json: (JsonApiResultBody body) {
          if (body.data.containsKey('results')) {
            final List<Map<String, dynamic>> results =
                (body.data['results']! as List).cast<Json>();
            final items = results.map<T>(bindings.fromJson).toList();
            return items;
          } else {
            return [bindings.fromJson(body.data)];
          }
        },
        plainText: (PlainTextApiResultBody body) => <T>[],
      );
}
