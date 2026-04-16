// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
UserProfileModel _$UserProfileModelFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'default':
          return UserProfile.fromJson(
            json
          );
                case 'update':
          return _UserProfileUpdate.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'UserProfileModel',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$UserProfileModel {

/// The user's new userName. Only truthy values are considered here. To
/// delete the `userName` field, set [clearUserName] to true.
 String? get userName;/// The user's new fullName. Only truthy values are considered here. To
/// delete the `fullName` field, set [clearFullName] to true.
 String? get fullName;/// The user's new imageUrl. Only truthy values are considered here. To
/// delete the `imageUrl` field, set [clearImageUrl] to true.
 String? get imageUrl;
/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileModelCopyWith<UserProfileModel> get copyWith => _$UserProfileModelCopyWithImpl<UserProfileModel>(this as UserProfileModel, _$identity);

  /// Serializes this UserProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfileModel&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,fullName,imageUrl);

@override
String toString() {
  return 'UserProfileModel(userName: $userName, fullName: $fullName, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $UserProfileModelCopyWith<$Res>  {
  factory $UserProfileModelCopyWith(UserProfileModel value, $Res Function(UserProfileModel) _then) = _$UserProfileModelCopyWithImpl;
@useResult
$Res call({
 String? userName, String? fullName, String? imageUrl
});




}
/// @nodoc
class _$UserProfileModelCopyWithImpl<$Res>
    implements $UserProfileModelCopyWith<$Res> {
  _$UserProfileModelCopyWithImpl(this._self, this._then);

  final UserProfileModel _self;
  final $Res Function(UserProfileModel) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = freezed,Object? fullName = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfileModel].
extension UserProfileModelPatterns on UserProfileModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( UserProfile value)?  $default,{TResult Function( _UserProfileUpdate value)?  update,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserProfile() when $default != null:
return $default(_that);case _UserProfileUpdate() when update != null:
return update(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( UserProfile value)  $default,{required TResult Function( _UserProfileUpdate value)  update,}){
final _that = this;
switch (_that) {
case UserProfile():
return $default(_that);case _UserProfileUpdate():
return update(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( UserProfile value)?  $default,{TResult? Function( _UserProfileUpdate value)?  update,}){
final _that = this;
switch (_that) {
case UserProfile() when $default != null:
return $default(_that);case _UserProfileUpdate() when update != null:
return update(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userName,  String? fullName,  String? imageUrl,  DateTime createdAt)?  $default,{TResult Function( String? userName,  String? fullName,  String? imageUrl,  bool clearUserName,  bool clearFullName,  bool clearImageUrl)?  update,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserProfile() when $default != null:
return $default(_that.id,_that.userName,_that.fullName,_that.imageUrl,_that.createdAt);case _UserProfileUpdate() when update != null:
return update(_that.userName,_that.fullName,_that.imageUrl,_that.clearUserName,_that.clearFullName,_that.clearImageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userName,  String? fullName,  String? imageUrl,  DateTime createdAt)  $default,{required TResult Function( String? userName,  String? fullName,  String? imageUrl,  bool clearUserName,  bool clearFullName,  bool clearImageUrl)  update,}) {final _that = this;
switch (_that) {
case UserProfile():
return $default(_that.id,_that.userName,_that.fullName,_that.imageUrl,_that.createdAt);case _UserProfileUpdate():
return update(_that.userName,_that.fullName,_that.imageUrl,_that.clearUserName,_that.clearFullName,_that.clearImageUrl);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userName,  String? fullName,  String? imageUrl,  DateTime createdAt)?  $default,{TResult? Function( String? userName,  String? fullName,  String? imageUrl,  bool clearUserName,  bool clearFullName,  bool clearImageUrl)?  update,}) {final _that = this;
switch (_that) {
case UserProfile() when $default != null:
return $default(_that.id,_that.userName,_that.fullName,_that.imageUrl,_that.createdAt);case _UserProfileUpdate() when update != null:
return update(_that.userName,_that.fullName,_that.imageUrl,_that.clearUserName,_that.clearFullName,_that.clearImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class UserProfile extends UserProfileModel {
  const UserProfile({required this.id, required this.userName, required this.fullName, required this.imageUrl, required this.createdAt, final  String? $type}): $type = $type ?? 'default',super._();
  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

/// UserProfiles share a primary key with Serverpod [AuthUser] records
 final  String id;
@override final  String? userName;
@override final  String? fullName;
@override final  String? imageUrl;
 final  DateTime createdAt;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userName,fullName,imageUrl,createdAt);

@override
String toString() {
  return 'UserProfileModel(id: $id, userName: $userName, fullName: $fullName, imageUrl: $imageUrl, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res> implements $UserProfileModelCopyWith<$Res> {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userName, String? fullName, String? imageUrl, DateTime createdAt
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userName = freezed,Object? fullName = freezed,Object? imageUrl = freezed,Object? createdAt = null,}) {
  return _then(UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class _UserProfileUpdate extends UserProfileModel {
  const _UserProfileUpdate({this.userName, this.fullName, this.imageUrl, this.clearUserName = false, this.clearFullName = false, this.clearImageUrl = false, final  String? $type}): $type = $type ?? 'update',super._();
  factory _UserProfileUpdate.fromJson(Map<String, dynamic> json) => _$UserProfileUpdateFromJson(json);

/// The user's new userName. Only truthy values are considered here. To
/// delete the `userName` field, set [clearUserName] to true.
@override final  String? userName;
/// The user's new fullName. Only truthy values are considered here. To
/// delete the `fullName` field, set [clearFullName] to true.
@override final  String? fullName;
/// The user's new imageUrl. Only truthy values are considered here. To
/// delete the `imageUrl` field, set [clearImageUrl] to true.
@override final  String? imageUrl;
/// If true, delete any userName value from the database.
@JsonKey() final  bool clearUserName;
/// If true, delete any fullName value from the database.
@JsonKey() final  bool clearFullName;
/// If true, delete any imageUrl value from the database.
@JsonKey() final  bool clearImageUrl;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileUpdateCopyWith<_UserProfileUpdate> get copyWith => __$UserProfileUpdateCopyWithImpl<_UserProfileUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfileUpdate&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.clearUserName, clearUserName) || other.clearUserName == clearUserName)&&(identical(other.clearFullName, clearFullName) || other.clearFullName == clearFullName)&&(identical(other.clearImageUrl, clearImageUrl) || other.clearImageUrl == clearImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userName,fullName,imageUrl,clearUserName,clearFullName,clearImageUrl);

@override
String toString() {
  return 'UserProfileModel.update(userName: $userName, fullName: $fullName, imageUrl: $imageUrl, clearUserName: $clearUserName, clearFullName: $clearFullName, clearImageUrl: $clearImageUrl)';
}


}

/// @nodoc
abstract mixin class _$UserProfileUpdateCopyWith<$Res> implements $UserProfileModelCopyWith<$Res> {
  factory _$UserProfileUpdateCopyWith(_UserProfileUpdate value, $Res Function(_UserProfileUpdate) _then) = __$UserProfileUpdateCopyWithImpl;
@override @useResult
$Res call({
 String? userName, String? fullName, String? imageUrl, bool clearUserName, bool clearFullName, bool clearImageUrl
});




}
/// @nodoc
class __$UserProfileUpdateCopyWithImpl<$Res>
    implements _$UserProfileUpdateCopyWith<$Res> {
  __$UserProfileUpdateCopyWithImpl(this._self, this._then);

  final _UserProfileUpdate _self;
  final $Res Function(_UserProfileUpdate) _then;

/// Create a copy of UserProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = freezed,Object? fullName = freezed,Object? imageUrl = freezed,Object? clearUserName = null,Object? clearFullName = null,Object? clearImageUrl = null,}) {
  return _then(_UserProfileUpdate(
userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,clearUserName: null == clearUserName ? _self.clearUserName : clearUserName // ignore: cast_nullable_to_non_nullable
as bool,clearFullName: null == clearFullName ? _self.clearFullName : clearFullName // ignore: cast_nullable_to_non_nullable
as bool,clearImageUrl: null == clearImageUrl ? _self.clearImageUrl : clearImageUrl // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
