import 'package:flutter/material.dart';

import '../widgets/qr_code_scanner.dart';

class WarehouseQRCodeScannerScreen extends StatelessWidget {
  const WarehouseQRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: QRCodeScanner(),
    );
  }
}
