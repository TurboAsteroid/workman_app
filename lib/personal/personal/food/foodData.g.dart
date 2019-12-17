// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foodData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodData _$FoodDataFromJson(Map<String, dynamic> json) {
  return FoodData(
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Voucher.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$FoodDataToJson(FoodData instance) =>
    <String, dynamic>{'data': instance.data};

Voucher _$VoucherFromJson(Map<String, dynamic> json) {
  return Voucher(
      norma: json['norma'] as int,
      name: json['name'] as String,
      available: json['available'] as int,
      used: json['used'] as String);
}

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'norma': instance.norma,
      'name': instance.name,
      'available': instance.available,
      'used': instance.used
    };
