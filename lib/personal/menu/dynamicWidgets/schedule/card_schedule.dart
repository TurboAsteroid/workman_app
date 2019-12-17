import 'package:flutter/material.dart';
import 'dart:math';

import 'card_schedule_data.dart';

class CardSchedule extends StatelessWidget {
  final CardScheduleData cardScheduleData;

  CardSchedule(this.cardScheduleData);

  @override
  Widget build(BuildContext context) {
    List<Widget> content = [];
    content.add(Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Text(cardScheduleData.description, textAlign: TextAlign.justify,)));
    content.add(SizedBox(height: 8.0));
    content.add(Text(cardScheduleData.scheduleName,
        style: TextStyle(fontWeight: FontWeight.bold)));
    for (int i = 0; i < cardScheduleData.schedule.length; i++) {
      content.add(
        Container(
          padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
          child: Column(
            children: <Widget>[
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(cardScheduleData.schedule[i].name),
                  Text(cardScheduleData.schedule[i].datetime)
                ],
              ),
            ],
          ),
        ),
      );
    }
    content.add(Container(
      padding: EdgeInsets.only(bottom: 22),
    ));
    return Card(
      child: ExpansionTile(
        key: PageStorageKey(Random().nextInt(10000)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              cardScheduleData.header,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              cardScheduleData.subheader,
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            )
          ],
        ),
        children: content,
      ),
    );
  }
}
