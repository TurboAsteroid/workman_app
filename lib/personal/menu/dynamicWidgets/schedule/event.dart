import 'package:flutter/material.dart';

abstract class ListScheduleEvent {}

class GetData extends ListScheduleEvent {
  BuildContext context;
  String url;

  GetData(this.context, this.url);

  @override
  String toString() => 'GetData';
}
