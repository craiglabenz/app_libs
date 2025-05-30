import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/shared_data.dart';

part 'increment.freezed.dart';
part 'increment.g.dart';

// abstract class IncrementInterface extends Model {
//   const IncrementInterface._();
//   String? get id => throw UnimplementedError();
//   int get delta => throw UnimplementedError();
//   DateTime get createdAt => throw UnimplementedError();
// }

/// {@template Increment}
/// Historical record of a change to the app's count.
/// {@endtemplate}
@Freezed()
class Increment extends Model with _$Increment {
  /// {@macro Increment}
  const factory Increment({
    required String id,
    required int delta,
    required DateTime createdAt,
  }) = _Increment;

  /// {@macro Increment}
  ///
  /// Companion classed used to create new [Increment] instances.
  const factory Increment.create({
    required int delta,
    required DateTime createdAt,
  }) = IncrementCreate;

  /// {@macro Increment}
  const Increment._();

  /// Hydrates an [Increment] instance from serialized [Json].
  factory Increment.fromJson(Json json) => _$IncrementFromJson(json);

  /// Yields the data [Bindings] for the [Increment] type.
  static Bindings<Increment> get bindings => Bindings<Increment>(
        fromJson: Increment.fromJson,
        getDetailUrl: (String id) => ApiUrl(path: 'increments/$id'),
        getListUrl: () => const ApiUrl(path: 'increments'),
      );
}

/// {@template IncrementConverter}
/// {@endtemplate }
class IncrementConverter implements JsonConverter<Increment, Json> {
  /// {@macro IncrementConverter}
  const IncrementConverter();

  @override
  Increment fromJson(Json json) => Increment.fromJson(json);

  @override
  Json toJson(Increment obj) => obj.toJson();
}

// /// {@template IncrementCompanion}
// /// Writeable version of an [Increment] record.
// /// {@endtemplate}
// @Freezed()
// class IncrementCompanion extends IncrementInterface with _$IncrementCompanion {
//   /// Type of [IncrementCompanion] used to create a new [Increment].
//   const factory IncrementCompanion.create({
//     required int delta,
//     required DateTime createdAt,
//   }) = IncrementCreate;

//   /// Type of [IncrementCompanion] used to delete an existing [Increment].
//   const factory IncrementCompanion.delete({required String id}) =
//       IncrementDelete;

//   const IncrementCompanion._() : super._();

//   /// Hydrates an [IncrementCompanion] instance from serialized [Json].
//   factory IncrementCompanion.fromJson(Json json) =>
//       _$IncrementCompanionFromJson(json);
// }

// /// {@template IncrementCompanionConverter}
// /// {@endtemplate }
// class IncrementCompanionConverter
//     implements JsonConverter<IncrementCompanion, Json> {
//   /// {@macro IncrementCompanionConverter}
//   const IncrementCompanionConverter();

//   @override
//   IncrementCompanion fromJson(Json json) => IncrementCompanion.fromJson(json);

//   @override
//   Json toJson(IncrementCompanion obj) => obj.toJson();
// }
