class SizeModel {
  final int id;
  final String name;
  final int price;

  SizeModel({required this.id, required this.name, required this.price});

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(id: json['id'], name: json['name'], price: json['price']);
  }
}
