import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import './bloc.dart';
import './event.dart';
import './state.dart';
import './card_vk_small.dart';

class ListVk extends StatefulWidget {
  @override
  _ListVkState createState() => _ListVkState();
}

class _ListVkState extends State<ListVk> {
  final VkBloc _bloc = VkBloc();
  ScrollController _scrollController;
  bool goTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setGoTopVisible(_scrollController.position.pixels != 0);
      });
    _bloc.add(VkGetData());
    
  }

  void setGoTopVisible(bool value) {
    setState(() {
      goTop = value;
    });
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
      body: BlocBuilder<VkBloc, VkState>(
        bloc: _bloc,
        builder: (BuildContext context, VkState state) {
          if (state is VkData) {
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
                onRefresh: () => _bloc.add(VkGetData()),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.listOfCardNewsData.response.newsItems.length,
                  itemBuilder: (context, index) {
                    return Container(
//                        padding: EdgeInsets.only(bottom: 8),
                        child: CardVkSmall(state
                            .listOfCardNewsData.response.newsItems[index]));
                  },
                ),
              ),
            );
          }
          if (state is VkInit) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is VkError) {
            return Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => _bloc.add(VkGetData()),
                      icon: Icon(Icons.refresh),
                    ),
                    Text(
                      'Ошибка загрузки списка новостей',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: goTop
          ? Opacity(
              opacity: 0.65,
              child: FloatingActionButton(
                backgroundColor: Colors.white70,
                onPressed: () => _scrollController.animateTo(0,
                    duration: new Duration(seconds: 2), curve: Curves.ease),
                child: Icon(
                  Icons.arrow_upward,
                  color: Colors.black54,
                ),
                mini: true,
              ))
          : null,
    );
  }
}
