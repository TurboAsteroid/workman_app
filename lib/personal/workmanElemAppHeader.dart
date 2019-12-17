import 'package:flutter/material.dart';

Widget workmanElemAppHeader () {
  return Row(
    children: <Widget>[
      Text('Персонал'),
      SizedBox(
        width: 2,
      ),
      Text(
        'элем',
        style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 10,
            fontStyle: FontStyle.italic),
      ),
    ],
  );
}