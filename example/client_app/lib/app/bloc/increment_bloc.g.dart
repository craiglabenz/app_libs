// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'increment_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IncrementEventImpl _$$IncrementEventImplFromJson(Map<String, dynamic> json) =>
    _$IncrementEventImpl(
      IncrementCreate.fromJson(json['incr'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$IncrementEventImplToJson(
        _$IncrementEventImpl instance) =>
    <String, dynamic>{
      'incr': instance.incr,
    };

_$IncrementStateImpl _$$IncrementStateImplFromJson(Map<String, dynamic> json) =>
    _$IncrementStateImpl(
      log: (json['log'] as List<dynamic>)
          .map((e) => Increment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$IncrementStateImplToJson(
        _$IncrementStateImpl instance) =>
    <String, dynamic>{
      'log': instance.log,
    };
