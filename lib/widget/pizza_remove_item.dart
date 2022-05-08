import 'package:flutter/material.dart';
import 'package:pizza_app/model/pizza_model.dart';
import 'package:pizza_app/provider/pizza_data_provider.dart';

import '../constants.dart';
import 'card_widget.dart';

//item widget of pizza list with decrease quantity button
class PizzaRemoveWidget extends StatelessWidget {
  final int index;

  const PizzaRemoveWidget({
    Key? key,
    required this.pizzaModel,
    required this.pizzaProvider,
    required this.index,
  }) : super(key: key);

  final PizzaModel? pizzaModel;
  final PizzaDataProvider pizzaProvider;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crust: ${pizzaModel!.pizzaList[index].crust}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Size: ${pizzaModel!.pizzaList[index].size}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Container(
              height: 32,
              width: 32,
              child: Center(
                child: Text(
                  'x${pizzaModel!.pizzaList[index].quantity}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kQuantityTextColor),
                ),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: kQuantityBGColor),
            ),
            SizedBox(width: 8),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  pizzaProvider.decreaseQuantity(index);
                },
                icon: Icon(
                  Icons.remove_circle,
                  size: 32,
                  color: kRemoveButtonColor,
                ))
          ],
        ));
  }
}