class ProductModel {
  final int id;
  final String productImage;
  final String productName;
  late final String productQuantity;
  final String productPrice;

  ProductModel(
      {required this.id,
      required this.productImage,
      required this.productName,
      required this.productQuantity,
      required this.productPrice});
}
