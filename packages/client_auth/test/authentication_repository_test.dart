import 'package:client_auth/client_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_data/shared_data.dart';

import 'helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final AuthUser user = AuthUser(
    id: 'asdf',
    privateId: 'abc',
    email: 'user@email.com',
    createdAt: DateTime(2025, 1, 1, 12),
    provider: AuthProvider.anonymous,
    allProviders: {AuthProvider.anonymous},
  );
  const String pw = 'pw';

  group('AuthRepository', () {
    late AuthRepository authRepository;
    late FakeFirebaseAuth firebaseAuthService;

    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
    });

    setUp(() async {
      await setUpTestingDI();
      firebaseAuthService = FakeFirebaseAuth();
      authRepository = AuthRepository(firebaseAuthService);
    });

    group('createAnonymousAccount', () {
      test('creates a user', () async {
        firebaseAuthService.prepareLogin(user);
        final result = await authRepository.createAnonymousAccount();
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const AuthFailure(AuthenticationError.unknownError()),
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
        firebaseAuthService.prepareLogin(user);
        final result = await authRepository.signUp(
          email: user.email!,
          password: pw,
        );
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const AuthFailure(AuthenticationError.emailTaken()),
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
        firebaseAuthService.prepareLogin(user);
        final result = await authRepository.logInWithEmailAndPassword(
          email: user.email!,
          password: pw,
        );
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const AuthFailure(AuthenticationError.badEmailPassword()),
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
        firebaseAuthService.prepareLogin(user);
        final result = await authRepository.logInWithApple();
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const AuthFailure(AuthenticationError.badEmailPassword()),
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
        firebaseAuthService.prepareLogin(user);
        final result = await authRepository.logInWithGoogle();
        expect(result, isAuthSuccess);
        expect(result.getOrRaise(), user);
      });

      test('returns a failure', () async {
        firebaseAuthService.prepareLoginError(
          const AuthFailure(AuthenticationError.emailTaken()),
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
        expect(authRepository.logOut(), completes);
      });

      test('calls signOut', () async {
        authRepository.lastUser = MockAuthUser();
        await authRepository.logOut();
        expect(
          (authRepository.primaryAuth as FakeFirebaseAuth).getStoredUser(),
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
          privateId: 'abc',
          email: email,
          provider: AuthProvider.email,
          createdAt: DateTime(2020),
          allProviders: {AuthProvider.email},
        );
      });
      test(
        'emits null when firebase user is null',
        () async {
          final authRepo = AuthRepository(
            FakeFirebaseAuth(),
          );
          final emitted = <AuthUser?>[];
          final sub = authRepo.listen(emitted.add);
          await authRepo.initialize();
          expect(emitted, equals([null]));
          await sub.cancel();
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );

      test(
        'emits new user when firebase user is not null',
        () async {
          final authRepo = AuthRepository(
            FakeFirebaseAuth()..prepareLogin(user),
          );
          final emitted = <AuthUser?>[];
          final sub = authRepo.listen(emitted.add);
          await authRepo.initialize();
          expect(emitted, equals([user]));
          await sub.cancel();
        },
        timeout: const Timeout(Duration(seconds: 1)),
      );
    });
  });
}
