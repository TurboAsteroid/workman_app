import 'package:flutter/material.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/menu/dynamicWidgets/proWatch/results/proResult.dart';

Widget proResultsCardLeft(BuildContext context, ProResult item) {
  SizeConfig().init(context);
  return Card(
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: new BorderRadius.circular(5.0),
            child: Image.asset(
              'assets/images/${item.img}.jpg',
              height: SizeConfig.safeBlockVertical * 20,
            ),
          ),
//          Image.network(
//            'https://img.purch.com/w/660/aHR0cDovL3d3dy5saXZlc2NpZW5jZS5jb20vaW1hZ2VzL2kvMDAwLzEwNC84MzAvb3JpZ2luYWwvc2h1dHRlcnN0b2NrXzExMTA1NzIxNTkuanBn',
//            height: SizeConfig.safeBlockVertical * 20,
//          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${item.name.toString()}',
                      style: Theme.of(context).primaryTextTheme.title,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('План: ${item.plan.toString()}'),
                        Text('Факт: ${item.fact.toString()}'),
                        Text('Осталось: ${item.left.toString()} дней'),
                        Text(
                            'Выполнено: ${(item.fact / item.plan * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context).primaryTextTheme.display4),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget proResultsCardRight(BuildContext context, ProResult item) {
  SizeConfig().init(context);
  return Card(
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'Цех: ${item.name.toString()}',
                      style: Theme.of(context).primaryTextTheme.title,
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('План: ${item.plan.toString()}'),
                        Text('Факт: ${item.fact.toString()}'),
                        Text('Осталось: ${item.left.toString()} дней'),
                        Text(
                          'Выполнено: ${(item.fact / item.plan * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).primaryTextTheme.display4,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: SizeConfig.safeBlockVertical * 10,
          ),
          Image.network(
            'https://miro.medium.com/max/320/0*koHv4qj2mQg3Nvly',
            height: SizeConfig.safeBlockVertical * 20,
          ),
        ],
      ),
    ),
  );
}
