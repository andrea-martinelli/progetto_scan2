import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_scan2/data/models/product_info.dart';
import 'package:progetto_scan2/data/models/product_info_update.dart';
import 'package:progetto_scan2/providers.dart';

class BarcodeScannerPage extends ConsumerStatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends ConsumerState<BarcodeScannerPage> {
  String? scannedBarcode;
  ProductInfo? productInfo;
  ProductInfoUpdate? productInfoUpdate;
  int? newQuantity;
  bool isLoading = false;
  String? errorMessage;

  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String? modifyScannedBarcode(String? barcode) {
    if (barcode != null && barcode.isNotEmpty) {
      return '0${barcode.substring(0, barcode.length - 1)}';
    }
    return barcode;
  }

  void _onScanCompleted(BarcodeCapture barcodeCapture) {
    final String barcode = barcodeCapture.barcodes.first.rawValue ?? '';

    setState(() {
      scannedBarcode = modifyScannedBarcode(barcode);
      isLoading = true;
    });
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    final productRepository = ref.read(productRepositoryProvider);
    try {
      final product = await productRepository.getProductByBarcode(scannedBarcode!);
      setState(() {
        productInfo = product;
        newQuantity = product.stockReel;
        _quantityController.text = newQuantity.toString();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Errore nel recupero delle informazioni del prodotto: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _saveQuantity() async {
    if (scannedBarcode != null) {
      setState(() {
        isLoading = true;
      });

      final productRepository = ref.read(productRepositoryProvider);
      try {
        // Recupera la nuova quantità dall'input
        newQuantity = int.tryParse(_quantityController.text) ?? 0;

        // Aggiorna la quantità nel database utilizzando i parametri separati
        await productRepository.updateProductQuantityOnServer(scannedBarcode!, newQuantity!);

        setState(() {
          productInfoUpdate = ProductInfoUpdate(barcode: scannedBarcode!, qty: newQuantity!);
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quantità aggiornata con successo')),
        );
      } catch (e) {
        setState(() {
          errorMessage = 'Errore nell\'aggiornamento della quantità: $e';
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading) 
                  Center(child: CircularProgressIndicator())
                else ...[
                  if (scannedBarcode == null) ...[
                    SizedBox(
                      height: 700,
                      width: 450,
                      child: AiBarcodeScanner(
                        onDetect: (BarcodeCapture capture) {
                          _onScanCompleted(capture);
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                  if (scannedBarcode != null) ...[
                    Text(
                      'Codice a barre scansionato: $scannedBarcode',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                  ],
                  if (productInfo != null) ...[
                    Text(
                      'Nome prodotto: ${productInfo!.ref}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Quantità attuale: ${newQuantity ?? productInfo!.stockReel}', 
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nuova quantità',
                          labelStyle: TextStyle(fontSize: 18),
                        ),
                        onChanged: (value) {
                          setState(() {
                            newQuantity = int.tryParse(value) ?? newQuantity;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (newQuantity! > 0) {
                                setState(() {
                                  newQuantity = newQuantity! - 1;
                                  _quantityController.text = newQuantity.toString();
                                });
                              }
                            },
                            child: Text('-', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                        SizedBox(width: 30),
                        SizedBox(
                          width: 80,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                newQuantity = newQuantity! + 1;
                                _quantityController.text = newQuantity.toString();
                              });
                            },
                            child: Text('+', style: TextStyle(fontSize: 24)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveQuantity,
                        child: Text('Salva', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
