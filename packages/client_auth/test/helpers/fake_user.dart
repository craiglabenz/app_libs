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

  Json toJson() => {'id': id, 'username': username};
}
