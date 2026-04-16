import 'package:example_client/example_client.dart' show Client;
import 'package:example_flutter/core/auth/auth.dart';
import 'package:example_flutter/core/core.dart';
import 'package:example_flutter/serverpod_client.dart';
import 'package:get_it/get_it.dart';

/// Instantiates and registers all dependencies.
Future<void> setUpDependencyInjection() async {
  GetIt.I.registerSingleton<Client>(await getClient());

  GetIt.I.registerSingleton<AuthService>(
    ServerpodAuthService(GetIt.I<Client>()),
  );
  GetIt.I.registerSingleton<AppRouter>(
    AppRouter(authService: GetIt.I<AuthService>()),
  );
}
