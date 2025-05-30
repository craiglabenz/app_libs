part of 'increment_bloc.dart';

/// {@template IncrementEvent}
///
/// {@endtemplate}
@Freezed()
class IncrementEvent with _$IncrementEvent {
  /// {@macro IncrementEvent}
  const factory IncrementEvent(
    @IncrementConverter() IncrementCreate incr,
  ) = _IncrementEvent;
  const IncrementEvent._();

  factory IncrementEvent.fromJson(Json json) => _$IncrementEventFromJson(json);
}
