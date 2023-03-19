class Product {
  final String productId;
  final int productBarcode;
  final String productName;
  final String productDescription;
  final double productPrice;
  final int productQuantity;

  Product({
    required this.productId,
    required this.productBarcode,
    required this.productDescription,
    required this.productName,
    required this.productQuantity,
    required this.productPrice,
  });
}
