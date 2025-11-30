import 'package:auth_server/src/business/auth_user_controller.dart';
import 'package:auth_server/src/business/converters.dart';
import 'package:auth_server/src/business/session_extension.dart';
import 'package:auth_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:shared_data/shared_data.dart';

/// Access point for user authentication.
class AuthUserEndpoint extends Endpoint {
  /// Loads user information for the currently authenticated user.
  Future<AuthResponse> validateKey(Session session) async {
    final authUser = await session.authUser;
    if (authUser is AuthUserDb) {
      return AuthSuccess(authUser.toDto(), isNewUser: false);
    }
    return const AuthFailure(AuthenticationError.expiredCredentials());
  }

  /// Creates a new anonymous user.
  Future<AuthResponse> createAnonymousUser(
    Session session, {
    required String socialId,
  }) async {
    final authUser = await AuthUserController.createUser(
      session,
      socialId: socialId,
      isAnonymous: true,
    );

    if (authUser == null) {
      return const AuthFailure(AuthenticationError.unknownError());
    }
    session.log('Created anonymous AuthUser: ${authUser.id!.uuid}');

    final jwt = AuthUserController.createJwt(
      authUser,
      AuthProvider.anonymous,
      null,
      session.passwords['jwtSalt']!,
    );
    session.log('Created JWT $jwt');
    return AuthSuccess(authUser.toDto(), isNewUser: true, apiToken: jwt);
  }

