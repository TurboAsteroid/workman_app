// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Check _$CheckFromJson(Map<String, dynamic> json) {
  return Check(
      dateTime: json['dateTime'] as String,
      checkPoint: json['checkPoint'] as String);
}

Map<String, dynamic> _$CheckToJson(Check instance) => <String, dynamic>{
      'dateTime': instance.dateTime,
      'checkPoint': instance.checkPoint
    };
