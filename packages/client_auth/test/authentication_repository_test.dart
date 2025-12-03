import 'package:client_auth/client_auth.dart';
import 'package:data_layer/data_layer.dart' show Readiness;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_data/shared_data.dart';

import 'helpers/helpers.dart';

class MockSyncAuth extends Mock implements SyncAuthService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  group('AuthRepository', () {
    late SyncAuthService syncAuth;
    late AuthRepository authRepository;
    late FakeFirebaseAuth firebaseAuthService;

    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
    });

    setUp(() async {
      // await setUpTestingDI();
      firebaseAuthService = FakeFirebaseAuth();
      syncAuth = MockSyncAuth();
      authRepository = AuthRepository(firebaseAuthService, syncAuth: syncAuth);
    });

    group('createAnonymousAccount', () {
      test('creates a user', () async {
        firebaseAuthService.prepareLogin(socialUser);
        when(() => syncAuth.syncAnonymousAccount(SocialAuthSuccess(socialUser)))
            .thenAnswer((_) async =>
                AuthSuccess(user, isNewUser: true, apiToken: 'api'));
        final result = await authRepository.createAnonymousAccount();
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const SocialAuthFailure(AuthenticationError.unknownError()),
        );
        final result = await authRepository.createAnonymousAccount();
        expect(result, isAuthFailure);
        expect(
          (result as AuthFailure).error,
          const AuthenticationError.unknownError(),
        );
      });
    });

    group('signUp', () {
      test('creates a user', () async {
        firebaseAuthService.prepareLogin(socialUser);
        when(() =>
            syncAuth.syncEmailPasswordAuthentication(
                SocialAuthSuccess(socialUser))).thenAnswer(
            (_) async => AuthSuccess(user, isNewUser: true, apiToken: 'api'));
        final result = await authRepository.signUp(
          email: user.email!,
          password: pw,
        );
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const SocialAuthFailure(AuthenticationError.emailTaken()),
        );
        final result = await authRepository.signUp(
          email: user.email!,
          password: pw,
        );
        expect(result, isAuthFailure);
        expect(
          (result as AuthFailure).error,
          const AuthenticationError.emailTaken(),
        );
      });
    });

    group('logInWithEmailAndPassword', () {
      test('creates a user', () async {
        firebaseAuthService.prepareLogin(socialUser);
        when(
          () =>
              syncAuth.logInWithEmailAndPassword(SocialAuthSuccess(socialUser)),
        ).thenAnswer(
            (_) async => AuthSuccess(user, isNewUser: false, apiToken: 'api'));
        final result = await authRepository.logInWithEmailAndPassword(
          email: user.email!,
          password: pw,
        );
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const SocialAuthFailure(AuthenticationError.badEmailPassword()),
        );
        final result = await authRepository.logInWithEmailAndPassword(
          email: user.email!,
          password: pw,
        );
        expect(result, isAuthFailure);
        expect(
          (result as AuthFailure).error,
          const AuthenticationError.badEmailPassword(),
        );
      });
    });

    group('logInWithApple', () {
      test('creates a user', () async {
        firebaseAuthService.prepareLogin(socialUser);
        when(
          () => syncAuth.syncAppleAuthentication(SocialAuthSuccess(socialUser)),
        ).thenAnswer(
            (_) async => AuthSuccess(user, isNewUser: false, apiToken: 'api'));
        final result = await authRepository.logInWithApple();
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const SocialAuthFailure(AuthenticationError.badEmailPassword()),
        );
        final result = await authRepository.logInWithApple();
        expect(result, isAuthFailure);
        expect(
          (result as AuthFailure).error,
          const AuthenticationError.badEmailPassword(),
        );
      });
    });

    group('logInWithGoogle', () {
      test('creates a user', () async {
        firebaseAuthService.prepareLogin(socialUser);
        when(
          () =>
              syncAuth.syncGoogleAuthentication(SocialAuthSuccess(socialUser)),
        ).thenAnswer(
            (_) async => AuthSuccess(user, isNewUser: false, apiToken: 'api'));
        final result = await authRepository.logInWithGoogle();
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const SocialAuthFailure(AuthenticationError.emailTaken()),
        );
        final result = await authRepository.logInWithGoogle();
        expect(result, isAuthFailure);
        expect(
          (result as AuthFailure).error,
          const AuthenticationError.emailTaken(),
        );
      });
    });

    group('logOut', () {
      test('does nothing without a lastUser', () async {
        when(syncAuth.logOut).thenAnswer((_) async => null);
        expect(authRepository.logOut(), completes);
      });

      test('calls signOut', () async {
        authRepository
          ..lastUser = MockAuthUser()
          ..readiness = Readiness.ready;
        when(() => syncAuth.logOut()).thenAnswer((_) async => null);
        await authRepository.logOut();
        expect(
          firebaseAuthService.getStoredUser(),
          isNull,
        );
      });
    });

    group('userUpdates', () {
      const userId = 'mock-uid';
      const email = 'mock-email';

      late AuthUser user;

      setUp(() {
        user = AuthUser(
          id: userId,
          loggingId: 'abc',
          email: email,
          createdAt: DateTime(2020),
          lastAuthProvider: AuthProvider.email,
          allProviders: {AuthProvider.email},
        );
      });
      test(
        'emits null when firebase user is null',
        () async {
          final authRepo = AuthRepository(
            FakeFirebaseAuth(),
            syncAuth: syncAuth,
          );
          final emitted = <AuthUser?>[];
          final sub = authRepo.listen(emitted.add);
          authRepo.initialize();
          await authRepo.ready;
          expect(emitted, equals([null, null]));
          await sub.cancel();
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );

      test(
        'emits new user when firebase user is not null',
        () async {
          final authRepo = AuthRepository(
            FakeFirebaseAuth()..prepareLogin(socialUser, AuthEvent.emitted),
            syncAuth: syncAuth,
          );
          when(() => syncAuth.verifySocialUserSession(socialUser))
              .thenAnswer((_) async => user);
          final emitted = <AuthUser?>[];
          final sub = authRepo.listen(emitted.add);
          await authRepo.ready;
          expect(emitted, equals([null, user]));
          await sub.cancel();
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );
    });
  });
}
