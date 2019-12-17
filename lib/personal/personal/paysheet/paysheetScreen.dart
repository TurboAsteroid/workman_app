import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/personal/paysheet/paysheetData.dart';

class PaySheet extends StatefulWidget {
  final String url;

  PaySheet(this.url);

  @override
  _PaySheetState createState() => _PaySheetState();
}

class _PaySheetState extends State<PaySheet> {
  PsBl _psBl;
  bool accept = false;

  @override
  void initState() {
    super.initState();
    _psBl = PsBl(widget.url);
    _psBl.add(PsLoadEv());
  }

  @override
  void dispose() {
    _psBl.close();
    super.dispose();
  }

  month(int monthNum) {
    List<String> month = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ];
    return month[monthNum - 1];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('Расчетный лист'),
//        actions: <Widget>[ToFavorites('PaySheet')],
          ),
          body: BlocBuilder(
              bloc: _psBl,
              builder: (context, state) {
                if (state is PsLoadedSt) {
                  List<Widget> list = [];

                  list.add(
                    Column(
                      children: <Widget>[
                        Text(
                          '${month(state.paysheetData.month)} ${state.paysheetData.year}',
                          style: Theme.of(context).primaryTextTheme.display4,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(state.paysheetData.data[0].rate.name,
                                  style:
                                      Theme.of(context).primaryTextTheme.title),
                              Text(
                                  double.parse(
                                          state.paysheetData.data[0].rate.value)
                                      .toStringAsFixed(2),
                                  style:
                                      Theme.of(context).primaryTextTheme.title)
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  state.paysheetData.data[0].workingTimeFundPlan
                                      .name,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle),
                              Text(
                                  state.paysheetData.data[0].workingTimeFundPlan
                                      .value
                                      .toString(),
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle)
                            ])
                      ],
                    ),
                  );

                  List<Widget> nacis = [
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Начисления за месяц',
                        style: Theme.of(context).primaryTextTheme.title,
                      ),
                    )
                  ];
                  List<TableRow> r = [
                    TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Вид',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle,
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Наименование',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle,
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Сумма',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle,
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Время',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle,
                              textAlign: TextAlign.center),
                        ),
                      ],
                    )
                  ];
                  state.paysheetData.data[0].accrualsPerMonth.data.forEach((v) {
                    List<TableCell> rr = [];
                    if (v[0].value != '') {
                      v.forEach((vv) {
                        rr.add(TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(vv.value,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle, textAlign: TextAlign.end,),
                        )));
                      });
                      r.add(TableRow(children: rr));
                    }
                  });
                  Widget t = Table(
                    columnWidths: {
                      0: FlexColumnWidth(0.2),
                      1: FlexColumnWidth(0.38),
                      2: FlexColumnWidth(0.32),
                      3: FlexColumnWidth(0.3),
                    },
                    border: TableBorder.all(width: 1, color: Colors.black87),
                    children: r,
                  );
                  nacis.add(t);
                  nacis.add(
                    Column(
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  state.paysheetData.data[0].accrualsPerMonth
                                      .totalAccrued.wageSlipName,
                                  style:
                                      Theme.of(context).primaryTextTheme.title),
                              Text(
                                  state.paysheetData.data[0].accrualsPerMonth
                                      .totalAccrued.value,
                                  style:
                                      Theme.of(context).primaryTextTheme.title)
                            ]),
                      ],
                    ),
                  );
                  list.add(Column(children: nacis));

                  List<Widget> uder = [
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Удержания за месяц',
                        style: Theme.of(context).primaryTextTheme.title,
                      ),
                    )
                  ];
                  List<TableRow> rUder = [
                    TableRow(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Вид',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle,
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Наименование',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle,
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Сумма',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle,
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Основание',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle,
                              textAlign: TextAlign.center),
                        ),
                      ],
                    )
                  ];
                  state.paysheetData.data[0].retentionsPerMonth.data
                      .forEach((v) {
                    List<TableCell> rr = [];
                    if (v[0].value != '') {
                      v.forEach((vv) {
                        rr.add(TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(vv.value,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle, textAlign: TextAlign.end,),
                        )));
                      });
                      rUder.add(TableRow(children: rr));
                    }
                  });
                  Widget tUder = Table(
                    columnWidths: {
                      0: FlexColumnWidth(0.2),
                      1: FlexColumnWidth(0.38),
                      2: FlexColumnWidth(0.32),
                      3: FlexColumnWidth(0.3),
                    },
                    border: TableBorder.all(width: 1, color: Colors.black87),
                    children: rUder,
                  );
                  uder.add(tUder);
                  uder.add(
                    Column(
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  state.paysheetData.data[0].retentionsPerMonth
                                      .totalRetentions.wageSlipName,
                                  style:
                                      Theme.of(context).primaryTextTheme.title),
                              Text(
                                  state.paysheetData.data[0].retentionsPerMonth
                                      .totalRetentions.value,
                                  style:
                                      Theme.of(context).primaryTextTheme.title)
                            ]),
                      ],
                    ),
                  );
                  list.add(Column(children: uder));
                  list.add(Divider());
                  list.add(Column(
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  state.paysheetData.data[0].payroll
                                      .wageSlipName,
                                  style:
                                      Theme.of(context).primaryTextTheme.title),
                              Text(state.paysheetData.data[0].payroll.value,
                                  style:
                                      Theme.of(context).primaryTextTheme.title)
                            ]),
                      ],
                    ),
                  );
                  list.add(Divider());
                  list.add(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(state.paysheetData.data[0].taxes[0][0].name +
                            ': ' +
                            state.paysheetData.data[0].taxes[0][0].value),
                        Text(state.paysheetData.data[0].taxes[0][1].name +
                            ': ' +
                            state.paysheetData.data[0].taxes[0][1].value)
                      ],
                    ));
                  list.add(Divider());
                  List<Widget> strax = [
                    Text(
                        state.paysheetData.data[0].insurancePremiums
                            .wageSlipName,
                        style: Theme.of(context).primaryTextTheme.subtitle)
                  ];
                  state.paysheetData.data[0].insurancePremiums.data
                      .forEach((v) {
                    if (v.value != '') {
                      strax.add(Row(
                        children: <Widget>[
                          Text(v.name + ': ',
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle),
                          Text(v.value,
                              style:
                                  Theme.of(context).primaryTextTheme.subtitle),
                        ],
                      ));
                    }
                  });

                  list.add(Column(children: strax));

                  return SingleChildScrollView(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: list),
                  ));
                }
                if (state is PsNoneSt) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_balance_wallet,
                          size: 82,
                          color: Colors.black26,
                        ),
                        Text(
                          state.text,
                          style: Theme.of(context).primaryTextTheme.display4,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                if (state is PsMsgSt) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          size: 82,
                          color: Colors.black26,
                        ),
                        Text(
                          state.text,
                          style: Theme.of(context).primaryTextTheme.display4,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                if (state is PsLoadingSt) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is PsErrorSt) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            onPressed: () => _psBl.add(PsLoadEv()),
                            icon: Icon(Icons.refresh),
                          ),
                          Text(
                            state.error,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              }),
        ),
