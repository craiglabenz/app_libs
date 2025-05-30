import 'package:bloc/bloc.dart';
import 'package:client_app/app/app.dart';
import 'package:common/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_data/shared_data.dart';

part 'increment_event.dart';
part 'increment_state.dart';

part 'increment_bloc.freezed.dart';
part 'increment_bloc.g.dart';

class IncrementBloc extends Bloc<IncrementEvent, IncrementState> {
  IncrementBloc({
    IncrementRepository? repository,
  })  : repository = repository ?? GetIt.I<IncrementRepository>(),
        super(IncrementState.initial()) {
    on<IncrementEvent>(addIncrement);
  }

  Future<void> addIncrement(
    IncrementEvent event,
    Emitter<IncrementState> emit,
  ) async {
    await repository.setItem(event.incr, RequestDetails.write());
    final result = await repository.getItems(RequestDetails.read());
    if (result.isLeft()) {
      // TODO(craiglabenz): What now?
      print(result.leftOrRaise());
    }
    emit(state.copyWith(log: result.getOrRaise().items));
  }

  final IncrementRepository repository;
}
