// import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/shared_data.dart';

class LoginRequest extends ReadApiRequest {
  LoginRequest({
    required super.url,
    required String email,
    required String password,
  }) : super(params: {'email': email, 'password': password});
}

class LoadProfileRequest extends AuthenticatedReadApiRequest {
  const LoadProfileRequest({required super.url, required super.user});
}

class RegisterRequest extends WriteApiRequest {
  RegisterRequest({
    required super.url,
    required String email,
    required String password,
  }) : super(body: {'email': email, 'password': password});
}

class UpdateProfileRequest extends AuthenticatedWriteApiRequest {
  UpdateProfileRequest({
    required super.url,
    required super.user,
    required BaseUser profile,
  }) : super(body: profile.toJson());
}
