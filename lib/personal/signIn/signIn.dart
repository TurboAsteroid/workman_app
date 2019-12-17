import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:personal/personal/signIn/bloc.dart';
import 'package:personal/personal/signIn/userPassword.dart';
import 'package:personal/personal/workmanElemAppHeader.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: workmanElemAppHeader(),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(32),
        child: LoginForm(),
      )),
      bottomSheet: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('v.$_version'),
              GestureDetector(
                  child: Text('Пользовательское соглашение',
                      style: TextStyle(color: Colors.blue)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsOfUse(),
                          settings: RouteSettings(name: 'TermsOfUse'),
                        ));
                  })
            ],
          )),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final LoginBloc _loginBloc = LoginBloc();

  final _formKey = new GlobalKey<FormState>();
  String _user;
  String _password;

  @override
  void initState() {
    super.initState();
  }

  bool accept = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      bloc: _loginBloc,
      builder: (BuildContext context, LoginState state) {
        if (state is LoginInit) {
          return _from(null);
        }
        if (state is LoginError) {
          return _from(state.error);
        }
        return Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('Информация'),
          content: new Text(
              'Восстановить пароль можно в Информационном киоске в разделе ЭЛЕМ Персонал'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _from(String error) {
    return Form(
      key: _formKey,
      child: new Column(
        children: <Widget>[
          _showPhoneInput(),
          _showPasswordInput(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CheckboxListTile(
              title: Text(
                  'Я ознакомлен(а) и согласен(а) с Пользовательским соглашением'),
              value: accept,
              onChanged: (bool value) {
                setState(() {
                  accept = !accept;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ),
          error != null ? _showErrorMessage(error) : Container(),
          _showPrimaryButton(),
          FlatButton(child: Text('Забыли пароль?'), onPressed: _showDialog),
        ],
      ),
    );
  }

  Widget _showPhoneInput() {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      maxLength: 10,
      maxLines: 1,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: new InputDecoration(
        prefixText: '+7',
        hintText: 'Номер телефона',
        prefixIcon: new Icon(Icons.phone),
      ),
      validator: (value) {
        if (value.isEmpty) return 'Введите номер телефона';
        if (value.length != 10)
          return 'Номер телефона должен состоять из 10 цифр';
        return null;
      },
      onSaved: (value) => _user = value,
    );
  }

  bool eye = true;

  void onFieldSubmitted(String v) {
    final form = _formKey.currentState;
    if (form.validate() && accept) {
      form.save();
      _loginBloc.add(DoLoginEvent(
          context, UserPassword(user: _user, password: _password), _loginBloc));
    }
  }

  Widget _showPasswordInput() {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      maxLines: 1,
      obscureText: eye,
      autofocus: false,
      decoration: new InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            this.eye ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () => setState(() {
            this.eye = !this.eye;
          }),
        ),
        prefixText: '    ',
        hintText: 'Пароль',
        prefixIcon: new Icon(Icons.lock),
      ),
      validator: (value) => value.isEmpty ? 'Введите пароль' : null,
      onSaved: (value) => _password = value,
    );
  }

  Widget _showPrimaryButton() {
    return ButtonTheme(
      buttonColor: Colors.blue,
      minWidth: (MediaQuery.of(context).size.width * 0.4),
      child: RaisedButton(
        child: Text(
          'Вход',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: accept
            ? () {
                final form = _formKey.currentState;
                if (form.validate()) {
                  form.save();
                  _loginBloc.add(DoLoginEvent(
                      context,
                      UserPassword(user: _user, password: _password),
                      _loginBloc));
                  return true;
                }
                return false;
              }
            : null,
      ),
    );
  }

  Widget _showErrorMessage(String txt) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        txt,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      ),
    );
  }
}

class TermsOfUse extends StatelessWidget {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('Пользовательское соглашение'),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl:
              'file:///android_asset/flutter_assets/assets/TermsOfUse.html',
          javascriptMode: JavascriptMode.disabled,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        );
      }),
    );
  }
}
