import 'package:flutter/material.dart';
import 'package:personal/personal/personal/education/educationData.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard(this.course);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(course.title,
                      style: Theme.of(context).primaryTextTheme.title),
                ),
                Text('Дата прохождения: ${course.date}',
                    style: Theme.of(context).textTheme.subhead),
                Text('Номер протокола: ${course.protocolNumber}',
                    style: Theme.of(context).textTheme.subhead),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
