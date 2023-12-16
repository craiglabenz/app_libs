import 'package:client_app/auth/auth.dart';
import 'package:client_auth/client_auth.dart';
import 'package:client_data/client_data.dart';

class UserRequestBuilder extends RestAuthRequestBuilder {
  const UserRequestBuilder();
  @override
  ApiUrl loadProfileUrl(AuthUser user) => UserDetailUrl(user);

  @override
  ApiUrl get loginUrl => const LoginUrl();

  @override
  ApiUrl get registerUrl => const RegisterUrl();

  @override
  ApiUrl updateProfileUrl(AuthUser user) => UserDetailUrl(user);
}
