// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'increment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IncrementImpl _$$IncrementImplFromJson(Map<String, dynamic> json) =>
    _$IncrementImpl(
      id: json['id'] as String,
      delta: json['delta'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$IncrementImplToJson(_$IncrementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'delta': instance.delta,
      'createdAt': instance.createdAt.toIso8601String(),
      'runtimeType': instance.$type,
    };

_$IncrementCreateImpl _$$IncrementCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$IncrementCreateImpl(
      delta: json['delta'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$IncrementCreateImplToJson(
        _$IncrementCreateImpl instance) =>
    <String, dynamic>{
      'delta': instance.delta,
      'createdAt': instance.createdAt.toIso8601String(),
      'runtimeType': instance.$type,
    };
