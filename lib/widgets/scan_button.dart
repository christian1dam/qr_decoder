import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {

        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        // String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        //   '#3D8BEF',
        //   'Cancelar',
        //   false,
        //   ScanMode.QR, 
        // );
        scanListProvider.newScan("https://www.youtube.com/");
        scanListProvider.newScan("geo:40.4165,-3.70256");
      },
      elevation: 0,
      child: const Icon(Icons.filter_center_focus),
    );
  }
}
