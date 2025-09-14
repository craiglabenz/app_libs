import 'package:auth_server/src/business/passwords_controller.dart';
import 'package:auth_server/src/generated/protocol.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shared_data/shared_data.dart';

/// Business logic container for user authentication.
class AuthUserController {
  /// Verifies sessions for each request.
  static Future<AuthenticationInfo?> authenticationHandler(
    Session session,
    String token,
  ) async {
    if (!session.passwords.containsKey('jwtSalt') ||
        session.passwords['jwtSalt'] == '') {
      throw Exception('Failed to configure security salt. Cannot sign JWTs');
    }
    JWT jwt;
    try {
      jwt = JWT.verify(token, SecretKey(session.passwords['jwtSalt']!));
    } on JWTInvalidException {
      session.log('Invalid signature for token. Not activating session');
      return null;
    }

    final payload = jwt.payload as Map<String, dynamic>;
    if (!payload.containsKey('socialId') || payload['socialId']!.isEmpty) {
      return null;
    }

    late final AuthProvider authProvider;
    late final int authId;
    try {
      authProvider = AuthProvider.values.byName(
        payload['provider'] ?? '_missing_',
      );
    } on Exception {
      session.log(
        'Invalid JWT provider value of ${payload['provider']}',
        level: LogLevel.warning,
      );
      return null;
    }

    try {
      authId = int.parse(payload['authId'] ?? '_missing_');
    } on Exception {
      session.log(
        'Invalid JWT authId value of ${payload['authId']}',
        level: LogLevel.warning,
      );
      return null;
    }

    switch (authProvider) {
      case AuthProvider.anonymous:
      // Do nothing
      case AuthProvider.email:
        final emailAuth = await AuthUserEmail.db.findById(session, authId);
        if (emailAuth == null) {
          session.log(
            'Received invalid JWT referencing unknown AuthUserEmail Id $authId',
            level: LogLevel.warning,
          );
          return null;
        }
      case AuthProvider.apple:
        final appleAuth = await AuthUserApple.db.findById(session, authId);
        if (appleAuth == null) {
          session.log(
            'Received invalid JWT referencing unknown AuthUserApple Id $authId',
            level: LogLevel.warning,
          );
          return null;
        }
      case AuthProvider.google:
        final googleAuth = await AuthUserGoogle.db.findById(session, authId);
        if (googleAuth == null) {
          session.log(
            'Received invalid JWT referencing unknown AuthUserGoogle '
            'Id $authId',
            level: LogLevel.warning,
          );
          return null;
        }
    }

    final authUser = await AuthUserDb.db.findFirstRow(
      session,
      where: (t) => t.socialId.equals(payload['socialId']),
    );

    if (authUser == null) {
      session.log(
        'Did not find user with socialId ${payload['socialId']} as '
        'decoded from JWT',
        level: LogLevel.warning,
      );
      return null;
    } else {
      session.log(
        'Successfully validated JWT for AuthUser::${authUser.id!.uuid}',
        level: LogLevel.info,
      );
    }

    return AuthenticationInfo(
      authUser.id!,
      <Scope>{},
      authId: payload['authId'],
    );
  }

  /// Creates a new user and attaches its initial auth.
  static Future<AuthUserDb?> createUser(
    Session session, {
    required String socialId,
    bool isAnonymous = false,
    SocialCredential? credential,
  }) async {
    assert(
      isAnonymous || credential != null,
      'Must provide session information',
    );

    String lastAuthProvider;

    if (isAnonymous) {
      lastAuthProvider = AuthProvider.anonymous.name;
    } else {
      lastAuthProvider = switch (credential!) {
        EmailCredential() => AuthProvider.email.name,
        AppleCredential() => AuthProvider.apple.name,
        GoogleCredential() => AuthProvider.google.name,
      };
    }

    // Check whether the existing social user is logging back in.
    AuthUserDb? authUser = await AuthUserDb.db.findFirstRow(
      session,
      where: (t) => t.socialId.equals(socialId),
    );

    if (authUser == null) {
      final row = AuthUserDb(
        socialId: socialId,
        lastAuthProvider: lastAuthProvider,
        email: credential?.getEmail(),
        allProviders: {},
        loggingId: UuidValue.fromString(const Uuid().v4()),
        createdAt: DateTime.now().toUtc(),
      );
      authUser = await AuthUserDb.db.insertRow(session, row);
    }

    if (credential != null) {
      await addAuthToUser(session, authUser: authUser, credential: credential);
    }

    return authUser;
  }

  /// Adds a new auth to an existing user, which may or may not still be
  /// exclusively anonymous.
  static Future<void> addAuthToUser(
    Session session, {
    required AuthUserDb authUser,
    required SocialCredential credential,
  }) async {
    await switch (credential) {
      EmailCredential() => AuthUserController.addEmailToUser(
        session,
        authUser,
        credential,
      ),
      AppleCredential() => AuthUserController.addAppleToUser(
        session,
        authUser,
        credential,
      ),
      GoogleCredential() => AuthUserController.addGoogleToUser(
        session,
        authUser,
        credential,
      ),
    };
  }

