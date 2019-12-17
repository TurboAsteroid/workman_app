import 'package:flutter/material.dart';
import 'package:personal/personal/medicine/hospital/hospital.dart';

class WorkingHoursScreen extends StatefulWidget {
  final Medics item;

  WorkingHoursScreen(this.item);

  @override
  _WorkingHoursScreenState createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Часы приема')),
        body: SingleChildScrollView(
            child: Container(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                        '${widget.item.fullname.surname} ${widget.item.fullname.name} ${widget.item.fullname.patronymic}',
                        style: TextStyle(fontSize: 24)),
                  ),
                  Divider(),
                  SizedBox(
                    height: 16,
                  ),
                  new HoursList(widget.item.workingHours),
                ],
              ),
            ),
          ),
        )));
  }
}

class HoursList extends StatelessWidget {
  const HoursList(this.workingHours);

  final List<Day> workingHours;

  @override
  Widget build(BuildContext context) {
    List<Widget> days = [];
    workingHours.forEach((it) {
      days.add(Divider());
      days.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(it.name), Text(it.value)],
        ),
      );
    });
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: days);
  }
}
