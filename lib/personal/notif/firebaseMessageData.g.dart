// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebaseMessageData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseMessageData _$FirebaseMessageDataFromJson(Map<String, dynamic> json) {
  return FirebaseMessageData(
      notification: json['notification'] == null
          ? null
          : Notification.fromJson(json['notification'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FirebaseMessageDataToJson(
        FirebaseMessageData instance) =>
    <String, dynamic>{
      'notification': instance.notification,
      'data': instance.data
    };

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
      title: json['title'] as String, body: json['body'] as String);
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{'title': instance.title, 'body': instance.body};

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(title: json['title'] as String, body: json['body'] as String);
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'title': instance.title, 'body': instance.body};
