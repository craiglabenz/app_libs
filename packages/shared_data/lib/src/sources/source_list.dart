import 'package:shared_data/shared_data.dart';

/// {@template SourceList}
/// Data component which iteratively asks individual sources for an object.
///
/// Sources that originally fail to yield an object have it cached if a fallback
/// source is able to yield it. [SourceList] should rarely be subclassed, as all
/// of its operations are intended to be completely uniform across data types.
/// If you are tempted to subclass [SourceList], consider putting that special
/// logic in the data type or feature's [Repository] instead.
///
/// The [RequestType] parameter on [RequestDetails] can be used to
/// control which sources are asked, which is helpful when you want to force a
/// cache read or cache miss.
/// {@endtemplate}
class SourceList<T extends Model> extends DataContract<T> {
  /// {@macro SourceList}
  SourceList({required this.sources, required this.bindings});

  /// Testing-friendly constructor for wiring things up that don't actually
  /// require a functioning [SourceList].
  factory SourceList.empty(Bindings<T> bindings) =>
      SourceList(sources: [], bindings: bindings);

  /// {@macro Bindings}
  final Bindings<T> bindings;

  /// Iterable of data [Source] objects which this [SourceList] will use to load
  /// requested data.
  final List<Source<T>> sources;

  /// Returns all sources that match a given [RequestType]. Unmatches sources
  /// are also returned with that indicator, so they can still be stored in a
  /// list of empty sources for the purposes of caching.
  Iterable<MatchedSource<T>> getSources({
    RequestType requestType = RequestType.global,
    bool reversed = false,
  }) sync* {
    final orderedSources = reversed ? sources.reversed : sources;
    for (final source in orderedSources) {
      if (requestType.includes(source.sourceType)) {
        yield MatchedSource.matched(source);
      }
      yield MatchedSource.unmatched(source);
    }
  }

  Future<void> _cacheItem(
    T item,
    List<Source> emptySources,
    RequestDetails<T> details,
  ) async {
    for (final source in emptySources) {
      await source.setItem(item, details);
    }
  }

  Future<void> _cacheItems(
    List<T> items,
    List<Source> emptySources,
    RequestDetails<T> details,
  ) async {
    for (final source in emptySources) {
      await source.setItems(items, details);
    }
  }

  @override
  Future<ReadResult<T>> getById(String id, RequestDetails<T> details) async {
    final emptySources = <Source<T>>[];
    for (final matchedSource in getSources(requestType: details.requestType)) {
      if (matchedSource.unmatched) {
        emptySources.add(matchedSource.source);
        continue;
      }
      final source = matchedSource.source;
      final sourceResult = await source.getById(id, details);

      switch (sourceResult) {
        case ReadFailure():
          {
            return sourceResult;
          }
        case ReadSuccess(:final item):
          {
            if (item != null) {
              await _cacheItem(item, emptySources, details);
              return sourceResult;
            }
            emptySources.add(source);
          }
      }
    }
    return ReadSuccess<T>(null, details: details);
  }

  @override
  Future<ReadListResult<T>> getByIds(
    Set<String> ids,
    RequestDetails<T> details,
  ) async {
    details.assertEmpty('getByIds');
    final items = <String, T>{};
    final pastSources = <Source>[];
    final backfillMap = <Source, Set<T>>{};

    // Copy the list of ids.
    // Called `missingIds` not because we've deemed these are all missing, but
    // because we're going to iteratively remove items that are locally known -
    // meaning at the end of the loop, remaining ids will be confirmed missing.
    var missingIds = Set<String>.from(ids);

    for (final matchedSource in getSources(requestType: details.requestType)) {
      if (missingIds.isEmpty) {
        break;
      }

      if (matchedSource.unmatched) {
        pastSources.add(matchedSource.source);
        continue;
      }
      final sourceResult =
          await matchedSource.source.getByIds(missingIds, details);

      switch (sourceResult) {
        case ReadListFailure():
          {
            return sourceResult;
          }
        case ReadListSuccess():
          {
            items.addAll(sourceResult.itemsMap);
            // Mark which Source needs which items
            for (final pastSource in pastSources) {
              backfillMap.putIfAbsent(pastSource, () => <T>{});
              backfillMap[pastSource]!.addAll(sourceResult.items);
            }

            // Remove any now-known Ids from `missingIds`
            missingIds =
                missingIds.where((id) => !items.containsKey(id)).toSet();

            // Note that we've already processed this Source, so if future
            // Sources produce any new items, we can backfill them to here.
            pastSources.add(matchedSource.source);
          }
      }
    }

    // Persist any items we found to local stores
    for (final pastSource in backfillMap.keys) {
      if (backfillMap[pastSource]!.isNotEmpty) {
        await pastSource.setItems(
          backfillMap[pastSource]!.toList(),
          RequestDetails<T>(requestType: details.requestType),
        );
      }
    }

    return ReadListResult<T>.fromMap(items, details, missingIds);
  }

