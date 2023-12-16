import 'package:shared_data/shared_data.dart';

class LoginUrl extends ApiUrl {
  const LoginUrl() : super(path: 'login');
}

class RegisterUrl extends ApiUrl {
  const RegisterUrl() : super(path: 'register');
}

class UserDetailUrl extends ApiUrl {
  UserDetailUrl(AuthUser user) : super(path: 'users/${user.id}');
}
