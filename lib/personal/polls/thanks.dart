import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/personal/polls/bloc.dart';

class Thanks extends StatefulWidget {
  final Pbl pbl;

  Thanks(this.pbl);

  @override
  _ThanksState createState() => _ThanksState();
}

class _ThanksState extends State<Thanks> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() {
          widget.pbl.add(LoadDataPev(context: context));
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          return false;
        });
      },
      child: Scaffold(
        body: BlocBuilder<Pbl, Pst>(
          bloc: widget.pbl,
          builder: (BuildContext context, Pst state) {
            if (state is SendingPst)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (state is SendedPst)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.done,
                      color: Colors.green,
                      size: 86,
                    ),
                    Text('Спасибо за участие в голосовании!'),
                    Text('Ваш голос учтен.'),
                    RaisedButton.icon(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        widget.pbl.add(LoadDataPev());
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      label: Text('Вернуться к списку опросов'),
                    )
                  ],
                ),
              );
            return Container();
          },
        ),
      ),
    );
  }
}
