import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  final bool isLoading;
  

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? productBarcodeResult;

  var _productBarcode = '';
  var _productName = '';
  var _productDescription = '';
  var _productQuantity = '';
  var _productPrice = '';

  void _saveProduct() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    final product = Provider.of<ProductProvider>(context, listen: false);

    if (isValid) {
      _formKey.currentState!.save();

      product.addProduct(
        DateTime.now().toString(),
        _productBarcode as int,
        _productName,
        _productDescription,
        _productQuantity as int,
        _productPrice as double,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                key: const ValueKey('barcode'),
                cursorColor: Theme.of(context).colorScheme.primary,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Barcode',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.document_scanner_rounded),
                    onPressed: productBarcodeScanner,
                  ),
                ),
                initialValue: productBarcodeResult == null
                    ? null
                    : '$productBarcodeResult',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Quantity field shouldn\'t be empty.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productBarcode = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                key: const ValueKey('productName'),
                cursorColor: Theme.of(context).colorScheme.primary,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Product name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Product name field shouldn\'t be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productName = value!;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                key: const ValueKey('description'),
                cursorColor: Theme.of(context).colorScheme.primary,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  focusColor: Theme.of(context).colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Product description field shouldn\'t be empty.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _productDescription = value!;
                },
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    key: const ValueKey('quantity'),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Quantity',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Quantity field shouldn\'t be empty or set at 0.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productQuantity = value!;
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    key: const ValueKey('price'),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Theme.of(context).colorScheme.primary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Price',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Price field shouldn\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productPrice = value!;
                    },
                  ),
                ),
              ],
            ),
            if (widget.isLoading) const CircularProgressIndicator(),
            if (!widget.isLoading)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  child: const Text('SAVE'),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    primary: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _saveProduct,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future productBarcodeScanner() async {
    String productBarcodeResult;
    try {
      productBarcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      productBarcodeResult = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      this.productBarcodeResult = productBarcodeResult;
    });
  }
}
