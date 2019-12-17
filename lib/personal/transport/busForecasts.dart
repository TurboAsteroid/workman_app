import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/transport/busForecast.dart';

class BusForecasts extends StatefulWidget {
  final String url;
  final String title;

  BusForecasts(this.url, this.title);

  @override
  _BusForecastsState createState() => _BusForecastsState();
}

class _BusForecastsState extends State<BusForecasts> {
  Bfb _bloc;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _bloc = Bfb(widget.url);
    _bloc.add(GetDataEv(preloader: true));
    
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () => _bloc.add(GetDataEv(preloader: false)),
            icon: Icon(Icons.refresh),
          )
        ],
      ),
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
                onRefresh: () => _bloc.add(GetDataEv(preloader: false)),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.busForecasts.length,
                  itemBuilder: (context, index) {
                    String name = state.busForecasts[index].id.toString();
                    switch (name) {
                      case '661000100':
                        name = 'Центральная проходная';
                        break;
                      case '661000101':
                        name = 'КПП №6';
                        break;
                      case '661000102':
                        name = 'Производство стальных конструкций';
                        break;
                      case '661000103':
                        name = 'Купоросный цех';
                        break;
                      case '661000104':
                        name = 'Склад готовой продукции';
                        break;
                      case '661000105':
                        name = 'Экологическая лаборатория';
                        break;
                    }
                    return ListTile(
                        leading: Icon(Icons.directions_bus),
                        title: Text(name),
                        subtitle: Text('Ближайшее время прибытия: ${state.busForecasts[index].forecast}'));
                  },
                ),
              ),
            );
          }
          if (state is InitSt || state is LoadingSt) {
            return Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          }
          if (state is ErrorSt) {
            return Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () =>
                          _bloc.add(GetDataEv(preloader: true)),
                      icon: Icon(Icons.refresh),
                    ),
                    Text(
                      'Ошибка загрузки расписания движения',
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
}

abstract class BfSt {}

class InitSt extends BfSt {}

class DataSt extends BfSt {
  List<BusForecast> busForecasts;
  RefreshController refreshController;

  DataSt(this.busForecasts, this.refreshController);
}

class LoadingSt extends BfSt {}

class ErrorSt extends BfSt {
  String error;

  ErrorSt(this.error);
}

abstract class BfEv {}

class GetDataEv extends BfEv {
  bool preloader = true;
  GetDataEv({this.preloader});
}

class Bfb extends Bloc<BfEv, BfSt> {
  String url;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Bfb(this.url);

  @override
  BfSt get initialState => InitSt();

  @override
  Stream<BfSt> mapEventToState(BfEv event) async* {
    if (event is GetDataEv) {
      if(event.preloader) {
        yield LoadingSt();
      }
      ServerResponse sr = await ajaxGet(url);
      if (sr.status != 'ok') {
        yield ErrorSt(sr.data['message']);
      }
      List<BusForecast> busForecasts = [];
      for (int i = 0; i < sr.data['bus_list'].length; i++) {
        busForecasts.add(BusForecast.fromJson(sr.data['bus_list'][i]));
      }
      _refreshController.refreshCompleted();
      yield DataSt(busForecasts, _refreshController);
    }
  }
}
