import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_management_app/models/product.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/add_product.dart';

class WarehouseProductAddScreen extends StatefulWidget {
  const WarehouseProductAddScreen({Key? key}) : super(key: key);

  static const routeName = 'add-product';

  @override
  State<WarehouseProductAddScreen> createState() =>
      _WarehouseProductAddScreenState();
}

class _WarehouseProductAddScreenState extends State<WarehouseProductAddScreen> {
  var _isLoading = false;

  void _submitProductInfo(
    int? productBarcode,
    String productName,
    String productDescription,
    int? productQuantity,
    double? productPrice,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
    } on FirebaseAuthException catch (error) {
      String message =
          'An error occurred, please check your product information!';

      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: AddProduct(
        isLoading: _isLoading,
      ),
      

    );
  }
}
