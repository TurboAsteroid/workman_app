import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:personal/personal/settings/bloc.dart';
import 'package:personal/personal/settings/event.dart';
import 'package:personal/personal/settings/state.dart';

class Security extends StatefulWidget {
  final SettingsBloc settingsBloc;

  Security(this.settingsBloc);

  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      bloc: widget.settingsBloc,
      builder: (BuildContext context, SettingsState state) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16),
              height: 34,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.security,
                    color: Colors.black87,
                  ),
                  Text(
                    "Безопасность",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(
                    'Для быстрого и безопасного входа в систему вы можете задать четырехзначный PIN-код',
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  alignment: Alignment.center,
                  child: _from(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  String _pin = '';
  bool eye = true;

  Widget _from() {
    return Container(
      alignment: Alignment.center,
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _showPasswordInput(),
            _buttons(),
          ],
        ),
      ),
    );
  }

  Widget _showPasswordInput() {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLines: 1,
      maxLength: 4,
      obscureText: eye,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Введите PIN',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              this.eye ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () => setState(() {
              this.eye = !this.eye;
            }),
          )),
      validator: (value) {
        if (value.isEmpty) return 'Введите постоянный PIN-код';
        if (value.length != 4) return 'PIN-код должен быть четырехзначным';
        return null;
      },
      onSaved: (value) => _pin = value,
    );
  }

  Widget _buttons() {
    return Column(
      children: <Widget>[
        ButtonTheme(
          buttonColor: Colors.blue,
          minWidth: (MediaQuery.of(context).size.width * 0.9),
          child: RaisedButton(
            child: Text(
              'Установить PIN-код',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              final form = _formKey.currentState;
              form.save();
              if (form.validate()) {
                if (_pin.length == 4) {
                  widget.settingsBloc.add(SetPin(context, _pin));
                  return true;
                } else {
                  form.validate();
                }
              }
              return false;
            },
          ),
        ),
        ButtonTheme(
          buttonColor: Colors.white70,
          minWidth: (MediaQuery.of(context).size.width * 0.9),
          child: FlatButton(
            child: Text(
              'Не использовать PIN-код',
            ),
            onPressed: () {
              widget.settingsBloc.add(Cancel(context));
            },
          ),
        ),
      ],
    );
  }
}
