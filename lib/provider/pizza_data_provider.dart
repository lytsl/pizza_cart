import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_app/model/pizza_item.dart';
import 'package:pizza_app/model/pizza_model.dart';

class PizzaDataProvider with ChangeNotifier {
  PizzaModel? pizza;
  bool loading = false;
  bool isFabVisible = true;

  getPizzaData() async {
    loading = true;
    pizza = await getSinglePizzaData();
    loading = false;
    notifyListeners();
  }

  addPizza() {
    final item = PizzaItemModel(
        name: pizza!.crust.name + " " + pizza!.size.name,
        crust: pizza!.crust.name,
        size: pizza!.size.name,
        price: pizza!.size.price);

    int index = pizza!.pizzaList.indexWhere((e) => e == item);
    if (index == -1) {
      pizza!.pizzaList.add(item);
    } else {
      pizza!.pizzaList[index].quantity += 1;
    }
    notifyListeners();
  }

  selectCrust(int? index) {
    if (index == null) return;
    pizza!.crustIndex = index;
    notifyListeners();
  }

  selectSize(int? index) {
    if (index == null) return;
    pizza!.crustList[pizza!.crustIndex].sizeIndex = index;
    notifyListeners();
  }

  decreaseQuantity(int index) {
    pizza!.pizzaList[index].quantity--;
    if (pizza!.pizzaList[index].quantity == 0) pizza!.pizzaList.removeAt(index);
    notifyListeners();
  }

  setFabScrollListener(ScrollController controller) {
    controller.addListener(() {
      isFabVisible =
          controller.position.userScrollDirection == ScrollDirection.forward;
      print("fab $isFabVisible");
      notifyListeners();
    });
  }
}

Future<PizzaModel?> getSinglePizzaData() async {
  PizzaModel? result;

  try {
    final response = await http.get(Uri.parse(
        'https://625bbd9d50128c570206e502.mockapi.io/api/v1/pizza/1'));

    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      result = PizzaModel.fromJson(item);
    } else {
      Fluttertoast.showToast(
          msg: "Data could not be loaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  } catch (e) {
    log("Pizza data was not loaded", error: e);
  }
  return result;
}
