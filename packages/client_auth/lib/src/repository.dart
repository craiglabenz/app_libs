import 'dart:async';

import 'package:client_auth/client_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('client_auth.AuthRepository');

enum LoginType { google, apple, email }

/// Repository which manages user authentication.
class AuthenticationRepository<T extends BaseUser> {
  AuthenticationRepository({
    required BaseStreamAuth streamAuthService,
    required BaseRestAuth<T> restAuthService,
  })  : _streamAuthService = streamAuthService,
        _restAuthService = restAuthService,
        _authUserController = StreamController<AuthUser?>.broadcast() {
    _streamAuthService.users.listen(syncUserToRest);
  }

  /// Allows methods like `signIn` and `logInWithGoogle`, etc, to return
  /// [AuthUser] values despite that value popping out of a stream later on,
  /// elsewhere.
  ///
  /// Because we always want to react to auth signals from Firebase, we need to
  /// keep the FirebaseAuth -> RestAuth stream connection alive. However, we
  /// also want our auth methods to return [AuthUser] objects directly (if
  /// asynchronously) instead of exposing all of this stream machinery to all
  /// calling code. Thus, to avoid publishing those user events twice, our
  /// methods know nothing of the streams, and instead await the result of the
  /// [_userCompleter], which they set up before pushing the first auth domino.
  /// This [_userCompleter] is then resolved in the function that glues all of
  /// the streams together - [syncUserToRest].
  Completer<AuthUserOrError>? _userCompleter;

  /// Helper to be called before attempting any imperative authorization
  /// attempt. This allows [syncUserToRest] to successfully feed the resultant
  /// user back to the `LoginBloc`.
  void _setUpUserCompleter() => _userCompleter = Completer<AuthUserOrError>();

  /// Helper to be called after attempting any imperative authorization attempt.
  /// This frees up resources after [syncUserToRest] is done with them.
  void _destroyUserCompleter() => _userCompleter = null;

  final BaseStreamAuth _streamAuthService;
  final BaseRestAuth _restAuthService;
  final StreamController<AuthUser?> _authUserController;

  /// Placeholder for the last [AuthUser] emitted from the Firebase auth stream.
  /// A value of `null` indicates that we have not yet completed initial checks
  /// and should probably show the `SplashPage`. A value of [AuthUser.anonymous]
  /// indicates that we have completed the initial checks and no user is logged
  /// in, so we should probably show the `LoginPage`.
  AuthUser? lastUser;

  /// Stream of [AuthUser] which will emit the current user when the
  /// authentication state changes.
  ///
  /// Emits [AuthUser.anonymous] if the user is not authenticated.
  Stream<AuthUser?> get user => _authUserController.stream;

  /// Sends a new [AuthUser] object through the stream for any listeners.
  Future<void> syncUserToRest(FirebaseUser? firebaseUser) async {
    _log.fine('Syncing FirebaseUser $firebaseUser to Rest API');
    if (firebaseUser != null) {
      final maybeUser = await _restLoginOrRegister(firebaseUser);
      _userCompleter?.complete(maybeUser);

      // Lastly, send all of this information to the rest of the WashDay app.
      if (maybeUser.isLeft()) {
        publishNewUser(AuthUser.anonymous);
      } else {
        publishNewUser(maybeUser.getOrRaise());
      }
    } else {
      publishNewUser(AuthUser.anonymous);
    }
  }

  Future<AuthUserOrError> _restLoginOrRegister(
    FirebaseUser firebaseUser,
  ) async {
    // See if this already exists in the application server database.
    return firebaseUser.isNew
        ? _restRegister(firebaseUser)
        : _restLogin(firebaseUser);

    // Alternate implementation below. Above could be better as it does not
    // threaten to silently fragment accounts downstream of a Firebase auth bug.
    // However, this also throws false-positive errors for existing users which
    // is a pain, so we'd have to figure that out.
    // final loginAuthUserOrError = await _restLogin(firebaseUser);
    // if (loginAuthUserOrError.isRight()) {
    //   return loginAuthUserOrError;
    // }

    // If the application server also has no idea, then just create them.
    // return _restRegister(firebaseUser);
  }

