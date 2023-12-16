import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/shared_data.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@Freezed()
class User extends BaseUser with _$User {
  const factory User({
    required String id,
    required String username,
  }) = _User;
  const User._() : super(id: '', username: '');

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
