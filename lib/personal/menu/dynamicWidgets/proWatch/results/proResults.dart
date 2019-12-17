import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:personal/personal/menu/dynamicWidgets/proWatch/results/proResult.dart';
import 'package:personal/personal/menu/dynamicWidgets/proWatch/results/proResultsCards.dart';
import 'package:personal/personal/network/network.dart';

class ProResults extends StatefulWidget {
  final String url;
  final String title;

  ProResults(this.url, this.title);

  @override
  _ProResultsState createState() => _ProResultsState();
}

class _ProResultsState extends State<ProResults> {
  ProResultsBloc _bloc;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _bloc = ProResultsBloc(widget.url);
    _bloc.add(GetDataEv(preloader: true));
    
  }

  @override
  void dispose() {
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
            onPressed: () => _bloc.add(GetDataEv(preloader: true)),
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
                  itemCount: state.proResults.length,
                  itemBuilder: (context, index) {
                    return proResultsCardLeft(context, state.proResults[index]);
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
            return Center(
              child: Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () => _bloc.add(GetDataEv(preloader: true)),
                    icon: Icon(Icons.refresh),
                  ),
                  Text(
                    state.error,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return Center(child: Text(state.error));
        },
      ),
    );
  }
}

abstract class ProResultsSt {}

class InitSt extends ProResultsSt {}

class DataSt extends ProResultsSt {
  List<ProResult> proResults;
  RefreshController refreshController;

  DataSt(this.proResults, this.refreshController);
}

class LoadingSt extends ProResultsSt {}

class ErrorSt extends ProResultsSt {
  String error;

  ErrorSt(this.error);
}

abstract class ProResultsEv {}

class GetDataEv extends ProResultsEv {
  bool preloader = true;

  GetDataEv({this.preloader});
}

class ProResultsBloc extends Bloc<ProResultsEv, ProResultsSt> {
  String url;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ProResultsBloc(this.url);

  @override
  ProResultsSt get initialState => InitSt();

  @override
  Stream<ProResultsSt> mapEventToState(ProResultsEv event) async* {
    if (event is GetDataEv) {
      if (event.preloader) {
        yield LoadingSt();
      }
      ServerResponse sr = await ajaxGet(url);
      if (sr.status != 'ok') {
        yield ErrorSt(sr.data['message']);
      }
      List<ProResult> proResults = [];
      for (int i = 0; i < sr.data['plans'].length; i++) {
        proResults.add(ProResult.fromJson(sr.data['plans'][i]));
      }
      _refreshController.refreshCompleted();
      yield DataSt(proResults, _refreshController);
    }
  }
}
