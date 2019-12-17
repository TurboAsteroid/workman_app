import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal/config.dart';

class Disp extends StatefulWidget {
  String title;

  Disp(this.title);

  @override
  _DispState createState() => _DispState();
}

class _DispState extends State<Disp> {
  final String assetName = 'assets/image.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                'Главная цель диспансеризации',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'как можно раньше обнаружить заболевание, выявить и скорректировать факторы риска его развития',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 18, height: 0.98),
                ),
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/mf.svg',
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/mf.svg',
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '18-39 лет',
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          SizedBox(height: SizeConfig.screenWidth * 0.08 + 8),
                          Text(
                            'старше 40 лет',
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/arrow.svg',
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/arrow.svg',
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'раз в три года',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          SizedBox(height: SizeConfig.screenWidth * 0.08 + 8),
                          Text(
                            'ежегодно',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Профилактический медицинский осмотр - ежегодно для всех граждан в возрасте 18 лет и старше',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 18, height: 0.98),
                ),
              ),
              Table(
                children: [
                  TableRow(children: [
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/1.svg',
                            ),
                          ),
                          Text(
                            'анкетирование',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/2.svg',
                            ),
                          ),
                          Text(
                            'измерение\nроста и веса',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/3.svg',
                            ),
                          ),
                          Text(
                            'измерение АД',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/4.svg',
                            ),
                          ),
                          Text(
                            'измерение уровня\nобщего холестерина',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/5.svg',
                            ),
                          ),
                          Text(
                            'общий анализ\nкрови с 40 лет',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/6.svg',
                            ),
                          ),
                          Text(
                            'флюорография',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/7.svg',
                            ),
                          ),
                          Text(
                            'ЭКГ',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/8.svg',
                            ),
                          ),
                          Text(
                            'измерение\nвнутриглазного\nдавления',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    TableCell(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            width: SizeConfig.screenWidth * 0.16,
                            height: SizeConfig.screenWidth * 0.16,
                            child: SvgPicture.asset(
                              'assets/images/disp/9.svg',
                            ),
                          ),
                          Text(
                            'осмотр врачом-\nтерапевтом',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ])
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Скрининги на выявление онкологических заболеваний',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 22, height: 0.98),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Исследование кала на скрытую кровь',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    width: SizeConfig.screenWidth * 0.16,
                    height: SizeConfig.screenWidth * 0.16,
                    child: SvgPicture.asset(
                      'assets/images/disp/mf.svg',
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.green[700],
                    height: SizeConfig.screenWidth * 0.16,
                    width: SizeConfig.screenWidth * 0.84 - 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '40-64 лет - 1 раз в 2 года',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '65-75 лет ежегодно',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Фиброгастроскопия',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    width: SizeConfig.screenWidth * 0.16,
                    height: SizeConfig.screenWidth * 0.16,
                    child: SvgPicture.asset(
                      'assets/images/disp/mf.svg',
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.green[700],
                    height: SizeConfig.screenWidth * 0.16,
                    width: SizeConfig.screenWidth * 0.84 - 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '45 лет',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Исследование уровня\nпростатитспецфического антигена в крови',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    width: SizeConfig.screenWidth * 0.16,
                    height: SizeConfig.screenWidth * 0.16,
                    child: SvgPicture.asset(
                      'assets/images/disp/m.svg',
                      color: Colors.yellow[800],
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.yellow[800],
                    height: SizeConfig.screenWidth * 0.16,
                    width: SizeConfig.screenWidth * 0.84 - 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '45, 50, 55, 60, 64 года',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Цитологическое исследование шейки матки',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    width: SizeConfig.screenWidth * 0.16,
                    height: SizeConfig.screenWidth * 0.16,
                    child: SvgPicture.asset(
                      'assets/images/disp/f.svg',
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.deepOrange,
                    height: SizeConfig.screenWidth * 0.16,
                    width: SizeConfig.screenWidth * 0.84 - 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '18-64 лет - 1 раз в 3 года',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Маммография',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    width: SizeConfig.screenWidth * 0.16,
                    height: SizeConfig.screenWidth * 0.16,
                    child: SvgPicture.asset(
                      'assets/images/disp/f.svg',
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    color: Colors.deepOrange,
                    height: SizeConfig.screenWidth * 0.16,
                    width: SizeConfig.screenWidth * 0.84 - 48,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '40-75 лет - 1 раз в 2 года',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Как записаться?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/w1.svg',
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'ЛИЧНЫЙ КАБИНЕТ\n(екатеринбург.рф)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/w2.svg',
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'ЛИЧНЫЙ КАБИНЕТ\n(gosuslugi.ru)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/w3.svg',
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'в Отделении/кабинете\nмедицинской профилактики',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/w4.svg',
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'CALL-центр\n(343) 204-76-76',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          width: SizeConfig.screenWidth * 0.16,
                          height: SizeConfig.screenWidth * 0.16,
                          child: SvgPicture.asset(
                            'assets/images/disp/w5.svg',
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'в регистратуре\nполиклиники',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
