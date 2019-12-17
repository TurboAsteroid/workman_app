import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/app_news/data.dart';
import 'package:personal/personal/app_news/textgallery.dart';
import 'package:personal/personal/system/fullscreen_image_swiper.dart';
import 'package:personal/personal/system/helpers.dart';

class AppCardNews extends StatefulWidget {
  final NewsInListData newsInListData;
  final String token;

  AppCardNews(this.newsInListData, this.token);

  @override
  _AppCardNewsState createState() => _AppCardNewsState();
}

class _AppCardNewsState extends State<AppCardNews> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wg = [
      Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(widget.newsInListData.appNewsImage +
                '?token=${widget.token.replaceAll('BEARER ', '')}'),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 12),
                    child: Text(
                      widget.newsInListData.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    )),
                Container(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    Helpers.dt(widget.newsInListData.timeCreated),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Divider(),
      GestureDetector(
        child: ExtendedImage.network(widget.newsInListData.appNewsImage + '?token=${widget.token.replaceAll('BEARER ', '')}'),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return FullscreenImageSwiper([widget.newsInListData.appNewsImage + '?token=${widget.token.replaceAll('BEARER ', '')}'], 0);
                },
                settings: RouteSettings(name: 'FullscreenImage'),
              ));
        },
      ),
      Container(
        padding: EdgeInsets.only(top: 12),
        child: Text(
          widget.newsInListData.description,
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
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TextGallery(widget.newsInListData),
                  settings: RouteSettings(name: 'TextGallery'),
                ),
              );
            },
          ),
        ],
      ),
      Divider(),
    ];
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: wg,
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TextGallery(widget.newsInListData),
            settings: RouteSettings(name: 'TextGallery'),
          ),
        );
      },
    );
  }
}
