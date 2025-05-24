import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:matcher/matcher.dart';
import 'package:shared_data/shared_data.dart';

part 'results.freezed.dart';

//////////////////
/// WRITE RESULTS
//////////////////

/// Explanations for why a write request may have failed.
enum FailureReason {
  /// Write request failed because of a problem on the server.
  serverError,

  /// Write request failed because of a problem with the client's request.
  badRequest;
}

/// {@template WriteResult}
/// {@endtemplate}
@Freezed()
sealed class WriteResult<T extends Model> with _$WriteResult<T> {
  const WriteResult._();

  /// {@template WriteSuccess}
  /// Container for a single object write request which did not encounter any
  /// errors.
  /// {@endtemplate}
  const factory WriteResult.success(T item,
      {required RequestDetails<T> details}) = WriteSuccess;

  /// {@template RequestFailure}
  /// Represents a failure with the write, resulting from either an unexpected
  /// problem on the server or the server rejecting the client's request.
  /// The `message` property should be suitable for showing the user.
  /// {@endtemplate}
  const factory WriteResult.failure(
    FailureReason reason,
    String message,
  ) = WriteFailure;

  /// {@template fromApiError}
  /// Builder for a failed write attemped, derived from its [ApiError].
  /// {@endtemplate}
  factory WriteResult.fromApiError(ApiError e) {
    if (e.statusCode >= HttpStatus.badRequest &&
        e.statusCode < HttpStatus.internalServerError) {
      return WriteFailure(FailureReason.badRequest, e.error.plain);
    } else if (e.statusCode >= HttpStatus.internalServerError) {
      return WriteFailure(FailureReason.serverError, e.error.plain);
    }
    // TODO(craiglabenz): Log `e.errorString`
    return WriteFailure(
      FailureReason.serverError,
      'Unexpected error: ${e.statusCode} ${e.error.plain}',
    );
  }

  /// Helper to extract expected [WriteSuccess] objects or throw in the case of
  /// an unexpected [WriteFailure].
  WriteSuccess<T> getOrRaise() {
    switch (this) {
      case WriteSuccess():
        {
          return this as WriteSuccess<T>;
        }
      case WriteFailure():
        {
          throw Exception('Unexpected $runtimeType');
        }
    }
  }
}

/// {@template WriteListResult}
/// {@endtemplate}
@Freezed()
sealed class WriteListResult<T extends Model> with _$WriteListResult<T> {
  const WriteListResult._();

  /// {@template BulkWriteSuccess}
  /// Container for a bulk write request which did not encounter any errors.
  /// {@endtemplate}
  const factory WriteListResult.success(
    List<T> items, {
    required RequestDetails<T> details,
  }) = WriteListSuccess;

  /// {@macro RequestFailure}
  const factory WriteListResult.failure(
    FailureReason reason,
    String message,
  ) = WriteListFailure;

  /// {@macro fromApiError}
  factory WriteListResult.fromApiError(ApiError e) {
    if (e.statusCode >= HttpStatus.badRequest &&
        e.statusCode < HttpStatus.internalServerError) {
      return WriteListFailure(FailureReason.badRequest, e.error.plain);
    } else if (e.statusCode >= HttpStatus.internalServerError) {
      return WriteListFailure(FailureReason.serverError, e.error.plain);
    }
    // TODO(craiglabenz): Log `e.errorString`
    return WriteListFailure(
      FailureReason.serverError,
      'Unexpected error: ${e.statusCode} ${e.error.plain}',
    );
  }

  /// Helper to extract expected [WriteListSuccess] objects or throw in the case
  /// of an unexpected [WriteListFailure].
  WriteListSuccess<T> getOrRaise() {
    switch (this) {
      case WriteListSuccess():
        {
          return this as WriteListSuccess<T>;
        }
      case WriteListFailure():
        {
          throw Exception('Unexpected $runtimeType');
        }
    }
  }
}

/////////////////
/// READ RESULTS
/////////////////

/// {@template ReadResult}
/// {@endtemplate}
@Freezed()
sealed class ReadResult<T extends Model> with _$ReadResult<T> {
  /// Container for the results of a single object read that did not encounter
  /// any errors. Note that the requested object may be null, which is not an
  /// error.
  const factory ReadResult.success(
    T? item, {
    required RequestDetails<T> details,
  }) = ReadSuccess;

