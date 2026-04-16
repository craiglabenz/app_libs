import 'package:example_flutter/core/auth/auth_service.dart';
import 'package:example_shared/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

part 'home_bloc.freezed.dart';

typedef _Emit = Emitter<HomeState>;

/// {@template HomeBloc}
/// {@endtemplate}
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// {@macro HomeBloc}
  HomeBloc() : super(HomeState.initial()) {
    on<HomeEvent>(
      (event, _Emit emit) => switch (event) {
        InitializeHome() => _onInitializeHome(event, emit),
        LogOutHome() => _onLogOutHome(event, emit),
      },
    );
  }

  Future<void> _onInitializeHome(InitializeHome event, _Emit emit) async {}

  Future<void> _onLogOutHome(LogOutHome event, _Emit emit) async {
    await GetIt.I<AuthService>().logOut();
  }
}

/// Actions that can be taken on the Home page.
@Freezed()
sealed class HomeEvent with _$HomeEvent {
  /// Placeholder event.
  const factory HomeEvent.init() = InitializeHome;
  const factory HomeEvent.logOut() = LogOutHome;
}

/// {@template HomeState}
/// Complete representation of the Home page's state.
/// {@endtemplate
@Freezed()
sealed class HomeState with _$HomeState {
  /// {@macro HomeState}
  const factory HomeState({
    required AuthSession? session,
  }) = _HomeState;
  const HomeState._();

  /// Starter state fed to the [HomeBloc].
  factory HomeState.initial({AuthSession? session}) =>
      HomeState(session: session ?? GetIt.I<AuthService>().session);
}
