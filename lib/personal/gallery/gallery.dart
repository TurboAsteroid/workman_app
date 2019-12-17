import 'package:bloc/bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:personal/config.dart';
import 'package:personal/personal/app_news/data.dart';
import 'package:personal/personal/network/network.dart';

import 'package:personal/personal/system/fullscreen_image_swiper.dart';

class Gallery extends StatelessWidget {
  final String title;
  final String url;

  Gallery(this.url, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SingleChildScrollView(child: GalleryContent(url))
    );
  }
}

class GalleryContent extends StatefulWidget {
  final String url;

  GalleryContent(this.url);

  @override
  _GalleryContentState createState() => _GalleryContentState();
}

class _GalleryContentState extends State<GalleryContent> {
  _Bl bl = _Bl();

  @override
  void initState() {
    super.initState();
    bl.add(_GetAppNewsEv(widget.url));

  }

  @override
  void dispose() {
    bl.close();
    super.dispose();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_Bl, _St>(
        bloc: bl,
        builder: (BuildContext context, _St state) {
          if (state is _InitEv) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is _GalleryLoadedSt) {
            List galleryCards = [];
            if (state.images.length > 1) {
              List<String> listOfImagesUrl = [];
              for (int j = 0; j < state.images.length; j++) {
                listOfImagesUrl.add(state.images[j].url +
                    '?token=${state.token.replaceAll('BEARER ', '')}');
              }
              galleryCards = map<Widget>(
                state.images,
                (index, item) {
                  return _galleryItem(context, listOfImagesUrl, index, item,
                      state.token.replaceAll('BEARER ', ''));
                },
              ).toList();
            } else {
              return Center(
                  child: Text(
                'Изображения отсутствуют',
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center,
              ));
            }
            Widget gallery;
            if (galleryCards.length > 1) {
              gallery = Container(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * 0.5,
                      child: CarouselSlider(
                        items: galleryCards,
                        viewportFraction: 1.0,
                        aspectRatio: 2.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        onPageChanged: (index) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    Column(
                      children: <Widget>[
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
                        Container(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(
                            state.images[_current].description,
                            style: Theme.of(context).textTheme.title,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            } else {
              gallery = Container(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * 0.5,
                      child: _galleryItem(
                          context,
                          [
                            state.images[0].url +
                                '?token=${state.token.replaceAll('BEARER ', '')}'
                          ],
                          0,
                          state.images[0],
                          state.token.replaceAll('BEARER ', '')),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16),
                      height: SizeConfig.screenHeight * 0.3,
                      child: Text(
                        state.images[0].description,
                        style: Theme.of(context).textTheme.title,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8),
              child: gallery,
            );
          }
          if (state is _ErrorSt) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => bl.add(_GetAppNewsEv(widget.url)),
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
    child: ExtendedImage.network(
      item.thumbUrl + '?token=$token',
      width: SizeConfig.screenWidth,
    ),
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
        if (sr.status != 'OK') throw sr.data;
        List<ImageObj> images;
        if (sr.data['images'] != null) {
          images = new List<ImageObj>();
          sr.data['images'].forEach((v) {
            images.add(new ImageObj.fromJson(v));
          });
        }
        String token = await storage.read(key: 'token');
        yield _GalleryLoadedSt(images, token);
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

class _GalleryLoadedSt extends _St {
  final List<ImageObj> images;
  final String token;

  _GalleryLoadedSt(this.images, this.token);

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
