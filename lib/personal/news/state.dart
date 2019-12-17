import 'package:pull_to_refresh/pull_to_refresh.dart';

import './news_data.dart';

abstract class VkState {}

class VkInit extends VkState {
  @override
  String toString() => 'VkInit';
}

class VkData extends VkState {
  News listOfCardNewsData;
  RefreshController refreshController;

  VkData(this.listOfCardNewsData, this.refreshController);

  @override
  String toString() => 'VkData';
}

class VkError extends VkState {
  final String error;
  RefreshController refreshController;

  VkError(this.error, this.refreshController);

  @override
  String toString() => 'VkError';
}
