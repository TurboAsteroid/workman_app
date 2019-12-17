import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BodyCheckData {
  List<Subdivisions> subdivisions;

  BodyCheckData({this.subdivisions});

  BodyCheckData.fromJson(Map<String, dynamic> json) {
    if (json['subdivisions'] != null) {
      subdivisions = new List<Subdivisions>();
      json['subdivisions'].forEach((v) {
        subdivisions.add(new Subdivisions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subdivisions != null) {
      data['subdivisions'] = this.subdivisions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subdivisions {
  String name;
  String status;
  String startDate;
  String endDate;

  Subdivisions({this.name, this.status, this.startDate, this.endDate});

  Subdivisions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class MedCard extends StatelessWidget {
  final Subdivisions item;
  MedCard(this.item);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                    child: item.status ==
                        'in_progress'
                        ? Icon(
                        Icons.filter_center_focus,
                        color: Colors.white)
                        : Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    radius: 24,
                    backgroundColor:
                    item.status == 'in_progress'
                        ? Colors.deepOrange
                        : Colors.green),
                VerticalDivider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    item.status == 'in_progress'
                        ? Text('В процессе', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),)
                        : Text('Завершен', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),),
                    Text(
                        'Подразделение ${item.name}'),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(14),
            child: Text(
                'Период проведения: ${item.startDate} - ${item.endDate}'),
          )
        ],
      ),
    );
  }
}

class BodyCheck extends StatefulWidget {
  @override
  _BodyCheckState createState() => _BodyCheckState();
}

class _BodyCheckState extends State<BodyCheck> {
  List<Map> _tabs = [
    {"name": 'ЦПП', "index": 1},
    {"name": 'ЛПУ', "index": 2}
  ];
  final _Bl _bl = _Bl();

  @override
  void initState() {
    super.initState();
    _bl.add(_LoadEv());
  }

  @override
  void dispose() {
    _bl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: Scaffold(
        appBar: AppBar(
          title: Text('Медосмотр'),
          bottom: TabBar(
            // These are the widgets to put in each tab in the tab bar.
            tabs: _tabs
                .map((Map item) => Tab(
                      child: Text(
                        item['name'],
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: _tabs.map((Map item) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return BlocBuilder(
                      bloc: _bl,
                      builder: (BuildContext context, state) {
                        if (state is _LoadingSt) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is _LoadedSt) {
                          List<Subdivisions> s =
                              state.bodyCheckData.subdivisions;
                          return ListView.builder(
                              itemCount: s.length,
                              itemBuilder: (BuildContext context, int i) {
                                return MedCard(s[i]);
                              });
                        }
                        if (state is _ErrorSt) {
                          return Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () => _bl.add(_LoadEv()),
                                    icon: Icon(Icons.refresh),
                                  ),
                                  Text(
                                    state.error,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Center(child: Text('Инициализация'));
                      });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

abstract class _St {}

class _InitSt extends _St {}

class _LoadingSt extends _St {}

class _LoadedSt extends _St {
  BodyCheckData bodyCheckData;

  _LoadedSt(this.bodyCheckData);
}

class _ErrorSt extends _St {
  String error;

  _ErrorSt(this.error);
}

abstract class _Ev {}

class _LoadEv extends _Ev {}

class _Bl extends Bloc<_Ev, _St> {
  @override
  _St get initialState => _InitSt();

  @override
  Stream<_St> mapEventToState(_Ev event) async* {
    if (event is _LoadEv) {
      yield _LoadingSt();
      String rawData =
          '{"subdivisions": [{"name": "УПР","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "МПЦ","status": "completed","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "ОХО","status": "complited","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "ЦГЦ","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "УБУиК","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "fff","status": "in_progress","start_date": "01.05.2019","end_date": "31.05.2019"},{"name": "ыыы","status": "completed","start_date": "01.04.2019","end_date": "31.04.2019"}]}';
      yield _LoadedSt(BodyCheckData.fromJson(json.decode(rawData)));
    }
  }
}
