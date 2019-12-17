import 'package:json_annotation/json_annotation.dart';

part 'check.g.dart';

@JsonSerializable()
class Check {
  Check({this.dateTime, this.checkPoint});

  factory Check.fromJson(Map<String, dynamic> json) =>
      _$CheckFromJson(json);

  Map<String, dynamic> toJson() => _$CheckToJson(this);

  String dateTime;
  String checkPoint;
}
