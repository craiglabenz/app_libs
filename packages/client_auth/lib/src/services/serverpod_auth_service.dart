import 'package:client_auth/client_auth.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
// import 'package:shared_data/src/models/auth_responses.dart';

/// Handler to produce an anonymous account.
typedef CreateAnonymousAccountCallback = Future<AuthSuccess> Function();

class ServerpodAuthService extends AuthService
    with EmailAuthService, SocialAuthService {
  @override
  Future<AuthSuccess> createAnonymousAccount() {
    // TODO: implement createAnonymousAccount
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<SocialAuthResponse> logInWithApple() {
    // TODO: implement logInWithApple
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement logInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<SocialAuthResponse> logInWithGoogle() {
    // TODO: implement logInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<AuthFailure?> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
