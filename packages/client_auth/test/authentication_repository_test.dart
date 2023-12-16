// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:collection';
import 'package:client_auth/client_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_data/shared_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'helpers/helpers.dart';

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase_auth.User {
  bool get isNew;
}

class MockUserMetadata extends Mock implements firebase_auth.UserMetadata {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  bool operator ==(dynamic other) => identical(this, other);

  @override
  int get hashCode => 0;
}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockAuthorizationCredentialAppleID extends Mock
    implements AuthorizationCredentialAppleID {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const email = 'test@gmail.com';
  const password = 't0ps3cret42';

  group('AuthenticationRepository', () {
    late firebase_auth.FirebaseAuth firebaseAuth;
    late StreamController<firebase_auth.User?> usersController;
    late GoogleSignIn googleSignIn;
    late AuthenticationRepository authenticationRepository;
    late AuthorizationCredentialAppleID authorizationCredentialAppleID;
    late GetAppleCredentials getAppleCredentials;
    late List<List<AppleIDAuthorizationScopes>> getAppleCredentialsCalls;

    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
    });

    Stream<firebase_auth.User?> getCallback(
      StreamController<firebase_auth.User?> controller,
    ) =>
        controller.stream;

    setUp(() async {
      await setUpTestingDI();
      usersController = StreamController<firebase_auth.User?>();
      firebaseAuth = MockFirebaseAuth();
      when(firebaseAuth.authStateChanges).thenAnswer(
        (_) => getCallback(usersController),
      );
      googleSignIn = MockGoogleSignIn();
      authorizationCredentialAppleID = MockAuthorizationCredentialAppleID();
      getAppleCredentialsCalls = <List<AppleIDAuthorizationScopes>>[];
      getAppleCredentials = ({
        List<AppleIDAuthorizationScopes> scopes = const [],
        WebAuthenticationOptions? webAuthenticationOptions,
        String? nonce,
        String? state,
      }) async {
        getAppleCredentialsCalls.add(scopes);
        return authorizationCredentialAppleID;
      };
      authenticationRepository = AuthenticationRepository(
        streamAuthService: FirebaseAuthService(
          firebaseAuth: firebaseAuth,
          getAppleCredentials: getAppleCredentials,
          googleSignIn: googleSignIn,
        ),
        restAuthService: GetIt.I<BaseRestAuth>(),
      );
    });

    group('logInWithApple', () {
      setUp(() async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(MockUserCredential()));
        when(() => authorizationCredentialAppleID.identityToken).thenReturn('');
        when(() => authorizationCredentialAppleID.authorizationCode)
            .thenReturn('');
        when(
          () => firebaseAuth.fetchSignInMethodsForEmail(any()),
        ).thenAnswer((_) => Future.value(<String>[]));
        await setUpTestingDI();
      });

      test('calls getAppleCredentials with correct scopes', () async {
        await authenticationRepository.logInWithApple();
        expect(getAppleCredentialsCalls, [
          [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ]
        ]);
      });

      test('calls signInWithCredential with correct credential', () async {
        const identityToken = 'identity-token';
        const accessToken = 'access-token';
        when(() => authorizationCredentialAppleID.identityToken)
            .thenReturn(identityToken);
        when(() => authorizationCredentialAppleID.authorizationCode)
            .thenReturn(accessToken);
        await authenticationRepository.logInWithApple();
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('throws LogInWithAppleFailure when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(await authenticationRepository.logInWithApple(), isLeft);
      });
    });

    group('signUp', () {
      setUp(() {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
        when(
          () => firebaseAuth.fetchSignInMethodsForEmail(any()),
        ).thenAnswer((_) => Future.value(<String>[]));
      });

      test('calls createUserWithEmailAndPassword', () async {
        await authenticationRepository.signUp(email: email, password: password);
        verify(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('succeeds when createUserWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.signUp(email: email, password: password),
          completes,
        );
      });

      test(
          'returns AuthenticationError when '
          'createUserWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          await authenticationRepository.signUp(
            email: email,
            password: password,
          ),
          isLeft,
        );
      });
    });

    group('loginWithGoogle', () {
      const accessToken = 'access-token';
      const idToken = 'id-token';

      setUp(() {
        final googleSignInAuthentication = MockGoogleSignInAuthentication();
        final googleSignInAccount = MockGoogleSignInAccount();
        when(() => googleSignInAuthentication.accessToken)
            .thenReturn(accessToken);
        when(() => googleSignInAuthentication.idToken).thenReturn(idToken);
        when(() => googleSignInAccount.authentication)
            .thenAnswer((_) async => googleSignInAuthentication);
        when(() => googleSignIn.signIn())
            .thenAnswer((_) async => googleSignInAccount);
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(MockUserCredential()));
        when(
          () => firebaseAuth.fetchSignInMethodsForEmail(any()),
        ).thenAnswer((_) => Future.value(<String>[]));
      });

      test('calls signIn authentication, and signInWithCredential', () async {
        await authenticationRepository.logInWithGoogle();
        verify(() => googleSignIn.signIn()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('succeeds when signIn succeeds', () {
        expect(authenticationRepository.logInWithGoogle(), completes);
      });

      test('returns an AuthenticationError when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(
          await authenticationRepository.logInWithGoogle(),
          isLeft,
        );
      });
    });

    group('logInWithEmailAndPassword', () {
      setUp(() {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
        // Wrap the email methods
        when(
          () => firebaseAuth.fetchSignInMethodsForEmail(any()),
        ).thenAnswer((_) => Future.value(<String>[]));
      });

      test('calls signInWithEmailAndPassword', () async {
        await authenticationRepository.logInWithEmailAndPassword(
          email: email,
          password: password,
        );
        verify(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('succeeds when signInWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.logInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          completes,
        );
      });

      test(
          'returns an AuthenticationError '
          'when signInWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          await authenticationRepository.logInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          isLeft,
        );
      });
    });

    group('logOut', () {
      test('calls signOut', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        when(() => googleSignIn.signOut())
            .thenAnswer((_) async => Future.value());
        await authenticationRepository.logOut();
        verify(() => firebaseAuth.signOut()).called(1);
        verify(() => googleSignIn.signOut()).called(1);
      });

      test('throws LogOutFailure when signOut throws', () async {
        when(() => firebaseAuth.signOut()).thenThrow(Exception());
        expect(
          await authenticationRepository.logOut(),
          isLeft,
        );
      });
    });

    group('user', () {
      const userId = 'mock-uid';
      const email = 'mock-email';
      const newUser = AuthUser(id: userId, apiKey: 'apiKey', email: email);
      const returningUser = AuthUser(
        id: userId,
        apiKey: 'apiKey',
        email: email,
      );
      test('emits User.anonymous when firebase user is null', () async {
        when(() => firebaseAuth.authStateChanges()).thenAnswer(
          (_) => Stream.value(null),
        );
        final authRepo = AuthenticationRepository(
          streamAuthService: FirebaseAuthService(
            firebaseAuth: firebaseAuth,
            getAppleCredentials: getAppleCredentials,
            googleSignIn: googleSignIn,
          ),
          restAuthService: GetIt.I<BaseRestAuth>(),
        );
        await expectLater(
          authRepo.user,
          emitsInOrder(const <AuthUser>[AuthUser.anonymous]),
        );
      });

      test('emits new user when firebase user is not null', () async {
        final firebaseUser = MockFirebaseUser();
        final userMetadata = MockUserMetadata();
        final creationTime = DateTime(2020);
        when(() => firebaseUser.uid).thenReturn(userId);
        when(() => firebaseUser.email).thenReturn(email);
        when(() => userMetadata.creationTime).thenReturn(creationTime);
        when(() => userMetadata.lastSignInTime).thenReturn(creationTime);
        when(() => firebaseUser.isNew).thenReturn(true);
        when(() => firebaseUser.photoURL).thenReturn(null);
        when(() => firebaseUser.metadata).thenReturn(userMetadata);
        when(() => firebaseAuth.authStateChanges()).thenAnswer(
          (_) => Stream.value(firebaseUser),
        );
        final authRepo = AuthenticationRepository(
          streamAuthService: FirebaseAuthService(
            firebaseAuth: firebaseAuth,
            getAppleCredentials: getAppleCredentials,
            googleSignIn: googleSignIn,
          ),
          restAuthService: FakeRestAuth(
            loginResults: Queue.from(<AuthUserOrError>[
              const Left(AuthenticationError.badEmailPassword()),
            ]),
            registerResults:
                Queue.from(<AuthUserOrError>[const Right(newUser)]),
          ),
        );
        await expectLater(
          authRepo.user,
          emitsInOrder(const <AuthUser>[newUser]),
        );
      });

      test('emits returning user when firebase user is not null', () async {
        final now = DateTime.now().toUtc();
        final returningFirebaseUser = FakeFirebaseUser(
          uid: 'asdf',
          email: 'user@domain.com',
          metadata: firebase_auth.UserMetadata(
            now.subtract(const Duration(minutes: 10)).millisecondsSinceEpoch,
            now.millisecondsSinceEpoch,
          ),
        );
        when(() => firebaseAuth.authStateChanges()).thenAnswer(
          (_) => Stream.value(returningFirebaseUser),
        );
        final authRepo = AuthenticationRepository(
          streamAuthService: FirebaseAuthService(
            firebaseAuth: firebaseAuth,
            getAppleCredentials: getAppleCredentials,
            googleSignIn: googleSignIn,
          ),
          restAuthService: FakeRestAuth(
            loginResults:
                Queue.from(<AuthUserOrError>[const Right(returningUser)]),
          ),
        );
        await expectLater(
          authRepo.user,
          emitsInOrder(const <AuthUser>[returningUser]),
        );
      });
    });
  });
}
