import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal/config.dart';

class FullscreenImageSwiper extends StatefulWidget {
  final List<String> imgUrls;
  final int index;

  FullscreenImageSwiper(this.imgUrls, this.index);

  @override
  _FullscreenImageSwiperState createState() => _FullscreenImageSwiperState();
}

class _FullscreenImageSwiperState extends State<FullscreenImageSwiper> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List child = map<Widget>(
      widget.imgUrls,
      (index, i) {
        return InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.pop(context);
          },
          child: ExtendedImage.network(
            i,
            fit: BoxFit.contain,
            //enableLoadState: false,
            mode: ExtendedImageMode.gesture,
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                  minScale: 1,
                  animationMinScale: 0.7,
                  maxScale: 3.0,
                  animationMaxScale: 3.5,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: false);
            },
          ),
        );
      },
    ).toList();
    // тут есть проверка на то, отображаем карусель или просто картинку
    return Scaffold(
      body: widget.imgUrls.length > 1
          ? CarouselSlider(
              initialPage: widget.index,
              height: SizeConfig.screenHeight,
              items: child,
              autoPlay: false,
              viewportFraction: 1.0,
              aspectRatio: SizeConfig.screenHeight / SizeConfig.screenWidth,
            )
          : child[0],
    );
  }
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}
