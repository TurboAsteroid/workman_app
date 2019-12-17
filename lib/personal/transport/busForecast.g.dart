// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'busForecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusForecast _$BusForecastFromJson(Map<String, dynamic> json) {
  return BusForecast(
      id: json['id'] as int, forecast: json['forecast'] as String);
}

Map<String, dynamic> _$BusForecastToJson(BusForecast instance) =>
    <String, dynamic>{'forecast': instance.forecast, 'id': instance.id};
