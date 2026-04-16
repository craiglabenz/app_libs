import 'package:example_shared/models.dart' as shared;
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class SessionEndpoint extends Endpoint {
  @override
  bool requireLogin = true;

  Future<shared.UserProfile?> getCurrentUserProfile(Session session) async {
    final authUserId = session.authenticated!.userIdentifier;

    final userProfile = await AppUserProfile.db.findById(
      session,
      UuidValue.fromString(authUserId),
    );

    if (userProfile == null) {
      throw Exception('UserProfile not found for UserId $authUserId');
    }

    return shared.UserProfile(
      id: authUserId,
      userName: userProfile.userName,
      fullName: userProfile.fullName,
      imageUrl: userProfile.imageUrl,
      createdAt: userProfile.createdAt,
    );
  }

  Future<shared.UserSettings?> getCurrentUserSettings(Session session) async {
    final authUserId = session.authenticated!.userIdentifier;

    final userSettings = await AppUserSettings.db.findById(
      session,
      UuidValue.fromString(authUserId),
    );

    if (userSettings == null) {
      throw Exception('UserSettings not found for UserId $authUserId');
    }

    return shared.UserSettings(
      email: userSettings.email,
      loggingId: userSettings.loggingId.toString(),
    );
  }
}
