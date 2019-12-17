import 'dart:convert';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import './event.dart';
import './state.dart';
import './news_data.dart';

class VkBloc extends Bloc<VkEvent, VkState> {
  final storage = new FlutterSecureStorage();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  VkState get initialState => VkInit();

  @override
  Stream<VkState> mapEventToState(VkEvent event) async* {
    if (event is VkGetData) {
      Map res = await vkGet();
      _refreshController.refreshCompleted();
      try {
        News news = News.fromJson(res);
        yield VkData(news, _refreshController);
      } catch (e) {
        yield VkError(e.toString(), _refreshController);
      }
    }
  }
}

Future<Map> vkGet() async {
  Map<String, dynamic> body = {
    "status": "NOK",
    "data": "Некорректный запрос или доступ запрещен"
  };
  try {
    var response = await http.get(
        'https://api.vk.com/method/wall.get?owner_id=-154991285&v=5.92&count=100&access_token=a9b073c6a9b073c6a9b073c673a9d9d46faa9b0a9b073c6f5129d485d18f22b5041ecb0');
    if (response.statusCode != 200) {
      throw {
        "data": "Ошибка доступа к api vk. Код ошибки неизвестен.",
        "status": "ACCESS ERROR"
      };
    }
    if (response.statusCode == 401) {
      throw {
        "data": "Ошибка доступа к api vk. Доступ запрещен",
        "status": "ACCESS ERROR"
      };
    }
    body = json.decode(response.body);
  } catch (e) {
    return {"status": "NOK", "data": e};
  }
  return body;
}
