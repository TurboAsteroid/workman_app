import 'package:personal/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:personal/personal/network/serverResponse.dart';

Future<ServerResponse> ajaxGet(String url) async {
  String token = await (FlutterSecureStorage()).read(key: 'token');
  try {
    var response = await http.get(apiServer + '/$url', headers: {
      'Authorization': token,
      'Content-Type': 'application/json; charset=utf-8'
    });
    if (response.statusCode == 401) {
      return ServerResponse(
          status: '401', data: {"message": response.reasonPhrase});
    } else if (response.statusCode == 200) {
      return ServerResponse.fromJson(json.decode(response.body));
    }
    return ServerResponse(
        status: '-1', data: {'message': 'Неизвестная ошибка'});
  } catch (e) {
    return ServerResponse(status: '-1', data: {'message': e.toString()});
  }
}
