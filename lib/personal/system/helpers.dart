import 'package:intl/intl.dart';

class Helpers {
  static String dtInt(int date) {
    var dt = DateTime.fromMillisecondsSinceEpoch(date * 1000).toLocal();
    String ret = '';
    ret += dt.day > 9 ? '${dt.day}.' : '0${dt.day}.';
    ret += dt.month > 9 ? '${dt.month}.' : '0${dt.month}.';
    ret += dt.year > 9 ? '${dt.year} ' : '0${dt.year} ';
    ret += dt.hour > 9 ? '${dt.hour}:' : '0${dt.hour}:';
    ret += dt.minute > 9 ? '${dt.minute}' : '0${dt.minute}';
    return ret;
  }

  static String dt(String publishedAt) {
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final dt = format.parse(publishedAt);
    String ret = '';
    ret += dt.day > 9 ? '${dt.day}.' : '0${dt.day}.';
    ret += dt.month > 9 ? '${dt.month}.' : '0${dt.month}.';
    ret += dt.year > 9 ? '${dt.year} ' : '0${dt.year} ';
    ret += dt.hour > 9 ? '${dt.hour}:' : '0${dt.hour}:';
    ret += dt.minute > 9 ? '${dt.minute}' : '0${dt.minute}';
    return ret;
  }

  static String dtOnlyDate(String publishedAt) {
    DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    final dt = format.parse(publishedAt);
    String ret = '';
    ret += dt.day > 9 ? '${dt.day}.' : '0${dt.day}.';
    ret += dt.month > 9 ? '${dt.month}.' : '0${dt.month}.';
    ret += dt.year > 9 ? '${dt.year} ' : '0${dt.year} ';
    return ret;
  }
}