//        !accept
//            ? ClipRect(
//                child: BackdropFilter(
//                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//                  child: Container(
//                    width: SizeConfig.screenWidth,
//                    height: SizeConfig.screenHeight,
//                    decoration: BoxDecoration(
//                      color: Colors.red.withOpacity(0.85),
//                    ),
//                  ),
//                ),
//              )
//            : Container(),
//        !accept
//            ? Container(
//                alignment: Alignment.center,
//                height: SizeConfig.screenHeight * 0.88,
//                child: SingleChildScrollView(
//                  child: Padding(
//                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        Text('ВНИМАНИЕ',
//                            style: Theme.of(context).primaryTextTheme.display3),
//                        Padding(
//                          padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
//                          child: Text('Раздел находится в стадии тестирования',
//                              style:
//                                  Theme.of(context).primaryTextTheme.display3,
//                              textAlign: TextAlign.center),
//                        ),
//                        Padding(
//                          padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
//                          child: Text(
//                              'Если данные не соответствуют действительности, просим вас обращаться по телефону',
//                              style:
//                                  Theme.of(context).primaryTextTheme.display1,
//                              textAlign: TextAlign.center),
//                        ),
//                        Padding(
//                          padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
//                          child: Text('8-34368-46663',
//                              style:
//                                  Theme.of(context).primaryTextTheme.display1),
//                        ),
//                        // Если вы обнаружили ошибку, просим вас сообщить о ней в рабочее время по телефону 8-34368-46663
//                      ],
//                    ),
//                  ),
//                ),
//              )
//            : Container(),
//        !accept
//            ? Container(
//                padding: EdgeInsets.only(top: SizeConfig.screenHeight * 0.88),
//                child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//                    children: [
//                      FlatButton.icon(
//                        color: Colors.white,
//                        icon: Icon(Icons.done, color: Colors.red),
//                        label: Text(
//                          'Принять',
//                          style: TextStyle(color: Colors.red),
//                        ),
//                        onPressed: () => setState(() {
//                          accept = true;
//                        }),
//                      ),
//                      FlatButton.icon(
//                        color: Colors.white,
//                        icon: Icon(Icons.cancel, color: Colors.red),
//                        label: Text(
//                          'Отклонить',
//                          style: TextStyle(color: Colors.red),
//                        ),
//                        onPressed: () => Navigator.pop(context),
//                      ),
//                    ]),
//              )
//            : Container()
      ],
    );
  }
}

abstract class PsSt {}

class PsInitSt extends PsSt {}

class PsLoadedSt extends PsSt {
  PaysheetData paysheetData;

  PsLoadedSt({this.paysheetData});
}

class PsLoadingSt extends PsSt {}

class PsErrorSt extends PsSt {
  String error;

  PsErrorSt(this.error);
}

class PsNoneSt extends PsSt {
  final String text;

  PsNoneSt(this.text);
}

class PsMsgSt extends PsSt {
  final String text;

  PsMsgSt(this.text);
}

abstract class PsEv {}

class PsLoadEv extends PsEv {}

class PsBl extends Bloc<PsEv, PsSt> {
  final String url;

  PsBl(this.url);

  @override
  PsSt get initialState => PsInitSt();

  @override
  Stream<PsSt> mapEventToState(PsEv event) async* {
    yield PsLoadingSt();
    if (event is PsLoadEv) {
      ServerResponse sr = await ajaxGet(url);
      if (sr.status != '200' && sr.status.toLowerCase() != 'ok') {
        yield PsErrorSt('Ошибка загрузки данных расчетного листа');
        return;
      }
      if (sr.data != null) {
        PaysheetData paysheetData = PaysheetData.fromJson(sr.data);
        if (paysheetData.data == null) {
          yield PsNoneSt('Информация по расчетному листу не найдена');
          return;
        }
        yield PsLoadedSt(paysheetData: paysheetData);
        return;
      }
      yield PsNoneSt('Информация по расчетному листу не найдена');
    }
  }
}
