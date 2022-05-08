import 'package:flutter/material.dart';
import 'package:pizza_app/provider/pizza_data_provider.dart';

//custom scrollable sheet for pizza cart
class MyScrollableSheet extends StatelessWidget {
  final PizzaDataProvider provider;
  final Widget child;

  const MyScrollableSheet({
    Key? key,
    required this.height,
    required this.provider,
    required this.child,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.90,
      minChildSize: 0.87,
      builder: (BuildContext context, ScrollController scrollController) {
        provider.setFabScrollListener(scrollController);
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            constraints: BoxConstraints(
              minHeight: height,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}