  /// Attempts to add email and password authentication to an existing account.
  /// This is likely to upgrade an anonymous account, but could also take place
  /// on a user account that already has social auth.
  ///
  /// Unlike Apple and Google auth, this method does not gracefully UPSERT
  /// records because it is not expected that users click the "Sign Up" button
  /// when they already have an account with email auth. Those users should
  /// log in.
  static Future<AuthUserEmail> addEmailToUser(
    Session session,
    AuthUserDb authUser,
    EmailCredential credential,
  ) async {
    final existingSocialQuery = AuthUserEmail.db.count(
      session,
      where: (t) => t.authUserId.equals(authUser.id),
    );
    if (await existingSocialQuery > 0) {
      session.log(
        'Attempting to add AuthUserEmail to AuthUser Id ${authUser.id} which '
        'already has AuthUserEmail record',
      );
      throw AuthenticationError.conflict();
    }

    if (authUser.allProviders.contains(AuthProvider.email.name)) {
      session.log(
        'Adding Email Auth to AuthUser Id ${authUser.id} which unexpectedly '
        'already has Email Auth in allProviders',
      );
      throw AuthenticationError.conflict();
    }

    authUser.allProviders.add(AuthProvider.email.name);
    AuthUserDb.db.updateRow(
      session,
      authUser,
      // TODO:
      // columns: [AuthUserDb.t.allProviders, AuthUserDb.t.email],
    );

    return AuthUserEmail.db.insertRow(
      session,
      AuthUserEmail(
        authUserId: authUser.id!,
        email: credential.email,
        password: await generatePasswordHash(credential.password),
      ),
    );
  }

  /// Attempts to add Apple Id authentication to an existing account.
  /// This is likely to upgrade an anonymous account, but could also take place
  /// on a user account that already has other auths.
  ///
  /// If the [AuthUserApple] record already exists, returns that, since users
  /// logging back in via Apple/Google do not have different LOGIN vs SIGNUP
  /// buttons.
  static Future<AuthUserApple> addAppleToUser(
    Session session,
    AuthUserDb authUser,
    AppleCredential credential,
  ) async {
    final existingSocial = await AuthUserApple.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUser.id),
    );
    if (existingSocial != null) {
      if (authUser.lastAuthProvider != AuthProvider.apple.name) {
        authUser.lastAuthProvider = AuthProvider.apple.name;
        AuthUserDb.db.updateRow(
          session,
          authUser,
          // TODO:
          // columns: [AuthUserDb.t.lastAuthProvider],
        );
      }
      return existingSocial;
    }

    if (authUser.allProviders.contains(AuthProvider.apple.name)) {
      session.log(
        'Adding Apple Auth to AuthUser Id ${authUser.id} which unexpectedly '
        'already has Apple Auth in allProviders',
      );
      throw AuthenticationError.conflict();
    }

    authUser.allProviders.add(AuthProvider.apple.name);
    authUser.email ??= credential.email;
    AuthUserDb.db.updateRow(
      session,
      authUser,
      // TODO:
      // columns: [AuthUserDb.t.allProviders, AuthUserDb.t.email],
    );

    return AuthUserApple.db.insertRow(
      session,
      AuthUserApple(
        authUserId: authUser.id!,
        email: credential.email,
        givenName: credential.givenName,
        familyName: credential.familyName,
        authorizationCode: credential.authorizationCode,
        identityToken: credential.identityToken,
        userIdentifier: credential.userIdentifier,
      ),
    );
  }

  /// Attempts to add Google authentication to an existing account.
  /// This is likely to upgrade an anonymous account, but could also take place
  /// on a user account that already has other auths.
  ///
  /// If the [AuthUserGoogle] record already exists, returns that, since users
  /// logging back in via Apple/Google do not have different LOGIN vs SIGNUP
  /// buttons.
  static Future<AuthUserGoogle> addGoogleToUser(
    Session session,
    AuthUserDb authUser,
    GoogleCredential credential,
  ) async {
    final existingSocial = await AuthUserGoogle.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUser.id),
    );
    if (existingSocial != null) {
      if (authUser.lastAuthProvider != AuthProvider.google.name) {
        authUser.lastAuthProvider = AuthProvider.google.name;
        AuthUserDb.db.updateRow(
          session,
          authUser,
          // TODO:
          // columns: [AuthUserDb.t.lastAuthProvider],
        );
      }
      return existingSocial;
    }

    if (authUser.allProviders.contains(AuthProvider.google.name)) {
      session.log(
        'Adding Google Auth to AuthUser Id ${authUser.id} which unexpectedly '
        'already has Google Auth in allProviders',
      );
      throw AuthenticationError.conflict();
    }

    authUser.allProviders.add(AuthProvider.google.name);
    authUser.email ??= credential.email;
    AuthUserDb.db.updateRow(
      session,
      authUser,
      // TODO:
      // columns: [AuthUserDb.t.allProviders, AuthUserDb.t.email],
    );

    return AuthUserGoogle.db.insertRow(
      session,
      AuthUserGoogle(
        authUserId: authUser.id!,
        email: credential.email,
        displayName: credential.displayName,
        photoUrl: credential.photoUrl,
        serverAuthCode: credential.serverAuthCode,
        idToken: credential.idToken,
        uniqueId: credential.uniqueId,
      ),
    );
  }

  /// Validates a user-supplied password against what the database says they
  /// supplied when they created their account.
  static Future<bool> validatePassword({
    required String rawPassword,
    required String email,
    required String hashedPassword,
  }) => validatePasswordHash(rawPassword, email, hashedPassword);

  /// Creates a JWT the user's device should hold onto and return with all
  /// future requests.
  static String createJwt(
    AuthUserDb dbUser,
    AuthProvider provider,
    int? authId,
    String salt,
  ) {
    final jwt = JWT({
      'id': dbUser.id!.uuid,
      'socialId': dbUser.socialId,
      'provider': provider.name,
      'authId': authId?.toString(),
      'issuedAt': DateTime.now().toUtc().toIso8601String(),
    });
    return jwt.sign(SecretKey(salt));
  }
}
