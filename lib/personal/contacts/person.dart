import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Person extends StatefulWidget {
  final ADUser adUser;

  Person(this.adUser);

  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(widget.adUser.photoPath),
      ),
      title: widget.adUser.displayName != null
          ? Text(widget.adUser.displayName)
          : null,
      subtitle: widget.adUser.title != null ? Text(widget.adUser.title) : null,
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvancedPerson(widget.adUser),
          settings: RouteSettings(name: 'AdvancedPerson'),
        ),
      ),
    );
  }
}

class AdvancedPerson extends StatefulWidget {
  final ADUser adUser;

  AdvancedPerson(this.adUser);

  @override
  _AdvancedPersonState createState() => _AdvancedPersonState();
}

class _AdvancedPersonState extends State<AdvancedPerson> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fab = [];

    if (widget.adUser.mail != null && widget.adUser.mail != '') {
      fab.add(
        FloatingActionButton(
          heroTag: null,
          child: Icon(Icons.mail),
          onPressed: () async {
            if (widget.adUser.mail != null) {
              await _make('mailto:' + widget.adUser.mail);
            }
          },
        ),
      );
    }
    if (widget.adUser.telephoneNumber != '' &&
        widget.adUser.telephoneNumber != null) {
      fab.add(SizedBox(
        width: 6,
      ));
      fab.add(
        FloatingActionButton(
          heroTag: null,
          child: Icon(Icons.phone),
          onPressed: () async {
            if (widget.adUser.telephoneNumber != null) {
              await _make('tel://' + widget.adUser.telephoneNumber);
            }
          },
        ),
      );
    }
    String txt = '';
    if (widget.adUser.department != '' && widget.adUser.department != null) {
      txt = widget.adUser.department + '. ';
    }
    if (widget.adUser.title != '' && widget.adUser.title != null) {
      txt += widget.adUser.title + '.';
    }

    Widget title = Container(
      padding: EdgeInsets.only(top: 15),
      child: Text(
        txt,
        textAlign: TextAlign.center,
      ),
    );

    Widget img = Image.asset(
      widget.adUser.photoPath,
      height: (MediaQuery.of(context).size.height * 0.4),
    );
    Widget description = Container();
    if (widget.adUser.description != '' && widget.adUser.description != null)
      description = Container(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          widget.adUser.description,
          textAlign: TextAlign.justify,
        ),
      );

    Widget displayName = Container();
    if (widget.adUser.displayName != '' && widget.adUser.displayName != null) {
      displayName = Container(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          widget.adUser.displayName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget mail = Container();
    if (widget.adUser.mail != '' && widget.adUser.mail != null) {
      mail = Container(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          widget.adUser.mail,
          textAlign: TextAlign.center,
        ),
      );
    }
    String header = '';
    List tmp = widget.adUser.displayName.split(' ');
    for (int i = 0; i < tmp.length; i++) {
      if (i > 0) {
        header += tmp[i][0] + '.';
      } else {
        header += tmp[i] + ' ';
      }
    }

    Widget telephoneNumber = Container();
    if (widget.adUser.telephoneNumber != '' && widget.adUser.telephoneNumber != null) {
      telephoneNumber = Container(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          widget.adUser.telephoneNumber,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(header),
//        actions: <Widget>[FlatButton(child: Icon(Icons.star, color: Colors.white,), shape: CircleBorder(), onPressed: () {},)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
                children: <Widget>[img, displayName, title, mail, telephoneNumber, description],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: fab,
      ),
    );
  }
}

_make(obj) async {
  if (await canLaunch(obj)) {
    await launch(obj);
  } else {
    throw 'Could not make $obj';
  }
}

// -----------------------------------------------------------------------------
class ADUser {
  String mail;
  String userPrincipalName;
  String displayName;
  String telephoneNumber;
  String department;
  String title;
  String employeeID;
  String photoPath;
  String description;

  ADUser(
      {this.mail,
      this.userPrincipalName,
      this.displayName,
      this.telephoneNumber,
      this.department,
      this.title,
      this.employeeID,
      this.photoPath,
      this.description})
      : super();

  ADUser.fromJson(Map<String, dynamic> json) {
    mail = json['mail'];
    userPrincipalName = json['userPrincipalName'];
    displayName = json['displayName'];
    telephoneNumber = json['telephoneNumber'];
    department = json['department'];
    title = json['title'];
    employeeID = json['employeeID'];
    photoPath = json['photoPath'];
    if (photoPath == '' || photoPath == null) {
      photoPath = 'assets/any_person.png';
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mail'] = this.mail;
    data['userPrincipalName'] = this.userPrincipalName;
    data['displayName'] = this.displayName;
    data['telephoneNumber'] = this.telephoneNumber;
    data['department'] = this.department;
    data['title'] = this.title;
    data['employeeID'] = this.employeeID;
    data['photoPath'] = this.photoPath;
    data['description'] = this.description;
    return data;
  }
}
