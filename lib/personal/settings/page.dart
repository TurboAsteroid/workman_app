import 'package:flutter/material.dart';

import 'package:personal/personal/settings/bloc.dart';
import 'package:personal/personal/settings/parts/polls.dart';
import 'package:personal/personal/settings/parts/security.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final SettingsBloc settingsBloc = SettingsBloc();

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    // часть функционала выключена т.к. не одобрило сб
    return Scaffold(
        appBar: AppBar(
          title: Text("Настройки"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 8),
            child: Column(
              children: <Widget>[
//                SelectAvatar(),
//                Container(height: 12),
                Security(settingsBloc),
                Container(height: 12),
                PollsSettings(settingsBloc),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    settingsBloc.close();
    super.dispose();
  }
}
