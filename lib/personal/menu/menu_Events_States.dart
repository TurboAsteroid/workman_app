import 'package:flutter/material.dart';

abstract class MenuEvent {
  BuildContext context;

  MenuEvent({this.context});
}

class CreateMenu extends MenuEvent {
  CreateMenu(context) : super(context: context);

  @override
  String toString() => 'CreateMenu';
}

class LoadingMenu extends MenuEvent {
  @override
  String toString() => 'LoadingMenu';
}

abstract class MenuState {}

class DrawMenu extends MenuState {
  List<Widget> widgets;

  DrawMenu(this.widgets);

  @override
  String toString() => 'DrawMenu';
}

class Init extends MenuState {
  @override
  String toString() => 'Init';
}

class Loading extends MenuState {
  @override
  String toString() => 'Loading';
}
