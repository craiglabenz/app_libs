// import 'dart:async';
import 'package:client_auth/client_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_data/shared_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../helpers/helpers.dart';

const email = 'homer@simpson.com';
const password = 't0ps3cret42';

FirebaseUser authUserToFirebaseUser(AuthUser authUser,
    {DateTime? lastSignInTime}) {
  return FakeFirebaseUser(
    isAnonymous: authUser.isAnonymous,
    uid: authUser.id,
    email: authUser.email,
    metadata: firebase_auth.UserMetadata(
      authUser.createdAt.millisecondsSinceEpoch,
      (lastSignInTime ?? authUser.createdAt).millisecondsSinceEpoch,
    ),
  );
}

void main() {
  group('FirebaseAuthService', () {
    late AuthorizationCredentialAppleID authorizationCredentialAppleID;
    late Repository<AuthUser> authUserRepo;
    late GetAppleCredentials getAppleCredentials;
    late List<List<AppleIDAuthorizationScopes>> getAppleCredentialsCalls;
    late GoogleSignIn googleSignIn;
    late firebase_auth.FirebaseAuth firebaseAuth;
    // late StreamController<firebase_auth.User?> usersController;
    late FirebaseAuthService firebaseAuthService;

    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
    });

    // Stream<firebase_auth.User?> getCallback(
    //   StreamController<firebase_auth.User?> controller,
    // ) =>
    //     controller.stream;

    setUp(() async {
      await setUpTestingDI();
      firebaseAuth = MockFirebaseAuth();

      // usersController = StreamController<firebase_auth.User?>();
      // firebaseAuth = MockFirebaseAuth();
      // when(firebaseAuth.authStateChanges).thenAnswer(
      //   (_) => getCallback(usersController),
      // );

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

      authUserRepo = Repository<AuthUser>(
        SourceList(
          bindings: GetIt.I<Bindings<AuthUser>>(),
          sources: <Source<AuthUser>>[
            LocalMemorySource<AuthUser>(
              bindings: GetIt.I<Bindings<AuthUser>>(),
            ),
          ],
        ),
      );

      firebaseAuthService = FirebaseAuthService(
        firebaseAuth: firebaseAuth,
        getAppleCredentials: getAppleCredentials,
        googleSignIn: googleSignIn,
        authUserRepo: authUserRepo,
        privateIdBuilder: () => 'private-eye',
      );
    });

    group('createAnonymousAccount', () {
      final userCred = MockUserCredential();
      final fbUser = MockFirebaseUser();
      final metadata = MockUserMetadata();

      setUp(() {
        when(firebaseAuth.signInAnonymously).thenAnswer(
          (_) async => userCred,
        );
        when(() => userCred.user).thenReturn(fbUser);
        when(() => fbUser.uid).thenReturn('abc');
        when(() => fbUser.email).thenReturn('');
        when(() => fbUser.metadata).thenReturn(metadata);
        when(() => metadata.creationTime).thenReturn(DateTime(2021));
      });

      test('should return a user', () async {
        final authResponse = await firebaseAuthService.createAnonymousAccount();
        expect(authResponse, isA<AuthSuccess>());
        final authUser = authResponse.getOrRaise();
        expect(authUser.id, 'abc');
        expect(authUser.email, '');
        expect(authUser.createdAt, DateTime(2021));
        expect(authUser.provider, AuthProvider.anonymous);
        expect(authUser.allProviders, {AuthProvider.anonymous});
      });
    });

    group('logInWithApple', () {
      final homerSimpson = AuthUser(
        id: 'abc',
        privateId: 'private-eye',
        email: 'homer@simpson.com',
        createdAt: DateTime(2021).toUtc(),
        provider: AuthProvider.apple,
        allProviders: {AuthProvider.apple},
      );

      setUp(() async {
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(
          authUserToFirebaseUser(homerSimpson),
        );
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(credential));
        when(() => authorizationCredentialAppleID.identityToken).thenReturn('');
        when(() => authorizationCredentialAppleID.authorizationCode)
            .thenReturn('');
      });

      test('calls getAppleCredentials with correct scopes', () async {
        await firebaseAuthService.logInWithApple();
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
        await firebaseAuthService.logInWithApple();
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('throws LogInWithAppleFailure when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(await firebaseAuthService.logInWithApple(), isAuthFailure);
      });

      test('returns a user', () async {
        final response = await firebaseAuthService.logInWithApple();
        expect(response, isAuthSuccess);
        expect(response.getOrRaise(), equals(homerSimpson));
      });
    });

    group('signUp', () {
      final homerSimpson = AuthUser(
        id: 'abc',
        privateId: 'private-eye',
        email: 'homer@simpson.com',
        createdAt: DateTime(2021).toUtc(),
        provider: AuthProvider.email,
        allProviders: {AuthProvider.email},
      );

      setUp(() {
        final firebaseUser = authUserToFirebaseUser(homerSimpson);
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(firebaseUser);
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(credential));
      });

      test('calls createUserWithEmailAndPassword', () async {
        await firebaseAuthService.signUp(email: email, password: password);
        verify(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('calls returns a user', () async {
        final response = await firebaseAuthService.signUp(
          email: email,
          password: password,
        );
        expect(response, isAuthSuccess);
        expect(response.getOrRaise(), equals(homerSimpson));
      });

      test('succeeds when createUserWithEmailAndPassword succeeds', () async {
        expect(
          firebaseAuthService.signUp(email: email, password: password),
          completes,
        );
      });

      test(
          'returns AuthFailure when '
          'createUserWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          await firebaseAuthService.signUp(email: email, password: password),
          isAuthFailure,
        );
      });
    });
    group('loginWithGoogle', () {
      const accessToken = 'access-token';
      const idToken = 'id-token';

      final homerSimpson = AuthUser(
        id: 'abc',
        privateId: 'private-eye',
        email: 'homer@simpson.com',
        createdAt: DateTime(2021).toUtc(),
        provider: AuthProvider.google,
        allProviders: {AuthProvider.google},
      );

      setUp(() {
        final googleSignInAuthentication = MockGoogleSignInAuthentication();
        final googleSignInAccount = MockGoogleSignInAccount();
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(
          authUserToFirebaseUser(homerSimpson),
        );
        when(() => googleSignInAuthentication.accessToken)
            .thenReturn(accessToken);
        when(() => googleSignInAuthentication.idToken).thenReturn(idToken);
        when(() => googleSignInAccount.authentication)
            .thenAnswer((_) async => googleSignInAuthentication);
        when(() => googleSignIn.signIn())
            .thenAnswer((_) async => googleSignInAccount);
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenAnswer((_) => Future.value(credential));
      });

      test('calls signIn authentication, and signInWithCredential', () async {
        await firebaseAuthService.logInWithGoogle();
        verify(() => googleSignIn.signIn()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('returns a user', () async {
        final response = await firebaseAuthService.logInWithGoogle();
        expect(response, isAuthSuccess);
        expect(response.getOrRaise(), equals(homerSimpson));
      });

      test('succeeds when signIn succeeds', () {
        expect(firebaseAuthService.logInWithGoogle(), completes);
      });

      test('returns an AuthenticationError when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any()))
            .thenThrow(Exception());
        expect(await firebaseAuthService.logInWithGoogle(), isAuthFailure);
      });
    });

    group('logInWithEmailAndPassword', () {
      final homerSimpson = AuthUser(
        id: 'abc',
        privateId: 'private-eye',
        email: 'homer@simpson.com',
        createdAt: DateTime(2021).toUtc(),
        provider: AuthProvider.email,
        allProviders: {AuthProvider.email},
      );

      setUp(() {
        final firebaseUser = authUserToFirebaseUser(homerSimpson);
        final credential = MockUserCredential();
        when(() => credential.user).thenReturn(firebaseUser);
        when(
          () => firebaseAuth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(credential));
      });

      test('calls signInWithEmailAndPassword', () async {
        await firebaseAuthService.logInWithEmailAndPassword(
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
          firebaseAuthService.logInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          completes,
        );
      });

      test('returns a user', () async {
        final response = await firebaseAuthService.logInWithEmailAndPassword(
          email: email,
          password: password,
        );
        expect(response, isAuthSuccess);
        expect(response.getOrRaise(), equals(homerSimpson));
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
          await firebaseAuthService.logInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          isAuthFailure,
        );
      });
    });

    group('logOut', () {
      test('calls signOut', () async {
        when(() => firebaseAuth.signOut()).thenAnswer((_) async {});
        when(() => googleSignIn.signOut())
            .thenAnswer((_) async => Future.value());
        await firebaseAuthService.logOut();
        verify(() => firebaseAuth.signOut()).called(1);
        verify(() => googleSignIn.signOut()).called(1);
      });

      test('throws LogOutFailure when signOut throws', () async {
        when(() => firebaseAuth.signOut()).thenThrow(Exception());
        expect(
          await firebaseAuthService.logOut(),
          isAuthFailure,
        );
      });
    });
  });
}
