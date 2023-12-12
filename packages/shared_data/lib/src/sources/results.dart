import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/shared_data.dart';

part 'results.freezed.dart';

//////////////////
/// WRITE RESULTS
//////////////////

/// {@template WriteSuccess}
/// Container for a single object write request which did not encounter any
/// errors.
/// {@endtemplate}
@Freezed()
class WriteSuccess<T extends Model> with _$WriteSuccess<T> {
  /// {@macro WriteSuccess}
  const factory WriteSuccess(T item, {required RequestDetails<T> details}) =
      _WriteSuccess;
}

/// {@template BulkWriteSuccess}
/// Container for a list write request which did not encounter any errors.
/// {@endtemplate}
@Freezed()
class BulkWriteSuccess<T extends Model> with _$BulkWriteSuccess<T> {
  /// {@macro BulkWriteSuccess}
  const factory BulkWriteSuccess(
    List<T> items, {
    required RequestDetails<T> details,
  }) = _BulkWriteSuccess;
}

/// Note that the result set may be empty, which is not an error.

/// {@template WriteFailure}
/// Represents a failure with the write, resulting from either an unexpected
/// problem on the server or the server rejecting the client's request.
/// The `message` property should be suitable for showing the user.
///
/// This class is used for errors that occurred on either a detail write or a
/// bulk write.
/// {@endtemplate}
@Freezed()
class WriteFailure<T extends Model> with _$WriteFailure<T> {
  const WriteFailure._();

  /// Container for a write request that failed to a problem on the server.
  const factory WriteFailure.serverError(String message) = _WriteServerError;

  /// Container for a write request that failed to a problem with the request.
  const factory WriteFailure.badRequest(String message) = _WriteClientError;

  /// Constructor which turns an [ApiError] instance into the appropriate flavor
  /// of [WriteFailure].
  factory WriteFailure.fromApiError(ApiError e) {
    if (e.statusCode >= HttpStatus.badRequest &&
        e.statusCode < HttpStatus.internalServerError) {
      return WriteFailure.badRequest(e.error.plain);
    } else if (e.statusCode >= HttpStatus.internalServerError) {
      return WriteFailure.serverError(e.error.plain);
    }
    // TODO(craiglabenz): Log `e.errorString`
    return WriteFailure.serverError(
      'Unexpected error: ${e.statusCode} ${e.error.plain}',
    );
  }
}

/// Either a [WriteFailure] or a [WriteSuccess].
typedef WriteResult<T extends Model> = Either<WriteFailure<T>, WriteSuccess<T>>;

/// Either a [WriteFailure] or a [BulkWriteSuccess].
typedef WriteListResult<T extends Model> = //
    Either<WriteFailure<T>, BulkWriteSuccess<T>>;

/////////////////
/// READ RESULTS
/////////////////

/// {@template ReadSuccess}
/// Container for the results of a single object read that did not encounter any
/// errors. Note that the requested object may be null, which is not an error.
/// {@endtemplate}
@Freezed()
class ReadSuccess<T extends Model> with _$ReadSuccess<T> {
  /// {@macro ReadSuccess}
  const factory ReadSuccess(
    T? item, {
    required RequestDetails<T> details,
  }) = _ReadSuccess;
}

/// {@template ReadSuccess}
/// Container for the results of a list read that did not encounter any errors.
/// Note that the list of results may be empty, which is not an error.
/// {@endtemplate}
@Freezed()
class ReadListSuccess<T extends Model> with _$ReadListSuccess<T> {
  /// {@macro ReadSuccess}
  const factory ReadListSuccess({
    required List<T> items,
    required Map<String, T> itemsMap,
    required Set<String> missingItemIds,
    required RequestDetails<T> details,
  }) = _ReadListSuccess;
  const ReadListSuccess._();

  /// Map-friendly constructor.
  factory ReadListSuccess.fromMap(
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
  factory ReadListSuccess.fromList(
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
}

/// Represents a failure with the read, resulting from either an unexpected
/// problem on the server or the server rejecting the client's request.
/// The `message` property should be suitable for showing the user.
///
/// This class is used for errors that occurred on either a detail read or a
/// list read.
@Freezed()
class ReadFailure<T> with _$ReadFailure<T> {
  /// Container for a write request that failed to a problem on the server.
  const factory ReadFailure.serverError(String message) = _ReadServerError;

  /// Container for a write request that failed to a problem with the request.
  const factory ReadFailure.badRequest(String message) = _ReadClientError;

  /// Constructor which turns an [ApiError] instance into the appropriate flavor
  /// of [ReadFailure].
  factory ReadFailure.fromApiError(ApiError e) {
    if (e.statusCode >= HttpStatus.badRequest &&
        e.statusCode < HttpStatus.internalServerError) {
      return ReadFailure.badRequest(e.error.plain);
    } else if (e.statusCode >= HttpStatus.internalServerError) {
      return ReadFailure.serverError(e.error.plain);
    }
    // TODO(craiglabenz): Log `e.errorString`
    return ReadFailure.serverError(
      'Unexpected error: ${e.statusCode} ${e.error.plain}',
    );
  }
}

/// Either a [ReadFailure] or a [ReadSuccess].
typedef ReadResult<T extends Model> = Either<ReadFailure<T>, ReadSuccess<T>>;

/// Either a [ReadFailure] or a [ReadListSuccess].
typedef ReadListResult<T extends Model> = //
    Either<ReadFailure<T>, ReadListSuccess<T>>;
