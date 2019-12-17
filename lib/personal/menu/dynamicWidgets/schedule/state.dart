import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'card_schedule_data.dart';

abstract class ListScheduleState {}

class ListScheduleInit extends ListScheduleState {
  @override
  String toString() => 'ListScheduleInit';
}

class ListScheduleData extends ListScheduleState {
  List<CardScheduleData> listOfCardScheduleData;
  RefreshController refreshController;

  ListScheduleData(this.listOfCardScheduleData, this.refreshController);

  @override
  String toString() => 'ListScheduleData';
}

class ListScheduleError extends ListScheduleState {
  final String error;
  RefreshController refreshController;

  ListScheduleError(this.error, this.refreshController);

  @override
  String toString() => 'ListScheduleError';
}
