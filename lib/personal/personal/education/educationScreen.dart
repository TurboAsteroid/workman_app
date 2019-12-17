import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/config.dart';

import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/personal/education/courseCard.dart';
import 'package:personal/personal/personal/education/educationData.dart';

class EducationScreen extends StatefulWidget {
  final String url;
  final String title;

  EducationScreen(this.url, this.title);

  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  Bl _educationBl;

  @override
  void initState() {
    super.initState();
    _educationBl = Bl(widget.url);
    _educationBl.add(LoadEv());
    
  }

  @override
  void dispose() {
    _educationBl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder(
          bloc: _educationBl,
          builder: (context, state) {
            if (state is LoadedSt) {
              return ListView.builder(
                itemCount: state.courses.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: CourseCard(state.courses[i]),
                  );
                },
              );
            }
            if (state is NoneSt) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.school,
                      size: 82,
                      color: Colors.black38,
                    ),
                    SizedBox(height: 16),
                    Text(state.text,
                        style: Theme.of(context).primaryTextTheme.display4,
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }
            if (state is LoadingSt) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ErrorSt) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => _educationBl.add(LoadEv()),
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
          }),
    );
  }
}

abstract class St {}

class InitSt extends St {}

class LoadedSt extends St {
  List<Course> courses;

  LoadedSt({this.courses});
}

class LoadingSt extends St {}

class NoneSt extends St {
  final String text;

  NoneSt(this.text);
}

class ErrorSt extends St {
  String error;

  ErrorSt(this.error);
}

abstract class Ev {}

class LoadEv extends Ev {}

class Bl extends Bloc<Ev, St> {
  final String url;

  Bl(this.url);

  @override
  St get initialState => InitSt();

  @override
  Stream<St> mapEventToState(Ev event) async* {
    yield LoadingSt();
    if (event is LoadEv) {
      ServerResponse sr = await ajaxGet(url);
      if (sr.status != '200' && sr.status != 'OK') {
        yield ErrorSt('Ошибка загрузки данных об обучении');
        return;
      }
      EducationData educationData = EducationData.fromJson(sr.data);
      if (educationData.data.length > 0) {
        List<Course> courses = educationData.data;
        yield LoadedSt(courses: courses);
        return;
      }
      yield NoneSt('Нет данных об обучении');
    }
  }
}
