// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProResult _$ProResultFromJson(Map<String, dynamic> json) {
  return ProResult(
      name: json['name'] as String,
      plan: json['plan'] as int,
      fact: json['fact'] as int,
      left: json['left'] as int)
    ..img = json['img'] as String;
}

Map<String, dynamic> _$ProResultToJson(ProResult instance) => <String, dynamic>{
      'name': instance.name,
      'plan': instance.plan,
      'fact': instance.fact,
      'left': instance.left,
      'img': instance.img
    };
