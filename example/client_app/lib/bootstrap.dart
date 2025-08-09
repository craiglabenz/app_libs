import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:client_app/dependency_injection.dart';
import 'package:client_app/firebase_options.dart';
import 'package:client_auth/client_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

enum Environment { prod, staging, dev }

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
  Environment env,
) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setUpDI(
    apiBaseUrl: switch (env) {
      Environment.dev => '127.0.0.1',
      Environment.staging => '127.0.0.1',
      Environment.prod => '127.0.0.1',
    },
    firebaseAuthService: FirebaseAuthService(fake: true),
  );

  runApp(await builder());
}
