import 'package:shared_data/shared_data.dart';

class FakeProfile {
  const FakeProfile({
    required this.id,
    required this.username,
  });
  factory FakeProfile.fromJson(Json json) => FakeProfile(
        id: json['id']! as String,
        username: json['username']! as String,
      );

  final String? id;
  final String username;

  Json toJson() => {'id': id, 'username': username};
}
