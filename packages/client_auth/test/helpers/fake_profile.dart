class FakeProfile {
  const FakeProfile({
    required this.id,
    required this.username,
  });
  factory FakeProfile.fromJson(Map<String, Object?> json) => FakeProfile(
        id: json['id']! as String,
        username: json['username']! as String,
      );

  final String? id;
  final String username;

  Map<String, Object?> toJson() => {'id': id, 'username': username};
}
