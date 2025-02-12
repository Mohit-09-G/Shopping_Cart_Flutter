class ProductModel {
  final int id;
  final String productImage;
  final String productName;
  final String productQuantity;
  final String productPrice;

  ProductModel(
      {required this.id,
      required this.productImage,
      required this.productName,
      required this.productQuantity,
      required this.productPrice});

  //converting A product model to Map

  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'productImage': productImage,
      'productName': productName,
      'productQuantity': productQuantity,
      'productPrice': productPrice
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        id: map['id'],
        productImage: map['productImage'],
        productName: map['productName'],
        productPrice: map['productPrice'],
        productQuantity: map['productQuantity']);
  }
}
