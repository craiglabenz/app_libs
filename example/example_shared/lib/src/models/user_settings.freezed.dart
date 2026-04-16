// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
UserSettingsModel _$UserSettingsModelFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'default':
          return UserSettings.fromJson(
            json
          );
                case 'update':
          return UserSettingsUpdate.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'UserSettingsModel',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$UserSettingsModel {

/// User email address, possibly sourced from a variety of places.
 String? get email;
/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsModelCopyWith<UserSettingsModel> get copyWith => _$UserSettingsModelCopyWithImpl<UserSettingsModel>(this as UserSettingsModel, _$identity);

  /// Serializes this UserSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsModel&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'UserSettingsModel(email: $email)';
}


}

/// @nodoc
abstract mixin class $UserSettingsModelCopyWith<$Res>  {
  factory $UserSettingsModelCopyWith(UserSettingsModel value, $Res Function(UserSettingsModel) _then) = _$UserSettingsModelCopyWithImpl;
@useResult
$Res call({
 String? email
});




}
/// @nodoc
class _$UserSettingsModelCopyWithImpl<$Res>
    implements $UserSettingsModelCopyWith<$Res> {
  _$UserSettingsModelCopyWithImpl(this._self, this._then);

  final UserSettingsModel _self;
  final $Res Function(UserSettingsModel) _then;

/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,}) {
  return _then(_self.copyWith(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettingsModel].
extension UserSettingsModelPatterns on UserSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( UserSettings value)?  $default,{TResult Function( UserSettingsUpdate value)?  update,required TResult orElse(),}){
final _that = this;
switch (_that) {
case UserSettings() when $default != null:
return $default(_that);case UserSettingsUpdate() when update != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( UserSettings value)  $default,{required TResult Function( UserSettingsUpdate value)  update,}){
final _that = this;
switch (_that) {
case UserSettings():
return $default(_that);case UserSettingsUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( UserSettings value)?  $default,{TResult? Function( UserSettingsUpdate value)?  update,}){
final _that = this;
switch (_that) {
case UserSettings() when $default != null:
return $default(_that);case UserSettingsUpdate() when update != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? email,  String loggingId)?  $default,{TResult Function( String? email,  bool clearEmail)?  update,required TResult orElse(),}) {final _that = this;
switch (_that) {
case UserSettings() when $default != null:
return $default(_that.email,_that.loggingId);case UserSettingsUpdate() when update != null:
return update(_that.email,_that.clearEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? email,  String loggingId)  $default,{required TResult Function( String? email,  bool clearEmail)  update,}) {final _that = this;
switch (_that) {
case UserSettings():
return $default(_that.email,_that.loggingId);case UserSettingsUpdate():
return update(_that.email,_that.clearEmail);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? email,  String loggingId)?  $default,{TResult? Function( String? email,  bool clearEmail)?  update,}) {final _that = this;
switch (_that) {
case UserSettings() when $default != null:
return $default(_that.email,_that.loggingId);case UserSettingsUpdate() when update != null:
return update(_that.email,_that.clearEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class UserSettings extends UserSettingsModel {
  const UserSettings({required this.email, required this.loggingId, final  String? $type}): $type = $type ?? 'default',super._();
  factory UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);

/// User email address, possibly sourced from a variety of places.
@override final  String? email;
/// Uuid prefixed to all logging statemenets to allow per-user filtering
/// in logging backends.
 final  String loggingId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.email, email) || other.email == email)&&(identical(other.loggingId, loggingId) || other.loggingId == loggingId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,loggingId);

@override
String toString() {
  return 'UserSettingsModel(email: $email, loggingId: $loggingId)';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res> implements $UserSettingsModelCopyWith<$Res> {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 String? email, String loggingId
});




}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? loggingId = null,}) {
  return _then(UserSettings(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,loggingId: null == loggingId ? _self.loggingId : loggingId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UserSettingsUpdate extends UserSettingsModel {
  const UserSettingsUpdate({this.email, this.clearEmail = false, final  String? $type}): $type = $type ?? 'update',super._();
  factory UserSettingsUpdate.fromJson(Map<String, dynamic> json) => _$UserSettingsUpdateFromJson(json);

/// The user's new email. Only truthy values are considered here. To
/// delete the `email` field, set [clearEmail] to true.
@override final  String? email;
/// Whether to clear the user's email address.
@JsonKey() final  bool clearEmail;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsUpdateCopyWith<UserSettingsUpdate> get copyWith => _$UserSettingsUpdateCopyWithImpl<UserSettingsUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSettingsUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsUpdate&&(identical(other.email, email) || other.email == email)&&(identical(other.clearEmail, clearEmail) || other.clearEmail == clearEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,clearEmail);

@override
String toString() {
  return 'UserSettingsModel.update(email: $email, clearEmail: $clearEmail)';
}


}

/// @nodoc
abstract mixin class $UserSettingsUpdateCopyWith<$Res> implements $UserSettingsModelCopyWith<$Res> {
  factory $UserSettingsUpdateCopyWith(UserSettingsUpdate value, $Res Function(UserSettingsUpdate) _then) = _$UserSettingsUpdateCopyWithImpl;
@override @useResult
$Res call({
 String? email, bool clearEmail
});




}
/// @nodoc
class _$UserSettingsUpdateCopyWithImpl<$Res>
    implements $UserSettingsUpdateCopyWith<$Res> {
  _$UserSettingsUpdateCopyWithImpl(this._self, this._then);

  final UserSettingsUpdate _self;
  final $Res Function(UserSettingsUpdate) _then;

/// Create a copy of UserSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? clearEmail = null,}) {
  return _then(UserSettingsUpdate(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,clearEmail: null == clearEmail ? _self.clearEmail : clearEmail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
