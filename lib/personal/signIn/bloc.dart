import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import 'package:personal/config.dart';
import 'package:personal/personal/index.dart';
import 'package:personal/personal/settings/settingsPinScreenOnly.dart';
import 'package:personal/personal/signIn/setPassword.dart';
import 'package:personal/personal/signIn/signIn.dart';
import 'package:personal/personal/signIn/userPassword.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final storage = new FlutterSecureStorage();

  @override
  LoginState get initialState => LoginInit();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is DoLoginEvent) {
      await storage.delete(key: 'token');
      yield LoginShowPreloader();
      try {
        FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
        event.userPassword.firebaseToken = await _firebaseMessaging.getToken();
        if (event.userPassword.user != null)
          await storage.write(key: 'user', value: event.userPassword.user);
        final res = await http.post('$apiServer/auth/login',
            body: jsonEncode(event.userPassword.toJson()),
            headers: {
              'Authorization': '',
              'Content-Type': 'application/json; charset=utf-8'
            });
        if (res.statusCode == 200) {
          final body = json.decode(res.body);
          if (body["tmpPass"] == true) {
            yield SetPasswordFormState();
            Navigator.pushAndRemoveUntil(
              event.context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    SetPassword(event.userPassword, event.loginBloc),
                settings: RouteSettings(name: 'SetPassword'),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            switch (body["status"]) {
              case "TOKEN":
                await storage.write(
                    key: 'token', value: 'BEARER ' + body["data"]);
                if (event.userPassword.user != null)
                  await storage.write(
                      key: 'user', value: event.userPassword.user);
                Navigator.pushAndRemoveUntil(
                  event.context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Index(),
                    settings: RouteSettings(name: 'Index'),
                  ),
                  (Route<dynamic> route) => false,
                );
                break;
              default:
                await storage.delete(key: 'token');
                await storage.delete(key: 'user');
                Navigator.pushAndRemoveUntil(
                  event.context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignIn(),
                    settings: RouteSettings(name: 'SignIn'),
                  ),
                  (Route<dynamic> route) => false,
                );
                break;
            }
          }
        } else {
          throw 'Учетные данные введены некорректно';
        }
      } catch (e) {
        yield LoginError(e.toString());
      }
    }
    if (event is DoChangePassEvent) {
      yield LoginShowPreloader();
      try {
        Map body = {
          "user": event.userPassword.user,
          "password": event.userPassword.password, // здесь новый пароль
          'tmpPass': event.tmpPass // здесь временный пароль
        };
        if (event.userPassword.user != null)
          await storage.write(key: 'user', value: event.userPassword.user);
        final res = await http.post('$apiServer/getApplication/recover',
            body: json.encode(body),
            headers: {
              'Authorization': '',
              'Content-Type': 'application/json; charset=utf-8'
            });
        if (res.statusCode == 200) {
          final body = json.decode(res.body);
          switch (body["status"]) {
            case "TOKEN":
              await storage.write(
                  key: 'token', value: 'BEARER ' + body["data"]);
              Navigator.pushAndRemoveUntil(
                event.context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPinScreenOnly(),
                  settings: RouteSettings(name: 'SettingsPinScreenOnly'),
                ),
                (Route<dynamic> route) => false,
              );
              break;
            default:
              await storage.delete(key: 'token');
              await storage.delete(key: 'user');
              Navigator.pushAndRemoveUntil(
                event.context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignIn(),
                  settings: RouteSettings(name: 'SignIn'),
                ),
                (Route<dynamic> route) => false,
              );
              break;
          }
        } else {
          throw 'Учетные данные введены некорректно';
        }
      } catch (_) {
        yield LoginError(_);
      }
    }
  }
}

abstract class LoginEvent {}

class DoLoginEvent extends LoginEvent {
  BuildContext context;
  UserPassword userPassword;
  LoginBloc loginBloc;
  DoLoginEvent(this.context, this.userPassword, this.loginBloc);

  @override
  String toString() => 'DoLoginEvent';
}

class DoChangePassEvent extends LoginEvent {
  BuildContext context;
  String tmpPass;
  UserPassword userPassword;
  DoChangePassEvent(this.context, this.userPassword, this.tmpPass);

  @override
  String toString() => 'DoRegisterChangeEvent';
}

abstract class LoginState {}

class LoginInit extends LoginState {
  @override
  String toString() => 'LoginInit';
}

class LoginShowPreloader extends LoginState {
  @override
  String toString() => 'LoginShowPreloader';
}

class LogginedState extends LoginState {
  @override
  String toString() => 'LogginedState';
}

class LoginError extends LoginState {
  final String error;
  LoginError(this.error);

  @override
  String toString() => 'LoginError';
}

class ChangePassState extends LoginState {
  Map initData;
  ChangePassState(this.initData);

  @override
  String toString() => 'ChangePassState';
}
class SetPasswordFormState extends LoginState {
  @override
  String toString() => 'SetPasswordFormState';
}
