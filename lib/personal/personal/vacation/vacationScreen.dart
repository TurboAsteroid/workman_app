import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/config.dart';

import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/personal/vacation/vacationData.dart';

class VacationScreen extends StatefulWidget {
  final String url;
  final String title;

  VacationScreen(this.url, this.title);

  @override
  _VacationScreenState createState() => _VacationScreenState();
}

class _VacationScreenState extends State<VacationScreen> {
  Bl _vacationBl;

  @override
  void initState() {
    super.initState();
    _vacationBl = Bl(widget.url);
    _vacationBl.add(LoadEv());
    
  }

  @override
  void dispose() {
    _vacationBl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder(
          bloc: _vacationBl,
          builder: (context, state) {
            if (state is LoadedSt) {
              return Container(
                  padding: EdgeInsets.all(8),
                  child: Card(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Stack(children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/vacation.jpg',
                                ),
                              ),
                            ),
                            height: SizeConfig.screenHeight * 0.33,
                          ),
                          Container(
                            height: SizeConfig.screenHeight * 0.33,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0),
                                      Colors.white.withOpacity(0),
                                      Colors.black38,
                                    ],
                                    stops: [
                                      0.0,
                                      0.3,
                                      1.0
                                    ])),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Отпуск',
                                style:
                                    Theme.of(context).primaryTextTheme.display3,
                              ),
                              alignment: Alignment.bottomLeft,
                            ),
                          ),
                        ]),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text('Запланировано:',
                              style:
                                  Theme.of(context).primaryTextTheme.display4),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.vacation.data.plannedDates.length,
                            itemBuilder: (context, i) {
                              return PlannedVacationWdg(
                                  state.vacation.data.plannedDates[i]);
                            },
                          ),
                        ),
                        Divider(color: Colors.black38,),
                        VacationAdditionInfo(state.vacation),
                        PeriodOfExistenceWdg(
                            state.vacation.data.periodOfExistence),
                      ])));
            }
            if (state is NoneSt) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.airplanemode_active,
                      size: 82,
                      color: Colors.black38,
                    ),
                    SizedBox(height: 16),
                    Text(state.text,
                        style: Theme.of(context).primaryTextTheme.display4,
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }
            if (state is LoadingSt) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ErrorSt) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => _vacationBl.add(LoadEv()),
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
    );
  }
}

class PeriodOfExistenceWdg extends StatelessWidget {
  PeriodOfExistenceWdg(this.periodOfExistence);

  final PeriodOfExistence periodOfExistence;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Text(
          'Период удовлетворения:\n${periodOfExistence.start} - ${periodOfExistence.end}'),
    );
  }
}

class PlannedVacationWdg extends StatelessWidget {
  PlannedVacationWdg(this.plannedDates);

  final PlannedDates plannedDates;

  @override
  Widget build(BuildContext context) {
    String monthName = 'январе';
    if (this.plannedDates.month == 2) monthName = 'феврале';
    if (this.plannedDates.month == 3) monthName = 'марте';
    if (this.plannedDates.month == 4) monthName = 'апреле';
    if (this.plannedDates.month == 5) monthName = 'мае';
    if (this.plannedDates.month == 6) monthName = 'июне';
    if (this.plannedDates.month == 7) monthName = 'июле';
    if (this.plannedDates.month == 8) monthName = 'августе';
    if (this.plannedDates.month == 9) monthName = 'сентябре';
    if (this.plannedDates.month == 10) monthName = 'октябре';
    if (this.plannedDates.month == 11) monthName = 'ноябре';
    if (this.plannedDates.month == 12) monthName = 'декабре';
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Text(
          '${this.plannedDates.year} год: в $monthName ${this.plannedDates.numberOfDays} дней',
          style: Theme.of(context).primaryTextTheme.display4),
    );
  }
}

class VacationAdditionInfo extends StatelessWidget {
  final Vacation vacation;

  VacationAdditionInfo(this.vacation);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Дней дополнительного отпуска: ${vacation.data.debt.addidtionDays}'),
          Text(
              'Задолженность дней прошлого периода: ${vacation.data.debt.debtLastPeriod}'),
          Text('Остаток дней текущего периода: ${vacation.data.debt.currentPeriodDebt}'),
        ],
      ),
    );
  }
}

abstract class St {}

class InitSt extends St {}

class LoadedSt extends St {
  Vacation vacation;

  LoadedSt(this.vacation);
}

class LoadingSt extends St {}

class NoneSt extends St {
  final String text;

  NoneSt(this.text);
}

class ErrorSt extends St {
  String error;

  ErrorSt(this.error);
}

abstract class Ev {}

class LoadEv extends Ev {}

class Bl extends Bloc<Ev, St> {
  final String url;

  Bl(this.url);

  @override
  St get initialState => InitSt();

  @override
  Stream<St> mapEventToState(Ev event) async* {
    yield LoadingSt();
    if (event is LoadEv) {
      ServerResponse sr = await ajaxGet(url);
      if (sr.status.toLowerCase() == 'ok') {
        try {
          Vacation vacation = Vacation.fromJson(sr.data);
          yield LoadedSt(vacation);
          return;
        } catch (a) {
          yield NoneSt('Нет данных об отпуске');
        }
      }
      yield NoneSt('Нет данных об отпуске');
    }
  }
}
