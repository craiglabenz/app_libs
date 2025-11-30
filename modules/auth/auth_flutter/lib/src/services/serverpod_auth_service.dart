// ignore_for_file: implementation_imports
import 'package:auth_client/src/protocol/client.dart' as client;
import 'package:client_auth/client_auth.dart';
import 'package:logging/logging.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:shared_data/shared_data.dart';

final _log = Logger('ServerpodAuthService');

typedef SessionCreator = Future<AuthResponse> Function();
typedef SessionDestroyer = Future<AuthResponse?> Function();
typedef EmailPasswordSessionCreator =
    Future<AuthResponse> Function({
      required String email,
      required String password,
    });

/// {@template ServerpodAuthService}
/// {@endtemplate}
class ServerpodAuthService extends SyncAuthService {
  /// {@macro ServerpodAuthService}
  ServerpodAuthService(this._client, {required this.keyManager});

  final client.Caller _client;
  final AuthenticationKeyManager keyManager;

  Future<AuthResponse> _cacheApiKey(Future<AuthResponse> responseFuture) async {
    final response = await responseFuture;
    if (response is AuthSuccess &&
        response.apiToken != null &&
        response.apiToken!.isNotEmpty) {
      _log.finest('Saving API Token: ${response.apiToken}');
      keyManager.put(response.apiToken!);
    }
    return response;
  }

  @override
  Future<AuthResponse> syncAnonymousAccount(SocialAuthSuccess success) async =>
      _cacheApiKey(
        _client.authUser.createAnonymousUser(socialId: success.user.id),
      );

  @override
  Future<AuthResponse> syncAppleAuthentication(SocialAuthSuccess success) =>
      _cacheApiKey(
        _client.authUser.addAppleToUser(
          socialId: success.user.id,
          credential: success.credential as AppleCredential,
        ),
      );

  @override
  Future<AuthResponse> syncGoogleAuthentication(SocialAuthSuccess success) =>
      _cacheApiKey(
        _client.authUser.addGoogleToUser(
          socialId: success.user.id,
          credential: success.credential as GoogleCredential,
        ),
      );

  @override
  Future<AuthResponse> syncEmailPasswordAuthentication(
    SocialAuthSuccess success,
  ) => _cacheApiKey(
    _client.authUser.addEmailToUser(
      socialId: success.user.id,
      credential: success.credential as EmailCredential,
    ),
  );

  @override
  Future<AuthResponse> logInWithEmailAndPassword(SocialAuthSuccess success) =>
      _cacheApiKey(
        _client.authUser.logInEmailUser(
          socialId: success.user.id,
          credential: success.credential as EmailCredential,
        ),
      );

  @override
  Future<AuthFailure?> logOut() async {
    try {
      keyManager.remove();
      return null;
    } on Exception catch (e) {
      _log.shout('Failed to remove Serverpod key :: $e');
      return const AuthFailure(AuthenticationError.logoutError());
    }
  }

  @override
  void dispose() {}

  @override
  Future<AuthUser?> verifySocialUserSession(SocialUser user) async {
    // [_client] will automatically include the key; but still do a local check
    // to confirm that the request stands any chance of being successful.
    final key = await keyManager.get();
    if (key == null) {
      _log.finer('Could not verify $user because Serverpod Auth has no key');
      return null;
    }
    // If we have a key, give it a try.
    final response = await _cacheApiKey(_client.authUser.validateKey());
    return switch (response) {
      AuthSuccess() => response.user,
      AuthFailure() => null,
    };
  }
}
