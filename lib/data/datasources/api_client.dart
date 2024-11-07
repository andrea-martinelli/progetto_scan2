import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progetto_scan2/data/models/product_info_update.dart';
import 'package:progetto_scan2/providers.dart';
 
class ApiClient {
  final Dio dio;
 // final String DOLAPIKEY;
 
  ApiClient(
    this.dio,
  //  this.DOLAPIKEY
  );
 
  // Metodo per ottenere i dettagli del prodotto dal codice a barre
    Future<Map<String, dynamic>> fetchProductFromAPI(String barcode, int warehouseId) async {
      // Inserisci qui l'URL dell'API
      final url = 'http://10.11.11.104:6003/api/NuovoBarcode/details-and-quantity/$barcode/$warehouseId';
         // 'http://10.11.11.104:6003/api/ProdottoBarcode/$barcode?warehouseId=$warehouseId'; // Sostituisci con l'URL corretto
  
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
  Future<String> updateProductQuantityOnServer(String barcode, int qty, int warehouseId) async {
    final url =
        'http://10.11.11.104:6003/api/ProductStock/adjust'; // Usa il nuovo endpoint
 
    try {
      print('Invio richiesta a $url con barcode: $barcode e qty: $qty');
      final response = await dio.put(
        url,
        data: {
          'barcode': barcode,
          'qty': qty,
          'warehouseId': warehouseId,
        },
      );
 
      print('Risposta dal server: ${response.data}');
 
      if (response.statusCode == 200) {
        return 'Quantità aggiornata con successo'; // Ritorna un messaggio di successo
      } else {
        throw Exception(
            'Errore nella risposta del server: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore nella richiesta API: $e');
      throw Exception('Errore nella richiesta API: $e');
    }
  }
 
  // Future<String> fetchWarehouseCapacity(int warehouseId) async {
  //   final url =
  //       'http://10.11.11.124:8080/dolibarr/dolibarr-20.0.1/htdocs/api/index.php/warehouses/$warehouseId';
 
  //   try {
  //     print('Invio richiesta a: $url');
  //     final response = await dio.get(
  //       url,
  //        options: Options()
  //       );
 
  //     if (response.statusCode == 200) {
  //       // Controllo che i dati siano nel formato corretto
  //       final data = response.data;
  //       final capienzaMassima = data['array_options']?['options_capienza_massima'];
  //       final etichetta = data['label'];
  //       if (capienzaMassima != null) {
  //         return capienzaMassima;
  //       } else {
  //         throw Exception(
  //             'Capienza massima non disponibile per questo magazzino');
  //       }
  //     } else {
  //       throw Exception(
  //           'Errore nella risposta del server: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Errore nella richiesta API: $e');
  //     throw Exception('Errore nella richiesta API: $e');
  //   }
  // }
  //api/Magazzino
  Future<List<Map<String, dynamic>>> fetchGetStock(int warehouseId, String reference) async {
    final url = 'http://10.11.11.104:6003/api/Magazzino';

    try {
      final response = await dio.get(
        url,
        data: {
          'warehouse_id': warehouseId,
          'reference': reference,
        },
        options: Options()
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Errore nella richiesta API: $e');
    }
  } 


  Future<int> getDisponibilitaMagazzino(int warehouseId) async {
  final url = 'http://10.11.11.104:6003/api/InfoMagazzino/disponibilita/$warehouseId';
  try {
    final response = await Dio().get(url);

    // Assicurati che la risposta sia una mappa JSON
    if (response.data is Map<String, dynamic>) {
      // Preleva il campo 'disponibilita' e assicurati che sia un int
      return (response.data['disponibilita'] as int? ?? 0); // Restituisce la disponibilità o 0 se non esiste
    } else {
      throw Exception('Risposta inattesa dal server. Atteso un oggetto JSON.');
    }
  } catch (e) {
    throw Exception('Errore nella richiesta API: $e');
  }
}
  }