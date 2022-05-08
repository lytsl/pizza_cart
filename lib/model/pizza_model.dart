import 'dart:math';

import 'package:pizza_app/model/crust_model.dart';
import 'package:pizza_app/model/pizza_item.dart';
import 'package:collection/collection.dart';
import 'package:pizza_app/model/size_model.dart';

class PizzaModel {
  final int defaultCrustIndex;
  final String id;
  final bool isVeg;
  final String name;
  final String description;
  final List<CrustModel> crustList;

  late int crustIndex;
  final List<PizzaItemModel> pizzaList = [];

  PizzaModel(
      {required this.id,
      required this.isVeg,
      required this.name,
      required this.description,
      required this.crustList,
      required this.defaultCrustIndex})
      : crustIndex = defaultCrustIndex;

  factory PizzaModel.fromJson(Map<String, dynamic> json) {
    final crusts =
        (json['crusts'] as List).map((e) => CrustModel.fromJson(e)).toList();
    final defaultCrustIndex =
        crusts.indexWhere((crust) => crust.id == json['defaultCrust']);

    return PizzaModel(
      id: json['id'],
      isVeg: json['isVeg'],
      name: json['name'],
      description: json['description'],
      crustList: crusts,
      defaultCrustIndex: defaultCrustIndex,
    );
  }

  CrustModel get crust => crustList[crustIndex];
  List<SizeModel> get sizeList => crust.sizeList;
  int get sizeIndex => crust.sizeIndex;
  SizeModel get size => sizeList[sizeIndex];
  int get priceOfItem => size.price;

  int get totalPrice {
    int total = 0;
    pizzaList.forEach((element) {
      total += (element.price) * (element.quantity);
    });
    return total;
  }

  int get totalQuantity {
    int q = 0;
    pizzaList.forEach((element) {
      q += element.quantity;
    });
    return q;
  }

  resetAllIndex(){
    crustIndex = defaultCrustIndex;
    crustList.forEach((e) =>e.sizeIndex = e.defaultSizeIndex);
  }

}
