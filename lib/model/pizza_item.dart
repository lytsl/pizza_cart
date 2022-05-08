class PizzaItemModel {
  late String name;
  late String crust;
  late String size;
  late int price;
  int quantity = 1;

  PizzaItemModel(
      {required this.name,
      required this.crust,
      required this.size,
      required this.price});

  @override
  bool operator ==(Object other) {
    if (other is! PizzaItemModel) return false;
    PizzaItemModel o = other;
    return (this.name == o.name &&
        this.crust == o.crust &&
        this.size == o.size &&
        this.price == o.price);
  }
}
