import 'package:flutter/material.dart';
import 'package:personal/personal/personal/vaccination/listOfVaccFullScreen.dart';
import 'package:personal/personal/personal/vaccination/vaccinationData.dart';

class VaccSmallCard extends StatelessWidget {
  final ListOfVacData vacData;

  VaccSmallCard(this.vacData);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(vacData.name,
                      style: Theme.of(context).primaryTextTheme.title),
                ),
                Text(
                    'Дата последней вакцинации: ' +
                        vacData.data[vacData.data.length - 1].dateVaccination,
                    style: Theme.of(context).textTheme.subhead),
                Text(
                    'Реакция: ' +
                        vacData.data[vacData.data.length - 1].vaccineResponse,
                    style: Theme.of(context).textTheme.subhead),
              ],
            ),
          ),
          Container(color: Colors.black12, height: 1),
          Container(
              child: FlatButton(
                child: Text('ОТКРЫТЬ'),
                onPressed: () {
                  print(vacData.name);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListOfVaccFullScreen(vacData),
                        settings: RouteSettings(name: 'ListOfVaccFullScreen'),
                      ));
                },
              ),
              alignment: Alignment.centerRight),
        ],
      ),
    );
  }
}
