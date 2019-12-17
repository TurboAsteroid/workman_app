import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ToFavorites extends StatefulWidget {
  final String wdgName;

  ToFavorites(this.wdgName);

  @override
  _ToFavoritesState createState() => _ToFavoritesState();
}

class _ToFavoritesState extends State<ToFavorites> {
  _Bl _bl = _Bl();

  @override
  void initState() {
    super.initState();
    _bl.add(InitEv(widget.wdgName));

  }

  @override
  void dispose() {
    _bl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_Bl, St>(
      bloc: _bl,
      builder: (BuildContext context, St state) {
        if (state is IncludedSt) {
          return IconButton(
            padding: EdgeInsets.all(8),
            icon: Icon(Icons.bookmark),
            onPressed: () => _bl.add(TapEv(widget.wdgName)),
          );
        }
        if (state is ExcludedSt) {
          return IconButton(
            padding: EdgeInsets.all(8),
            icon: Icon(Icons.bookmark_border),
            onPressed: () => _bl.add(TapEv(widget.wdgName)),
          );
        }
        return Container();
      },
    );
  }
}

class _Bl extends Bloc<Ev, St> {
  SharedPreferences prefs;

  @override
  St get initialState => InitSt();

  @override
  Stream<St> mapEventToState(Ev event) async* {
    prefs = await SharedPreferences.getInstance();

    BookmarksJsonObj bjo;
    try {
      bjo =
          BookmarksJsonObj.fromJson(json.decode(prefs.getString('bookmarks')));
    } catch (e) {
      print(e);
      bjo = BookmarksJsonObj.fromJson({"bookmarks": []});
    }
    if (event is InitEv) {
      yield ExcludedSt();
      for (int i = 0; i < bjo.bookmarks.length; i++) {
        if (bjo.bookmarks[i] == event.wdg) yield IncludedSt();
      }
    }
    if (event is TapEv) {
      if (bjo.bookmarks.indexOf(event.wdg) >= 0) {
        //надо удалить
        bjo.bookmarks.remove(event.wdg);
        yield ExcludedSt();
      } else {
        //надо добавить
        bjo.bookmarks.add(event.wdg);
        yield IncludedSt();
      }
      String s = '{"bookmarks": [';
      for (int i = 0; i < bjo.bookmarks.length; i++) {
        if (i + 1 == bjo.bookmarks.length)
          s += '"' + bjo.bookmarks[i].toString() + '"';
        else
          s += '"' + bjo.bookmarks[i].toString() + '",';
      }
      s += ']}';
      try {
        await prefs.setString('bookmarks', s);
      } catch (e) {
        print(e);
      }
    }
  }
}

class BookmarksJsonObj {
  List<String> bookmarks;

  BookmarksJsonObj({this.bookmarks});

  BookmarksJsonObj.fromJson(Map<String, dynamic> json) {
    bookmarks = json['bookmarks'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookmarks'] = this.bookmarks;
    return data;
  }
}

abstract class Ev {
  String wdg;

  Ev({this.wdg});
}

class InitEv extends Ev {
  InitEv(wdg) : super(wdg: wdg);

  @override
  String toString() => 'InitEv';
}

class TapEv extends Ev {
  TapEv(wdg) : super(wdg: wdg);

  @override
  String toString() => 'TapEv';
}

abstract class St {}

class InitSt extends St {
  @override
  String toString() => 'InitSt';
}

class IncludedSt extends St {
  @override
  String toString() => 'IncludedSt';
}

class ExcludedSt extends St {
  @override
  String toString() => 'ExcludedSt';
}
