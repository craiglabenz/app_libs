// import 'package:dartz/dartz.dart';
import 'package:shared_data/shared_data.dart';

/// {@template Source}
/// Parent type of all entries in a [SourceList]. Each [Source] subtype should
/// know how to load data from a particular place. The field [sourceType]
/// indicates whether that place is immediately accessible (and thus is a cache)
/// or is remotely accessible and thus is the source of truth.
/// {@endtemplate }
abstract class Source<T extends Model> extends DataContract<T> {
  /// Indicator for whether this [Source] loads data from a store on-device, or
  /// off-device.
  SourceType get sourceType;

  // Either<WriteFailure<T>, WriteSuccess<T>> createdItemOr(T? item) =>
  //     item?.id == null
  //         // ignore: prefer_const_constructors
  //         ? Left(WriteFailure<T>.error('Failed to save item'))
  //         : Right(WriteSuccess<T>(item!));

  // Either<NotFound, FoundItem<T>> itemOr(T? item) {
  //   if (item == null) {
  //     return const Left(notFound);
  //   }
  //   return Right(FoundItem(item));
  // }

  // Either<NotFound, FoundItems<T>> listOr(
  //   List<T>? items,
  //   ReadDetails details, {
  //   Set<String> missingItemIds = const {},
  // }) =>
  //     Right(
  //       FoundItems.fromList(items ?? [],
  //           setName: details.setName, missingItemIds: missingItemIds),
  //     );
  // items == null || items.isEmpty
  //     // ignore: prefer_const_constructors
  //     ? Left(notFound)
  //     : Right(FoundItems.fromList(items,
  //         setName: details.setName, missingItemIds: missingItemIds));

  // Either<NotFound, FoundItems<T>> mapOr(
  //   Map<String, T>? items,
  //   ReadDetails details, {
  //   Set<String> missingItemIds = const {},
  // }) =>
  //     items == null || items.isEmpty
  //         // ignore: prefer_const_constructors
  //         ? Left(notFound)
  //         : Right(FoundItems.fromMap(items,
  //             setName: details.setName, missingItemIds: missingItemIds));

  @override
  String toString() => '$runtimeType()';
}

/// Classifier for a given [Source] instance's primary data location.
enum SourceType {
  /// Indicates a given [Source] retrieves its data from an on-device store.
  local,

  /// Indicates a given [Source] retrieves its data from an off-device store.
  remote;

  /// Accepts a handler for each [SourceType] variant and runs the appropriate
  /// handler for which flavor this instance is.
  T map<T>({
    required T Function(SourceType) local,
    required T Function(SourceType) remote,
  }) {
    return switch (this) {
      SourceType.local => local(this),
      SourceType.remote => remote(this),
    };
  }
}
