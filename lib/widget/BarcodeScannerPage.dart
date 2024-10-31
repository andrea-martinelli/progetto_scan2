import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_scan2/data/models/product_info.dart';
import 'package:progetto_scan2/data/models/product_info_update.dart';
import 'package:progetto_scan2/providers.dart';

class BarcodeScannerPage extends ConsumerStatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends ConsumerState<BarcodeScannerPage> {
  String? scannedBarcode;
  ProductInfo? productInfo;
  int newQuantity = 0;
  bool isLoading = false;
  String? errorMessage;
  int totalQuantity = 0;

  final TextEditingController _quantityController =
      TextEditingController(text: '0');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  String? modifyScannedBarcode(String? barcode) {
    return barcode?.isNotEmpty == true
        ? barcode!.substring(0, barcode.length - 1).padLeft(12, '0')
        : barcode;
  }

  Future<void> _startBarcodeScan() async {
    setState(() => isLoading = true);

    try {
      final result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        scannedBarcode = modifyScannedBarcode(result.rawContent);
        await _fetchProductDetails();
      }
    } catch (e) {
      _showError('Errore durante la scansione: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchProductDetails() async {
    final productRepository = ref.read(productRepositoryProvider);
    try {
      final product =
          await productRepository.getProductByBarcode(scannedBarcode!);
      setState(() {
        productInfo = product;
        totalQuantity = product.stockReel;
        _quantityController.text = '0';
      });
    } catch (e) {
      _showError('Errore nel recupero delle informazioni del prodotto: $e');
    }
  }

  Future<void> _saveQuantity() async {
    if (scannedBarcode == null) return;

    setState(() => isLoading = true);

    final productRepository = ref.read(productRepositoryProvider);
    try {
      int quantityChange = int.tryParse(_quantityController.text) ?? 0;
      int newTotalQuantity = totalQuantity + quantityChange;

      if (quantityChange > newTotalQuantity) {
        _showError('Errore: Quantità negativa non consentita.');
        return;
      }

      await productRepository.updateProductQuantityOnServer(
          scannedBarcode!, quantityChange);
      setState(() {
        totalQuantity = newTotalQuantity;
        _quantityController.text = '0';
      });
      _showMessage('Quantità aggiornata con successo');
    } catch (e) {
      _showError('Errore nell\'aggiornamento della quantità: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    setState(() => errorMessage = message);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildScannerButton() {
    return SizedBox(
      height: 700,
      width: 450,
      child: ElevatedButton(
        onPressed: _startBarcodeScan,
        child:
            const Text('Inizia la scansione', style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      children: [
        Text('Nome prodotto: ${productInfo!.ref}',
            style: const TextStyle(fontSize: 18)),
        Text('Quantità attuale: $totalQuantity',
            style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        _buildQuantityInput(),
        const SizedBox(height: 20),
        _buildQuantityButtons(),
        const SizedBox(height: 30),
        SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton(
            onPressed: _saveQuantity,
            child: const Text('Salva', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityInput() {
    return SizedBox(
      width: 200,
      child: TextFormField(
        controller: _quantityController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nuova quantità',
          labelStyle: TextStyle(fontSize: 18),
        ),
        onChanged: (value) => setState(() {
          newQuantity = int.tryParse(value) ?? 0;
        }),
      ),
    );
  }

  Widget _buildQuantityButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIncrementButton('-', () {
          if (newQuantity > 0) setState(() => newQuantity -= 1);
        }),
        const SizedBox(width: 30),
        _buildIncrementButton('+', () => setState(() => newQuantity += 1)),
      ],
    );
  }

  Widget _buildIncrementButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: 80,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Scanner')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isLoading)
                  const CircularProgressIndicator()
                else ...[
                  if (scannedBarcode == null) _buildScannerButton(),
                  if (scannedBarcode != null) 
                    Text(
                      'Codice a barre scansionato: $scannedBarcode',
                      style: const TextStyle(fontSize: 18),
                    ),
                  const SizedBox(height: 16),
                  if (productInfo != null) _buildProductInfo(),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