  @override
  Future<ReadListResult<T>> getItems(RequestDetails<T> details) async {
    final emptySources = <Source>[];
    for (final matchedSource in getSources(requestType: details.requestType)) {
      if (matchedSource.unmatched) {
        emptySources.add(matchedSource.source);
        continue;
      }

      final sourceResult = await matchedSource.source.getItems(details);

      switch (sourceResult) {
        case ReadListFailure():
          {
            return sourceResult;
          }
        case ReadListSuccess():
          {
            final items = sourceResult.items;
            if (items.isNotEmpty) {
              await _cacheItems(items, emptySources, details);
              return ReadListResult<T>.fromList(items, details, {});
            } else {
              emptySources.add(matchedSource.source);
            }
          }
      }
    }
    return ReadListResult<T>.fromList([], details, {});
  }

  @override
  Future<WriteResult<T>> setItem(T item, RequestDetails<T> details) async {
    T itemDup = item;
    for (final ms in getSources(
      requestType: details.requestType,
      // Hit API first if item is new, so as to get an Id
      reversed: item.id == null,
    )) {
      if (ms.unmatched) continue;

      final result = await ms.source.setItem(itemDup, details);

      switch (result) {
        case WriteFailure():
          {
            return result;
          }
        case WriteSuccess():
          {
            if (item.id == null) {
              if (result.item.id == null) {
                return WriteFailure<T>(
                  FailureReason.serverError,
                  'Failed to generate Id for new $T',
                );
              }
              itemDup = result.item;
            }
          }
      }
    }
    return WriteSuccess<T>(itemDup, details: details);
  }

  @override
  Future<WriteListResult<T>> setItems(
    List<T> items,
    RequestDetails<T> details,
  ) async {
    assert(
      details.requestType == RequestType.local,
      'setItems is a local-only method',
    );
    for (final ms in getSources(requestType: details.requestType)) {
      if (ms.unmatched) continue;
      final result = await ms.source.setItems(items, details);
      if (result is WriteListFailure) {
        return result;
      }
    }
    return WriteListSuccess<T>(items, details: details);
  }
}

/// Indicates whether a given [Source] produced data, which is used when we turn
/// around and locally cache objects fetched from the server.
class MatchedSource<T extends Model> {
  MatchedSource._({required this.source, required this.matched});

  /// Flavor of [Source] that matched the given [RequestType]. This [Source]
  /// will be asked for the desired data.
  factory MatchedSource.matched(Source<T> source) => MatchedSource._(
        source: source,
        matched: true,
      );

  /// Flavor of [Source] that did not match the given [RequestType]. This
  /// [Source] will not be asked for the desired data and will only be able to
  /// cache the results of another [Source], if appropriate.
  factory MatchedSource.unmatched(Source<T> source) => MatchedSource._(
        source: source,
        matched: false,
      );

  /// {@macro Source}
  final Source<T> source;

  /// Whether or not this [Source] matched the given [RequestType].
  final bool matched;

  /// Opposite of [matched].
  bool get unmatched => !matched;

  @override
  String toString() => 'MatchedSource(matched=$matched, source=$source)';
}
