import 'package:json_annotation/json_annotation.dart';

part 'firebaseMessageData.g.dart';

@JsonSerializable()
class FirebaseMessageData {
  FirebaseMessageData({this.notification, this.data});

  factory FirebaseMessageData.fromJson(Map<String, dynamic> json) =>
      _$FirebaseMessageDataFromJson(json);

  Map<dynamic, dynamic> toJson() => _$FirebaseMessageDataToJson(this);

  Notification notification;
  Data data;
}

@JsonSerializable()
class Notification {

  Notification({this.title, this.body});

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<dynamic, dynamic> toJson() => _$NotificationToJson(this);

  String title;
  String body;
}

@JsonSerializable()
class Data {
  Data({this.title, this.body});

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<dynamic, dynamic> toJson() => _$DataToJson(this);

  String title;
  String body;
}