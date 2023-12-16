// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_auth/client_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_data/shared_data.dart';

import 'helpers.dart';

/// Bootstraps a runtime for unit tests.
Future<void> setUpTestingDI({
  RequestDelegate? requestDelegate,
  TargetPlatform? targetPlatform,
}) async {
  await GetIt.I.reset();
  GetIt.I.registerSingleton<BaseStreamAuth>(FakeFirebaseAuth());
  GetIt.I.registerSingleton<BaseRestAuth>(FakeRestAuth());

  GetIt.I.registerSingleton<RequestDelegate>(
    requestDelegate ?? RequestDelegate.fake(),
  );
  if (targetPlatform != null) {
    GetIt.I.registerSingleton<TargetPlatform>(targetPlatform);
  }
  GetIt.I.registerSingleton<AuthenticationRepository>(
    AuthenticationRepository(
      streamAuthService: GetIt.I<BaseStreamAuth>(),
      restAuthService: GetIt.I<BaseRestAuth>(),
    ),
  );
}
