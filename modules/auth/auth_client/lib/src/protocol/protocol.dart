/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:shared_data/shared_data.dart' as _i2;
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.AuthUser) {
      return _i2.AuthUser.fromJson(data) as T;
    }
    if (t == _i2.AuthResponse) {
      return _i2.AuthResponse.fromJson(data) as T;
    }
    if (t == _i2.AuthenticationError) {
      return _i2.AuthenticationError.fromJson(data) as T;
    }
    if (t == _i2.AuthProvider) {
      return _i2.AuthProvider.fromJson(data) as T;
    }
    if (t == _i2.AppleCredential) {
      return _i2.AppleCredential.fromJson(data) as T;
    }
    if (t == _i2.EmailCredential) {
      return _i2.EmailCredential.fromJson(data) as T;
    }
    if (t == _i2.GoogleCredential) {
      return _i2.GoogleCredential.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AuthUser?>()) {
      return (data != null ? _i2.AuthUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i2.AuthResponse?>()) {
      return (data != null ? _i2.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i2.AuthenticationError?>()) {
      return (data != null ? _i2.AuthenticationError.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i2.AuthProvider?>()) {
      return (data != null ? _i2.AuthProvider.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i2.AppleCredential?>()) {
      return (data != null ? _i2.AppleCredential.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i2.EmailCredential?>()) {
      return (data != null ? _i2.EmailCredential.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i2.GoogleCredential?>()) {
      return (data != null ? _i2.GoogleCredential.fromJson(data) : null) as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.AuthUser) {
      return 'AuthUser';
    }
    if (data is _i2.AuthResponse) {
      return 'AuthResponse';
    }
    if (data is _i2.AuthenticationError) {
      return 'AuthenticationError';
    }
    if (data is _i2.AuthProvider) {
      return 'AuthProvider';
    }
    if (data is _i2.AppleCredential) {
      return 'AppleCredential';
    }
    if (data is _i2.EmailCredential) {
      return 'EmailCredential';
    }
    if (data is _i2.GoogleCredential) {
      return 'GoogleCredential';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthUser') {
      return deserialize<_i2.AuthUser>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i2.AuthResponse>(data['data']);
    }
    if (dataClassName == 'AuthenticationError') {
      return deserialize<_i2.AuthenticationError>(data['data']);
    }
    if (dataClassName == 'AuthProvider') {
      return deserialize<_i2.AuthProvider>(data['data']);
    }
    if (dataClassName == 'AppleCredential') {
      return deserialize<_i2.AppleCredential>(data['data']);
    }
    if (dataClassName == 'EmailCredential') {
      return deserialize<_i2.EmailCredential>(data['data']);
    }
    if (dataClassName == 'GoogleCredential') {
      return deserialize<_i2.GoogleCredential>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
