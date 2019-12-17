import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:personal/config.dart';

import 'package:personal/personal/menu/dynTree.dart';
import 'package:personal/personal/menu/menuHeader.dart';
import 'package:personal/personal/menu/menu_Events_States.dart';
import 'package:personal/personal/network/network.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(this.url, this.position);
  final String position;
  final String url;

  @override
  MenuState get initialState => Init();

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is CreateMenu) {
      yield Loading();
      List<Widget> widgets = [];
      if (position == 'left') {
        ServerResponse srHeader = await ajaxGet('');
        SizeConfig().setPhone(srHeader.data['originalPhone'].toString());
        widgets.add(menuHeaderL(srHeader));
      } else {
        widgets.add(menuHeaderR());
      }
      ServerResponse srMenu = await ajaxGet(url);
      List<dynamic> data = srMenu.data['children'];
      List<DynTree> _dynTree = [];
      for (int i = 0; i < data.length; i++) {
        _dynTree.add(DynTree.fromJson(data[i]));
      }
      widgets.add(Column(children: dynTreeWidgets(_dynTree, event.context)));
      yield DrawMenu(widgets);
    }
  }
}
