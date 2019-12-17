import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:personal/personal/menu/dynamicWidgets/schedule/card_schedule.dart';

import './bloc.dart';
import './event.dart';
import './state.dart';

class ListSchedule extends StatefulWidget {
  final String url;

  ListSchedule(this.url);

  @override
  _ListScheduleState createState() => _ListScheduleState();
}

class _ListScheduleState extends State<ListSchedule> {
  final ListScheduleBloc _bloc = ListScheduleBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(GetData(context, widget.url));
    
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListScheduleBloc, ListScheduleState>(
      bloc: _bloc,
      builder: (BuildContext context, ListScheduleState state) {
        if (state is ListScheduleData) {
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
              onRefresh: () => _bloc
                  .add(GetData(context, widget.url)),
              child: ListView.builder(
                itemCount: state.listOfCardScheduleData.length,
                itemBuilder: (context, index) {
                  return CardSchedule(state.listOfCardScheduleData[index]);
                },
              ),
            ),
          );
        }
        if (state is ListScheduleInit) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ListScheduleError) {
          return Center(child: Text(state.error));
        }
        return Container();
      },
    );
  }
}
