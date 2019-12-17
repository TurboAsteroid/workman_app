import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/bugreport/bugreportScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:personal/personal/signIn/signIn.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("О программе"),
            Text(
              "v.$_version",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
      body: dev(context),
    );
  }

  Widget dev(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(16.0),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Тех.поддержка: +7-34368-46414'),
              FlatButton(
                  onPressed: () => _make("tel:+73436846663"),
                  child: Icon(Icons.phone))
            ],
          ),
          Row(
            children: <Widget>[
              Text('Берняев П.О.'),
              FlatButton(
                  onPressed: () => _make("mailto:bpo@elem.ru"),
                  child: Text('bpo@elem.ru'))
            ],
          ),
          Row(
            children: <Widget>[
              Text('Лобарев В.О.'),
              FlatButton(
                  onPressed: () => _make("mailto:v.lobarev@elem.ru"),
                  child: Text('v.lobarev@elem.ru'))
            ],
          ),
          Container(
            width: SizeConfig.screenWidth,
            child: RaisedButton.icon(
              icon: Icon(Icons.error),
              label: Text('Сообщить об ошибке'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BugReportScreen(),
                  settings: RouteSettings(name: 'BugReportScreen'),
                ),
              ),
              color: Colors.red,
            ),
          ),
          Container(
            width: SizeConfig.screenWidth,
            child: RaisedButton.icon(
              icon: Icon(Icons.description),
              label: Text('Пользовательское соглашение'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsOfUse(),
                    settings: RouteSettings(name: 'TermsOfUse'),
                  ))
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _make(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
