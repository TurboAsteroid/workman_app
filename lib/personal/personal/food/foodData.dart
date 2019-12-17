import 'package:json_annotation/json_annotation.dart';

part 'foodData.g.dart';

//@JsonSerializable()
//class FoodData {
//  List<Voucher> vouchers;
//
//  FoodData({this.vouchers});
//
//  factory FoodData.fromJson(Map<String, dynamic> json) =>
//      _$FoodDataFromJson(json);
//
//  Map<String, dynamic> toJson() => _$FoodDataToJson(this);
//}
//
//@JsonSerializable()
//class Voucher {
//  String name;
//  int norma;
////  int used;
//  int available;
//
//  Voucher({this.name, this.norma, this.available});
//
//  factory Voucher.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
//
//  Map<String, dynamic> toJson() => _$FoodToJson(this);
//}

//@JsonSerializable()
//class Food {
//  Food({this.milk, this.eat, this.milkPekt, this.kefirPect, this.subsidy});
//
//  factory Food.fromJson(Map<String, dynamic> json) =>
//      _$FoodFromJson(json);
//
//  Map<String, dynamic> toJson() => _$FoodToJson(this);
//
//  Milk milk;
//  Eat eat;
//  MilkPekt milkPekt;
//  KefirPect kefirPect;
//  Subsidy subsidy;
//}
//
//@JsonSerializable()
//class Milk {
//  Milk({this.amount});
//
//  factory Milk.fromJson(Map<String, dynamic> json) =>
//      _$MilkFromJson(json);
//
//  Map<String, dynamic> toJson() => _$MilkToJson(this);
//
//  Amount amount;
//}
//@JsonSerializable()
//class Eat {
//  Eat({this.amount});
//
//  factory Eat.fromJson(Map<String, dynamic> json) =>
//      _$EatFromJson(json);
//
//  Map<String, dynamic> toJson() => _$EatToJson(this);
//
//  Amount amount;
//}
//@JsonSerializable()
//class MilkPekt {
//  MilkPekt({this.amount});
//
//  factory MilkPekt.fromJson(Map<String, dynamic> json) =>
//      _$MilkPektFromJson(json);
//
//  Map<String, dynamic> toJson() => _$MilkPektToJson(this);
//
//  Amount amount;
//}
//@JsonSerializable()
//class KefirPect {
//  KefirPect({this.amount});
//
//  factory KefirPect.fromJson(Map<String, dynamic> json) =>
//      _$KefirPectFromJson(json);
//
//  Map<String, dynamic> toJson() => _$KefirPectToJson(this);
//
//  Amount amount;
//}
//@JsonSerializable()
//class Subsidy {
//  Subsidy({this.amount});
//
//  factory Subsidy.fromJson(Map<String, dynamic> json) =>
//      _$SubsidyFromJson(json);
//
//  Map<String, dynamic> toJson() => _$SubsidyToJson(this);
//
//  Amount amount;
//}

//@JsonSerializable()
//class Amount {
//  Amount({this.norm, this.balance});
//
//  factory Amount.fromJson(Map<String, dynamic> json) => _$AmountFromJson(json);
//
//  Map<String, dynamic> toJson() => _$AmountToJson(this);
//
//  int norm;
//  int balance;
//}
@JsonSerializable()
class FoodData {
  List<Voucher> data;

  FoodData({this.data});

  factory FoodData.fromJson(Map<String, dynamic> json) =>
      _$FoodDataFromJson(json);

  Map<String, dynamic> toJson() => _$FoodDataToJson(this);
}
@JsonSerializable()
class Voucher {
  int norma;
  String name;
  int available;
  String used;

  Voucher({this.norma, this.name, this.available, this.used});

  factory Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);
}