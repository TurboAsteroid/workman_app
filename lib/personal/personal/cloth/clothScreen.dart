import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/personal/personal/cloth/item_got.dart';

import './bloc.dart';
import './item_get.dart';

class ClothScreen extends StatelessWidget {
  ClothScreen(this.url);

  final String url;
  final TabController _tabController =
      TabController(length: 2, vsync: AnimatedListState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('СИЗ'),
          bottom: sizTabBar(_tabController),
//          actions: <Widget>[ToFavorites('Siz')],
        ),
        body: Siz(_tabController, url));
  }
}

class Siz extends StatefulWidget {
  final String url;
  final TabController tabController;

  Siz(this.tabController, this.url);

  @override
  _SizState createState() => _SizState();
}

class _SizState extends State<Siz> {
  ClothBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ClothBloc(widget.url);
    _bloc.add(LoadEv());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClothBloc, ClothSt>(
      bloc: _bloc,
      builder: (BuildContext context, ClothSt state) {
        if (state is LoadedSt) {
          return TabBarView(controller: widget.tabController, children: [
            Container(
              child: state.clothData.get.length > 0
                  ? ListView.builder(
                      itemCount: state.clothData.get.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            Item(state.clothData.get[i]),
                            Divider()
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.done,
                            size: 82,
                            color: Colors.black38,
                          ),
                          SizedBox(height: 16),
                          Text('Все СИЗ получены',
                              style:
                                  Theme.of(context).primaryTextTheme.display4),
                        ],
                      ),
                    ),
            ),
            Container(
              child: state.clothData.got.length > 0
                  ? ListView.builder(
                      itemCount: state.clothData.got.length,
                      itemBuilder: (context, i) {
                        return ItemGot(state.clothData.got[i]);
                      },
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.error_outline,
                            size: 82,
                            color: Colors.black26,
                          ),
                          SizedBox(height: 16),
                          Text('Вы не получали СИЗ',
                              style:
                                  Theme.of(context).primaryTextTheme.display4),
                        ],
                      ),
                    ),
            ),
          ]);
        }
        if (state is LoadingSt) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ErrorSt) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () => _bloc.add(LoadEv()),
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

PreferredSizeWidget sizTabBar(TabController tabController) {
  return TabBar(
    controller: tabController,
    labelColor: Colors.white,
    tabs: [
      Tab(
        icon: Icon(Icons.error_outline),
        text: 'Необходимо получить',
      ),
      Tab(
        icon: Icon(Icons.done_outline),
        text: 'Вам выдано',
      ),
    ],
  );
}
