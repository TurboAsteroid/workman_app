import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/polls/pollStepByStep.dart';
import 'package:personal/personal/polls/questionsList.dart';
import 'package:personal/personal/polls/thanks.dart';
import 'package:personal/personal/polls/pollsData.dart';

abstract class Pev {
  BuildContext context;

  Pev({this.context});
}

class InitPev extends Pev {
  @override
  String toString() => 'InitPev';
}

class LoadDataPev extends Pev {
  LoadDataPev({context}) : super(context: context);

  @override
  String toString() => 'LoadDataPev';
}

class SelectPev extends Pev {
  PollsData pollsData;

  SelectPev(this.pollsData, {context}) : super(context: context);

  @override
  String toString() => 'SelectPev';
}

class SendPev extends Pev {
  PollsAnswer pollsAnswer;

  SendPev(this.pollsAnswer, {context}) : super(context: context);

  @override
  String toString() => 'SendPev';
}

class ResultsPev extends Pev {
  PollsData pollsData;

  ResultsPev(this.pollsData, context) : super(context: context);

  @override
  String toString() => 'ResultsPev';
}

abstract class Pst {}

class InitPst extends Pst {
  @override
  String toString() => 'InitPst';
}

class AllPst extends Pst {
  List<PollsData> pdl;

  AllPst(this.pdl);

  @override
  String toString() => 'AllPst';
}

class SelectedPst extends Pst {
  PollsData pollsData;
  List<QuestionAnswers> questionAnswers;

  SelectedPst(this.pollsData, this.questionAnswers);

  @override
  String toString() => 'SelectedPst';
}

class SendingPst extends Pst {
  @override
  String toString() => 'SendingPst';
}

class SendedPst extends Pst {
  @override
  String toString() => 'SendedPst';
}

class ErrPst extends Pst {
  String error;
  ErrPst(this.error);
  @override
  String toString() => 'ErrPst';
}


class ResultsPst extends Pst {
  PollsData pollsData;

  ResultsPst(this.pollsData);

  @override
  String toString() => 'ResultsPst';
}

class Pbl extends Bloc<Pev, Pst> {
  String url;

  Pbl(this.url);

  @override
  Pst get initialState => InitPst();

  @override
  Stream<Pst> mapEventToState(Pev event) async* {
     try {
       if (event is LoadDataPev) {
         ServerResponse sr = await ajaxGet(url);
         if (sr.status == '-1') throw ('Ошибка загрузки данных опросов');
         List<PollsData> pdl = List<PollsData>();
         sr.data['polls_list'].forEach((v) async {
           // ignore: await_only_futures
           await pdl.add(
               new PollsData.fromJson(
                   v)); // ТУТ ВСЕ ВЕРНО!!! ХОТЬ IDE И РУГАЕТСЯ
         });
         yield AllPst(pdl);
       }
       if (event is SelectPev) {
         List<QuestionAnswers> questionAnswers = [];
         for (int i = 0; i < event.pollsData.questions.length; i++) {
           List<OptionsAnswers> oal = [];
           for (int j = 0; j <
               event.pollsData.questions[i].options.length; j++) {
             oal.add(OptionsAnswers(
                 id: event.pollsData.questions[i].options[j].id, state: false));
           }
           questionAnswers.add(
               QuestionAnswers(
                   id: event.pollsData.questions[i].id, options: oal));
         }
         yield SelectedPst(event.pollsData, questionAnswers);

         SharedPreferences prefs = await SharedPreferences.getInstance();
         bool eachQuestionOnaSeparateScreen =
         prefs.getBool('polls_eachQuestionOnaSeparateScreen');
         if (eachQuestionOnaSeparateScreen != null) {
           if (eachQuestionOnaSeparateScreen) {
             // шаг за шагом
             Navigator.push(
               event.context,
               MaterialPageRoute(
                 builder: (context) => PollStepByStep(this),
                 settings: RouteSettings(name: 'PollStepByStep'),
               ),
             );
           } else {
             // список
             Navigator.push(
               event.context,
               MaterialPageRoute(
                 builder: (context) => QuestionsList(this),
                 settings: RouteSettings(name: 'QuestionsList'),
               ),
             );
           }
         } else {
           prefs.setBool('polls_eachQuestionOnaSeparateScreen', true);
           Navigator.push(
             event.context,
             MaterialPageRoute(
               builder: (context) => PollStepByStep(this),
               settings: RouteSettings(name: 'QuestionsList'),
             ),
           );
         }
       }
       if (event is SendPev) {
         yield SendingPst();
         Navigator.push(
           event.context,
           MaterialPageRoute(
             builder: (context) => Thanks(this),
             settings: RouteSettings(name: 'Thanks'),
           ),
         );
         ServerResponse sr = await ajaxPost(url, event.pollsAnswer.toJson());
         if (sr.status == '-1') throw ('Ошибка отправки данных');
         yield SendedPst();
       }
       if (event is ResultsPev) {
         yield ResultsPst(event.pollsData);
         Navigator.push(
           event.context,
           MaterialPageRoute(
             builder: (context) => QuestionsList(this),
             settings: RouteSettings(name: 'QuestionsList'),
           ),
         );
       }
     } catch (e) {
       yield ErrPst(e);
     }
  }
}
