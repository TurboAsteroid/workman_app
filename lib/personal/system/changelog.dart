import 'package:flutter/material.dart';
import 'package:personal/config.dart';

class Changelog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.88,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 32, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Новое в версии ${SizeConfig.appVersion}',
                  style: Theme.of(context).primaryTextTheme.display3),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: Text('Добавлено:',
                    style: Theme.of(context).primaryTextTheme.display1),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                          'Ориентация изображений, открытых на весь экран, изменяется в зависимости от ориентации устройства',
                          style: Theme.of(context).primaryTextTheme.display1),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                          'Обновленный раздел Диспансеризация в разделе Здоровье',
                          style: Theme.of(context).primaryTextTheme.display1),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                          'Добавлено Пользовательское соглашение',
                          style: Theme.of(context).primaryTextTheme.display1),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: Text('Изменено:',
                    style: Theme.of(context).primaryTextTheme.display1),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('Способ отображения вариантов ответов в разделе "Опросы"',
                          style: Theme.of(context).primaryTextTheme.display1),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: Text('Устранены ошибки:',
                    style: Theme.of(context).primaryTextTheme.display1),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('Ошибка в первой анимации экрана обучения',
                          style: Theme.of(context).primaryTextTheme.display1),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('Ошибка получения версии',
                          style: Theme.of(context).primaryTextTheme.display1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}