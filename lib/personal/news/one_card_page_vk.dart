

import './card_vk.dart';
import './news_data.dart';
import 'package:flutter/material.dart';

class OneCardPageVk extends StatefulWidget {
  final NewsItem data;
  OneCardPageVk(this.data);
  @override
  _OneCardPageVkState createState() => _OneCardPageVkState();
}

class _OneCardPageVkState extends State<OneCardPageVk> {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Новость')
      ),
      body: SingleChildScrollView(child: CardVk(widget.data),),
    );
  }
}
