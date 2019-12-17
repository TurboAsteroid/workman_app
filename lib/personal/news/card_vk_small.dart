import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/system/fullscreen_image_swiper.dart';
import 'package:personal/personal/system/helpers.dart';

import './news_data.dart';
import './one_card_page_vk.dart';

class CardVkSmall extends StatefulWidget {
  final NewsItem data;

  CardVkSmall(this.data);

  @override
  _CardVkSmallState createState() => _CardVkSmallState();
}

class _CardVkSmallState extends State<CardVkSmall> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // быстрая заглушка от ошибки
    if (widget.data.text == "" || widget.data.attachments == null) {
      return Container();
    }
    String title =
        ((((widget.data.text.split('.'))[0]).split('\n')[0]).split('!')[0])
            .replaceAll(')))', '.');
    String txt = widget.data.text.replaceFirst(RegExp(title), '');
    for (int i = 0; i < 2; i++) {
      while (txt[0] == '.') {
        txt = txt.replaceFirst(RegExp('.'), '');
      }
      while (txt[0] == '\n') {
        txt = txt.replaceFirst(RegExp('\n'), '');
      }
      while (txt[0] == ' ') {
        txt = txt.replaceFirst(RegExp(' '), '');
      }
    }
    // все что не русские буквы [^а-яА-Я]*(.*)
    int t = 0;
    for (; t < txt.length; t++) {
      if (RegExp(r'[а-яА-Я]').hasMatch(txt[t])) break;
    }
    txt = txt.substring(t);
    txt = txt.split('\n')[0];
    Widget imgWdg = Container();
    for (int imgUrlIndex = 0;
        imgUrlIndex < widget.data.attachments.length;
        imgUrlIndex++) {
      if (widget.data.attachments[imgUrlIndex].type == 'video')
        return Container();
      if (widget.data.attachments[imgUrlIndex].type == 'photo') {
        imgWdg = GestureDetector(
          child: ExtendedImage.network(
              widget.data.attachments[imgUrlIndex].photo.sizes[4].url),
          onTap: () {
            String urlZ =
                widget.data.attachments[imgUrlIndex].photo.sizes[4].url;
            for (int s = 0;
                s < widget.data.attachments[imgUrlIndex].photo.sizes.length;
                s++) {
              if (widget.data.attachments[imgUrlIndex].photo.sizes[s].type ==
                  "z") {
                urlZ = widget.data.attachments[imgUrlIndex].photo.sizes[s].url;
              }
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return FullscreenImageSwiper([urlZ], 0);
                  },
                  settings: RouteSettings(name: 'FullscreenImageCardVkSmall'),
                ));
          },
        );
        break;
      }
    }
    List<Widget> wg = [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/drawer_bg.jpg'),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
//                  Container(
//                    padding: EdgeInsets.only(left: 8),
//                    child: Text(
//                      Helpers.dtInt(widget.data.date),
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold, color: Colors.black54),
//                    ),
//                  )
                ],
              ),
            ),
          ],
        ),
      ),
      Divider(),
      Container(
          constraints: BoxConstraints(
            maxHeight: SizeConfig.screenHeight * 0.4,
          ),
          child: imgWdg),
      Container(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          txt,
          textAlign: TextAlign.justify,
          style: TextStyle(color: Colors.black87),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            child: Text(
              'ОТКРЫТЬ',
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OneCardPageVk(widget.data),
                  settings: RouteSettings(name: 'OneCardPageVk'),
                ),
              );
            },
          ),
        ],
      ),
      Divider(),
    ];

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: wg,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OneCardPageVk(widget.data),
            settings: RouteSettings(name: 'OneCardPageVk'),
          ),
        );
      },
    );
  }
}
