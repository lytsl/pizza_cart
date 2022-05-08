import 'package:flutter/material.dart';
import 'package:pizza_app/page/cart_page.dart';
import 'package:pizza_app/provider/pizza_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(MultiProvider(providers: providers, child: MyApp()));
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<PizzaDataProvider>(create: (_) => PizzaDataProvider()),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CartPage(),
    );
  }
}
