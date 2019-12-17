import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/polls/bloc.dart';
import 'package:personal/personal/polls/pollsData.dart';

class PollStepByStep extends StatefulWidget {
  final Pbl pbl;

  PollStepByStep(this.pbl);

  @override
  _PollStepByStepState createState() => _PollStepByStepState();
}

class _PollStepByStepState extends State<PollStepByStep> {
  Future<void> _cantSend() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ответы не отправлены'),
          content: SingleChildScrollView(
            child: Text(
              'Пожалуйста, ответе на все вопросы, а затем нажмите снова на кнопку отправки.',
              textAlign: TextAlign.justify,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Понятно'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() {
          widget.pbl.add(LoadDataPev(context: context));
          Navigator.of(context).pop(true);
          return false;
        });
      },
      child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<Pbl, Pst>(
                bloc: widget.pbl,
                builder: (BuildContext context, Pst state) {
                  if (state is SelectedPst) return Text(state.pollsData.title);
                  if (state is ResultsPst) return Text(state.pollsData.title);
                  return Text('');
                }),
          ),
          bottomNavigationBar: BlocBuilder<Pbl, Pst>(
            bloc: widget.pbl,
            builder: (BuildContext context, Pst state) {
              if (state is SelectedPst) {
                if (state.pollsData.questions.length == 0)
                  return Container(height: 0);
                Widget right = FlatButton.icon(
                  icon: Icon(Icons.navigate_next),
                  label: Text('Далее'),
                  onPressed: () {
                    setState(() {
                      _questionPagesIndex++;
                    });
                  },
                );
                Widget left = FlatButton.icon(
                  icon: Icon(Icons.navigate_before),
                  label: Text('Назад'),
                  onPressed: () {
                    setState(() {
                      _questionPagesIndex--;
                    });
                  },
                );
                if (_questionPagesIndex + 1 == state.pollsData.questions.length)
                  right = FlatButton.icon(
                    icon: Icon(Icons.send),
                    label: Text('Проголосовать'),
                    onPressed: () => _sender(state),
                  );
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  height: SizeConfig.blockSizeVertical * 14,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _questionPagesIndex != 0 ? left : Container(),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 3,
                          ),
                          right,
                        ],
                      ),
                      Text(
                          'Всего ${_questionPagesIndex + 1} из ${state.pollsData.questions.length}')
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
          body: BlocBuilder<Pbl, Pst>(
            bloc: widget.pbl,
            builder: (BuildContext context, Pst state) {
              if (state is SelectedPst) {
                if (state.pollsData.questions.length == 0)
                  return state.pollsData.description.length == 0
                      ? Container()
                      : Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(state.pollsData.description),
                            ),
                          ],
                        );
                return Dismissible(
                    direction: DismissDirection.endToStart,
                    resizeDuration: null,
                    onDismissed: (DismissDirection direction) {
                      if (_questionPagesIndex + 1 <
                          state.pollsData.questions.length) {
                        setState(() {
                          _questionPagesIndex +=
                              direction == DismissDirection.endToStart ? 1 : -1;
                        });
                      } else {
                        setState(() {
                          _questionPagesIndex = 0;
                        });
                      }
                    },
                    key: new ValueKey(_questionPagesIndex),
                    child: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        state.pollsData.description.length == 0
                            ? Container()
                            : Container(
                                padding: EdgeInsets.all(16),
                                child: Text(state.pollsData.description),
                              ),
                        _questionPageBuilder(state),
                      ],
                    )));
              }
              if (state is ResultsPst) {
                SizeConfig().init(context);
                return ListView.builder(
                  itemCount: state.pollsData.questions.length,
                  itemBuilder: (BuildContext context, int i) {
                    List<Widget> wdgs = [];
                    for (int j = 0;
                        j < state.pollsData.questions[i].options.length;
                        j++) {
                      wdgs.add(
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal * 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                    child: Text(state.pollsData.questions[i]
                                        .options[j].title)),
                                Text(
                                    '${state.pollsData.questions[i].options[j].result} %')
                              ],
                            ),
                            LinearProgressIndicator(
                              value: double.parse(
                                    state.pollsData.questions[i].options[j]
                                        .result
                                        .toString(),
                                  ) /
                                  100,
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${i + 1}. ${state.pollsData.questions[i].title}',
                                style:
                                    Theme.of(context).primaryTextTheme.display3,
                              )),
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              children: wdgs,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          )),
    );
  }

  _sender(Pst state) {
    if (state is SelectedPst) {
      for (int i = 0; i < state.questionAnswers.length; i++) {
        for (int j = 0; j < state.questionAnswers[i].options.length; j++) {
          if (state.questionAnswers[i].options[j].state == true) break;
          if (state.questionAnswers[i].options[j].state == false &&
              state.questionAnswers[i].options.length == j + 1) {
            _cantSend();
            return;
          }
        }
      }
      widget.pbl.add(SendPev(
          PollsAnswer(
              id: state.pollsData.id, questionAnswers: state.questionAnswers),
          context: context));
    }
  }

  int _questionPagesIndex = 0;

  _questionPageBuilder(Pst state) {
    if (state is SelectedPst) {
      if (state.pollsData.questions.length == 0) return Container();
      int i = _questionPagesIndex;
      List<Widget> wdgs = [];
      for (int j = 0; j < state.pollsData.questions[i].options.length; j++) {
        wdgs.add(CheckboxListTile(
          title: Text(state.pollsData.questions[i].options[j].title),
          value: state.questionAnswers[i].options[j].state,
          onChanged: (bool value) {
            if (state.pollsData.questions[i].type == 0) {
              for (int i1 = 0;
                  i1 < state.questionAnswers[i].options.length;
                  i1++) {
                setState(() {
                  state.questionAnswers[i].options[i1].state = false;
                });
              }
            }
            setState(() {
              state.questionAnswers[i].options[j].state = value;
            });
          },
          controlAffinity:
              ListTileControlAffinity.leading, //  <-- leading Checkbox
        ));
      }
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  '${i + 1}. ${state.pollsData.questions[i].title}',
                )),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                children: wdgs,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
