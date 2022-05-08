import 'package:flutter/material.dart';

import '../constants.dart';
import 'card_widget.dart';

class PizzaItemWidget extends StatelessWidget {
  const PizzaItemWidget(
      {Key? key,
      required this.name,
      required this.description,
      required this.quantity,
      required this.isVeg})
      : super(key: key);

  final String name, description;
  final int quantity;
  final bool isVeg;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isVeg ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      isVeg ? "veg" : "non-veg",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            child: Center(
              child: Text(
                'x$quantity',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kQuantityTextColor),
              ),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isVeg ? Colors.green : Colors.red),
          ),
        ],
      ),
    );
  }
}