  /// {@macro RequestFailure}
  const factory ReadResult.failure(
    FailureReason reason,
    String message,
  ) = ReadFailure;

  const ReadResult._();

  /// {@macro fromApiError}
  factory ReadResult.fromApiError(ApiError e) {
    if (e.statusCode >= HttpStatus.badRequest &&
        e.statusCode < HttpStatus.internalServerError) {
      return ReadFailure(FailureReason.badRequest, e.error.plain);
    } else if (e.statusCode >= HttpStatus.internalServerError) {
      return ReadFailure(FailureReason.serverError, e.error.plain);
    }
    // TODO(craiglabenz): Log `e.errorString`
    return ReadFailure(
      FailureReason.serverError,
      'Unexpected error: ${e.statusCode} ${e.error.plain}',
    );
  }

  /// Helper to extract expected [ReadSuccess] objects or throw in the case of
  /// an unexpected [ReadFailure].
  ReadSuccess<T> getOrRaise() {
    switch (this) {
      case ReadSuccess():
        {
          return this as ReadSuccess<T>;
        }
      case ReadFailure():
        {
          throw Exception('Unexpected $runtimeType');
        }
    }
  }
}

/// {@template ReadListResult}
/// {@endtemplate}
@Freezed()
sealed class ReadListResult<T extends Model> with _$ReadListResult<T> {
  /// Container for the results of a list read that did not encounter any
  /// errors. Note that the list of results may be empty, which is not an error.
  const factory ReadListResult({
    required List<T> items,
    required Map<String, T> itemsMap,
    required Set<String> missingItemIds,
    required RequestDetails<T> details,
  }) = ReadListSuccess;

  const ReadListResult._();

  /// Map-friendly constructor.
  factory ReadListResult.fromMap(
    Map<String, T> map,
    RequestDetails<T> details,
    Set<String> missingItemIds,
  ) =>
      ReadListSuccess(
        items: map.values.toList(),
        itemsMap: map,
        missingItemIds: missingItemIds,
        details: details,
      );

  /// List-friendly constructor.
  factory ReadListResult.fromList(
    List<T> items,
    RequestDetails<T> details,
    Set<String> missingItemIds,
  ) {
    final map = <String, T>{};
    for (final item in items) {
      map[item.id!] = item;
    }
    return ReadListSuccess(
      items: items,
      itemsMap: map,
      details: details,
      missingItemIds: missingItemIds,
    );
  }

  /// {@macro RequestFailure}
  const factory ReadListResult.failure(
    FailureReason reason,
    String message,
  ) = ReadListFailure;

  /// {@macro fromApiError}
  factory ReadListResult.fromApiError(ApiError e) {
    if (e.statusCode >= HttpStatus.badRequest &&
        e.statusCode < HttpStatus.internalServerError) {
      return ReadListFailure(FailureReason.badRequest, e.error.plain);
    } else if (e.statusCode >= HttpStatus.internalServerError) {
      return ReadListFailure(FailureReason.serverError, e.error.plain);
    }
    // TODO(craiglabenz): Log `e.errorString`
    return ReadListFailure(
      FailureReason.serverError,
      'Unexpected error: ${e.statusCode} ${e.error.plain}',
    );
  }

  /// Helper to extract expected [ReadListSuccess] objects or throw in the case
  /// of an unexpected [ReadListFailure].
  ReadListSuccess<T> getOrRaise() {
    switch (this) {
      case ReadListSuccess():
        {
          return this as ReadListSuccess<T>;
        }
      case ReadListFailure():
        {
          throw Exception('Unexpected $runtimeType');
        }
    }
  }
}

/// Testing matcher for whether this request was a failure.
const Matcher isFailure = _IsFailure();

class _IsFailure extends Matcher {
  const _IsFailure();
  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is ReadFailure ||
      item is ReadListFailure ||
      item is WriteFailure ||
      item is WriteListFailure;

  @override
  Description describe(Description description) => description.add('is-left');
}

/// Testing matcher for whether this was a success.
const Matcher isRight = _IsSuccess();

class _IsSuccess extends Matcher {
  const _IsSuccess();
  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is ReadSuccess ||
      item is ReadListSuccess ||
      item is WriteSuccess ||
      item is WriteListSuccess;

  @override
  Description describe(Description description) => description.add('is-right');
}
