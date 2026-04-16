// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthSession {

/// The active user's profile.
 UserProfile get profile;/// Meta information about the active user.
// required AuthInfo info,
/// All Idps the user has connected.
 Set<AuthProvider> get allProviders;/// The active user's settings.
 UserSettings get settings;
/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSessionCopyWith<AuthSession> get copyWith => _$AuthSessionCopyWithImpl<AuthSession>(this as AuthSession, _$identity);

  /// Serializes this AuthSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSession&&const DeepCollectionEquality().equals(other.profile, profile)&&const DeepCollectionEquality().equals(other.allProviders, allProviders)&&const DeepCollectionEquality().equals(other.settings, settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(profile),const DeepCollectionEquality().hash(allProviders),const DeepCollectionEquality().hash(settings));

@override
String toString() {
  return 'AuthSession(profile: $profile, allProviders: $allProviders, settings: $settings)';
}


}

/// @nodoc
abstract mixin class $AuthSessionCopyWith<$Res>  {
  factory $AuthSessionCopyWith(AuthSession value, $Res Function(AuthSession) _then) = _$AuthSessionCopyWithImpl;
@useResult
$Res call({
 UserProfile profile, Set<AuthProvider> allProviders, UserSettings settings
});




}
/// @nodoc
class _$AuthSessionCopyWithImpl<$Res>
    implements $AuthSessionCopyWith<$Res> {
  _$AuthSessionCopyWithImpl(this._self, this._then);

  final AuthSession _self;
  final $Res Function(AuthSession) _then;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? allProviders = null,Object? settings = freezed,}) {
  return _then(_self.copyWith(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile,allProviders: null == allProviders ? _self.allProviders : allProviders // ignore: cast_nullable_to_non_nullable
as Set<AuthProvider>,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettings,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthSession].
extension AuthSessionPatterns on AuthSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthSession value)  $default,){
final _that = this;
switch (_that) {
case _AuthSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthSession value)?  $default,){
final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserProfile profile,  Set<AuthProvider> allProviders,  UserSettings settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that.profile,_that.allProviders,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserProfile profile,  Set<AuthProvider> allProviders,  UserSettings settings)  $default,) {final _that = this;
switch (_that) {
case _AuthSession():
return $default(_that.profile,_that.allProviders,_that.settings);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserProfile profile,  Set<AuthProvider> allProviders,  UserSettings settings)?  $default,) {final _that = this;
switch (_that) {
case _AuthSession() when $default != null:
return $default(_that.profile,_that.allProviders,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthSession extends AuthSession {
  const _AuthSession({required this.profile, required final  Set<AuthProvider> allProviders, required this.settings}): _allProviders = allProviders,super._();
  factory _AuthSession.fromJson(Map<String, dynamic> json) => _$AuthSessionFromJson(json);

/// The active user's profile.
@override final  UserProfile profile;
/// Meta information about the active user.
// required AuthInfo info,
/// All Idps the user has connected.
 final  Set<AuthProvider> _allProviders;
/// Meta information about the active user.
// required AuthInfo info,
/// All Idps the user has connected.
@override Set<AuthProvider> get allProviders {
  if (_allProviders is EqualUnmodifiableSetView) return _allProviders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_allProviders);
}

/// The active user's settings.
@override final  UserSettings settings;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthSessionCopyWith<_AuthSession> get copyWith => __$AuthSessionCopyWithImpl<_AuthSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthSession&&const DeepCollectionEquality().equals(other.profile, profile)&&const DeepCollectionEquality().equals(other._allProviders, _allProviders)&&const DeepCollectionEquality().equals(other.settings, settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(profile),const DeepCollectionEquality().hash(_allProviders),const DeepCollectionEquality().hash(settings));

@override
String toString() {
  return 'AuthSession(profile: $profile, allProviders: $allProviders, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$AuthSessionCopyWith<$Res> implements $AuthSessionCopyWith<$Res> {
  factory _$AuthSessionCopyWith(_AuthSession value, $Res Function(_AuthSession) _then) = __$AuthSessionCopyWithImpl;
@override @useResult
$Res call({
 UserProfile profile, Set<AuthProvider> allProviders, UserSettings settings
});




}
/// @nodoc
class __$AuthSessionCopyWithImpl<$Res>
    implements _$AuthSessionCopyWith<$Res> {
  __$AuthSessionCopyWithImpl(this._self, this._then);

  final _AuthSession _self;
  final $Res Function(_AuthSession) _then;

/// Create a copy of AuthSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? allProviders = null,Object? settings = freezed,}) {
  return _then(_AuthSession(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile,allProviders: null == allProviders ? _self._allProviders : allProviders // ignore: cast_nullable_to_non_nullable
as Set<AuthProvider>,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettings,
  ));
}


}

// dart format on
