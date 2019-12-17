import 'package:flutter/material.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/personal/cloth/clothData.dart';

class Item extends StatelessWidget {
  final Get get;

  Item(this.get);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (get.qUOTA == null || get.wGBEZ == null)
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: SizeConfig.screenHeight / 3),
        child: Text('Нет доступной спецодежды'),
      );
      return Row(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(get.wGBEZ, style: Theme.of(context).textTheme.subhead),
                  Text(
                    'Количество: ${get.qUOTA}',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          )
        ],
      );
  }
}
