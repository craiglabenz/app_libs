import 'dart:convert';
import 'package:client_auth/client_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_data/shared_data.dart';

const userPayload =
//
// ignore: lines_longer_than_80_chars
    '{"id": "abc", "privateId": "private", "apiKey": "123xyz", "lastAuthProvider": "google", "allProviders": ["google"], "loggingId": "_log_", "createdAt": "2025-01-01T12:00:00Z"}';

Future<http.Response> login200Handler(
  Uri url, {
  Map<String, String>? headers,
}) async {
  if (url.path != '/api/v1/login') {
    return http.Response('Not Found', 404, headers: normalHeaders);
  }
  if (!url.queryParameters.containsKey('email')) {
    return http.Response('Bad Request', 400, headers: normalHeaders);
  }
  if (!url.queryParameters.containsKey('password')) {
    return http.Response('Bad Request', 400, headers: normalHeaders);
  }
  return http.Response(userPayload, 200, headers: normalHeaders);
}

Future<http.Response> login400Handler(
  Uri url, {
  Map<String, String>? headers,
}) async {
  return http.Response('Bad Request', 400, headers: normalHeaders);
}

Future<http.Response> register200Handler(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  assert(body != null, 'Must pass a non-null `body`');
  assert(body is String, 'Must pass a String value for `body`');
  if (url.path != '/api/v1/register') {
    return http.Response('Not Found', 404, headers: normalHeaders);
  }
  final requestBody = json.decode(body! as String) as Json;
  if (!requestBody.containsKey('email')) {
    return http.Response('Bad Request', 400, headers: normalHeaders);
  }
  if (!requestBody.containsKey('password')) {
    return http.Response('Bad Request', 400, headers: normalHeaders);
  }
  return http.Response(userPayload, 200, headers: normalHeaders);
}

Future<http.Response> register409Handler(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
}) async {
  return http.Response('Conflict', 409, headers: normalHeaders);
}

RestAuth<AuthUser> setUpAuthService({
  ReadHandler? readHandler,
  WriteRequestHandler? postHandler,
  WriteRequestHandler? putHandler,
  WriteRequestHandler? patchHandler,
  WriteRequestHandler? deleteHandler,
  ResponseProcessor? responseProcessor,
}) {
  final RestApi api = RestApi(
    apiBaseUrl: 'https://fake.com',
    delegate: RequestDelegate.fake(
      readHandler: readHandler,
      postHandler: postHandler,
      putHandler: putHandler,
      patchHandler: patchHandler,
      deleteHandler: deleteHandler,
      responseProcessor: responseProcessor,
    ),
    headersBuilder: () => <String, String>{},
  );
  return RestAuth<AuthUser>(
    api: api,
    logInUrl: const ApiUrl(path: 'login', baseUrl: 'api/v1'),
    registerUrl: const ApiUrl(path: 'register', baseUrl: 'api/v1'),
    logOutUrl: const ApiUrl(path: 'logout', baseUrl: 'api/v1'),
  );
}

void main() {
  group('RestAuth.login should', () {
    test('return a logged in user', () async {
      final auth = setUpAuthService(readHandler: login200Handler);
      final result = await auth.logInWithEmailAndPassword(
        email: 'fake@email.com',
        password: 'password',
      );
      expect(result, isAuthSuccess);
      final AuthUser user = result.getOrRaise();
      expect(user.id, 'abc');
      // expect(user.apiKey, '123xyz');
    });

    test('handle a bad response', () async {
      final auth = setUpAuthService(readHandler: login400Handler);
      final result = await auth.logInWithEmailAndPassword(
        email: 'does not matter',
        password: 'does not matter',
      );
      expect(result, isAuthFailure);
      expect((result as AuthFailure).error, isA<BadEmailPasswordError>());
    });
  });

  group('RestAuth.signUp should', () {
    test('return a registered user', () async {
      final auth = setUpAuthService(postHandler: register200Handler);
      final result = await auth.signUp(
        email: 'fake@email.com',
        password: 'password',
      );
      expect(result, isAuthSuccess);
      final AuthUser user = result.getOrRaise();
      expect(user.id, 'abc');
      // expect(user.apiKey, '123xyz');
    });
    test('handle a bad response', () async {
      final auth = setUpAuthService(postHandler: register409Handler);
      final result = await auth.signUp(
        email: 'does not matter',
        password: 'does not matter',
      );
      expect(result, isAuthFailure);
      expect((result as AuthFailure).error, isA<EmailTakenError>());
    });
  });
}

const normalHeaders = <String, String>{
  'Content-Type': 'application/json',
};
