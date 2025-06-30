// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client_auth/client_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_data/shared_data.dart';

import 'helpers.dart';

// /// Bootstraps a runtime for unit tests.
Future<void> setUpTestingDI({
  RequestDelegate? requestDelegate,
  TargetPlatform? targetPlatform,
}) async {
  await GetIt.I.reset();
  GetIt.I.registerSingleton<Bindings<AuthUser>>(
    Bindings<AuthUser>(
      fromJson: AuthUser.fromJson,
      getDetailUrl: (String id) => ApiUrl(path: 'authUsers/$id'),
      getListUrl: () => const ApiUrl(path: 'authUsers'),
      toJson: (AuthUser obj) => obj.toJson(),
      getId: (AuthUser obj) => obj.id,
    ),
  );
  GetIt.I.registerSingleton<StreamAuthService>(FakeFirebaseAuth());
  GetIt.I.registerSingleton<AuthService>(FakeRestAuth());

  GetIt.I.registerSingleton<RequestDelegate>(
    requestDelegate ?? RequestDelegate.fake(),
  );
  if (targetPlatform != null) {
    GetIt.I.registerSingleton<TargetPlatform>(targetPlatform);
  }
  GetIt.I.registerSingleton<AuthRepository>(
    AuthRepository(
      GetIt.I<StreamAuthService>(),
      secondaryAuths: [GetIt.I<AuthService>()],
    ),
  );
}
