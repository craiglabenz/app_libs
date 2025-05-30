import 'dart:collection';

import 'package:client_auth/client_auth.dart';

/// Scriptable auth results from the application server.
class FakeRestAuth implements AuthService {
  FakeRestAuth({
    Queue<AuthResponse>? loginResults,
    Queue<AuthResponse>? registerResults,
  })  : loginResults = loginResults ?? Queue<AuthResponse>(),
        registerResults = registerResults ?? Queue<AuthResponse>();

  final Queue<AuthResponse> loginResults;
  final Queue<AuthResponse> registerResults;

  @override
  Future<AuthResponse> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      Future.value(loginResults.removeFirst());

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) =>
      Future.value(registerResults.removeFirst());

  @override
  void dispose() {}

  @override
  Future<AuthFailure?> logOut() => Future.value();
}
