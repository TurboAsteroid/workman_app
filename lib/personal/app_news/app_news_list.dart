import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:personal/personal/app_news/app_card_news.dart';
import 'package:personal/personal/app_news/bloc.dart';


class AppNewsList extends StatefulWidget {
  final String url;

  AppNewsList(this.url);

  @override
  _AppNewsListState createState() => _AppNewsListState();
}

class _AppNewsListState extends State<AppNewsList> {
  final EventBloc _bloc = EventBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(GetAppNewsEv(context, widget.url));

  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      bloc: _bloc,
      builder: (BuildContext context, EventState state) {
        if (state is AppNewsLoadedSt) {
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
                  onRefresh: () => _bloc.add(GetAppNewsEv(context, widget.url)),
                  child: ListView.builder(
                    itemCount: state.newsInListData.length,
                    itemBuilder: (context, index) {
                      return AppCardNews(
                          state.newsInListData[index], state.token);
                    },
                  )));
        }
        if (state is AppNewsInitSt) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is AppNewsErrorSt) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () =>
                        _bloc.add(GetAppNewsEv(context, widget.url)),
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
      },
    );
  }
}
