import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal/config.dart';

import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/personal/food/foodData.dart';

class FoodScreen extends StatefulWidget {
  final String url;
  final String title;

  FoodScreen(this.url, this.title);

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  FoodBl _foodBl;

  @override
  void initState() {
    super.initState();
    _foodBl = FoodBl(widget.url);
    _foodBl.add(FLoadEv());
    
  }

  @override
  void dispose() {
    _foodBl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder(
          bloc: _foodBl,
          builder: (context, state) {
            if (state is FoodLoadedSt) {
              return ListView.builder(
                itemCount: state.vouchers.length,
                itemBuilder: (context, i) {
                  return FoodCard(state.vouchers[i], SizeConfig.screenWidth);
                },
              );
            }
            if (state is FoodNoneSt) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.free_breakfast,
                      size: 82,
                      color: Colors.black26,
                    ),
                    Text(state.text,
                        style: Theme.of(context).primaryTextTheme.display4,
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }
            if (state is FoodLoadingSt) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is FoodErrorSt) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: () =>
                            _foodBl.add(FLoadEv()),
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
          }),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Voucher food;
  final double width;

  FoodCard(this.food, this.width);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(''),
            food.name == 'Дотация' ? Container() : Container(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Image.asset('assets/food/${food.name}.png'),
                height: SizeConfig.blockSizeVertical * 18,
              ),
              width: SizeConfig.blockSizeVertical * 18,
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${food.name.toString()}',
                        style: Theme.of(context).primaryTextTheme.title,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Остаток ${food.available}',
                            style: Theme.of(context).primaryTextTheme.display4,
                          ),
                          Text('Норма ${food.norma}'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class FoodSt {}

class FoodInitSt extends FoodSt {}

class FoodLoadedSt extends FoodSt {
  List<Voucher> vouchers;

  FoodLoadedSt({this.vouchers});
}

class FoodLoadingSt extends FoodSt {}

class FoodErrorSt extends FoodSt {
  String error;

  FoodErrorSt(this.error);
}

class FoodNoneSt extends FoodSt {
  final String text;

  FoodNoneSt(this.text);
}

abstract class FoodEv {}

class FLoadEv extends FoodEv {}

class FoodBl extends Bloc<FoodEv, FoodSt> {
  final String url;

  FoodBl(this.url);

  @override
  FoodSt get initialState => FoodInitSt();

  @override
  Stream<FoodSt> mapEventToState(FoodEv event) async* {
    yield FoodLoadingSt();
    if (event is FLoadEv) {
      ServerResponse sr = await ajaxGet(url);
      if (sr.status != '200' && sr.status != 'OK') {
        yield FoodErrorSt('Ошибка загрузки данных о питании');
        return;
      }
      FoodData foods = FoodData.fromJson(sr.data);
      List<Voucher> vouchers = foods.data;
      if (vouchers.length > 0) {
        yield FoodLoadedSt(vouchers: vouchers);
        return;
      }
      yield FoodNoneSt('У вас нет талонов');
    }
  }
}
