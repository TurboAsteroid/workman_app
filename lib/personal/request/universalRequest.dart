import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/personal/network/network.dart';


class UniversalRequest extends StatefulWidget {
  final String url;
  final String header;
  final String id;

  UniversalRequest({@required this.header, @required this.url, this.id});

  @override
  State<StatefulWidget> createState() => UniversalRequestState();
}

class UniversalRequestState extends State<UniversalRequest> {
  final _formKey = GlobalKey<FormState>();
  final _themeController = TextEditingController();
  final _descController = TextEditingController();
  _Bloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = _Bloc(widget.url);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.header),
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, _State state) {
          if (state is _InitSt) {
            return SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _themeController,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      decoration: new InputDecoration(
                          hintText: 'Тема',
                          icon: new Icon(
                            Icons.title,
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите тему';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: _descController,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          hintText: 'Описание',
                          icon: new Icon(
                            Icons.description,
                          )),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Введите описание';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _bloc.add(_SendEv(FeedbackForm.fromJson({
                            "title": _themeController.text.toString(),
                            "body": _descController.text.toString()
                          })));
                        }
                      },
                      label: Text(
                        'Отправить',
                      ),
                      icon: Icon(
                        Icons.send,
                      ),
                    ),
                  ),
                ],
              ),
            ));
          } else if (state is _LoadingSt) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is _ResponseOkSt) {
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
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.display4,
                    ),
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text('ОК'),
                    icon: Icon(Icons.done),
                  )
                ],
              ),
            );
          }
          if (state is _ResponseErrorSt) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 86,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).primaryTextTheme.display4,
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      _bloc.add(_SendEv(state.form));
                    },
                    label: Text('Повторить'),
                    icon: Icon(Icons.replay),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _Bloc extends Bloc<_Event, _State> {
  _Bloc(this.url);

  final String url;

  @override
  _State get initialState => _InitSt();

  @override
  Stream<_State> mapEventToState(_Event event) async* {
    if (event is _SendEv) {
      yield _LoadingSt();
      ServerResponse sr = await ajaxPost(url, event.form.toJson());
      if (sr.status == 'OK')
        yield _ResponseOkSt(sr.data['message']);
      else
        yield _ResponseErrorSt(sr.data['message'], event.form);
    }
  }
}

abstract class _Event {}

class _SendEv extends _Event {
  FeedbackForm form;

  _SendEv(this.form);

  @override
  String toString() => '_SendEv';
}

abstract class _State {}

class _InitSt extends _State {
  @override
  String toString() => '_InitSt';
}

class _LoadingSt extends _State {
  @override
  String toString() => '_LoadingSt';
}

class _ResponseOkSt extends _State {
  String message;

  _ResponseOkSt(this.message);

  @override
  String toString() => '_ResponseOkSt';
}

class _ResponseErrorSt extends _State {
  String message;
  FeedbackForm form;

  _ResponseErrorSt(this.message, this.form);

  @override
  String toString() => '_ResponseErrorSt';
}

class FeedbackForm {
  String title;
  String body;

  FeedbackForm({this.title, this.body});

  FeedbackForm.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
