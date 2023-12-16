import 'package:client_auth/client_auth.dart';
import 'package:shared_data/shared_data.dart';

class FakeUser extends BaseUser {
  const FakeUser({
    required super.id,
    required super.username,
  });
  factory FakeUser.fromJson(Json json) => FakeUser(
        id: json['id']! as String,
        username: json['username']! as String,
      );

  @override
  Json toJson() => {'id': id, 'username': username};
}

class FakeUserBindings extends Bindings<FakeUser> {
  FakeUserBindings({
    required super.fromJson,
    required super.getDetailUrl,
    required super.getListUrl,
  });
}

class FakeUserRequestBuilder extends RestAuthRequestBuilder {
  const FakeUserRequestBuilder();

  @override
  ApiUrl loadProfileUrl(AuthUser user) => ApiUrl(path: 'users/${user.id}');

  @override
  ApiUrl get loginUrl => const ApiUrl(path: 'login');

  @override
  ApiUrl get registerUrl => const ApiUrl(path: 'register');

  @override
  ApiUrl updateProfileUrl(AuthUser user) => ApiUrl(path: 'users/${user.id}');
}
