import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progetto_scan2/data/models/product_info_update.dart';

class ApiClient {
  final Dio dio;
  //final String DOLAPIKEY;

  ApiClient(this.dio,
  // this.DOLAPIKEY
  );

  // Metodo per ottenere i dettagli del prodotto dal codice a barre
  Future<Map<String, dynamic>> fetchProductFromAPI(String barcode) async {
    // Inserisci qui l'URL dell'API
    final url = 'http://10.11.11.104:6003/api/ProdottoBarcode/$barcode'; // Sostituisci con l'URL corretto

    try {
      print('Invio richiesta a: $url'); // Log dell'URL
      final response = await dio.get(
        url,
      //  options: Options(headers: {'DOLAPIKEY': DOLAPIKEY}), // Aggiungi la chiave API nell'header
     
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Errore nella risposta del server');
      }
    } catch (e) {
      throw Exception('Errore nella richiesta API: $e'); 
    }
  }

  // Metodo per aggiornare la quantità del prodotto sul server
 Future<String> updateProductQuantityOnServer(String barcode, int qty) async {
  final url = 'http://10.11.11.104:6003/api/ProductStock/adjust'; // Usa il nuovo endpoint

  try {
        print('Invio richiesta a $url con barcode: $barcode e qty: $qty');
    final response = await dio.put(
      url,
      data: {
        'barcode': barcode,
        'qty': qty,
      },
    );

    print('Risposta dal server: ${response.data}');

    if (response.statusCode == 200) {
      return 'Quantità aggiornata con successo'; // Ritorna un messaggio di successo
    } else {
      throw Exception('Errore nella risposta del server: ${response.statusCode}');
    }
  } catch (e) {
    print('Errore nella richiesta API: $e');
    throw Exception('Errore nella richiesta API: $e');
  }
}
}