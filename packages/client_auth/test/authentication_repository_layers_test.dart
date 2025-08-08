import 'package:client_auth/client_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_data/shared_data.dart';

import 'helpers/helpers.dart';

class MockSyncAuth extends Mock implements SyncAuthService {}

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
  late AuthRepository authRepo;
  late SyncAuthService syncAuth;
  final AuthUser user = AuthUser(
    id: 'asdf',
    loggingId: 'abc',
    email: 'user@email.com',
    createdAt: DateTime(2025, 1, 1, 12),
    lastAuthProvider: AuthProvider.anonymous,
    allProviders: {AuthProvider.anonymous},
  );
  final SocialUser socialUser = SocialUser(
    id: 'asdf',
    email: 'user@email.com',
    createdAt: DateTime(2025, 1, 1, 12),
    provider: AuthProvider.anonymous,
  );
  const String pw = 'pw';
  registerFallbackValue(
    SocialAuthSuccess(
      socialUser,
      credential:
          const EmailCredential(email: 'user@email.com', password: 'pswrd'),
    ),
  );

  group('AuthRepository should', () {
    setUp(() {
      syncAuth = MockSyncAuth();
    });

    test('successfully create a user on sign up', () async {
      // final fbUser = buildFbUser(accountAge: Duration.zero);
      when(() => syncAuth.signUp(any())).thenAnswer(
          (_) async => AuthSuccess(user, isNewUser: true, apiToken: 'abc'));
      authRepo = AuthRepository(
        FakeFirebaseAuth()..prepareLogin(socialUser),
        syncAuth: syncAuth,
      );
      final AuthResponse result = await authRepo.signUp(
        email: user.email!,
        password: pw,
      );
      expect(result, isAuthSuccess);
      final AuthUser signedUpUser = result.getOrRaise();
      expect(signedUpUser.email, user.email);
      expect(signedUpUser.id, user.id);
    });

    test(
      'fail to login a bad password and do not register',
      () async {
        authRepo = AuthRepository(
          FakeFirebaseAuth()
            ..prepareLoginError(
              const SocialAuthFailure(AuthenticationError.invalidPassword()),
            ),
          syncAuth: syncAuth,
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
      when(() => syncAuth.logInWithEmailAndPassword(any())).thenAnswer(
          (_) async => AuthSuccess(user, isNewUser: false, apiToken: 'abc'));
      authRepo = AuthRepository(
        FakeFirebaseAuth()..prepareLogin(socialUser),
        syncAuth: syncAuth,
      );
      final AuthResponse result = await authRepo.logInWithEmailAndPassword(
        email: user.email!,
        password: pw,
      );
      expect(authRepo.lastUser, isNotNull);
      expect(result, isAuthSuccess);
    });

    // test('successfully creates a user that is new to the app server',
    // () async {

    //   authRepo = AuthRepository(
    //     FakeFirebaseAuth()..prepareLogin(socialUser),
    //     syncAuth: syncAuth,
    //   );
    //   final AuthResponse result = await authRepo.logInWithEmailAndPassword(
    //     email: user.email!,
    //     password: pw,
    //   );
    //   expect(result, isAuthSuccess);
    //   expect(result.getOrRaise(), user);
    // });
  });
}
