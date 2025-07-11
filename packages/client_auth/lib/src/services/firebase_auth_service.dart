import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

final _log = Logger('client_auth.FirebaseAuthService');

/// Alias for Firebase's [firebase_auth.User] class.
typedef FirebaseUser = firebase_auth.User;

/// Yields `privateId` values for new [AuthUser] records.
typedef PrivateIdBuilder = String Function();

const _uuid = Uuid();

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
    required Repository<AuthUser> authUserRepo,
    required Repository<SocialCredential> credentialRepo,
    GetAppleCredentials? getAppleCredentials,
    GoogleSignIn? googleSignIn,
    firebase_auth.FirebaseAuth? firebaseAuth,
    PrivateIdBuilder? privateIdBuilder,
  })  : _getAppleCredentials =
            getAppleCredentials ?? SignInWithApple.getAppleIDCredential,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _auth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _userUpdatesController = StreamController<AuthUser?>(),
        _authUserRepo = authUserRepo,
        _credentialRepo = credentialRepo,
        _privateIdBuilder = privateIdBuilder ?? _uuidV7;

  final firebase_auth.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final GetAppleCredentials _getAppleCredentials;
  final PrivateIdBuilder _privateIdBuilder;
  late final Repository<AuthUser> _authUserRepo;
  late final Repository<SocialCredential> _credentialRepo;

  StreamSubscription<FirebaseUser?>? _firebaseStreamSubscription;

  // Not currently .broadcast() - is that okay? In theory only the outermost
  // auth repository will listen to this.
  final StreamController<AuthUser?> _userUpdatesController;

  AuthUser? _lastUserEmitted;

  /// Set to true before calling a Firebase auth function and set back to false
  /// after completing _syncFirebaseUserWithDatabase.
  ///
  /// The purpose of this method is to throw away users emitted by
  /// _firebaseAuth.authStateChanges(), which fires before auth methods return.
  bool _isAuthorizing = false;

  @override
  Future<AuthUser?> performInitialization() async {
    _log.finest('Initializing FirebaseAuthService');
    _firebaseStreamSubscription ??= _auth.authStateChanges().listen(
      (FirebaseUser? firebaseUser) async {
        if (_isAuthorizing) return;
        _log.finest('New FirebaseUser from Firebase: $firebaseUser');
        final AuthUser? newUser = firebaseUser != null
            ? await _syncFirebaseUserWithDatabase(firebaseUser)
            : null;
        if (firebaseUser != null || newUser != null) {
          _log.finest('New AuthUser from database: $newUser');
        }
        _emitUser(newUser);
      },
    );
    return ready;
  }

  void _emitUser(AuthUser? user) {
    if (isNotResolved || user?.id != _lastUserEmitted?.id) {
      _lastUserEmitted = user;
      _userUpdatesController.sink.add(user);
    }
    if (isNotResolved) {
      markReady(user);
    }
  }

  @override
  StreamSubscription<AuthUser?> listen(void Function(AuthUser?) cb) {
    final sub = _userUpdatesController.stream.listen(cb);
    if (_lastUserEmitted != null) {
      cb(_lastUserEmitted);
    }
    return sub;
  }

  @override
  Future<Set<AuthProvider>> getAvailableMethods(String email) async =>
      throw UnimplementedError('Need to pull this info from _authUserRepo');

  @override
  Future<AuthResponse> createAnonymousAccount() async {
    try {
      _isAuthorizing = true;
      final userCred = await _auth.signInAnonymously();
      if (userCred.user != null) {
        final authUser = await _syncFirebaseUserWithDatabase(
          userCred.user!,
          provider: AuthProvider.anonymous,
        );
        _isAuthorizing = false;
        if (authUser != null) {
          _emitUser(authUser);
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
        final authUser = await _syncFirebaseUserWithDatabase(
          userCred.user!,
          credentialBuilder: (String userId) => AppleCredential(
            userId: userId,
            userIdentifier: appleIdCredential.userIdentifier ?? userId,
            email: appleIdCredential.email ??
                userCred.additionalUserInfo?.profile?['email'] as String?,
            givenName: appleIdCredential.givenName ??
                userCred.additionalUserInfo?.username,
            familyName: appleIdCredential.familyName,
            identityToken: appleIdCredential.identityToken,
            authorizationCode: appleIdCredential.authorizationCode,
            state: appleIdCredential.state,
          ),
          provider: AuthProvider.apple,
        );
        if (authUser != null) {
          _emitUser(authUser);
          return AuthSuccess(authUser);
        } else {
          return const AuthFailure(AuthenticationError.unknownError());
        }
      }
      _log.severe('loginWithApple failed without throwing exception');
      return const AuthFailure(AuthenticationError.unknownError());
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
        final authUser = await _syncFirebaseUserWithDatabase(
          userCred.user!,
          provider: AuthProvider.email,
          // Don't provide a [credentialBuilder] here, since it should
          // have been saved during [signUp]
        );
        _isAuthorizing = false;
        if (authUser != null) {
          _emitUser(authUser);
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
      return AuthResponse.fromFirebaseException(
        e,
        const AuthenticationError.badEmailPassword(),
      );
    } on Exception catch (e) {
      _log.warning('Unexpected logInWithEmailAndPassword Exception: $e');
      return const AuthFailure(AuthenticationError.unknownError());
    }
  }

  @override
  Future<AuthResponse> logInWithGoogle() async {
    try {
      _isAuthorizing = true;
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return const AuthFailure(AuthenticationError.cancelledSocialAuth());
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
        final authUser = await _syncFirebaseUserWithDatabase(
          userCred.user!,
          provider: AuthProvider.google,
          credentialBuilder: (String userId) => GoogleCredential(
            userId: userId,
            displayName: googleUser.displayName,
            email: googleUser.email,
            uniqueId: googleUser.id,
            photoUrl: googleUser.photoUrl,
            idToken: googleAuth.idToken,
            serverAuthCode: googleUser.serverAuthCode,
          ),
        );
        if (authUser != null) {
          _emitUser(authUser);
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
  }) async =>
      _signUpWithCleanEmail(
        email: email.toLowerCase().trim(),
        password: password,
      );

  Future<AuthResponse> _signUpWithCleanEmail({
    required String email,
    required String password,
  }) async {
    try {
      _isAuthorizing = true;

      late final firebase_auth.UserCredential userCred;
      AuthUser? preloadedUser;
      bool mustSave = false;

      if (_auth.currentUser != null) {
        preloadedUser = await _loadUserWithExpectations(
          _auth.currentUser!.uid,
          'signUp',
          unexpectedProviders: {AuthProvider.email},
        );
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

      if (preloadedUser != null && preloadedUser.email != email) {
        preloadedUser = preloadedUser.copyWith(email: email);
        mustSave = true;
      }

      _isAuthorizing = false;
      if (userCred.user != null) {
        final authUser = await _syncFirebaseUserWithDatabase(
          userCred.user!,
          provider: AuthProvider.email,
          user: preloadedUser,
          mustSave: mustSave,
          credentialBuilder: (String userId) => EmailCredential(
            email: email,
            userId: userId,
          ),
        );
        if (authUser != null) {
          _emitUser(authUser);
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
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      _log.finer('Successfully logged out');
      return null;
    } on Exception catch (e) {
      _log.severe('Logout exception: $e');
      return const AuthFailure(AuthenticationError.logoutError());
    }
  }

  Future<AuthUser?> _syncFirebaseUserWithDatabase(
    FirebaseUser firebaseUser, {
    AuthProvider? provider,

    /// If the user authenticated from an [AuthProvider] which is associated
    /// with a [SocialCredential], that should be passed here to be saved
    SocialCredential Function(String userId)? credentialBuilder,

    /// If the user was preloaded for account state checks, provide the object
    /// here to prevent a duplicate read
    AuthUser? user,

    /// If the user was both preloaded and had modifications made to it (because
    /// a new auth method yielded new information, for example), then this can
    /// be passed in to guarantee a save
    bool mustSave = false,
  }) async {
    assert(
      !mustSave || user != null,
      'Can only pass mustSave=true when user is not null',
    );

    AuthUser? loadedUser = user ??
        await _loadUserWithExpectations(
          firebaseUser.uid,
          '_syncFirebaseUserWithDatabase',
          exists: null,
        );

    bool shouldSave = false;
    if (loadedUser == null) {
      if (provider == null) {
        _log.shout(
          'Reached invalid state with no AuthUser in Firestore '
          'and a null authProvider value passed to '
          '_syncFirebaseUserWithDatabase. An AuthUser should have been '
          'created in Firestore when this account was first created.',
        );
        await logOut();
        return null;
      }
      // Write the new AuthUser record to Firestore
      loadedUser = toAuthUser(
        firebaseUser,
        provider,
        _privateIdBuilder(),
      );
      shouldSave = true;
    } else {
      if (provider != null) {
        if (loadedUser.lastAuthProvider != provider ||
            !loadedUser.allProviders.contains(provider)) {
          loadedUser = loadedUser.copyWith(lastAuthProvider: provider);
          loadedUser = loadedUser.copyWith(
            allProviders: Set<AuthProvider>.from(loadedUser.allProviders)
              ..add(provider),
          );
          shouldSave = true;
        }
      }
    }
    if (shouldSave) {
      final savedUser = await _authUserRepo.setItem(
        loadedUser,
        RequestDetails.write(),
      );

      if (savedUser != null) {
        if (credentialBuilder != null) {
          final credential = credentialBuilder(savedUser.id);
          final savedCredential = await _credentialRepo.setItem(
            credential,
            RequestDetails.write(shouldOverwrite: false),
          );
          if (savedCredential != null &&
              savedCredential.userId != savedUser.id) {
            _log.shout(
              'Credential ${savedCredential.id} belongs to '
              'AuthUser ${savedCredential.userId}, not current '
              'AuthUser ${savedUser.id}',
            );
          }
        }
      }
      return savedUser;
    } else {
      return loadedUser;
    }
  }

  Future<AuthUser?> _loadUserWithExpectations(
    String id,
    String originMethod, {
    /// If true, the user is expected to exist.
    /// If false, the user is expected to not exist (it is being created).
    /// If null, no assumption is made.
    bool? exists = true,
    Set<AuthProvider> expectedProviders = const {},
    Set<AuthProvider> unexpectedProviders = const {},
  }) async {
    final loadedUser = await _authUserRepo.getById(
      id,
      RequestDetails.read(requestType: RequestType.refresh),
    );

    if (exists != null) {
      if (!exists && loadedUser != null) {
        _log.shout(
          'Found unexpected existing AuthUser in $originMethod with Id $id',
        );
      }
      if (exists && loadedUser == null) {
        _log.shout(
          'Did not find expected AuthUser in $originMethod with Id $id',
        );
      }
    }
    if (loadedUser != null) {
      if (expectedProviders.isNotEmpty) {
        final missingProviders =
            loadedUser.allProviders.difference(expectedProviders);
        if (missingProviders.isNotEmpty) {
          _log.shout(
            'Expected to find AuthUser in $originMethod with Id $id and at '
            'least $expectedProviders. Instead, found AuthUser with '
            '${loadedUser.allProviders}',
          );
        }
        if (unexpectedProviders.isNotEmpty) {
          final surprisingProviders =
              loadedUser.allProviders.intersection(unexpectedProviders);
          if (surprisingProviders.isNotEmpty) {
            _log.shout(
              'Found AuthUser in $originMethod with Id $id which unexpectedly '
              'already had $surprisingProviders.',
            );
          }
        }
      }
    }
    return loadedUser;
  }

  /// Converts a [FirebaseUser] to an application [AuthUser].
  AuthUser toAuthUser(
    FirebaseUser user,
    AuthProvider thisSession,
    String uuid,
  ) =>
      AuthUser(
        id: user.uid,
        loggingId: uuid,
        email: user.email,
        createdAt: user.metadata.creationTime!,
        lastAuthProvider: thisSession,
        allProviders: {thisSession},
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

String _uuidV7() => _uuid.v7();
