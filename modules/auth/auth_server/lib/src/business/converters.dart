import 'package:auth_server/auth_server.dart';
import 'package:shared_data/shared_data.dart';

extension ConvertibleAuthUser on AuthUserDb {
  AuthUser toDto() => AuthUser(
    id: id!.uuid,
    loggingId: loggingId.uuid,
    email: email,
    createdAt: createdAt,
    lastAuthProvider: AuthProvider.values.byName(lastAuthProvider),
    allProviders: allProviders
        .map<AuthProvider>(AuthProvider.values.byName)
        .toSet(),
  );
}
