import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../index.dart';
import './event.dart';
import './state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final storage = new FlutterSecureStorage();

  @override
  SettingsState get initialState => SettingsInit();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SetPin) {
      await storage.write(key: 'pin', value: event.pin);
      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(
          builder: (BuildContext context) => Index(),
          settings: RouteSettings(name: 'Index'),
        ),
        (Route<dynamic> route) => false,
      );
      return;
    }
    if (event is Cancel) {
      await storage.delete(key: 'pin');
      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(
          builder: (BuildContext context) => Index(),
          settings: RouteSettings(name: 'Index'),
        ),
        (Route<dynamic> route) => false,
      );
      return;
    }
    if (event is SetPollsVisualisation) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (event.pollsVisualisation) {
        // Каждый вопрос на отдельном экране
        prefs.setBool('polls_eachQuestionOnaSeparateScreen', true);
      } else {
        prefs.setBool('polls_eachQuestionOnaSeparateScreen', false);
      }
    }
  }
}
