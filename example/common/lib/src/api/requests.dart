import 'package:common/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_data/shared_data.dart';

part 'requests.freezed.dart';
part 'requests.g.dart';

/// {@template UserProfileRequest}
/// Updates a [User] record on the server by acceppting a [UserCompanion]
/// record.
/// {@endtemplate}
@Freezed()
class UpdateProfileRequestBody extends WriteApiRequest
    with _$UpdateProfileRequestBody {
  /// {@macro UserProfileTemplate}
  const factory UpdateProfileRequestBody({
    required UserCompanion userCompanion,
  }) = _UpdateProfileRequestBody;

  /// Json deserializer for [UpdateProfileRequestBody].
  factory UpdateProfileRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestBodyFromJson(json);
}
