import 'dart:async';
import 'dart:math';

import 'package:client_auth/client_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final _log = Logger('client_auth.FirebaseAuthService');

/// Alias for Firebase's [firebase_auth.User] class.
typedef FirebaseUser = firebase_auth.User;

/// Signature for [SignInWithApple.getAppleIDCredential].
typedef GetAppleCredentials = Future<AuthorizationCredentialAppleID> Function({
  required List<AppleIDAuthorizationScopes> scopes,
  WebAuthenticationOptions webAuthenticationOptions,
  String nonce,
  String state,
});

/// Executes real session actions with Firebase.
class FirebaseAuthService extends StreamSocialAuthService {
  /// Default constructor for [FirebaseAuthService].
  FirebaseAuthService({
    GetAppleCredentials? getAppleCredentials,
    GoogleSignIn? googleSignIn,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _getAppleCredentials =
            getAppleCredentials ?? SignInWithApple.getAppleIDCredential,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _auth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _userUpdatesController = StreamController<SocialUser?>();

  final firebase_auth.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final GetAppleCredentials _getAppleCredentials;

  StreamSubscription<FirebaseUser?>? _firebaseStreamSubscription;

  // Not currently .broadcast() - is that okay? In theory only the outermost
  // auth repository will listen to this.
  final StreamController<SocialUser?> _userUpdatesController;

  SocialUser? _lastUserEmitted;

  /// Set to true before calling a Firebase auth function and set back to false
  /// after completing _syncFirebaseUserWithDatabase.
  ///
  /// The purpose of this method is to throw away users emitted by
  /// _firebaseAuth.authStateChanges(), which fires before auth methods return.
  bool _isAuthorizing = false;

  @override
  Future<SocialUser?> performInitialization() async {
    _log.finest('Initializing FirebaseAuthService');
    _firebaseStreamSubscription ??= _auth.authStateChanges().listen(
      (FirebaseUser? firebaseUser) async {
        if (_isAuthorizing) return;
        final SocialUser? newUser =
            firebaseUser != null ? toSocialUser(firebaseUser) : null;
        _log.finest(
          'New FirebaseUser from Firebase: $firebaseUser :: $newUser',
        );
        _emitUser(newUser);
      },
    );
    // FAKE: to force a session when eal FirebaseAuth is turned off
    // _emitUser(
    //   SocialUser(
    //     id: 'abc',
    //     email: 'craig.labenz@gmail.com',
    //     createdAt: DateTime.now(),
    //   ),
    // );
    return ready;
  }

  void _emitUser(SocialUser? user) {
    if (isNotResolved || user?.id != _lastUserEmitted?.id) {
      _lastUserEmitted = user;
      _userUpdatesController.sink.add(user);
    }
    if (isNotResolved) {
      markReady(user);
    }
  }

  @override
  StreamSubscription<SocialUser?> listen(void Function(SocialUser?) cb) {
    final sub = _userUpdatesController.stream.listen(cb);
    if (_lastUserEmitted != null) {
      cb(_lastUserEmitted);
    }
    return sub;
  }

  @override
  Future<SocialAuthResponse> createAnonymousAccount() async {
    try {
      _isAuthorizing = true;
      final userCred = await _auth.signInAnonymously();
      if (userCred.user != null) {
        final authUser = toSocialUser(
          userCred.user!,
          AuthProvider.anonymous,
        );
        _isAuthorizing = false;
        _emitUser(authUser);
        return SocialAuthSuccess(authUser);
      }
      _log.shout('No error, but null user from createAnonymousAccount');
      return const SocialAuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return SocialAuthResponse.fromFirebaseException(e);
    }
  }

  @override
  Future<SocialAuthResponse> logInWithApple() async {
    try {
      _isAuthorizing = true;
      final appleIdCredential = await _getAppleCredentials(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = firebase_auth.OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      final userCred = await ((_auth.currentUser != null)
          ? _auth.currentUser!.linkWithCredential(credential)
          : _auth.signInWithCredential(credential));

      _isAuthorizing = false;
      if (userCred.user != null) {
        final socialUser = toSocialUser(
          userCred.user!,
          AuthProvider.apple,
        );
        _emitUser(socialUser);
        return SocialAuthSuccess(
          socialUser,
          credential: AppleCredential(
            userIdentifier: appleIdCredential.userIdentifier,
            email: appleIdCredential.email ??
                userCred.additionalUserInfo?.profile?['email'] as String?,
            givenName: appleIdCredential.givenName ??
                userCred.additionalUserInfo?.username,
            familyName: appleIdCredential.familyName,
            identityToken: appleIdCredential.identityToken,
            authorizationCode: appleIdCredential.authorizationCode,
            state: appleIdCredential.state,
          ),
        );
      }
      _log.severe('loginWithApple failed without throwing exception');
      return const SocialAuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase exception during logInWithApple: $e');
      return SocialAuthResponse.fromFirebaseException(e);
    } on Exception catch (e) {
      _log.severe('Unexpected logInWithApple Exception: $e');
      return const SocialAuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<SocialAuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // return SocialAuthSuccess(
      //   SocialUser(
      //     id: 'abc',
      //     email: email,
      //     createdAt: DateTime.now(),
      //   ),
      //   credential: EmailCredential(email: email, password: password),
      // );
      _isAuthorizing = true;
      final cleanEmail = email.toLowerCase().trim();

      if (_auth.currentUser != null && _auth.currentUser!.isAnonymous) {
        throw Exception(
          'Should not call logIn for anonymous user - call signUp instead.',
        );
      }

      final userCred = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      if (userCred.user != null) {
        final authUser = toSocialUser(
          userCred.user!,
          AuthProvider.email,
        );
        _isAuthorizing = false;
        _emitUser(authUser);
        return SocialAuthSuccess(
          authUser,
          credential: EmailCredential(email: cleanEmail, password: password),
        );
      }
      _log.severe(
        'logInWithEmailAndPassword failed without throwing exception',
      );
      return const SocialAuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase exception during logInWithEmailAndPassword: $e');
      return SocialAuthResponse.fromFirebaseException(
        e,
        const AuthenticationError.badEmailPassword(),
      );
    } on Exception catch (e) {
      _log.warning('Unexpected logInWithEmailAndPassword Exception: $e');
      return const SocialAuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<SocialAuthResponse> logInWithGoogle() async {
    try {
      _isAuthorizing = true;
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return const SocialAuthFailure(
          AuthenticationError.cancelledSocialAuth(),
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await ((_auth.currentUser != null)
          ? _auth.currentUser!.linkWithCredential(credential)
          : _auth.signInWithCredential(credential));

      _isAuthorizing = false;
      if (userCred.user != null) {
        final socialUser = toSocialUser(
          userCred.user!,
          AuthProvider.google,
        );
        _emitUser(socialUser);
        return SocialAuthSuccess(
          socialUser,
          credential: GoogleCredential(
            displayName: googleUser.displayName,
            email: googleUser.email,
            uniqueId: googleUser.id,
            photoUrl: googleUser.photoUrl,
            idToken: googleAuth.idToken,
            serverAuthCode: googleUser.serverAuthCode,
          ),
        );
      }
      _log.severe('logInWithGoogle failed without throwing exception');
      return const SocialAuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase exception during logInWithGoogle: $e');
      return SocialAuthResponse.fromFirebaseException(e);
    } on Exception catch (e) {
      _log.warning('Unexpected logInWithGoogle Exception: $e');
      return const SocialAuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<SocialAuthResponse> signUp({
    required String email,
    required String password,
  }) async =>
      _signUpWithCleanEmail(
        email: email.toLowerCase().trim(),
        password: password,
      );

  Future<SocialAuthResponse> _signUpWithCleanEmail({
    required String email,
    required String password,
  }) async {
    try {
      // return SocialAuthSuccess(
      //   SocialUser(
      //     id: 'abc',
      //     email: email,
      //     createdAt: DateTime.now(),
      //   ),
      //   credential: EmailCredential(email: email, password: password),
      // );
      _isAuthorizing = true;

      late final firebase_auth.UserCredential userCred;

      if (_auth.currentUser != null) {
        final authCred = firebase_auth.EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        userCred = await _auth.currentUser!.linkWithCredential(authCred);
      } else {
        userCred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      _isAuthorizing = false;
      if (userCred.user != null) {
        final socialUser = toSocialUser(
          userCred.user!,
          AuthProvider.email,
        );
        _emitUser(socialUser);
        return SocialAuthSuccess(
          socialUser,
          credential: EmailCredential(email: email, password: password),
        );
      }
      _log.severe('signUp failed without throwing exception');
      return const SocialAuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase exception during signUp: $e');
      return SocialAuthResponse.fromFirebaseException(e);
    } on Exception catch (e) {
      _log.severe('Unexpected signUp Exception: $e');
      return const SocialAuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<SocialAuthFailure?> logOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _log.finer('Successfully logged out');
      return null;
    } on Exception catch (e) {
      _log.severe('Logout exception: $e');
      return const SocialAuthFailure(AuthenticationError.logoutError());
    }
  }

  // Future<AuthUser?> _syncFirebaseUserWithDatabase(
  //   FirebaseUser firebaseUser, {
  //   AuthProvider? provider,

  //   /// If the user authenticated from an [AuthProvider] which is associated
  //   /// with a [SocialCredential], that should be passed here to be saved
  //   SocialCredential? credential,

  //   /// If the user was preloaded for account state checks, provide the object
  //   /// here to prevent a duplicate read
  //   AuthUser? user,

  //   /// If the user was both preloaded and had modifications made to it (because
  //   /// a new auth method yielded new information, for example), then this can
  //   /// be passed in to guarantee a save
  //   bool mustSave = false,
  // }) async {
  //   assert(
  //     !mustSave || user != null,
  //     'Can only pass mustSave=true when user is not null',
  //   );

  //   AuthUser? loadedUser = user ??
  //       await _loadUserWithExpectations(
  //         firebaseUser.uid,
  //         '_syncFirebaseUserWithDatabase',
  //         exists: null,
  //       );

  //   bool shouldSave = false;
  //   if (loadedUser == null) {
  //     if (provider == null) {
  //       _log.shout(
  //         'Reached invalid state with no AuthUser in Firestore '
  //         'and a null authProvider value passed to '
  //         '_syncFirebaseUserWithDatabase. An AuthUser should have been '
  //         'created in Firestore when this account was first created.',
  //       );
  //       await logOut();
  //       return null;
  //     }
  //     // Write the new AuthUser record to Firestore
  //     loadedUser = toAuthUser(firebaseUser, provider);
  //     shouldSave = true;
  //   } else {
  //     if (provider != null) {
  //       if (loadedUser.lastAuthProvider != provider ||
  //           !loadedUser.allProviders.contains(provider)) {
  //         loadedUser = loadedUser.copyWith(lastAuthProvider: provider);
  //         loadedUser = loadedUser.copyWith(
  //           allProviders: Set<AuthProvider>.from(loadedUser.allProviders)
  //             ..add(provider),
  //         );
  //         shouldSave = true;
  //       }
  //     }
  //   }
  //   if (shouldSave) {
  //     final savedUser = await _authUserRepo.setItem(
  //       loadedUser,
  //       RequestDetails.write(),
  //     );

  //     if (savedUser != null && credential != null) {
  //       await _credentialRepo.setItem(credential);
  //     }
  //     return savedUser;
  //   } else {
  //     return loadedUser;
  //   }
  // }

  /// Converts a [FirebaseUser] to an application [SocialUser].
  SocialUser toSocialUser(
    FirebaseUser user, [
    AuthProvider? provider,
  ]) =>
      SocialUser(
        id: user.uid,
        email: user.email,
        createdAt: user.metadata.creationTime!,
        provider: provider,
      );

  @override
  void dispose() {
    _firebaseStreamSubscription?.cancel();
    _userUpdatesController.close();
  }

  @override
  String toString() => 'FirebaseAuthService';
}

/// Converts provider names into [AuthProvider] enums.
Set<AuthProvider> loginTypesFromStrings(List<String> methods) {
  return methods
      .map<AuthProvider?>((method) {
        final authProvider = AuthProvider.values.asNameMap()[method];
        if (authProvider == null) {
          _log.shout('Invalid Firebase auth method: $method');
        }
        return authProvider;
      })
      .where((AuthProvider? authProvider) => authProvider != null)
      .cast<AuthProvider>()
      .toSet();
}

/// Adds the boolean [isNew] getter to [FirebaseUser].
extension NewAwareFirebaseUser on FirebaseUser {
  /// Returns true if the FirebaseUser has just signed in for the first time as
  /// indicated by their metadata `creationTime` and `lastSignInTime`.
  bool get isNew =>
      metadata.creationTime == null ||
      metadata.lastSignInTime == null ||
      (metadata.lastSignInTime!.difference(metadata.creationTime!)) <
          const Duration(seconds: 5);
}
