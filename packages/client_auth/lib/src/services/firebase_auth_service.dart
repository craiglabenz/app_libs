import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';
import 'package:shared_data_firebase/shared_data_firebase.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final _log = Logger('client_auth.StreamAuth');

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
class FirebaseAuthService extends StreamAuthService
    with SocialAuthService, AnonymousAuthService {
  /// Default constructor for [FirebaseAuthService].
  FirebaseAuthService({
    Repository<AuthUser>? authUserRepo,
    GetAppleCredentials? getAppleCredentials,
    GoogleSignIn? googleSignIn,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _getAppleCredentials =
            getAppleCredentials ?? SignInWithApple.getAppleIDCredential,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _userUpdatesController = StreamController<AuthUser?>(),
        _authUserRepo = authUserRepo ?? _AuthUserRepo();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final GetAppleCredentials _getAppleCredentials;
  late final Repository<AuthUser> _authUserRepo;

  StreamSubscription<FirebaseUser?>? _firebaseStreamSubscription;

  // Not currently .broadcast() - is that okay? In theory only the outermost
  // auth repository will listen to this.
  final StreamController<AuthUser?> _userUpdatesController;

  @override
  Stream<AuthUser?> get userUpdates => _userUpdatesController.stream;

  AuthUser? _lastUserEmitted;

  final _initializationCompleter = Completer<AuthUser?>();
  bool get _initialized => _initializationCompleter.isCompleted;

  @override
  Future<AuthUser?> initialize() async {
    _log.finest('Initializing FirebaseAuthService');
    _firebaseStreamSubscription ??= _firebaseAuth.authStateChanges().listen(
      (FirebaseUser? firebaseUser) async {
        final AuthUser? newUser = firebaseUser != null
            ? await _syncFirebaseUserWithFirestore(firebaseUser)
            : null;
        _log.fine('New AuthUser from Firebase: $newUser');
        if (!_initialized || newUser?.id != _lastUserEmitted?.id) {
          _lastUserEmitted = newUser;
          _userUpdatesController.sink.add(newUser);
        }
        if (!_initialized) {
          _initializationCompleter.complete(newUser);
        }
      },
    );
    return _initializationCompleter.future;
  }

  @override
  Future<Set<AuthProvider>> getAvailableMethods(String email) async =>
      throw UnimplementedError('Need to pull this info from _authUserRepo');

  @override
  Future<AuthResponse> createAnonymousAccount() async {
    try {
      final userCred = await _firebaseAuth.signInAnonymously();
      if (userCred.user != null) {
        final authUser = await _syncFirebaseUserWithFirestore(
          userCred.user!,
          AuthProvider.anonymous,
        );
        if (authUser != null) {
          return AuthSuccess(authUser);
        } else {
          return const AuthFailure(AuthenticationError.unknownError());
        }
      }
      _log.shout('No error, but null user from createAnonymousAccount');
      return const AuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      return AuthResponse.fromFirebaseException(e);
    }
  }

  @override
  Future<AuthResponse> logInWithApple() async {
    try {
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
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      if (userCred.user != null) {
        final authUser = await _syncFirebaseUserWithFirestore(
          userCred.user!,
          AuthProvider.apple,
        );
        if (authUser != null) {
          return AuthSuccess(authUser);
        } else {
          return const AuthFailure(AuthenticationError.unknownError());
        }
      }
      _log.severe('loginWithApple failed without throwing exception');
      return const AuthFailure(AuthenticationError.unknownError());
      // return const Left(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase exception during logInWithApple: $e');
      return AuthResponse.fromFirebaseException(e);
    } on Exception catch (e) {
      _log.severe('Unexpected logInWithApple Exception: $e');
      return const AuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );
      if (userCred.user != null) {
        final authUser = await _syncFirebaseUserWithFirestore(
          userCred.user!,
          AuthProvider.email,
        );
        if (authUser != null) {
          return AuthSuccess(authUser);
        } else {
          return const AuthFailure(AuthenticationError.unknownError());
        }
      }
      _log.severe(
        'logInWithEmailAndPassword failed without throwing exception',
      );
      return const AuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase exception during logInWithEmailAndPassword: $e');
      return AuthResponse.fromFirebaseException(e);
    } on Exception catch (e) {
      _log.warning('Unexpected logInWithEmailAndPassword Exception: $e');
      return const AuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<AuthResponse> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      if (userCred.user != null) {
        final authUser = await _syncFirebaseUserWithFirestore(
          userCred.user!,
          AuthProvider.google,
        );
        if (authUser != null) {
          return AuthSuccess(authUser);
        } else {
          return const AuthFailure(AuthenticationError.unknownError());
        }
      }
      _log.severe('logInWithGoogle failed without throwing exception');
      return const AuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase exception during logInWithGoogle: $e');
      return AuthResponse.fromFirebaseException(e);
    } on Exception catch (e) {
      _log.warning('Unexpected logInWithGoogle Exception: $e');
      return const AuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password,
      );
      if (userCred.user != null) {
        final authUser = await _syncFirebaseUserWithFirestore(
          userCred.user!,
          AuthProvider.email,
        );
        if (authUser != null) {
          return AuthSuccess(authUser);
        } else {
          return const AuthFailure(AuthenticationError.unknownError());
        }
      }
      _log.severe('signUp failed without throwing exception');
      return const AuthFailure(AuthenticationError.unknownError());
    } on firebase_auth.FirebaseAuthException catch (e) {
      _log.severe('Firebase exception during signUp: $e');
      return AuthResponse.fromFirebaseException(e);
    } on Exception catch (e) {
      _log.severe('Unexpected signUp Exception: $e');
      return const AuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<AuthFailure?> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _log.finer('Successfully logged out');
      return null;
    } on Exception catch (e) {
      _log.severe('Logout exception: $e');
      return const AuthFailure(AuthenticationError.logoutError());
    }
  }

  Future<AuthUser?> _syncFirebaseUserWithFirestore(
    FirebaseUser firebaseUser, [
    AuthProvider? provider,
  ]) async {
    final readResult = await _authUserRepo.getById(
      firebaseUser.uid,
      RequestDetails.read(),
    );
    switch (readResult) {
      case ReadSuccess<AuthUser>():
        {
          bool shouldSave = false;
          var authUser = readResult.itemOrRaise();
          if (authUser == null) {
            if (provider == null) {
              _log.shout(
                'Reached invalid state with no AuthUser in Firestore '
                'and a null authProvider value passed to '
                '_syncFirebaseUserWithFirestore. An AuthUser should have been '
                'created in Firestore when this user first signed up.',
              );
              return null;
            }
            authUser = toAuthUser(firebaseUser, provider, {provider});
            shouldSave = true;
          } else {
            if (provider != null) {
              if (authUser.provider != provider ||
                  !authUser.allProviders.contains(provider)) {
                authUser = authUser.copyWith(provider: provider);
                authUser = authUser.copyWith(
                  allProviders: Set<AuthProvider>.from(authUser.allProviders)
                    ..add(provider),
                );
                shouldSave = true;
              }
            }
          }
          if (shouldSave) {
            final writeResult = await _authUserRepo.setItem(
              authUser,
              RequestDetails.write(),
            );

            switch (writeResult) {
              case WriteSuccess():
                {
                  return writeResult.item;
                }
              case WriteFailure():
                {
                  _log.shout(
                    'Failed to write $authUser to Firestore: $writeResult',
                  );
                  return null;
                }
            }
          } else {
            return authUser;
          }
        }
      case ReadFailure<AuthUser>():
        {
          _log.shout(
            'Failed to sync UserCredential with Firestore: $readResult',
          );
          return null;
        }
    }
  }

  /// Converts a [FirebaseUser] to an application [AuthUser].
  AuthUser toAuthUser(
    FirebaseUser user,
    AuthProvider thisSession,
    Set<AuthProvider> allProviders,
  ) =>
      AuthUser(
        id: user.uid,
        email: user.email,
        createdAt: user.metadata.creationTime!,
        provider: thisSession,
        allProviders: allProviders,
      );

  @override
  void dispose() {
    _firebaseStreamSubscription?.cancel();
    _userUpdatesController.close();
  }

  @override
  Future<AuthResponse> syncAnonymousAccount(AuthSuccess authSuccess) {
    throw UnimplementedError(
      'FirebaseAuthService is not designed to be a secondaryAuth',
    );
  }
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

class _AuthUserRepo extends Repository<AuthUser> {
  _AuthUserRepo()
      : super(
          SourceList<AuthUser>(
            bindings: GetIt.I<Bindings<AuthUser>>(),
            sources: <Source<AuthUser>>[
              LocalMemorySource<AuthUser>(
                bindings: GetIt.I<Bindings<AuthUser>>(),
              ),
              FirestoreSource<AuthUser>(
                db: GetIt.I<FirebaseFirestore>(),
                bindings: GetIt.I<Bindings<AuthUser>>(),
              ),
            ],
          ),
        );
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
