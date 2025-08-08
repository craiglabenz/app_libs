import 'package:auth_server/auth_server.dart';
import 'package:serverpod/serverpod.dart';

extension EasyAuthUser on Session {
  Future<AuthUserDb?> get authUser async {
    final authInfo = await authenticated;
    if (authInfo != null) {
      return await AuthUserDb.db.findFirstRow(
        this,
        where: (t) => t.id.equals(
          UuidValue.fromString(authInfo.userIdentifier),
        ),
      );
    }
    return null;
  }
}
