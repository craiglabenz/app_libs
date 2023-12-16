import 'package:shared_data/shared_data.dart';

class LoadProfile extends ReadApiRequest {
  LoadProfile({required super.url, required AuthUser user})
      : _user = user,
        super(apiKey: user.apiKey);

  final AuthUser _user;

  AuthUser get user => _user;
}

class UpdateProfile extends WriteApiRequest {
  UpdateProfile({
    required super.url,
    required AuthUser user,
    required super.body,
  })  : _user = user,
        super(apiKey: user.apiKey);

  final AuthUser _user;

  AuthUser get user => _user;
}

class LoginRequest extends ReadApiRequest {
  const LoginRequest({
    required super.url,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Params get params => {'email': email, 'password': password};
}

class RegisterRequest extends WriteApiRequest {
  const RegisterRequest({
    required super.url,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  Body get body => {'email': email, 'password': password};
}
