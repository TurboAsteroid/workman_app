import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal/personal/contacts/book/bookScreen.dart';
import 'package:personal/personal/contacts/colleagues.dart';
import 'package:personal/personal/personal/cloth/clothScreen.dart';
import 'package:personal/personal/personal/paysheet/paysheetScreen.dart';
import 'package:personal/personal/polls/page.dart';

class Awf {
  Widget wdg;
  String name;
  Icon icon;
  String wdgName;

  Awf(this.wdg, this.name, {this.icon, this.wdgName});
}

class AllWdg {
  Map<String, Awf> allWdg = {};

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allWdg = {
      "PaySheet":
          Awf(PaySheet(prefs.getString('url.PaySheet')), "Расчетный лист",
              icon: Icon(
                Icons.attach_money,
                color: Colors.blue,
              ),
              wdgName: 'PaySheet'),
      "Polls": Awf(Polls(prefs.getString('url.Polls'), 'Опросы'), "Опросы",
          icon: Icon(
            Icons.question_answer,
            color: Colors.blue,
          ),
          wdgName: 'Polls'),
      "Siz": Awf(ClothScreen(prefs.getString('url.SizIndex')), "СИЗ",
          icon: Icon(
            Icons.headset,
            color: Colors.blue,
          ),
          wdgName: 'SizIndex'),
      "Colleagues":
          Awf(Colleagues(prefs.getString('url.Colleagues')), "Коллеги",
              icon: Icon(
                Icons.group,
                color: Colors.blue,
              ),
              wdgName: 'Colleagues'),
      "Book": Awf(Book(prefs.getString('url.Book')), "Тел. справочник",
          icon: Icon(
            Icons.contact_phone,
            color: Colors.blue,
          ),
          wdgName: 'Book'),
    };
  }
}
