import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:personal/personal/settings/bloc.dart';
import 'package:personal/personal/settings/event.dart';

class PollsSettings extends StatefulWidget {
  final SettingsBloc settingsBloc;

  PollsSettings(this.settingsBloc);

  @override
  _PollsSettingsState createState() => _PollsSettingsState();
}

class _PollsSettingsState extends State<PollsSettings> {
  bool _value;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs){
      _value = prefs.getBool('polls_eachQuestionOnaSeparateScreen');
      if(_value == null) {
        prefs.setBool('polls_eachQuestionOnaSeparateScreen', true);
      }
      setState(() {
        _value = prefs.getBool('polls_eachQuestionOnaSeparateScreen');
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16),
          height: 34,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.question_answer,
                color: Colors.black87,
              ),
              Text(
                'Опросы',
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            'Способ отображения опросов',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(child: Text('Каждый вопрос на отдельном экране')),
              _value == null ? Container() : Switch(value: _value, onChanged: _onChanged),
            ],
          ),
        ),
      ],
    );
  }

  void _onChanged(bool value) {
    widget.settingsBloc.add(SetPollsVisualisation(value));
    setState(() {
      _value = value;
    });
  }
}
