import 'package:json_annotation/json_annotation.dart';

part 'busForecast.g.dart';

@JsonSerializable()
class BusForecast{
  BusForecast({this.id,this.forecast});

  factory BusForecast.fromJson(Map<String, dynamic> json) => _$BusForecastFromJson(json);

  Map<String, dynamic> toJson() => _$BusForecastToJson(this);

  String forecast;
  int id;
}
