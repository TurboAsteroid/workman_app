import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:personal/personal/network/network.dart';
import 'package:personal/personal/personal/cloth/clothData.dart';

class ClothBloc extends Bloc<ClothEv, ClothSt> {
  ClothBloc(this.url);

  final String url;

  @override
  ClothSt get initialState => InitSt();

  @override
  Stream<ClothSt> mapEventToState(ClothEv event) async* {
    if (event is LoadEv) {
      try {
        yield LoadingSt();
        ServerResponse sr = await ajaxGet(url);
        if(sr.status == '-1') throw 'Ошибка загрузки данных о СИЗ';
        ClothData clothData = ClothData.fromJson(sr.data);
        yield LoadedSt(clothData);
      } catch (e) {
        yield ErrorSt(e);
      }
    }
  }
}

abstract class ClothEv {}

class LoadEv extends ClothEv {}

abstract class ClothSt {}

class InitSt extends ClothSt {}

class LoadingSt extends ClothSt {}

class LoadedSt extends ClothSt {
  ClothData clothData;

  LoadedSt(this.clothData);
}

class ErrorSt extends ClothSt {
  final String error;

  ErrorSt(this.error);
}
