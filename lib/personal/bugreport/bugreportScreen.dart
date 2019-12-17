import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/bugreport/reportData.dart';
import 'package:personal/personal/index.dart';
import 'package:personal/personal/network/ajaxPost.dart';
import 'package:personal/personal/network/serverResponse.dart';

class BugReportScreen extends StatefulWidget {
  @override
  _BugReportScreenState createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  _Bl _bl = _Bl();
  final _formKey = GlobalKey<FormState>();
  final _errorDesc = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Сообщение об ошибке'),
        ),
        body: BlocBuilder(
            bloc: _bl,
            builder: (context, state) {
              if (state is _InitSt) {
                return SingleChildScrollView(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text('Пожалуйста, кратко опишите ошибку,чтобы мы могли скорее устранить ее')),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: TextFormField(
                          controller: _errorDesc,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          decoration: new InputDecoration(
                            hintText: 'Описание ошибки',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Требуется заполнить поле "Описание ошибки"';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _bl.add(_SendEv(Report.fromJson({
                                "version": SizeConfig.appVersion,
                                "error_desc": _errorDesc.text.toString(),
                                "phone": SizeConfig.phone
                              })));
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Отправить',
                                style: TextStyle(
                                  color: Theme.of(context).buttonColor,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Icon(
                                Icons.send,
//                              color: Theme.of(context).buttonColor,
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
              }
              if (state is _SendedSt) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.done,
                        color: Colors.green,
                        size: 86,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Спасибо за обратную связь!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).primaryTextTheme.display4,
                        ),
                      ),
                      RaisedButton.icon(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Index(),
                              settings: RouteSettings(name: 'fromBugToIndex'),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        label: Text('На главный экран'),
                      )
                    ],
                  ),
                );
              }
              if (state is _LoadingSt) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is _ErrorSt) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error,
                        size: 82,
                        color: Colors.red,
                      ),
                      Text(
                        state.error,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).primaryTextTheme.display4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.replay),
                            onPressed: () {
                              _bl.add(_SendEv(state.report));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
              return Container();
            }));
  }
}

abstract class _St {}

class _InitSt extends _St {}

class _SendedSt extends _St {}

class _LoadingSt extends _St {}

class _ErrorSt extends _St {
  Report report;
  String error;

  _ErrorSt(this.error, {this.report});
}

abstract class _Ev {}

class _SendEv extends _Ev {
  Report report;

  _SendEv(this.report);
}

class _Bl extends Bloc<_Ev, _St> {
  @override
  _St get initialState => _InitSt();

  @override
  Stream<_St> mapEventToState(_Ev event) async* {
    yield _LoadingSt();
    if (event is _SendEv) {
      ServerResponse sr =
          await ajaxPost('modules/feedback/62', event.report.toJson());
      if (sr.status != '200' && sr.status != 'OK') {
        yield _ErrorSt('Ошибка отправки вашего сообщения',
            report: event.report);
        return;
      }
      yield _SendedSt();
      return;
    }
  }
}
