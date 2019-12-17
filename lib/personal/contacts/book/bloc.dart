import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:personal/personal/network/network.dart' as prefix0;
import 'package:personal/personal/network/network.dart';

import './event.dart';
import './state.dart';

import '../person.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc(this.url);
  final String url;
  @override
  BookState get initialState => Init('');

  @override
  Stream<BookState> mapEventToState(BookEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (event is Colleagues) {
      yield Searching();
      String colleagues = prefs.getString('url.Colleagues');
      prefix0.ServerResponse sr = await prefix0.ajaxGet(colleagues);
      List<ADUser> users = [];
      for (int i = 0; i < sr.data["users"].length; i++) {
        users.add(ADUser.fromJson(sr.data["users"][i]));
      }
      if (users.length > 0) {
        yield Ok(users);
      } else {
        yield Nothing("Ничего не найдено");
      }
    }
    if (event is Search) {
      yield Searching();
      ServerResponse sr = await ajaxPost(url, {'searchString': event.searchSring});
//      if (sr.data == null) sr.data = '';
      switch (sr.status.toUpperCase()) {
        case "OK":
          List<ADUser> users = [];
          for (int i = 0; i < sr.data['users'].length; i++) {
            users.add(ADUser.fromJson(sr.data['users'][i]));
          }
          if (users.length > 0) {
            yield Ok(users);
          } else {
            yield Nothing("Ничего не найдено");
          }
          break;
        default:
          yield Nothing('Произошла неизвестная ошибка');
          break;
      }
    }
    if (event is Call) {
      _make("tel:" + event.telephoneNumber);
    }
    if (event is SendMail) {
      _make("mailto:" + event.mail);
    }
    if (event is AddToContact) {
      await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      try {
        yield Searching();
        Contact newContact = Contact();
        newContact.givenName = event.user.displayName;
        newContact.phones = [
          Item(label: "work", value: event.user.telephoneNumber)
        ];
        newContact.jobTitle = event.user.title + ", " + event.user.department;
        newContact.emails = [Item(label: "work", value: event.user.mail)];
        await ContactsService.addContact(newContact);
        yield Added(event.users);
      } catch (e) {
        yield Error("Ошибка добавления контакта");
      }
    }
  }

  Future<void> _make(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
