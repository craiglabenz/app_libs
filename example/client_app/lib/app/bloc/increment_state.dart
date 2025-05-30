part of 'increment_bloc.dart';

/// {@template IncrementState}
///
/// {@endtemplate}
@Freezed()
class IncrementState with _$IncrementState {
  /// {@macro IncrementState}
  const factory IncrementState({required List<Increment> log}) =
      _IncrementState;
  const IncrementState._();

  factory IncrementState.initial() => const IncrementState(log: []);

  /// Hydrates an [IncrementState] instance from serialized JSON.
  factory IncrementState.fromJson(Json json) => _$IncrementStateFromJson(json);

  int get sum => log.fold<int>(0, (prev, el) => prev + el.delta);
}
