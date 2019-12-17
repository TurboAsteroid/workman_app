import 'package:json_annotation/json_annotation.dart';

part 'proResult.g.dart';

@JsonSerializable()
class ProResult {
  ProResult({this.name, this.plan, this.fact, this.left});

  factory ProResult.fromJson(Map<String, dynamic> json) => _$ProResultFromJson(json);

  Map<String, dynamic> toJson() => _$ProResultToJson(this);

  String name;
  int plan;
  int fact;
  int left;
  String img;
}
