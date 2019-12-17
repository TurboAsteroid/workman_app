import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/menu/universalMaterialWidget.dart';

class DynTree {
  String id;
  String title;
  String description;
  Icon icon;
  String widget;
  String url;
  List<DynTree> children;

  DynTree(
      {this.title,
      this.description,
      this.icon,
      this.widget,
      this.url,
      this.children});

  DynTree.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    description = json['description'];
    icon = Icon(IconData(int.parse(json['icon']), fontFamily: 'MaterialIcons'));
    widget = json['widget'];
    url = json['url'];
    if (json['children'] != null) {
      children = new List<DynTree>();
      json['children'].forEach((v) {
        children.add(new DynTree.fromJson(v));
      });
    }
    // для Favorites
    try {
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      _prefs.then((prefs) {
        prefs.setString('url.$widget', url);
      });
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['description'] = this.description;
    data['icon'] = this.icon.icon.codePoint;
    data['widget'] = this.widget;
    data['url'] = this.url;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

Widget dynTreeParent(DynTree item, BuildContext context) {
  List<Widget> children = dynTreeWidgets(item.children, context);
  return ExpansionTile(
    key: PageStorageKey(Random().nextInt(10000)),
    initiallyExpanded: false,
    title: Text(item.title),
    leading: item.icon,
    children: children,
  );
}

List<Widget> dynTreeWidgets(List<DynTree> dynTree, BuildContext context) {
  List<Widget> widgets = [];
  for (int i = 0; i < dynTree.length; i++) {
    if (dynTree[i].widget != null) {
      widgets.add(dynTreeChild(dynTree[i], context));
    } else {
      widgets.add(dynTreeParent(dynTree[i], context));
    }
  }
  return widgets;
}

Widget dynTreeChild(DynTree item, BuildContext context) {
  SizeConfig().init(context);
  print('dynTreeChild ${item.widget}   ${item.url}');
  return ListTile(
//    contentPadding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*10), // смещение может быть, но оно смещает не только детей в родителе , но и детей в корне
    title: Text(item.title),
    leading: item.icon,
    onTap: () {
//      Navigator.pop(context); // скрытие меню после выбора элемента
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UniversalMaterialWidget(item),
          settings: RouteSettings(name: item.widget),
        ),
      );
    },
  );
}
