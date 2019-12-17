import 'package:flutter/material.dart';
import 'package:personal/personal/personal/vaccination/vaccinationData.dart';

class ListOfVaccFullScreen extends StatelessWidget {
  final ListOfVacData listOfVacData;

  ListOfVaccFullScreen(this.listOfVacData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listOfVacData.name),
      ),
      body: ListView.builder(
        itemCount: listOfVacData.data.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: VaccFullCard(
                listOfVacData.data[listOfVacData.data.length - 1 - i]),
          );
        },
      ),
    );
  }
}

class VaccFullCard extends StatelessWidget {
  final VacData vacData;

  VaccFullCard(this.vacData);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text(vacData.dateVaccination,
                        style: Theme.of(context).primaryTextTheme.title)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Реакция ' + vacData.vaccineResponse,
                        style: Theme.of(context).textTheme.subhead),
                  ),
                ),
              ],
            ),
            Divider(),
            Text('Наименование вакцины: ' + vacData.nameVaccine,
                style: Theme.of(context).textTheme.subhead),
            Text('Доза: ' + vacData.dose,
                style: Theme.of(context).textTheme.subhead),
            Text('Серия: ' + vacData.series,
                style: Theme.of(context).textTheme.subhead),
            Text('Производитель: ' + vacData.manufacturingPlant,
                style: Theme.of(context).textTheme.subhead),
            Text('Срок годности: ' + vacData.dateVaccination,
                style: Theme.of(context).textTheme.subhead),
            Text('Тип вакцинации: ' + vacData.typeVaccination,
                style: Theme.of(context).textTheme.subhead),
          ],
        ),
      ),
    );
  }
}
