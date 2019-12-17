import 'package:flutter/material.dart';

import 'package:personal/personal/settings/bloc.dart';
import 'package:personal/personal/settings/parts/security.dart';

class SettingsPinScreenOnly extends StatefulWidget {
  @override
  _SettingsPinScreenOnlyState createState() => _SettingsPinScreenOnlyState();
}

class _SettingsPinScreenOnlyState extends State<SettingsPinScreenOnly> {
  final SettingsBloc settingsBloc = SettingsBloc();

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Установка pin-кода'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 8),
            child: Column(
              children: <Widget>[
                Security(settingsBloc),
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
