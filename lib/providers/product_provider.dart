import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  Map<String, Product> _productItems = {};

  Map<String, Product> get productItem {
    return {..._productItems};
  }

  int get productCount {
    return _productItems.length;
  }

  void addProduct(
    String productId,
    int productBarcode,
    String productName,
    String productDescription,
    int productQuantity,
    double productPrice,
  ) {
    if (_productItems.containsKey(productId)) {
      _productItems.update(
        productId,
        (existingProductItem) => Product(
            productId: existingProductItem.productId,
            productBarcode: existingProductItem.productBarcode,
            productDescription: existingProductItem.productDescription,
            productName: existingProductItem.productName,
            productQuantity: existingProductItem.productQuantity,
            productPrice: existingProductItem.productPrice),
      );
    } else {
      _productItems.putIfAbsent(
        productId,
        () => Product(
          productId: DateTime.now().toString(),
          productBarcode: productBarcode,
          productDescription: productDescription,
          productName: productName,
          productQuantity: 1,
          productPrice: productPrice,
        ),
      );
    }
    notifyListeners();
  }
}
