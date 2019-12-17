import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/medicine/hospital/medic.dart';
import 'package:personal/personal/gallery/gallery.dart';
import 'package:personal/personal/medicine/hospital/workingHours.dart';
import 'package:personal/personal/network/network.dart';

class HospitalData {
  String aboutGalleryUrl;
  List<Medics> medics;

  HospitalData({this.aboutGalleryUrl, this.medics});

  HospitalData.fromJson(Map<String, dynamic> json) {
    aboutGalleryUrl = json['aboutGalleryUrl'];
    if (json['medics'] != null) {
      medics = new List<Medics>();
      json['medics'].forEach((v) {
        medics.add(new Medics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aboutGalleryUrl'] = this.aboutGalleryUrl;
    if (this.medics != null) {
      data['medics'] = this.medics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medics {
  String photo;
  Fullname fullname;
  String infoUrl;
  String description;
  String position;
  List<Day> workingHours;

  Medics(
      {this.photo,
      this.fullname,
      this.infoUrl,
      this.position,
      this.workingHours});

  Medics.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    fullname = json['fullname'] != null
        ? new Fullname.fromJson(json['fullname'])
        : null;
    infoUrl = json['infoUrl'];
    description = json['description'];
    position = json['position'];
    if (json['working_hours'] != null) {
      workingHours = new List<Day>();
      json['working_hours'].forEach((v) {
        workingHours.add(new Day.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['description'] = this.description;
    if (this.fullname != null) {
      data['fullname'] = this.fullname.toJson();
    }
    data['infoUrl'] = this.infoUrl;
    data['position'] = this.position;
    if (this.workingHours != null) {
      data['working_hours'] = this.workingHours.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fullname {
  String name;
  String surname;
  String patronymic;

  Fullname({this.name, this.surname, this.patronymic});

  Fullname.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    patronymic = json['patronymic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['patronymic'] = this.patronymic;
    return data;
  }
}

class Day {
  String name;
  String value;

  Day({this.name, this.value});

  Day.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class MedicCard extends StatelessWidget {
  final Medics item;

  MedicCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.screenWidth),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 3,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(8),
                  child: CircleAvatar(
                    maxRadius: SizeConfig.screenWidth * 0.12,
                    backgroundImage: NetworkImage(item.photo),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${item.fullname.name} ${item.fullname.surname}',
                      softWrap: true,
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.position),
                  ),
                ],
              ),
              Container(
                color: Colors.black12,
                width: SizeConfig.screenWidth * 0.66,
                height: 1,
              ),
              Row(
                children: <Widget>[
                  FlatButton.icon(
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicScreen(item),
                              settings: RouteSettings(name: 'MedicScreen'),
                            ),
                          ),
                      icon: Icon(Icons.info_outline),
                      label: Text('ИНФО')),
                  FlatButton.icon(
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkingHoursScreen(item),
                              settings:
                                  RouteSettings(name: 'WorkingHoursScreen'),
                            ),
                          ),
                      icon: Icon(Icons.schedule),
                      label: SizeConfig.screenWidth * 0.66 > 270
                          ? Text('ЧАСЫ ПРИЕМА')
                          : Text('ПРИЕМ'))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Hospital extends StatefulWidget {
  final String url;
  final String title;

  Hospital(this.url, this.title);

  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  List<Map> _tabs = [
    {"name": 'Врачи', "index": 0},
//    {"name": 'График работы', "index": 1},
    {"name": 'О нас', "index": 2}
  ];
  _Bl _bl;

  @override
  void initState() {
    super.initState();
    _bl = _Bl(widget.url);
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
          title: Text(widget.title),
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
                          if (item["index"] == 0) {
                            List<Medics> s = state.hospitalData.medics;
                            return ListView.builder(
                                itemCount: s.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return MedicCard(s[i]);
                                });
                          }

                          if (item["index"] == 2) {
                            return SingleChildScrollView(
                                child: GalleryContent(
                                    state.hospitalData.aboutGalleryUrl));
                          }
                          // index == 2
                          return Text(state.hospitalData.aboutGalleryUrl);
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
  HospitalData hospitalData;

  _LoadedSt(this.hospitalData);
}

class _ErrorSt extends _St {
  String error;

  _ErrorSt(this.error);
}

abstract class _Ev {}

class _LoadEv extends _Ev {}

class _Bl extends Bloc<_Ev, _St> {
  String url;

  _Bl(this.url);

  @override
  _St get initialState => _InitSt();

  @override
  Stream<_St> mapEventToState(_Ev event) async* {
    if (event is _LoadEv) {
      yield _LoadingSt();
      String token = await (FlutterSecureStorage()).read(key: 'token');
      ServerResponse sr = await ajaxGet(url);
      if (sr.status.toLowerCase() != 'ok') {
        yield _ErrorSt('Ошибка загрузки данных');
      }
      HospitalData hd = HospitalData.fromJson(sr.data);
      for (int i = 0; i < hd.medics.length; i++) {
        hd.medics[i].photo += '?token=${token.replaceAll('BEARER ', '')}';
        hd.medics[i].infoUrl += '?token=${token.replaceAll('BEARER ', '')}';
      }
      yield _LoadedSt(hd);
    }
  }
}
