import 'dart:collection';
import 'package:client_auth/client_auth.dart';
import 'package:dartz/dartz.dart';
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
  late AuthenticationRepository authRepo;
  const AuthUser user = AuthUser(
    id: 'asdf',
    apiKey: 'apiKey',
    email: 'user@email.com',
  );
  const String pw = 'pw';

  group('AuthRepository should', () {
    test('successfully create a user on sign up', () async {
      final fbUser = buildFbUser(accountAge: Duration.zero);
      restAuth = FakeRestAuth(
        loginResults: Queue.from(
          <AuthUserOrError>[const Left(AuthenticationError.badEmailPassword())],
        ),
        registerResults: Queue.from(<AuthUserOrError>[const Right(user)]),
      );
      authRepo = AuthenticationRepository(
        streamAuthService: FakeFirebaseAuth()..prepareLogin(fbUser),
        restAuthService: restAuth,
      );
      final AuthUserOrError result = await authRepo.signUp(
        email: user.email!,
        password: pw,
      );
      expect(result, isRight);
      final AuthUser signedUpUser = result.getOrRaise();
      expect(signedUpUser.email, user.email);
      expect(signedUpUser.id, user.id);
      // Did not attempt to login because account is new
      expect(restAuth.loginResults, isNotEmpty);
      expect(restAuth.registerResults, isEmpty);
    });

    test('fail to login a bad password and do not register', () async {
      final fbUser = buildFbUser(accountAge: const Duration(seconds: 10));
      restAuth = FakeRestAuth(
        loginResults: Queue.from(
          <AuthUserOrError>[const Left(AuthenticationError.badEmailPassword())],
        ),
        registerResults: Queue.from(<AuthUserOrError>[const Right(user)]),
      );
      authRepo = AuthenticationRepository(
        streamAuthService: FakeFirebaseAuth()..prepareLogin(fbUser),
        restAuthService: restAuth,
      );
      final AuthUserOrError result = await authRepo.signUp(
        email: user.email!,
        password: pw,
      );
      expect(result, isLeft);
      expect(restAuth.loginResults, isEmpty);
      expect(restAuth.registerResults, isNotEmpty);
    });

    test('successfully logs in a user on EM/PW login', () async {
      final fbUser = buildFbUser(accountAge: const Duration(seconds: 10));
      restAuth = FakeRestAuth(
        loginResults: Queue.from(<AuthUserOrError>[const Right(user)]),
      );
      authRepo = AuthenticationRepository(
        streamAuthService: FakeFirebaseAuth()..prepareLogin(fbUser),
        restAuthService: restAuth,
      );
      final AuthUserOrError result = await authRepo.logInWithEmailAndPassword(
        email: user.email!,
        password: pw,
      );
      expect(result, isRight);
      expect(restAuth.loginResults.isEmpty, true);
    });

    test('successfully creates a user that is new to the app server', () async {
      final newFbUser = buildFbUser(accountAge: Duration.zero);
      restAuth = FakeRestAuth(
        loginResults: Queue.from(
          <AuthUserOrError>[const Left(AuthenticationError.badEmailPassword())],
        ),
        registerResults: Queue.from(<AuthUserOrError>[const Right(user)]),
      );
      authRepo = AuthenticationRepository(
        streamAuthService: FakeFirebaseAuth()..prepareLogin(newFbUser),
        restAuthService: restAuth,
      );
      final AuthUserOrError result = await authRepo.logInWithEmailAndPassword(
        email: user.email!,
        password: pw,
      );
      expect(result, isRight);
      expect(restAuth.loginResults.isEmpty, false);
      expect(restAuth.registerResults.isEmpty, true);
    });

    test('successfully suggests acceptable login forms', () async {
      restAuth = FakeRestAuth();
      authRepo = AuthenticationRepository(
        streamAuthService: FakeFirebaseAuth()
          ..error = const AuthenticationError.wrongMethod(
            <LoginType>{LoginType.google},
          ),
        restAuthService: restAuth,
      );
      final AuthUserOrError result = await authRepo.logInWithEmailAndPassword(
        email: user.email!,
        password: pw,
      );
      expect(result, isLeft);
      final error = result.leftOrRaise();
      expect(error, const WrongMethod(<LoginType>{LoginType.google}));
    });

    test('successfully suggests acceptable login forms on sign up', () async {
      restAuth = FakeRestAuth();
      authRepo = AuthenticationRepository(
        streamAuthService: FakeFirebaseAuth()
          ..error = const AuthenticationError.wrongMethod(
            <LoginType>{LoginType.google},
          ),
        restAuthService: restAuth,
      );
      final AuthUserOrError result = await authRepo.signUp(
        email: user.email!,
        password: pw,
      );
      expect(result, isLeft);
      final error = result.leftOrRaise();
      expect(error, const WrongMethod(<LoginType>{LoginType.google}));
    });
  });
}
