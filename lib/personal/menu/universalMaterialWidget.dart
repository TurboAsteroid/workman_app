import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:personal/personal/about.dart';
import 'package:personal/personal/app_news/app_news_list.dart';
import 'package:personal/personal/contacts/book/bookScreen.dart';
import 'package:personal/personal/contacts/colleagues.dart';
import 'package:personal/personal/gallery/gallery.dart';
import 'package:personal/personal/medicine/bodyCheck.dart';
import 'package:personal/personal/medicine/disp.dart';
import 'package:personal/personal/medicine/hospital/hospital.dart';
import 'package:personal/personal/menu/dynTree.dart';
import 'package:personal/personal/menu/dynamicWidgets/proWatch/results/proResults.dart';
import 'package:personal/personal/menu/dynamicWidgets/schedule/list_schedule.dart';
import 'package:personal/personal/menu/dynamicWidgets/simple_html/simple_html.dart';
import 'package:personal/personal/personal/checks/checks.dart';
import 'package:personal/personal/personal/cloth/clothScreen.dart';
import 'package:personal/personal/personal/education/educationScreen.dart';
import 'package:personal/personal/personal/food/foodScreen.dart';
import 'package:personal/personal/personal/paysheet/paysheetScreen.dart';
import 'package:personal/personal/personal/vacation/vacationScreen.dart';
import 'package:personal/personal/personal/vaccination/listOfVaccinationScreen.dart';
import 'package:personal/personal/polls/page.dart';
import 'package:personal/personal/request/universalRequest.dart';
import 'package:personal/personal/settings/page.dart';
import 'package:personal/personal/signIn/signIn.dart';
import 'package:personal/personal/transport/busForecasts.dart';

class UniversalMaterialWidget extends StatelessWidget {
  final DynTree item;

  UniversalMaterialWidget(this.item);

  @override
  Widget build(BuildContext context) {
    String widgetName = item.widget;
    String title = item.title;
    String url = item.url;
    print('selected: $widgetName $url');
    // widgets map
    switch (widgetName) {
      case 'EducationScreen':
        return EducationScreen(url, title);
      case 'Disp':
        return Disp(title);
      case 'ListOfVaccinationScreen':
        return ListOfVaccinationScreen(url, title);
      case 'BusForecasts':
        return BusForecasts(url, title);
      case 'VacationScreen':
        return VacationScreen(url, title);
      case 'FoodScreen':
        return FoodScreen(url, title);
      case 'ProResults': // релизе надо удалить
        return ProResults(url, title);
      case 'BodyCheck':
        return BodyCheck();
      case 'Hospital':
        return Hospital(url, title);
      case 'Checks':
        return Checks(url, title);
      case 'Polls':
        return Polls(url, title);
      case 'AppNewsList':
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: AppNewsList(url),
        );
      case 'Gallery':
        return Gallery(url, title);
      case 'ListSchedule':
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: ListSchedule(url),
        );
      case 'SimpleHtml':
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: SimpleHtml(url),
        );
      case 'PaySheet':
        return PaySheet(url);
      case 'SizIndex':
        return ClothScreen(url);
      case 'Book':
        return Book(url);
      case 'Colleagues':
        return Colleagues(url);
      case 'UniversalRequest':
        return UniversalRequest(header: item.description, url: url);
      case 'Settings':
        return Settings();
      case 'About':
        return About();
      case 'SignIn':
        (FlutterSecureStorage()).delete(key: 'token').then((val) {
          Navigator.pop(context); // !!!иначе ошибка!!!
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => SignIn(),
              settings: RouteSettings(name: 'SignIn'),
            ),
            (Route<dynamic> route) => false,
          );
        });
        return Container();
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text('Что-то пошло не так'),
          ),
          body: Center(
            child: Text(
              'Виджет $widgetName не найден',
              textAlign: TextAlign.center,
            ),
          ),
        );
    }
  }
}
