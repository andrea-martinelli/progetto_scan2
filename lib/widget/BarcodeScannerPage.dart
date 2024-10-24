import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_scan2/data/models/product_info.dart';
import 'package:progetto_scan2/providers.dart';

class BarcodeScannerPage extends ConsumerStatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends ConsumerState<BarcodeScannerPage> {
  String? scannedBarcode;
  ProductInfo? productInfo;
  int? newQuantity; // Nuova quantità temporanea
  bool isLoading = false;
  String? errorMessage;

  // Aggiungiamo un TextEditingController per il campo di input
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startBarcodeScan());
  }

  //Funzione per rimuovere l'ultima cifra dal codice a barre
  String removeLastDigit(String barcode) {
    if (barcode.isEmpty || barcode.length == 1) {
      return barcode; // Se il barcode è vuoto o ha una sola cifra, lo restituisce così com'è
    }
    return barcode.substring(0, barcode.length - 1); // Rimuove l'ultima cifra
  }

  Future<void> _startBarcodeScan() async {
    try {
      var result = await BarcodeScanner.scan();

      if (result.type == ResultType.Barcode && result.rawContent.isNotEmpty) {
       
        // Debug: stampa il barcode originale scansionato
      print('Codice a barre originale scansionato: ${result.rawContent}');
       
        // Rimuovi l'ultima cifra dal barcode scansionato
       String cleanedBarcode = removeLastDigit(result.rawContent);

       // Debug: stampa il barcode dopo aver rimosso l'ultima cifra
      print('Codice a barre dopo rimozione dell\'ultima cifra: $cleanedBarcode');


        setState(() {
          scannedBarcode = cleanedBarcode;
          isLoading = true;
        });

        // Usa il ProductRepository per ottenere i dettagli del prodotto
        final productRepository = ref.read(productRepositoryProvider);
        try {
          final product = await productRepository.getProductByBarcode(scannedBarcode!);
        // Debug: stampa il barcode passato al repository
        print('Barcode passato al repository: $scannedBarcode');


          setState(() {
            productInfo = product;
            newQuantity = product.stockReel; // Imposta la quantità attuale come quantità temporanea
            _quantityController.text = newQuantity.toString(); // Aggiorna il campo con la quantità
            isLoading = false;
          });
        } catch (e) {
          setState(() {
            errorMessage = 'Errore nel recupero delle informazioni del prodotto: $e';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Errore durante la scansione del codice a barre';
      });
    }
  }

  // Metodo per aggiornare la quantità sul server
  Future<void> _saveQuantity() async {
    if (scannedBarcode != null && newQuantity != null) {
      setState(() {
        isLoading = true;
      });
      final productRepository = ref.read(productRepositoryProvider);
      try {
        // Invia la nuova quantità al server usando i valori dinamici da productInfo
        await productRepository.updateProductQuantityOnServer(
          productInfo!.id, // Passa il product_id dal productInfo
          scannedBarcode!, // Passa il barcode dal productInfo 
          newQuantity!, // Usa la nuova quantità inserita
         );

        // Aggiorna localmente l'oggetto productInfo
        setState(() {
          productInfo = productInfo!.copyWith(stockReel: newQuantity);
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Errore nell\'aggiornamento della quantità: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Center( // Centra tutto il contenuto della pagina
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                        'Quantità attuale: ${productInfo!.stockReel}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16),
                      // Campo di input per la nuova quantità con label più grande
                      SizedBox(
                        width: 200, // Aumenta la larghezza del campo
                        child: TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nuova quantità', // Modifica della label
                            labelStyle: TextStyle(fontSize: 18), // Aumenta la dimensione del testo della label
                          ),
                          onChanged: (value) {
                            // Aggiorna la quantità quando l'utente inserisce manualmente
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
                          // Bottone "-" con larghezza e altezza maggiorate
                          SizedBox(
                            width: 80, // Aumenta la larghezza
                            height: 50, // Aumenta l'altezza
                            child: ElevatedButton(
                              onPressed: () {
                                if (newQuantity! > 0) {
                                  setState(() {
                                    newQuantity = newQuantity! - 1; // Decrementa la quantità temporanea
                                    _quantityController.text = newQuantity.toString(); // Aggiorna il campo di input
                                  });
                                }
                              },
                              child: Text('-', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                          SizedBox(width: 30), // Spazio tra i bottoni
                          // Bottone "+" con larghezza e altezza maggiorate
                          SizedBox(
                            width: 80, // Aumenta la larghezza
                            height: 50, // Aumenta l'altezza
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  newQuantity = newQuantity! + 1; // Incrementa la quantità temporanea
                                  _quantityController.text = newQuantity.toString(); // Aggiorna il campo di input
                                });
                              },
                              child: Text('+', style: TextStyle(fontSize: 24)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30), // Più spazio prima del pulsante "Salva"
                      // Bottone "Salva" con dimensioni maggiorate
                      SizedBox(
                        width: 180, // Larghezza maggiore per il pulsante "Salva"
                        height: 50, // Altezza maggiore per il pulsante "Salva"
                        child: ElevatedButton(
                          onPressed: _saveQuantity, // Salva la nuova quantità sul server
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
                ),
        ),
      ),
    );
  }
}
