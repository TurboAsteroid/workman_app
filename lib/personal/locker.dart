import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/auth_strings.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:personal/personal/index.dart';
import 'package:personal/personal/signIn/signIn.dart';

class Locker extends StatefulWidget {
  final String pin;

  Locker(this.pin);

  @override
  State<StatefulWidget> createState() => _LockerState();
}

class _LockerState extends State<Locker> {
  String curPin = '';

  @override
  void initState() {
    super.initState();
    biometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.08,
            ),
            child: Image.asset(
              'assets/updater_locker_logo.png',
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          ),
          Container(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              alignment: Alignment.center,
              child: GridView.count(
                crossAxisCount: widget.pin.length,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: List.generate(
                  widget.pin.length,
                  (index) {
                    Color c;
                    if (index < curPin.length)
                      c = Colors.black87;
                    else
                      c = Colors.white;
                    return Container(
                      child: Text(' '),
                      decoration: BoxDecoration(
                          color: c,
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(width: 1, color: Colors.black54)),
                    );
                  },
                ),
              ),
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.16,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(
                48, MediaQuery.of(context).size.width * 0.4, 48, 48),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: List.generate(12, (index) {
                // 11 потому что одна пустая для выравнивания
                int num = index + 1;
                if (num == 10) {
                  return IconButton(
                    icon: Icon(Icons.exit_to_app, color: Colors.black54),
                    onPressed: () {
                      (FlutterSecureStorage()).delete(key: 'token').then((val) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SignIn(),
                            settings: RouteSettings(name: 'SignIn'),
                          ),
                              (Route<dynamic> route) => false,
                        );
                      });
                    },
                  );
                }
                if (num == 12)
                  return Container(
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          String newCurPin = '';
                          for (int i = 0; i < curPin.length - 1; i++)
                            newCurPin += curPin[i];
                          if (curPin.length == 0) newCurPin = '';
                          if (newCurPin == widget.pin)
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Index(),
                                settings: RouteSettings(name: 'Index'),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          curPin = newCurPin;
                          print(curPin);
                        });
                      },
                      child: Icon(Icons.arrow_back, color: Colors.black54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  );
                if (num == 11) num = 0;
                return Container(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (index + 1 == 11)
                          index = -1; // когда пользователь нажмет на ноль
                        String newCurPin = curPin + (index + 1).toString();
                        print(newCurPin);
                        if (newCurPin == widget.pin && newCurPin.length == 4)
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Index(),
                              settings: RouteSettings(name: 'Index'),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        else if (newCurPin != widget.pin &&
                            newCurPin.length == 4)
                          curPin = '';
                        else
                          curPin = newCurPin;
                      });
                    },
                    child: Text(
                      num.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: Colors.black87),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                      side: BorderSide(width: 1, color: Colors.black54),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> biometrics() async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Отсканируйте отпечаток пальца для входа',
          useErrorDialogs: true,
          stickyAuth: false,
          androidAuthStrings: AndroidAuthMessages(
              fingerprintHint: 'Сканер отпечатка пальца.',
              fingerprintNotRecognized:
                  'Отпечаток пальца не распознан. Попробуйте еще раз.',
              fingerprintSuccess: 'Отпечаток распознан',
              cancelButton: 'Отмена',
              signInTitle: 'Аутентификация по отпечатку пальца',
              fingerprintRequiredTitle: 'Требуется отпечаток пальца',
              goToSettingsButton: 'Перейти к настройкам',
              goToSettingsDescription:
                  'Отпечаток пальца не установлен на вашем устройстве. Откройте "Настройки > Безопасность", чтобы добавить отпечаток пальца.'));
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    if (authenticated) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Index(),
          settings: RouteSettings(name: 'Index'),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}
