import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/favorites/awf.dart';

import 'package:personal/personal/favorites/toFavorites.dart';


class FavoritesBottomBar extends StatefulWidget {
  final bool firstRun;
  final GlobalKey<ScaffoldState> scaffoldKey;

  FavoritesBottomBar(this.firstRun, {this.scaffoldKey, Key key})
      : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesBottomBar> {
  _Bl _bl = _Bl();

  @override
  void initState() {
    super.initState();
    _bl.add(FirstRun(widget.firstRun));
    
  }

  @override
  void dispose() {
    _bl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _bl.add(InitEv());
    return BlocBuilder(
      bloc: _bl,
      builder: (BuildContext context, _St state) {
        if (state is LoadedSt) {
          List<Widget> dd = [];
//          List<Container> bnbi = [];
          List<BottomNavigationBarItem> bnbi = [];
          for (int i = 0; i < state.bjo.bookmarks.length; i++) {
            if (state.allWdg[state.bjo.bookmarks[i]] != null) {
//              bnbi.add(Container(
//                  width: SizeConfig.screenWidth/state.bjo.bookmarks.length,
//                  child: FlatButton(
//                    child: Column(
//                      children: <Widget>[
//                        state.allWdg[state.bjo.bookmarks[i]].icon,
//                        Flexible(child: Text(state.allWdg[state.bjo.bookmarks[i]].name)),
//                      ],
//                    ),
//                    onPressed: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) =>
//                              (state.allWdg[state.bjo.bookmarks[i]].wdg),
//                        ),
//                      );
//                    },
//                  )));
              bnbi.add(BottomNavigationBarItem(
                  title: Text(state.allWdg[state.bjo.bookmarks[i]].name),
                  icon: state.allWdg[state.bjo.bookmarks[i]].icon));
              dd.add(
                IconButton(
                  icon: state.allWdg[state.bjo.bookmarks[i]].icon,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          (state.allWdg[state.bjo.bookmarks[i]].wdg),
                      settings: RouteSettings(
                          name: state.allWdg[state.bjo.bookmarks[i]].wdgName),
                    ),
                  ),
                ),
              );
            }
          }
//          return Container(padding: EdgeInsets.only(top: 8), height: SizeConfig.safeBlockVertical * 8, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: bnbi,),);
//          return bnbi.length > 0
//              ? SizedBox(
//                  height: 52,
//                  width: MediaQuery.of(context).size.width,
//                  child: Padding(
//                    padding: EdgeInsets.only(top: 4),
//                    child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceAround,
//                        children: bnbi),
//                  ),
//                )
//              : Container(height: 0);
          return BottomNavigationBar(
            items: List.of(bnbi),
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            onTap: (i) {
              setState(() {
                _selectedIndex = i;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      (state.allWdg[state.bjo.bookmarks[i]].wdg),
                  settings: RouteSettings(
                      name: state.allWdg[state.bjo.bookmarks[i]].wdgName),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  int _selectedIndex = 0;
}

class _Bl extends Bloc<_Ev, _St> {
  SharedPreferences prefs;

  @override
  _St get initialState => InitSt();

  @override
  Stream<_St> mapEventToState(_Ev event) async* {
    prefs = await SharedPreferences.getInstance();
    // при первом запуске выставляем настройку закладок
    if (event is FirstRun) {
      await prefs.setString(
//          'bookmarks', '{\"bookmarks\": [\"PaySheet\",\"Siz\",\"Book\"]}');
          'bookmarks',
          '{\"bookmarks\": [\"PaySheet\",\"Siz\",\"Polls\"]}');
    }
    if (event is InitEv) {
      AllWdg instanceOfAllWdg = AllWdg();
      await instanceOfAllWdg.init();
      BookmarksJsonObj bjo;
      try {
        bjo = BookmarksJsonObj.fromJson(
            json.decode(prefs.getString('bookmarks')));
      } catch (e) {
        print(e);
        bjo = BookmarksJsonObj.fromJson({'bookmarks': []});
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

class FirstRun extends _Ev {
  bool fr;

  FirstRun(this.fr);
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
