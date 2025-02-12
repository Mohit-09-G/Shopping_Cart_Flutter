import 'package:shop/models/product_model.dart';

class AllProductsModel {
  final List<Map<int, List<ProductModel>>> productGroups;

  AllProductsModel({required this.productGroups});

  Map<String, dynamic> toMap() {
    print("object");
    return {
      'productGroups': productGroups.map((group) {
        return group.map((key, value) {
          return MapEntry(
            key.toString(),
            value.map((product) => product.tomap()).toList(),
          );
        });
      }).toList(),
    };
  }

  factory AllProductsModel.fromMap(Map<String, dynamic> map) {
    var groupsList = (map['productGroups'] as List);
    return AllProductsModel(
      productGroups: groupsList.map((group) {
        return (group as Map<String, dynamic>).map((key, value) {
          return MapEntry(
            int.parse(key),
            (value as List)
                .map((item) =>
                    ProductModel.fromMap(item as Map<String, dynamic>))
                .toList(),
          );
        });
      }).toList(),
    );
  }
}
