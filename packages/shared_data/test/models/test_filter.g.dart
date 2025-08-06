// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgEqualsFilter _$MsgEqualsFilterFromJson(Map<String, dynamic> json) =>
    MsgEqualsFilter(
      json['needle'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MsgEqualsFilterToJson(MsgEqualsFilter instance) =>
    <String, dynamic>{
      'needle': instance.needle,
      'runtimeType': instance.$type,
    };

MsgStartsWithFilter _$MsgStartsWithFilterFromJson(Map<String, dynamic> json) =>
    MsgStartsWithFilter(
      json['needle'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MsgStartsWithFilterToJson(
        MsgStartsWithFilter instance) =>
    <String, dynamic>{
      'needle': instance.needle,
      'runtimeType': instance.$type,
    };
