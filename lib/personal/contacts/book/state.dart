import '../person.dart';

abstract class BookState {}

class Init extends BookState {
  String text;
  Init(this.text);
  @override
  String toString() => 'Init';
}

class Searching extends BookState {
  @override
  String toString() => 'Searching';
}

class Ok extends BookState {
  List<ADUser> users;

  Ok(this.users);

  @override
  String toString() => 'Ok';
}

class Nothing extends BookState {
  String text;

  Nothing(this.text);

  @override
  String toString() => 'Nothing';
}

class Added extends BookState {
  List<ADUser> users;

  Added(this.users);

  @override
  String toString() => 'Added';
}

class Posted extends BookState {
  List<ADUser> users;
  String text;

  Posted(this.users, this.text);

  @override
  String toString() => 'Posted';
}

class Error extends BookState {
  String text;

  Error(this.text);

  @override
  String toString() => 'Error';
}
