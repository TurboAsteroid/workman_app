import 'package:flutter/material.dart';
import '../person.dart';

abstract class BookEvent {}

class Search extends BookEvent {
  BuildContext context;
  String searchSring;

  Search(this.context, this.searchSring);

  @override
  String toString() => 'Search';
}

class Colleagues extends BookEvent {}

class Call extends BookEvent {
  String telephoneNumber;

  Call(this.telephoneNumber);

  @override
  String toString() => 'Call';
}

class SendMail extends BookEvent {
  String mail;

  SendMail(this.mail);

  @override
  String toString() => 'SendMail';
}

class AddToContact extends BookEvent {
  ADUser user;
  List<ADUser> users;

  AddToContact(this.user, this.users);

  @override
  String toString() => 'AddToContacts';
}