  /// Attempts to verify an existing user account by email and password.
  Future<AuthResponse> logInEmailUser(
    Session session, {
    required String socialId,
    required EmailCredential credential,
  }) async {
    final authUser = await AuthUserDb.db.findFirstRow(
      session,
      where: (t) => t.socialId.equals(socialId),
    );

    if (authUser == null) {
      session.log(
        'Did not find AuthUserId for social Id $socialId',
        level: LogLevel.warning,
      );
      return const AuthFailure(AuthenticationError.badEmailPassword());
    }

    // Check for too many recent login attempts
    final recentFailures = await AuthUserFailedLogin.db.count(
      session,
      where: (t) =>
          t.authUserId.equals(authUser.id) &
          (t.createdAt >
              DateTime.now().toUtc().subtract(const Duration(days: 1))),
    );

    if (recentFailures > 5) {
      session.log(
        'Throttling login attempt for AuthUser ${authUser.id}',
        level: LogLevel.warning,
      );
      // TODO(craiglabenz): Add a [throttle] error type.
      return AuthFailure(AuthenticationError.unknownError());
    }

    final emailAuth = await AuthUserEmail.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUser.id),
    );

    if (emailAuth == null || emailAuth.email != credential.email) {
      session.log(
        'Could not login AuthUser with socialId $socialId with unknown '
        'email ${credential.email}',
        level: LogLevel.warning,
      );
      return const AuthFailure(AuthenticationError.unknownError());
    }

    final isPasswordValid = await AuthUserController.validatePassword(
      rawPassword: credential.password,
      email: emailAuth.email,
      hashedPassword: emailAuth.password,
    );

    if (!isPasswordValid) {
      session.log(
        'Rejecting logIn to AuthUserId Id ${authUser.id} on account of '
        'bad password',
        level: LogLevel.warning,
      );
      await AuthUserFailedLogin.db.insertRow(
        session,
        AuthUserFailedLogin(
          authUserId: authUser.id!,
          createdAt: DateTime.now().toUtc(),
        ),
      );
      return const AuthFailure(AuthenticationError.unknownError());
    }

    final jwt = AuthUserController.createJwt(
      authUser,
      AuthProvider.email,
      emailAuth.id,
      session.passwords['jwtSalt']!,
    );
    return AuthSuccess(authUser.toDto(), isNewUser: false, apiToken: jwt);
  }

  /// Adds an [AuthUserEmail] record to the associated [AuthUserDb].
  Future<AuthResponse> addEmailToUser(
    Session session, {
    required String socialId,
    required EmailCredential credential,
  }) async {
    AuthUserDb? authUser = await session.authUser;
    AuthUserEmail? emailRow;
    bool isNewUser = authUser == null;

    if (authUser == null) {
      authUser = await AuthUserController.createUser(
        session,
        socialId: socialId,
        credential: credential,
      );
      if (authUser == null) {
        session.log(
          'Failed to create AuthUserDb for SocialId $socialId and '
          'email ${credential.getEmail()}',
        );
        return AuthFailure(AuthenticationError.unknownError());
      }
      emailRow = await AuthUserEmail.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUser!.id),
      );
      if (emailRow == null) {
        session.log(
          'Failed to create AuthUserEmail for SocialId $socialId and '
          'email ${credential.getEmail()}',
        );
        return AuthFailure(AuthenticationError.unknownError());
      }
    } else {
      if (authUser.socialId != socialId) {
        session.log(
          'addEmailToUser rejected as session socialId '
          '${authUser.socialId} != supplied socialId $socialId',
          level: LogLevel.warning,
        );
        return const AuthFailure(AuthenticationError.unknownError());
      }

      emailRow = await AuthUserController.addEmailToUser(
        session,
        authUser,
        credential,
      );
    }

    final jwt = AuthUserController.createJwt(
      authUser,
      AuthProvider.email,
      emailRow.id,
      session.passwords['jwtSalt']!,
    );
    return AuthSuccess(authUser.toDto(), isNewUser: isNewUser, apiToken: jwt);
  }

  /// Attempts to create a new account secured by an email and password.
  // Future<AuthResponse> createUserWithEmailAndPassword(
  //   Session session, {
  //   required String socialId,
  //   required EmailCredential credential,
  // }) async {
  //   final existingUser = await AuthUserDb.db.findFirstRow(
  //     session,
  //     where: (t) => t.email.equals(credential.email),
  //   );

  //   if (existingUser != null) {
  //     session.log(
  //       'Failed to create new user for existing email address '
  //       '${credential.email}',
  //       level: LogLevel.info,
  //     );
  //     return AuthFailure(AuthenticationError.conflict());
  //   }

  //   final authUser = await AuthUserController.createUser(
  //     session,
  //     socialId: socialId,
  //     credential: credential,
  //   );

  //   if (authUser == null) {
  //     session.log(
  //       'Failed to create new AuthUserDb for socialId $socialId',
  //       level: LogLevel.error,
  //     );
  //     return const AuthFailure(AuthenticationError.unknownError());
  //   }

  //   // [emailRow] is created during [AuthUserController.createUser] by way of
  //   // the [credential]
  //   final emailRow = await AuthUserEmail.db.findFirstRow(
  //     session,
  //     where: (t) => t.authUserId.equals(authUser.id),
  //   );

  //   if (emailRow == null) {
  //     session.log(
  //       'Failed to create AuthUserEmail for new AuthUserDb Id ${authUser.id}',
  //       level: LogLevel.error,
  //     );
  //     return const AuthFailure(AuthenticationError.unknownError());
  //   }

  //   final jwt = AuthUserController.createJwt(
  //     authUser,
  //     AuthProvider.email,
  //     emailRow.id,
  //     session.passwords['jwtSalt']!,
  //   );
  //   return AuthSuccess(authUser.toDto(), isNewUser: true, apiToken: jwt);
  // }

  /// Adds an [AuthUserApple] record to the associated [AuthUserDb].
  Future<AuthResponse> addAppleToUser(
    Session session, {
    required String socialId,
    required AppleCredential credential,
  }) async {
    AuthUserDb? authUser = await session.authUser;
    AuthUserApple? appleRow;

    if (authUser == null) {
      authUser = await AuthUserController.createUser(
        session,
        socialId: socialId,
        credential: credential,
      );
      if (authUser == null) {
        session.log(
          'Failed to create AuthUserDb for SocialId $socialId and '
          'email ${credential.getEmail()}',
        );
        return AuthFailure(AuthenticationError.unknownError());
      }
      appleRow = await AuthUserApple.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUser!.id),
      );
      if (appleRow == null) {
        session.log(
          'Failed to create AuthUserApple for SocialId $socialId and '
          'email ${credential.getEmail()}',
        );
        return AuthFailure(AuthenticationError.unknownError());
      }
    } else {
      if (authUser.socialId != socialId) {
        session.log(
          'addAppleToUser rejected as session socialId '
          '${authUser.socialId} != supplied socialId $socialId',
          level: LogLevel.warning,
        );
        return const AuthFailure(AuthenticationError.unknownError());
      }

      appleRow = await AuthUserController.addAppleToUser(
        session,
        authUser,
        credential,
      );
    }

    final jwt = AuthUserController.createJwt(
      authUser,
      AuthProvider.apple,
      appleRow.id,
      session.passwords['jwtSalt']!,
    );
    return AuthSuccess(authUser.toDto(), isNewUser: false, apiToken: jwt);
  }

  /// Adds an [AuthUserGoogle] record to the associated [AuthUserDb].
  Future<AuthResponse> addGoogleToUser(
    Session session, {
    required String socialId,
    required GoogleCredential credential,
  }) async {
    AuthUserDb? authUser = await session.authUser;
    AuthUserGoogle? googleRow;

    if (authUser == null) {
      authUser = await AuthUserController.createUser(
        session,
        socialId: socialId,
        credential: credential,
      );
      if (authUser == null) {
        session.log(
          'Failed to create AuthUserDb for SocialId $socialId and '
          'email ${credential.getEmail()}',
        );
        return AuthFailure(AuthenticationError.unknownError());
      }
      googleRow = await AuthUserGoogle.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(authUser!.id),
      );
      if (googleRow == null) {
        session.log(
          'Failed to create AuthUserGoogle for SocialId $socialId and '
          'email ${credential.getEmail()}',
        );
        return AuthFailure(AuthenticationError.unknownError());
      }
    } else {
      if (authUser.socialId != socialId) {
        session.log(
          'addGoogleToUser rejected as session socialId '
          '${authUser.socialId} != supplied socialId $socialId',
          level: LogLevel.warning,
        );
        return const AuthFailure(AuthenticationError.unknownError());
      }

      googleRow = await AuthUserController.addGoogleToUser(
        session,
        authUser,
        credential,
      );
    }

    final jwt = AuthUserController.createJwt(
      authUser,
      AuthProvider.google,
      googleRow.id,
      session.passwords['jwtSalt']!,
    );
    return AuthSuccess(authUser.toDto(), isNewUser: false, apiToken: jwt);
  }
}
