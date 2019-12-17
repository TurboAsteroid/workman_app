import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/polls/bloc.dart';
import 'package:personal/personal/polls/pollsData.dart';

class QuestionsList extends StatefulWidget {
  final Pbl pbl;

  QuestionsList(this.pbl);

  @override
  _QuestionsListState createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
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
          floatingActionButton: BlocBuilder<Pbl, Pst>(
              bloc: widget.pbl,
              builder: (BuildContext context, Pst state) {
                if (state is SelectedPst)
                  return FloatingActionButton(
                    onPressed: () {
                      for (int i = 0; i < state.questionAnswers.length; i++) {
                        for (int j = 0;
                            j < state.questionAnswers[i].options.length;
                            j++) {
                          if (state.questionAnswers[i].options[j].state == true)
                            break;
                          if (state.questionAnswers[i].options[j].state ==
                                  false &&
                              state.questionAnswers[i].options.length ==
                                  j + 1) {
                            _cantSend();
                            return;
                          }
                        }
                      }
                      widget.pbl.add(SendPev(
                          PollsAnswer(
                              id: state.pollsData.id,
                              questionAnswers: state.questionAnswers),
                          context: context));
                    },
                    child: Icon(Icons.send),
                  );
                return Text('');
              }),
          body: BlocBuilder<Pbl, Pst>(
            bloc: widget.pbl,
            builder: (BuildContext context, Pst state) {
              if (state is SelectedPst) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(state.pollsData.description),
                    ),
                    Flexible(
                      child: ListView.builder(
                        itemCount: state.pollsData.questions.length,
                        itemBuilder: (BuildContext context, int i) {
                          List<Widget> wdgs = [];
                          for (int j = 0;
                              j < state.pollsData.questions[i].options.length;
                              j++) {
                            wdgs.add(CheckboxListTile(
                              title: Text(state
                                  .pollsData.questions[i].options[j].title),
                              value: state.questionAnswers[i].options[j].state,
                              onChanged: (bool value) {
                                if (state.pollsData.questions[i].type == 0) {
                                  for (int i1 = 0;
                                      i1 <
                                          state.questionAnswers[i].options
                                              .length;
                                      i1++) {
                                    setState(() {
                                      state.questionAnswers[i].options[i1]
                                          .state = false;
                                    });
                                  }
                                }
                                setState(() {
                                  state.questionAnswers[i].options[j].state =
                                      value;
                                });
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ));
                          }
                          return Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        '${i + 1}. ${state.pollsData.questions[i].title}')),
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
                      ),
                    )
                  ],
                );
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
                                  '${i + 1}. ${state.pollsData.questions[i].title}')),
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
              if (state is ErrPst) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          onPressed: () => widget.pbl.add(LoadDataPev()),
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
          )),
    );
  }
}
