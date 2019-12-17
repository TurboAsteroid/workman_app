import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal/personal/favorites/awf.dart';
import 'package:personal/personal/favorites/toFavorites.dart';


class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  _Bl _bl = _Bl();

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
    _bl.add(InitEv());
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: BlocBuilder<_Bl, _St>(
        bloc: _bl,
        builder: (BuildContext context, _St state) {
          if (state is LoadedSt) {
            if (state.bjo.bookmarks.length == 0)
              return Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text("Вы ничего не добавили в избранное"),
              );
            return ListView.builder(
              itemCount: state.bjo.bookmarks.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(state.allWdg[state.bjo.bookmarks[i]].name[0]),
                  ),
                  title: Text(state.allWdg[state.bjo.bookmarks[i]].name),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          (state.allWdg[state.bjo.bookmarks[i]].wdg),
                      settings: RouteSettings(name: state.allWdg[state.bjo.bookmarks[i]].wdgName),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

class _Bl extends Bloc<_Ev, _St> {
  SharedPreferences prefs;

  @override
  _St get initialState => InitSt();

  @override
  Stream<_St> mapEventToState(_Ev event) async* {
    prefs = await SharedPreferences.getInstance();
    if (event is InitEv) {
      AllWdg instanceOfAllWdg = AllWdg();
      await instanceOfAllWdg.init();
      BookmarksJsonObj bjo;
      try {
        bjo = BookmarksJsonObj.fromJson(
            json.decode(prefs.getString('bookmarks')));
      } catch (e) {
        print(e);
        bjo = BookmarksJsonObj.fromJson({"bookmarks": []});
      }
      yield LoadedSt(bjo, instanceOfAllWdg.allWdg);
    }
  }
}

abstract class _Ev {}

class InitEv extends _Ev {
  @override
  String toString() => 'InitEv';
}

abstract class _St {}

class InitSt extends _St {
  @override
  String toString() => 'InitSt';
}

class LoadedSt extends _St {
  Map<String, Awf> allWdg;
  BookmarksJsonObj bjo;

  LoadedSt(this.bjo, this.allWdg);

  @override
  String toString() => 'LoadedSt';
}
