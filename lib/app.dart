import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:personal/personal/init.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Персонал',
      // TODO переделать все под цвет темы
      theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.blue, textTheme: ButtonTextTheme.primary),
          primaryTextTheme: TextTheme(
            title: TextStyle(color: Colors.black),
            body1: TextStyle(color: Colors.black87),
            body2: TextStyle(color: Colors.black87),
            subtitle: TextStyle(color: Colors.black87),
            display1: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w300, fontSize: 16),
            display3: TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.w300),
            display4: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w300,
                fontSize: 24),
          ),
          appBarTheme: AppBarTheme(
            color: Colors.blue,
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
      home: Init(),
    );
  }
}
