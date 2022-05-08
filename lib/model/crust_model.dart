import 'package:pizza_app/model/size_model.dart';

class CrustModel {
  final int id;
  final String name;
  final int defaultSizeIndex;
  final List<SizeModel> sizeList;

  late int sizeIndex;

  CrustModel(
      {required this.id,
      required this.name,
      required this.defaultSizeIndex,
      required this.sizeList}) {
    sizeIndex = defaultSizeIndex;
  }

  factory CrustModel.fromJson(Map<String, dynamic> json) {
    final sizes =
        (json['sizes'] as List).map((e) => SizeModel.fromJson(e)).toList();
    final index = sizes.indexWhere((s) => s.id == json['defaultSize']);
    return CrustModel(
        id: json['id'],
        name: json['name'],
        defaultSizeIndex: index,
        sizeList: sizes);
  }
}
