import 'package:bloc/bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:personal/personal/app_news/data.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/network/network.dart';

import 'package:personal/personal/system/fullscreen_image_swiper.dart';

class TextGallery extends StatefulWidget {
  final NewsInListData newsInListData;

  TextGallery(this.newsInListData);

  @override
  _TextGalleryState createState() => _TextGalleryState();
}

class _TextGalleryState extends State<TextGallery> {
  _Bl bl = _Bl();

  @override
  void initState() {
    super.initState();
    bl.add(_GetAppNewsEv(widget.newsInListData.appNewsUrl));

  }

  @override
  void dispose() {
    bl.close();
    super.dispose();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.newsInListData.title)),
      body: BlocBuilder<_Bl, _St>(
        bloc: bl,
        builder: (BuildContext context, _St state) {
          if (state is _InitEv) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is _AppNewsSt) {
            List galleryCards = [];
            if (state.appNewsData.images.length > 1) {
              List<String> listOfImagesUrl = [];
              for (int j = 0; j < state.appNewsData.images.length; j++) {
                listOfImagesUrl.add(state.appNewsData.images[j].url +
                    '?token=${state.token.replaceAll('BEARER ', '')}');
              }
              galleryCards = map<Widget>(
                state.appNewsData.images,
                (index, item) {
                  return _galleryItem(context, listOfImagesUrl, index, item,
                      state.token.replaceAll('BEARER ', ''));
                },
              ).toList();
            }
            Widget gallery;
            if (galleryCards.length > 1) {
//              gallery = Container(
//                child: CarouselSlider(
//                  height: SizeConfig.screenHeight * 0.34,
//                  items: galleryCards,
//                  viewportFraction: 0.9,
//                  aspectRatio: 2.0,
//                  autoPlay: true,
//                  enlargeCenterPage: true,
//                ),
//              );

              gallery = Column(children: [
                CarouselSlider(
                  height: SizeConfig.screenHeight * 0.34,
                  items: galleryCards,
                  viewportFraction: 0.9,
                  aspectRatio: 2.0,
                  autoPlay: true,
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
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
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
            } else {
              gallery = state.appNewsData.images.length > 0 ? Container(
                  height: SizeConfig.screenHeight * 0.34,
                  child: _galleryItem(
                      context,
                      [
                        state.appNewsData.images[0].url +
                            '?token=${state.token.replaceAll('BEARER ', '')}'
                      ],
                      0,
                      state.appNewsData.images[0],
                      state.token.replaceAll('BEARER ', ''))) : Container();
            }

            return Container(
              child: Column(
                children: <Widget>[
                  Flexible(
                      child: Container(
                    width: SizeConfig.screenWidth - 16,
                    child: WebView(
                      initialUrl: state.appNewsData.newsLink +
                          '?token=${state.token.replaceAll('BEARER ', '')}',
                    ),
                  )),
                  gallery
                ],
              ),
            );
          }
          if (state is _ErrorSt) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => bl.add(
                          _GetAppNewsEv(widget.newsInListData.appNewsUrl)),
                      icon: Icon(Icons.refresh),
                    ),
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

Widget _galleryItem(BuildContext context, List<String> listOfImagesUrl,
    int index, ImageObj item, String token) {
  return InkWell(
    splashColor: Colors.blue.withAlpha(30),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return FullscreenImageSwiper(listOfImagesUrl, index);
          },
          settings: RouteSettings(name: 'FullscreenImageSwiperTextGallery'),
        ),
      );
    },
    child: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                child: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExtendedImage.network(
                        item.thumbUrl + '?token=$token',
                        width: SizeConfig.screenWidth),
                  ),
                ]),
              ),
            ),
            Container(
              height: 34,
              padding: const EdgeInsets.all(8.0),
              child: Text(item.description),
            )
          ],
        )),
  );
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class _Bl extends Bloc<_Ev, _St> {
  final storage = new FlutterSecureStorage();

  @override
  _St get initialState => _InitEv();

  @override
  Stream<_St> mapEventToState(_Ev event) async* {
    if (event is _GetAppNewsEv) {
      yield _LoadingSt();
      try {
        ServerResponse sr = await ajaxGet(event.url);
        String token = await storage.read(key: 'token');
        yield _AppNewsSt(AppNewsData.fromJson(sr.data), token);
      } catch (e) {
        yield _ErrorSt('К сожалению, произошла ошибка');
      }
    }
  }
}

abstract class _Ev {}

class _GetAppNewsEv extends _Ev {
  final String url;

  _GetAppNewsEv(this.url);

  @override
  String toString() => 'GetAppNewsEv';
}

abstract class _St {}

class _InitEv extends _St {
  @override
  String toString() => 'InitEv';
}

class _AppNewsSt extends _St {
  final AppNewsData appNewsData;
  final String token;

  _AppNewsSt(this.appNewsData, this.token);

  @override
  String toString() => '_AppNewsSt';
}

class _LoadingSt extends _St {
  @override
  String toString() => '_LoadingSt';
}

class _ErrorSt extends _St {
  final String error;

  _ErrorSt(this.error);

  @override
  String toString() => '_ErrorSt';
}
