import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pizza_app/model/pizza_model.dart';
import 'package:pizza_app/provider/pizza_data_provider.dart';
import 'package:pizza_app/widget/expandable_fab.dart';
import 'package:pizza_app/widget/my_scrollable_sheet.dart';
import 'package:pizza_app/widget/pizza_item_widget.dart';
import 'package:pizza_app/widget/pizza_remove_item.dart';
import 'package:pizza_app/widget/rounded_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../constants.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late double height;

  @override
  void initState() {
    super.initState();
    Provider.of<PizzaDataProvider>(context, listen: false).getPizzaData();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Consumer<PizzaDataProvider>(builder: (context, provider, child) {
          //if data is loading
          if (provider.loading == true)
            return Column(
                children: [Center(child: CircularProgressIndicator())]);

          final PizzaModel? pizzaModel = provider.pizza;

          //if data was not loaded
          if (pizzaModel == null)
            return ErrorWidget(retry: provider.getPizzaData());

          //if cart is empty
          else if (pizzaModel.pizzaList.length == 0) {
            return EmptyWidget();
          }

          //show cart data
          else {
            return Container(
              color: Theme.of(context).primaryColor,
              child: Stack(
                children: [
                  buildPizzaDetailsBar(provider),
                  buildPizzaListSheet(provider, pizzaModel),
                ],
              ),
            );
          }
        }),
      ),
      floatingActionButton:
          //Provider.of<PizzaDataProvider>(context).isFabVisible
          buildFAB(context),
    );
  }

  //bar showing details of quantity and total amount
  Widget buildPizzaDetailsBar(PizzaDataProvider provider) {
    return Container(
      height: height * 0.1,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quantity: ' + provider.pizza!.totalQuantity.toString(),
                style: kText16BoldWhite),
            Text('Total: ₹' + provider.pizza!.totalPrice.toString(),
                style: kText16BoldWhite),
          ],
        ),
      ),
    );
  }

  //list of all custom pizza added to the cart in a scrollable sheet
  Widget buildPizzaListSheet(
      PizzaDataProvider provider, PizzaModel pizzaModel) {
    return MyScrollableSheet(
      height: height,
      provider: provider,
      child: Column(
        children: [
          buildScrollHandle(),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: (pizzaModel.pizzaList.length),
            itemBuilder: (context, index) {
              return PizzaItemWidget(
                name: pizzaModel.pizzaList[index].name,
                description: pizzaModel.description,
                isVeg: pizzaModel.isVeg,
                quantity: pizzaModel.pizzaList[index].quantity,
              );
            },
          ),
          SizedBox(height: 52),
        ],
      ),
    );
  }

  //floating action button with options to add and remove pizza
  Visibility buildFAB(BuildContext context) {
    return Visibility(
      visible: Provider.of<PizzaDataProvider>(context).isFabVisible,
      child: ExpandableFab(
        distance: 80.0,
        children: [
          ActionButton(
            onPressed: () => showAddBottomSheet(),
            icon: Icon(
              Icons.add,
              size: 32,
            ),
          ),
          ActionButton(
            onPressed: () => showRemovePizzaSheet(),
            icon: Icon(
              Icons.remove,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  //show bottom sheet for adding custom pizza to the cart
  showAddBottomSheet() {
    print('add pizza');
    if (Provider.of<PizzaDataProvider>(context, listen: false).pizza == null) {
      Fluttertoast.showToast(
          msg: "There was an error while loading data. Please try again.");
    } else {
      showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              backgroundColor: Colors.white,
              builder: (context) {
                final pizzaProvider = Provider.of<PizzaDataProvider>(context);
                final PizzaModel? pizzaModel = pizzaProvider.pizza;
                return Container(
                  padding: EdgeInsets.all(16.0),
                  height: height * 0.7 + 32,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Crust', style: kText16Bold),
                      SizedBox(height: 4),
                      buildCrustToggle(pizzaModel!, pizzaProvider),
                      SizedBox(height: 16),
                      Text('Size', style: kText16Bold),
                      SizedBox(height: 4),
                      buildSizeToggle(pizzaModel, pizzaProvider),
                      Expanded(child: Container()),
                      Text(
                          'Price: ₹' +
                              pizzaProvider.pizza!.priceOfItem.toString(),
                          style: kText16Bold),
                      SizedBox(height: 16),
                      RoundedButtonWidget(
                          buttonText: 'ADD TO CART',
                          onPressed: () {
                            Navigator.pop(context);
                            pizzaProvider.addPizza();
                          })
                    ],
                  ),
                );
              })

          //reset all selected indexes when the sheet is closed
          .whenComplete(() {
        Provider.of<PizzaDataProvider>(context, listen: false)
            .pizza!
            .resetAllIndex();
      });
    }
  }

  //toggle switch for selecting crust of custom pizza
  SizedBox buildCrustToggle(
      PizzaModel pizzaModel, PizzaDataProvider pizzaProvider) {
    return SizedBox(
      width: double.infinity,
      child: ToggleSwitch(
        activeBgColor: [Colors.lightBlue],
        activeFgColor: Colors.white,
        isVertical: true,
        inactiveBgColor: Colors.lightBlue.shade100,
        inactiveFgColor: Colors.black,
        fontSize: 14.0,
        initialLabelIndex: pizzaModel.crustIndex,
        totalSwitches: pizzaModel.crustList.length,
        labels: List.generate(pizzaModel.crustList.length,
                (index) => pizzaModel.crustList[index].name),
        onToggle: (index) => pizzaProvider.selectCrust(index),
      ),
    );
  }

  //toggle switch for selecting size of selected crust
  SizedBox buildSizeToggle(
      PizzaModel pizzaModel, PizzaDataProvider pizzaProvider) {
    return SizedBox(
      width: double.infinity,
      child: ToggleSwitch(
        activeBgColor: [Colors.lightBlue],
        activeFgColor: Colors.white,
        isVertical: true,
        inactiveBgColor: Colors.lightBlue.shade100,
        inactiveFgColor: Colors.black,
        fontSize: 14.0,
        initialLabelIndex: pizzaModel.sizeIndex,
        totalSwitches: pizzaModel.sizeList.length,
        labels: List.generate(pizzaModel.sizeList.length,
            (index) => pizzaModel.sizeList[index].name),
        onToggle: (index) => pizzaProvider.selectSize(index),
      ),
    );
  }

  //show bottom sheet for removing a pizza from the cart
  showRemovePizzaSheet() {
    print('remove pizza');
    final provider = Provider.of<PizzaDataProvider>(context, listen: false);
    if (provider.pizza == null) {
      Fluttertoast.showToast(
          msg: "There was an error while loading data. Please try again.");
    } else if (provider.pizza!.pizzaList.length == 0) {
      Fluttertoast.showToast(msg: "Your cart is empty.");
    } else {
      showModalBottomSheet(
        builder: (context) {
          final pizzaProvider = Provider.of<PizzaDataProvider>(context);
          final PizzaModel? pizzaModel = pizzaProvider.pizza;
          return Container(
            padding: EdgeInsets.all(16.0),
            height: height * 0.65,
            child: ListView.builder(
                itemCount: pizzaModel!.pizzaList.length,
                itemBuilder: (context, index) {
                  return PizzaRemoveWidget(
                    pizzaModel: pizzaModel,
                    pizzaProvider: pizzaProvider,
                    index: index,
                  );
                }),
          );
        },
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.white,
      );
      // }
    }
  }

  //handle at the top of the ScrollableSheet
  Widget buildScrollHandle() {
    return Center(
      child: Container(
        height: 5,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text('Your cart is empty. please add a custom pizza.',
          style: kText16Bold, textAlign: TextAlign.center),
    ));
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
    required this.retry,
  }) : super(key: key);

  final void Function() retry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('An error occurred while loading data.'),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => retry,
          child: Text('Retry'),
        )
      ],
    );
  }
}
