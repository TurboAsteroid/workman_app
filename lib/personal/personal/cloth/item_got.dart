import 'package:flutter/material.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/personal/cloth/clothData.dart';
import 'package:personal/personal/system/helpers.dart';

class ItemGot extends StatelessWidget {
  final Got got;

  ItemGot(this.got);

  @override
  Widget build(BuildContext context) {
    return Card(
//      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            constraints: BoxConstraints(
              minHeight: 48,
            ),
            padding: EdgeInsets.all(8.0),
            child: got.dESCRIPT == ''
                ? Container()
                : Text(
                    got.dESCRIPT,
                    style: Theme.of(context).textTheme.subhead,
                  ),
          ),
          Container(height: 1, color: Colors.black12),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                got.pERCENTWEAR == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Text('Износ: ${got.pERCENTWEAR}%'),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 10,
                                    color: Colors.black12,
                                    width: SizeConfig.screenWidth * 0.2,
                                  ),
                                  Container(
                                      height: 10,
                                      color: Colors.blue,
                                      width: SizeConfig.screenWidth * 0.2 -
                                          SizeConfig.screenWidth *
                                              0.2 *
                                              got.pERCENTWEAR /
                                              100),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                Container(width: 1, color: Colors.black12),
                got.aQUANT == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Text(
                                'Выдано ${got.aUOM.toString().toLowerCase()}: '),
                            Text(got.aQUANT.toString()),
                          ],
                        ),
                      ),
                Container(width: 1, color: Colors.black12),
                FlatButton(
                  child: Text('ПОДРОБНО'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemGotAdvanced(got),
                      settings: RouteSettings(name: 'ItemGotAdvanced'),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ItemGotAdvanced extends StatelessWidget {
  final Got got;

  ItemGotAdvanced(this.got);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(got.dESCRIPT == '' ? '' : got.dESCRIPT.split(' ')[0])),
      body: SingleChildScrollView(
        child: Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              got.dESCRIPT == ''
                  ? Container()
                  : Text(
                      'Фактически выданно:\n${got.dESCRIPT}',
                      style: Theme.of(context).textTheme.subhead,
                    ),
              got.aQUANT == null
                  ? Container()
                  : Text(
                      'Количество ${got.aUOM}: ${got.aQUANT}',
                      style: Theme.of(context).textTheme.subhead,
                    ),
              Divider(),
              got.sROK == ''
                  ? Container()
                  : Text('Срок эксплуатации, лет: ${got.sROK}'),
              got.aKTIV == ''
                  ? Container()
                  : Text(
                      'Начало использования: ${Helpers.dtOnlyDate(got.aKTIV)}'),
              got.dEAKTIV == ''
                  ? Container()
                  : Text(
                      'Конец использования: ${Helpers.dtOnlyDate(got.dEAKTIV)}'),
              Divider(),
              got.wGBEZ == ''
                  ? Container()
                  : Text('Полагалось к выдаче: ${got.wGBEZ}'),
              got.qUOTA == null ? Container() : Text('Лимит: ${got.qUOTA}'),
              Divider(),
              got.pERCENTWEAR == null
                  ? Container()
                  : Padding(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Text('Износ: ${got.pERCENTWEAR}%'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 10,
                            color: Colors.black12,
                            width: SizeConfig.screenWidth,
                          ),
                          Container(
                              height: 10,
                              color: Colors.blue,
                              width: SizeConfig.screenWidth -
                                  SizeConfig.screenWidth *
                                      got.pERCENTWEAR /
                                      100),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
