import 'dart:collection';
import 'package:client_auth/client_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_data/shared_data.dart';

import 'helpers/helpers.dart';

FirebaseUser buildFbUser({required Duration accountAge}) {
  final now = DateTime.now().toUtc();
  return FakeFirebaseUser(
    uid: 'asdf',
    email: 'user@domain.com',
    metadata: firebase_auth.UserMetadata(
      now.subtract(accountAge).millisecondsSinceEpoch,
      now.millisecondsSinceEpoch,
    ),
  );
}

void main() {
  late FakeRestAuth restAuth;
  late AuthRepository authRepo;
  final AuthUser user = AuthUser(
    id: 'asdf',
    loggingId: 'abc',
    email: 'user@email.com',
    createdAt: DateTime(2025, 1, 1, 12),
    lastAuthProvider: AuthProvider.anonymous,
    allProviders: {AuthProvider.anonymous},
  );
  const String pw = 'pw';

  group('AuthRepository should', () {
    test('successfully create a user on sign up', () async {
      // final fbUser = buildFbUser(accountAge: Duration.zero);
      restAuth = FakeRestAuth(
        loginResults: Queue.from(
          <AuthResponse>[
            const AuthFailure(AuthenticationError.badEmailPassword()),
          ],
        ),
        registerResults: Queue.from(<AuthResponse>[AuthSuccess(user)]),
      );
      authRepo = AuthRepository(
        FakeFirebaseAuth()..prepareLogin(user),
        secondaryAuths: [restAuth],
      );
      final AuthResponse result = await authRepo.signUp(
        email: user.email!,
        password: pw,
      );
      expect(result, isAuthSuccess);
      final AuthUser signedUpUser = result.getOrRaise();
      expect(signedUpUser.email, user.email);
      expect(signedUpUser.id, user.id);
      // Did not attempt to login because account is new
      expect(restAuth.loginResults, isNotEmpty);
      expect(restAuth.registerResults, isEmpty);
    });

    test(
      'fail to login a bad password and do not register',
      () async {
        authRepo = AuthRepository(
          FakeFirebaseAuth()
            ..prepareLoginError(
              const AuthFailure(AuthenticationError.invalidPassword()),
            ),
        );
        await authRepo.initialize();
        final AuthResponse result = await authRepo.logInWithEmailAndPassword(
          email: user.email!,
          password: pw,
        );
        expect(result, isAuthFailure);
        expect(authRepo.lastUser, isNull);
      },
      timeout: const Timeout(Duration(seconds: 1)),
    );

    test('successfully logs in a user on EM/PW login', () async {
      restAuth = FakeRestAuth(
        loginResults: Queue.from(<AuthResponse>[AuthSuccess(user)]),
      );
      authRepo = AuthRepository(
        FakeFirebaseAuth()..prepareLogin(user),
        secondaryAuths: [restAuth],
      );
      final AuthResponse result = await authRepo.logInWithEmailAndPassword(
        email: user.email!,
        password: pw,
      );
      expect(authRepo.lastUser, isNotNull);
      expect(result, isAuthSuccess);
      expect(restAuth.loginResults.isEmpty, true);
    });

    test('successfully creates a user that is new to the app server', () async {
      authRepo = AuthRepository(
        FakeFirebaseAuth()..prepareLogin(user),
      );
      final AuthResponse result = await authRepo.logInWithEmailAndPassword(
        email: user.email!,
        password: pw,
      );
      expect(result, isAuthSuccess);
      expect(result.getOrRaise(), user);
    });

    test('successfully suggests acceptable login forms', () async {
      restAuth = FakeRestAuth();
      authRepo = AuthRepository(
        FakeFirebaseAuth()
          ..error = const AuthFailure(AuthenticationError.wrongMethod(
            <AuthProvider>{AuthProvider.google},
          )),
        secondaryAuths: [restAuth],
      );
      final AuthResponse result = await authRepo.logInWithEmailAndPassword(
        email: user.email!,
        password: pw,
      );
      expect(result, isAuthFailure);
      expect(
        (result as AuthFailure).error,
        const WrongMethod(<AuthProvider>{AuthProvider.google}),
      );
    });

    test('successfully suggests acceptable login forms on sign up', () async {
      restAuth = FakeRestAuth();
      authRepo = AuthRepository(
        FakeFirebaseAuth()
          ..error = const AuthFailure(AuthenticationError.wrongMethod(
            <AuthProvider>{AuthProvider.google},
          )),
        secondaryAuths: [restAuth],
      );
      final AuthResponse result = await authRepo.signUp(
        email: user.email!,
        password: pw,
      );
      expect(result, isAuthFailure);
      expect(
        (result as AuthFailure).error,
        const WrongMethod(<AuthProvider>{AuthProvider.google}),
      );
    });
  });
}
