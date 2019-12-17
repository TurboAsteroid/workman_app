import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class SelectAvatar extends StatefulWidget {
  @override
  _SelectAvatarState createState() => _SelectAvatarState();
}

class _SelectAvatarState extends State<SelectAvatar> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16),
          height: 34,
          child: Row(
            children: <Widget>[
              Icon(Icons.person, color: Colors.black87),
              Text(
                "Персонализация",
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: CircleAvatar(
                minRadius: 64,
                maxRadius: 64,
                backgroundImage: _image == null ? AssetImage('assets/any_person.png') : FileImage(_image),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(96, 96, 0, 0),
              child: ClipOval(
                child: Container(
                  color: Colors.blue,
                  child: IconButton(
                    onPressed: getImage,
                    icon: Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
