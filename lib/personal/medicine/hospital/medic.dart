import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/medicine/hospital/hospital.dart';
import 'package:personal/personal/medicine/hospital/workingHours.dart';

class MedicScreen extends StatefulWidget {
  final Medics item;

  MedicScreen(this.item);

  @override
  _MedicScreenState createState() => _MedicScreenState();
}

class _MedicScreenState extends State<MedicScreen> {
  @override
  Widget build(BuildContext context) {
    double offset = 24;

    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${widget.item.fullname.surname} ${widget.item.fullname.name}')),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton.icon(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkingHoursScreen(widget.item),
                        settings: RouteSettings(name: 'WorkingHoursScreen'),
                      ),
                    ),
                icon: Icon(Icons.schedule),
                label: Text('ЧАСЫ ПРИЕМА')),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              widget.item.photo != null ? Stack(
                children: <Widget>[
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth,
                    child: Image.network(widget.item.photo),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, SizeConfig.screenWidth - offset * 4, 0, 0),
                      height: offset * 4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color.fromARGB(0, 255, 255, 255),
                            Colors.black12,
                            Colors.black38,
                            Colors.black54
                          ]))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        offset,
                        SizeConfig.screenWidth - offset * 2,
                        offset,
                        offset),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${widget.item.fullname.surname} ${widget.item.fullname.name}',
                        style:
                            TextStyle(fontSize: offset, color: Colors.white),
                      ),
                    ),
                  ), // 8 - padding
                ],
              ) : FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  '${widget.item.fullname.surname} ${widget.item.fullname.name}',
                  style:
                  TextStyle(fontSize: offset, color: Colors.white),
                ),
              ),
              Divider(),
              Html(data: widget.item.description)
            ],
          ),
        ),
      ),
    );
  }
}
