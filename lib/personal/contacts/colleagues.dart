import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/personal/network/network.dart';


import 'person.dart';

class Colleagues extends StatefulWidget {
  Colleagues(this.url);

  final String url;

  @override
  _ColleaguesState createState() => _ColleaguesState();
}

class _ColleaguesState extends State<Colleagues> {
  _Bloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = _Bloc(widget.url);
    _bloc.add(_LoadEv());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Коллеги'),
//        actions: <Widget>[ToFavorites('Colleagues')],
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, _State state) {
          if (state is _LoadedSt) {
            return ListView.builder(
              itemCount: state.adUsers.length,
              itemBuilder: (context, index) {
                return Person(state.adUsers[index]);
              },
            );
          }
          return Container(
            child: CircularProgressIndicator(),
            alignment: Alignment.center,
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
class _Bloc extends Bloc<_Event, _State> {
  _Bloc(this.url);

  final String url;

  @override
  _State get initialState => _InitSt();

  @override
  Stream<_State> mapEventToState(_Event event) async* {
    if (event is _LoadEv) {
      List<ADUser> adUsers = [];
      ServerResponse sr = await ajaxGet(url);
      List users = sr.data['users'];
      users.forEach((item) {
        if (item['title'] != null &&
            item['userPrincipalName'].toString().contains('_adm') == false)
          adUsers.add(ADUser.fromJson(item));
      });
      yield _LoadedSt(adUsers);
    }
  }
}

// -----------------------------------------------------------------------------
abstract class _Event {
  BuildContext context;

  _Event({this.context});
}

class _LoadEv extends _Event {
  @override
  String toString() => 'LoadEv';
}

// -----------------------------------------------------------------------------
abstract class _State {}

class _InitSt extends _State {
  @override
  String toString() => 'InitSt';
}

class _LoadedSt extends _State {
  List<ADUser> adUsers;

  _LoadedSt(this.adUsers);

  @override
  String toString() => 'LoadedSt';
}
