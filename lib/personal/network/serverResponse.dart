import 'dart:convert';

class ServerResponse {
  String status;
  Map data;

  ServerResponse({this.status, this.data});

  ServerResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] is List) {
      data = { 'list': json['data'] };
    } else {
      data = json['data'];
    }
  }

  @override
  String toString() {
    return '{status: $status, data: ${json.encode(data)}}';
  }
}