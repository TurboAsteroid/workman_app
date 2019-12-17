import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:personal/personal/index.dart';
import 'package:personal/personal/locker.dart';
import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/signIn/signIn.dart';

import '../config.dart';

class Init extends StatefulWidget {
  @override
  _InitState createState() => _InitState();
}

class _InitState extends State<Init> {
  _Bloc _bloc = _Bloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(_TokenCheckEv(context));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/updater_locker_logo.png',
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              SizedBox(
                height: 12,
              ),
              BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, _State state) {
                  if (state is _InfoSt) {
                    return Text(
                      state.txt,
                      textAlign: TextAlign.center,
                    );
                  }
                  if (state is _ErrSt) {
                    return Column(
                      children: <Widget>[
                        IconButton(
                          onPressed: () => _bloc.add(_TokenCheckEv(context)),
                          icon: Icon(Icons.refresh),
                        ),
                        Text(
                          state.txt,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }
                  return Text(
                    'Неизвестная ошибка. Попробуйте перезапустить приложение.',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// вспомогательный класс если нет соединения с сетью
class eCon {
  String message;

  eCon({this.message});

  eCon.fromJson(Map<dynamic, dynamic> json) {
    message = json['message'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['message'] = this.message;
    return data;
  }
}

// -----------------------------------------------------------------------------
class _Bloc extends Bloc<_Event, _State> {
  final storage = new FlutterSecureStorage();

  @override
  _State get initialState => _InfoSt('Инициализация');

  @override
  Stream<_State> mapEventToState(_Event event) async* {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SizeConfig().setAppVersion(packageInfo.version);
    if (int.parse(packageInfo.version[0]) < 1) await storage.deleteAll();
    if (event is _TokenCheckEv) {
      try {
        yield _InfoSt('Проверка токена');
        ServerResponse sr = await ajaxGet('');
        if (sr.data['message'].contains('SocketException')) {
          throw eCon.fromJson(sr.data);
        }
        if (sr.status.toLowerCase() != 'ok' || sr.status == '401') {
          yield _InfoSt('Токен не является корректным');
          Navigator.pushAndRemoveUntil(
            event.context,
            MaterialPageRoute(
              builder: (BuildContext context) => SignIn(),
              settings: RouteSettings(name: 'SignIn'),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          yield _InfoSt('Токен проверен успешно');
          String pin = await storage.read(key: 'pin');
          if (pin != null)
            Navigator.pushAndRemoveUntil(
              event.context,
              MaterialPageRoute(
                builder: (BuildContext context) => Locker(pin),
                settings: RouteSettings(name: 'Locker'),
              ),
              (Route<dynamic> route) => false,
            );
          else {
            Navigator.pushAndRemoveUntil(
              event.context,
              MaterialPageRoute(
                builder: (BuildContext context) => Index(),
                settings: RouteSettings(name: 'Index'),
              ),
              (Route<dynamic> route) => false,
            );
          }
        }
      } catch (e) {
        print(e);
        if (e.message.contains('BAD_DECRYPT')) {
          await storage.delete(key: 'token');
          yield _ErrSt(
              'Ошибка проверки токена.\nНевозможно получить токен.\nТокен удален.\nОшибка #881',
              881);
        } else
          yield _ErrSt(
              'Ошибка проверки токена.\nПроверьте подключение к сети Интернет.\n Ошибка #882',
              882);
      }
    }
  }
}

// -----------------------------------------------------------------------------
abstract class _Event {
  BuildContext context;

  _Event({this.context});
}

class _TokenCheckEv extends _Event {
  _TokenCheckEv(context) : super(context: context);

  @override
  String toString() => '_TokenCheckEv';
}

// -----------------------------------------------------------------------------
abstract class _State {}

class _InfoSt extends _State {
  String txt;

  _InfoSt(this.txt);

  @override
  String toString() => 'InfoSt';
}

class _ErrSt extends _State {
  String txt;
  int code;

  _ErrSt(this.txt, this.code);

  @override
  String toString() => '_ErrSt';
}
