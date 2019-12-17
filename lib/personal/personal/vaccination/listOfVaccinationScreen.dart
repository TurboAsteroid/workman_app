import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/personal/vaccination/vaccSmallCard.dart';
import 'package:personal/personal/personal/vaccination/vaccinationData.dart';

class ListOfVaccinationScreen extends StatefulWidget {
  final String url;
  final String title;

  ListOfVaccinationScreen(this.url, this.title);

  @override
  _ListOfVaccinationScreenState createState() => _ListOfVaccinationScreenState();
}

class _ListOfVaccinationScreenState extends State<ListOfVaccinationScreen> {
  Bl _vaccinationBl;

  @override
  void initState() {
    super.initState();
    _vaccinationBl = Bl(widget.url);
    _vaccinationBl.add(LoadEv());
    
  }

  @override
  void dispose() {
    _vaccinationBl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder(
          bloc: _vaccinationBl,
          builder: (context, state) {
            if (state is LoadedSt) {
              return ListView.builder(
                itemCount: state.vacList.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: VaccSmallCard(state.vacList[i]),
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
                      Icons.favorite,
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
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => _vaccinationBl.add(LoadEv()),
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
  List<ListOfVacData> vacList;

  LoadedSt({this.vacList});
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
        yield ErrorSt('Ошибка загрузки данных о вакцинации');
        return;
      }
      VaccinationData vaccinationData = VaccinationData.fromJson(sr.data);
      if (vaccinationData.data.length > 0) {
        List<ListOfVacData> vacList = vaccinationData.data;
        yield LoadedSt(vacList: vacList);
        return;
      }
      yield NoneSt('Нет данных о вакцинации');
    }
  }
}
