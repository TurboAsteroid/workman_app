import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:personal/personal/network/network.dart';

import './event.dart';
import './state.dart';

import 'card_schedule_data.dart';

class ListScheduleBloc extends Bloc<ListScheduleEvent, ListScheduleState> {
  @override
  ListScheduleState get initialState => ListScheduleInit();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Stream<ListScheduleState> mapEventToState(ListScheduleEvent event) async* {
    if (event is GetData) {
      ServerResponse sr = await ajaxGet(event.url);
      List<CardScheduleData> listOfCardScheduleData = [];
      for (int i = 0; i < sr.data['list'].length; i++) {
        listOfCardScheduleData.add(CardScheduleData.fromJson(sr.data['list'][i]));
      }
      _refreshController.refreshCompleted();
      yield ListScheduleData(listOfCardScheduleData, _refreshController);
    }
  }
}