  @visibleForTesting
  void publishNewUser(AuthUser user) {
    lastUser = user;
    _authUserController.sink.add(user);
  }

  /// Helper method to complete other login methods that start with Firebase.
  Future<AuthUserOrError> _restLogin(FirebaseUser user) =>
      _restAuthService.login(
        email: user.email ?? '',
        password: user.uid,
      );

  /// Helper method to complete other login methods that start with Firebase.
  Future<AuthUserOrError> _restRegister(FirebaseUser user) async =>
      _restAuthService.register(
        email: user.email ?? '',
        password: user.uid,
      );

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws an [AuthenticationError] if an exception occurs.
  Future<AuthUserOrError> signUp({
    required String email,
    required String password,
  }) async =>
      _curriedLoginOrRegister(
        () => _streamAuthService.signUp(
          email: email,
          password: password,
        ),
        onError: (AuthenticationError error) async {
          final methods = await _streamAuthService.getAvailableMethods(email);
          if (methods.isNotEmpty) {
            return AuthenticationError.wrongMethod(methods);
          }
          return error;
        },
      );

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws an [AuthenticationError] if an exception occurs.
  Future<AuthUserOrError> logInWithApple() async =>
      _curriedLoginOrRegister(_streamAuthService.logInWithApple);

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws an [AuthenticationError] if an exception occurs.
  Future<AuthUserOrError> logInWithGoogle() async =>
      _curriedLoginOrRegister(_streamAuthService.logInWithGoogle);

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws an [AuthenticationError] if an exception occurs.
  Future<AuthUserOrError> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async =>
      _curriedLoginOrRegister(
        () => _streamAuthService.logInWithEmailAndPassword(
          email: email,
          password: password,
        ),
        onError: (AuthenticationError error) async {
          final methods = await _streamAuthService.getAvailableMethods(email);
          if (methods.isNotEmpty) {
            return AuthenticationError.wrongMethod(methods);
          }
          return error;
        },
      );

  Future<AuthUserOrError> _curriedLoginOrRegister(
    Future<FirebaseUserOrError> Function() sessionCreator, {
    Future<AuthenticationError> Function(AuthenticationError)? onError,
  }) async {
    _setUpUserCompleter();
    final firebaseAuthUserOrError = await sessionCreator();
    if (firebaseAuthUserOrError.isLeft()) {
      final firebaseError = firebaseAuthUserOrError.leftOrRaise();
      final handledError =
          onError != null ? await onError(firebaseError) : firebaseError;
      return Left(handledError);
    }
    final userOrError = await _userCompleter!.future;
    _destroyUserCompleter();
    return userOrError;
  }

  /// Signs out the current user which will emit
  /// [AuthUser.anonymous] from the [user] Stream.
  ///
  /// Throws an [AuthenticationError] if an exception occurs.
  Future<Either<AuthenticationError, void>> logOut() async =>
      _streamAuthService.logOut();

  Future<Either<DisplayableError, T>> updateUserProfile(Json data) async {
    assert(
      lastUser != null,
      "Cannot update a user's profile while unauthenticated",
    );
    final profileOrError = await _restAuthService.updateUserProfile(
      lastUser!,
      data,
    ) as Either<ApiError, T>;
    if (profileOrError.isRight()) {
      final updateProfile = profileOrError.getOrRaise();
      await GetIt.I<Repository<BaseUser>>().setItem(
        updateProfile,
        RequestDetails<T>(requestType: RequestType.local),
      );
      return Right(updateProfile);
    } else {
      return const Left(
        DisplayableError('Unable to update profile. Please try again later.'),
      );
    }
  }
}

extension on FirebaseUser {
  bool get isNew =>
      metadata.creationTime == null ||
      metadata.lastSignInTime == null ||
      (metadata.lastSignInTime!.difference(metadata.creationTime!)) <
          const Duration(seconds: 1);
}
