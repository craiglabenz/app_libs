import 'package:client_auth/client_auth.dart';
import 'package:client_data/client_data.dart';

class LoginUrl extends ApiUrl {
  const LoginUrl() : super(path: 'login');
}

class RegisterUrl extends ApiUrl {
  const RegisterUrl() : super(path: 'register');
}

class UserDetailUrl extends ApiUrl {
  UserDetailUrl(AuthUser user) : super(path: 'users/${user.id}');
}
