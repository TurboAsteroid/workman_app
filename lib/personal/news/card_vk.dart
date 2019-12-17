import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:personal/personal/system/fullscreen_image_swiper.dart';
import 'package:personal/personal/system/helpers.dart';

import './news_data.dart';

class CardVk extends StatefulWidget {
  final NewsItem data;

  CardVk(this.data);

  @override
  _CardVkState createState() => _CardVkState();
}

class _CardVkState extends State<CardVk> {
  @override
  void initState() {
    super.initState();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
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
    }
    Widget gallery;
    // все что не русские буквы [^а-яА-Я]*(.*)
    int t = 0;
    for (; t < txt.length; t++) {
      if (RegExp(r'[а-яА-Я]').hasMatch(txt[t])) break;
    }
    txt = txt.substring(t);
    txt = txt.replaceAll('#UMMC', '');
    txt = txt.replaceAll('#Uralelectromed', '');
    txt = txt.replaceAll('#УГМК', '');
    txt = txt.replaceAll('#Уралэлектромедь', '');
    txt = txt.replaceAll('#ППМ', '');
    for (int a = txt.length - 1; a > 0; a--) {
      if (RegExp(r'[а-яА-Я]').hasMatch(txt[a])) break;
      txt = txt.replaceFirst('\n', '', a - 2);
      if (txt.length == a - 1) a--;
      txt = txt.replaceFirst(' ', '', a - 2);
      if (txt.length == a - 1) a--;
    }
    Widget header = Padding(
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
              ],
            ),
          ),
        ],
      ),
    );
    List<String> urlList = [];
    for (int i = 0; i < widget.data.attachments.length; i++) {
      if (widget.data.attachments[i].type == 'photo') {
        for (int j = 0;
            j < widget.data.attachments[i].photo.sizes.length;
            j++) {
          if (widget.data.attachments[i].photo.sizes[j].type == "x") {
            String urlZ = widget.data.attachments[i].photo.sizes[j]
                .url; // чтобы вообще что-то было
            for (int s = 0;
                s < widget.data.attachments[i].photo.sizes.length;
                s++) {
              if (widget.data.attachments[i].photo.sizes[s].type == "z") {
                urlZ = widget.data.attachments[i].photo.sizes[s].url;
              }
            }
            urlList.add(urlZ);
          }
        }
      }
    }

    List c = [];
    for (int i = 0; i < widget.data.attachments.length; i++) {
      if (widget.data.attachments[i].type == 'photo') {
        for (int j = 0;
            j < widget.data.attachments[i].photo.sizes.length;
            j++) {
          if (widget.data.attachments[i].photo.sizes[j].type == "x") {
            c.add(GestureDetector(
              onTap: () {
                if (urlList.length > 1)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return FullscreenImageSwiper(urlList, i);
                        },
                        settings:
                            RouteSettings(name: 'FullscreenImageSwiperCardVk'),
                      ));
                else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return FullscreenImageSwiper(urlList, 0);
                        },
                        settings: RouteSettings(name: 'FullscreenImageCardVk'),
                      ));
                }
              },
              child: ExtendedImage.network(
                  widget.data.attachments[i].photo.sizes[j].url),
            ));
          }
        }
      }
    }
    if (c.length == 1) {
      gallery = ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
            height: 200.0,
            padding: EdgeInsets.only(left: 3, right: 3),
            child: c[0]),
      );
    } else if (c.length > 1) {
      List<Widget> galleryCards = c.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Container(
                  height: 200.0,
                  padding: EdgeInsets.only(left: 3, right: 3),
                  child: item),
            );
          },
        );
      }).toList();
      gallery = Column(children: [
        CarouselSlider(
          autoPlay: true,
          viewportFraction: 1.0,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          height: 200.0,
          items: galleryCards,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(
            galleryCards,
            (index, url) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4)),
              );
            },
          ),
        ),
      ]);
    }
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          header,
          Divider(),
          gallery,
          Padding(
            padding:
                c.length == 1 ? EdgeInsets.only(top: 8) : EdgeInsets.all(0),
            child: Text(
              txt,
              textAlign: TextAlign.justify,
            ),
          ),
          Text(
            Helpers.dtInt(widget.data.date),
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
