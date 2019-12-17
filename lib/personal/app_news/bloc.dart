import 'package:flutter/material.dart';

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:personal/personal/app_news/data.dart';
import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/network/serverResponse.dart';

class EventBloc extends Bloc<AppNewsEv, EventState> {
  final storage = new FlutterSecureStorage();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  EventState get initialState => AppNewsInitSt();

  @override
  Stream<EventState> mapEventToState(AppNewsEv event) async* {
    if (event is GetAppNewsEv) {
      ServerResponse sr = await ajaxGet(event.url);
      List<NewsInListData> listOfCardEventData = [];
      for (int i = 0; i < sr.data['list'].length; i++) {
        listOfCardEventData.add(NewsInListData.fromJson(sr.data['list'][i]));
      }
      String token = await storage.read(key: 'token');
      _refreshController.refreshCompleted();
      yield AppNewsLoadedSt(listOfCardEventData, token, _refreshController);
    }
  }
}

abstract class AppNewsEv {}

class GetAppNewsEv extends AppNewsEv {
  BuildContext context;
  String url;

  GetAppNewsEv(this.context, this.url);

  @override
  String toString() => 'GetAppNewsEv';
}

abstract class EventState {}

class AppNewsInitSt extends EventState {
  @override
  String toString() => 'AppNewsInitSt';
}

class AppNewsLoadedSt extends EventState {
  List<NewsInListData> newsInListData;
  String token;
  RefreshController refreshController;

  AppNewsLoadedSt(this.newsInListData, this.token, this.refreshController);

  @override
  String toString() => 'AppNewsLoadedSt';
}

class AppNewsErrorSt extends EventState {
  final String error;

  AppNewsErrorSt(this.error);

  @override
  String toString() => 'AppNewsErrorSt';
}
