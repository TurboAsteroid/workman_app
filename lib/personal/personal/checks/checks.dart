import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:personal/personal/system/helpers.dart';

import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/personal/checks/check.dart';

class Checks extends StatefulWidget {
  final String url;
  final String title;

  Checks(this.url, this.title);

  @override
  _ChecksState createState() => _ChecksState();
}

class _ChecksState extends State<Checks> {
  ChecksBloc _bloc;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = ChecksBloc(widget.url);
    _scrollController = new ScrollController();
    _bloc.add(GetDataEv());
    
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          if (state is DataSt) {
            return Container(
              child: new SmartRefresher(
                header: ClassicHeader(
                  completeIcon: const Icon(Icons.done),
                  completeText: 'Обновлено успешно',
                  refreshingText: 'Загрузка...',
                  idleIcon: const Icon(Icons.arrow_upward),
                  idleText: 'Потяните вниз, чтобы обновить...',
                  releaseIcon: const Icon(Icons.refresh),
                  releaseText: 'Отпустите, чтобы обновить...',
                ),
                enablePullDown: true,
                enablePullUp: false,
                controller: state.refreshController,
                onRefresh: () => _bloc.add(GetDataEv()),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.checksByDates.length,
                  itemBuilder: (context, index) {
                    List<Widget> cardItems = [];
                    String dt = '';
                    state.checksByDates[index].forEach((Check it) {
                      IconData icon = Icons.check;
                      if (it.checkPoint.toLowerCase().contains('вход')) {
                        icon = Icons.arrow_forward;
                      } else if (it.checkPoint
                          .toLowerCase()
                          .contains('выход')) {
                        icon = Icons.arrow_back;
                      }
                      dt = it.dateTime;
                      cardItems.add(Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: ListTile(
                          leading: Container(
                            child: Icon(icon, color: Colors.white),
                            decoration: new BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(999))),
                          ),
                          title: Text(
                            it.checkPoint,
                          ),
                          subtitle: Text(Helpers.dt(dt)),
                        ),
                      ));
                    });
                    return dayCard(state, index, dt, cardItems);
                  },
                ),
              ),
            );
          }
          if (state is InitSt) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ErrorSt) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => _bloc.add(GetDataEv()),
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
          return Center(child: Text(state.error));
        },
      ),
    );
  }

  Widget dayCard(DataSt state, int index, String dt, List<Widget> cardItems) {
    return ExpansionTile(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(state.checksByDates[index].length.toString()),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        Helpers.dtOnlyDate(dt),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.justify,
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      'Количество входов-выходов',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: cardItems);
  }
}

abstract class ChecksSt {}

class InitSt extends ChecksSt {}

class DataSt extends ChecksSt {
  List<Check> checks;
  RefreshController refreshController;
  List<List<Check>> checksByDates;

  DataSt(this.checks, this.refreshController, this.checksByDates);
}

class ErrorSt extends ChecksSt {
  String error;

  ErrorSt(this.error);
}

abstract class ChecksEv {}

class GetDataEv extends ChecksEv {}

class ChecksBloc extends Bloc<ChecksEv, ChecksSt> {
  String url;

  ChecksBloc(this.url);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  ChecksSt get initialState => InitSt();

  @override
  Stream<ChecksSt> mapEventToState(ChecksEv event) async* {
    if (event is GetDataEv) {
      ServerResponse sr = await ajaxGet(url);
      if (sr.status != 'ok') {
        yield ErrorSt('Ошибка загрузки данных о контроле доступа');
      }
      _refreshController.refreshCompleted();
      List<Check> checks = [Check.fromJson(sr.data['checks'][0])];

      // надо сделать карточку на проходки данные в checksByDates

      List<List<Check>> checksByDates = [];
      for (int i = 1; i < sr.data['checks'].length; i++) {
        if (Check.fromJson(sr.data['checks'][i - 1])
                .dateTime
                .substring(0, 10) !=
            Check.fromJson(sr.data['checks'][i]).dateTime.substring(0, 10)) {
          checksByDates.add(checks);
          checks = [];
        }
        checks.add(Check.fromJson(sr.data['checks'][i]));
      }
      checks = [Check.fromJson(sr.data['checks'][0])];
      for (int i = 0; i < sr.data['checks'].length; i++) {
        checks.add(Check.fromJson(sr.data['checks'][i]));
      }
      yield DataSt(checks, _refreshController, checksByDates);
    }
  }
}
