import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/personal/cloth/clothScreen.dart';
import 'package:personal/personal/personal/paysheet/paysheetScreen.dart';
import 'package:personal/personal/polls/page.dart';
import 'package:personal/personal/request/universalRequest.dart';
import 'package:personal/personal/system/changelog.dart';
import 'package:personal/personal/menu/bloc.dart';
import 'package:personal/personal/menu/dr.dart';
import 'package:personal/personal/menu/menu_Events_States.dart';
import 'package:personal/personal/news/list_vk_news.dart';
import 'package:personal/personal/notif/notif.dart';
import 'package:personal/personal/workmanElemAppHeader.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> with TickerProviderStateMixin {
  final MenuBloc _blocMenuL =
      MenuBloc('general/getMainMenu?debug=$debug&left', 'left');
  final MenuBloc _blocMenuR =
      MenuBloc('general/getMainMenu?debug=$debug&right', 'right');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool changelogWasShown = true;
  bool introWasShown = true;

  @override
  void initState() {
    super.initState();
    NotifHelper().setUpFirebase(context);
    (FlutterSecureStorage()).read(key: 'user').then((user) {
      FirebaseAnalytics analytics = FirebaseAnalytics();
      analytics.setUserId(user);
    });
    _blocMenuL.add(CreateMenu(context));
    _blocMenuR.add(CreateMenu(context));

    (SharedPreferences.getInstance()).then((prefs) {
      introWasShown = prefs.getBool('introWasShown');
      String appVersion = prefs.getString('changelog');
      if (introWasShown == null) {
        setState(() {
          changelogWasShown = true;
          showTutorial();
        });
      } else if (SizeConfig.appVersion != appVersion) {
        setState(() {
          changelogWasShown = false;
        });
      }
    });
  }

  GlobalKey redButtonKey = GlobalKey();
  GlobalKey drRightKey = GlobalKey();
  GlobalKey drLeftKey = GlobalKey();
  GlobalKey paysheetKey = GlobalKey();
  GlobalKey clothKey = GlobalKey();
  GlobalKey pollsKey = GlobalKey();
  bool skip = false;

  void showTutorial() {
    Timer(Duration(milliseconds: 600), () {
      TutorialCoachMark(context,
          targets: targets(drLeftKey, drRightKey, redButtonKey, paysheetKey,
              clothKey, pollsKey),
          colorShadow: Colors.indigo.withOpacity(0.7),
          alignSkip: Alignment.bottomRight,
          textSkip: 'ПРОПУСТИТЬ', finish: () {
            (SharedPreferences.getInstance()).then((prefs) {
              prefs.setBool('introWasShown', true);
              prefs.setString('changelog', SizeConfig.appVersion);
            });
            print("finish");
          }, clickTarget: (target) {
            print(target);
          }, clickSkip: () {
            print("skip");
          })
        ..show();
    });
  }

  @override
  void dispose() {
    _blocMenuL.close();
    _blocMenuR.close();
    super.dispose();
  }

  int _selectedIndex = 0;
  AnimationController controller;
  Animation<double> animation;

  initControllerAndAnimation(int duration) {
    controller = AnimationController(
        duration: Duration(milliseconds: duration), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    initControllerAndAnimation(800);
    SizeConfig().init(context);
    double size =
        (SizeConfig.screenWidth * 0.08) > (SizeConfig.screenHeight * 0.08)
            ? (SizeConfig.screenHeight * 0.08)
            : (SizeConfig.screenWidth * 0.08);

    return Stack(
      children: <Widget>[
        Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              key: drLeftKey,
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            title: workmanElemAppHeader(),
            actions: <Widget>[
              Builder(
                builder: (context) => IconButton(
                  key: drRightKey,
                  icon: new Icon(Icons.info_outline),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
              Container(
                key: redButtonKey,
                child: FloatingActionButton(
                  heroTag: Random().nextInt(9999),
                  mini: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UniversalRequest(
                            header: 'Предложить функционал',
                            url: 'modules/feedback/62'),
                        settings: RouteSettings(name: 'Idea'),
                      ),
                    );
                  },
                  child: Container(
                    width: size,
                    child: Image.asset('assets/icons/idea.png'),
                  ),
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
          body: ListVk(),
          drawer: Dr(_blocMenuL),
          endDrawer: Dr(_blocMenuR),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                title: Text(
                  'Расчетный лист',
                  style: TextStyle(color: Colors.blue),
                ),
                icon: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.blue,
                  key: paysheetKey,
                ),
              ),
              BottomNavigationBarItem(
                  title: Text(
                    'СИЗ',
                    style: TextStyle(color: Colors.blue),
                  ),
                  icon: Icon(
                    Icons.headset,
                    color: Colors.blue,
                    key: clothKey,
                  )),
              BottomNavigationBarItem(
                  title: Text(
                    'Опросы',
                    style: TextStyle(color: Colors.blue),
                  ),
                  icon: Icon(
                    Icons.question_answer,
                    color: Colors.blue,
                    key: pollsKey,
                  ))
            ],
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            onTap: (i) {
              (SharedPreferences.getInstance()).then((prefs) {
                Widget w;
                switch (i) {
                  case 0:
                    w = PaySheet(prefs.getString('url.PaySheet'));
                    break;
                  case 1:
                    w = ClothScreen(prefs.getString('url.SizIndex'));
                    break;
                  case 2:
                    w = Polls(prefs.getString('url.Polls'), 'Опросы');
                    break;
                }
                setState(() {
                  _selectedIndex = i;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => w,
                    settings: RouteSettings(name: w.toString()),
                  ),
                );
              });
            },
          ),
        ),
        !changelogWasShown
            ? Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.8, sigmaY: 1.8),
                      child: Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight,
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                      opacity: animation,
                      child: Stack(
                        children: <Widget>[
                          Changelog(),
                          Container(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * 0.88),
                            child: Center(
                              child: FlatButton.icon(
                                color: Colors.white,
                                icon: Icon(Icons.done),
                                label: Text('OK'),
                                onPressed: () {
                                  setState(() {
                                    changelogWasShown = true;
                                  });
                                  (SharedPreferences.getInstance())
                                      .then((prefs) {
                                    prefs.setString(
                                        'changelog', SizeConfig.appVersion);
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              )
            : Container()
      ],
    );
  }
}

List<TargetFocus> targets(
    drLeftKey, drRightKey, redButtonKey, paysheetKey, clothKey, pollsKey) {
  List<TargetFocus> targets = List();
  targets.add(TargetFocus(identify: "DrLeft", keyTarget: drLeftKey, contents: [
    ContentTarget(
        align: AlignContent.bottom,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Главное меню',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Здесь расположена Ваша персональная информация, доступные услуги и другие интерактивные разделы приложения',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ))
  ]));
  targets
      .add(TargetFocus(identify: "DrRight", keyTarget: drRightKey, contents: [
    ContentTarget(
        align: AlignContent.bottom,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Меню "Полезная информация"',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Здесь расположены справочные материалы полезные для сотрудника предприятия",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ))
  ]));
  targets.add(TargetFocus(identify: "Idea", keyTarget: redButtonKey, contents: [
    ContentTarget(
        align: AlignContent.bottom,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Кнопка "Предложить функционал"',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Вы всегда можете воспользоваться этой кнопкой и предложить функционал, которого по Вашему мнению, нехватает в приложении",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ))
  ]));
  targets
      .add(TargetFocus(identify: "PaySheer", keyTarget: paysheetKey, contents: [
    ContentTarget(
        align: AlignContent.top,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Расчетный лист всегда рядом',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'В любой момент у Вас есть доступ к своему расчетному листу',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ))
  ]));
  targets.add(TargetFocus(identify: "Cloth", keyTarget: clothKey, contents: [
    ContentTarget(
        align: AlignContent.top,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Быстрый доступ к СИЗ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Вы всегда можете отследить список необходимых к получению и выданных СИЗ',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ))
  ]));
  targets.add(TargetFocus(identify: "Polls", keyTarget: pollsKey, contents: [
    ContentTarget(
        align: AlignContent.top,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Участвуйте в опросах',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Вы можете принимать участие в опросах, а затем узнать результаты',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ))
  ]));
  return targets;
}
