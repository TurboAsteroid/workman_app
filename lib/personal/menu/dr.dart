import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:personal/personal/menu/bloc.dart';
import 'package:personal/personal/menu/menu_Events_States.dart';

class Dr extends StatefulWidget {
  final MenuBloc bloc;

  Dr(this.bloc);

  @override
  _DrState createState() => _DrState();
}

class _DrState extends State<Dr> {

  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
          return BlocBuilder(
              bloc: widget.bloc,
              builder: (BuildContext context, MenuState state) {
                if (state is DrawMenu) {
                  return Drawer(
                    child: Column(
                        children: <Widget>[
                          Flexible(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: state.widgets,
                            ),
                          )
                        ],
                      )
                    ,
                  );
                }
                if (state is Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              });
  }
}
