import 'package:flutter/material.dart';
import 'package:personal/personal/network/network.dart';

Widget menuHeaderR() {
  return UserAccountsDrawerHeader(
    accountEmail: Text(''),
    accountName: Text(
      'Полезная информация',
      style: TextStyle(
        color: Colors.white,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 4.0,
            color: Colors.black38,
          ),
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 4.0,
            color: Colors.black38,
          ),
        ],
      ),
    ),
    decoration: new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage('assets/images/drawer_bg.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget menuHeaderL(ServerResponse srHeader) {
  Map data = srHeader.data;
  return Stack(
    alignment: Alignment.topRight,
    children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(
          'Добро пожаловать, ${data['name'].toString()}!',
          style: TextStyle(
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 4.0,
                color: Colors.black38,
              ),
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 4.0,
                color: Colors.black38,
              ),
            ],
          ),
        ),
        accountEmail: Text(
          '+7' + data['phone'].toString(),
          style: TextStyle(
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 4.0,
                color: Colors.black38,
              ),
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 4.0,
                color: Colors.black38,
              ),
            ],
          ),
        ),
        currentAccountPicture: CircleAvatar(
          child: Text(
            data['name'].toString()[0],
            style: TextStyle(fontSize: 40.0),
          ),
        ),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/images/drawer_bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
//      Container(
//        padding: EdgeInsets.fromLTRB(8,12,8,8),
//        child: IconButton(
//          icon: Icon(Icons.settings),
//          color: Colors.white,
//          onPressed: () {},
//        ),
//      )
    ],
  );
}
