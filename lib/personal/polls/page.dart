import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:personal/personal/polls/bloc.dart';

class Polls extends StatefulWidget {
  Polls(this.url, this.title);

  final String url;
  final String title;

  @override
  _PollsState createState() => _PollsState();
}

class _PollsState extends State<Polls> {
  Pbl pbl;

  @override
  void initState() {
    super.initState();
    pbl = Pbl(widget.url);
    pbl.add(LoadDataPev());
    
  }

  @override
  void dispose() {
    pbl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<Pbl, Pst>(
        bloc: pbl,
        builder: (BuildContext context, Pst state) {
          if (state is AllPst) {
            return ListView.builder(
              itemCount: state.pdl.length,
              itemBuilder: (BuildContext context, int i) {
                if (state.pdl[i].voted)
                  return ListTile(
                    leading: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    title: Text('Результаты: ' + state.pdl[i].title),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      pbl.add(ResultsPev(state.pdl[i], context));
                    },
                  );
                return ListTile(
                  leading: Icon(Icons.insert_chart),
                  title: Text(state.pdl[i].title),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    pbl.add(SelectPev(state.pdl[i], context: context));
                  },
                );
              },
            );
          }
          if (state is ErrPst) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () =>
                          pbl.add(LoadDataPev()),
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
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
