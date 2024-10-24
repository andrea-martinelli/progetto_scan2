import 'package:dio/dio.dart';

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
  Future<void> updateProductQuantityOnServer(int id,  String ref, int stockReel)
   async {
    final url = 'http://10.11.11.104:6003/api/ProdottoBarcode/$stockReel'; // Usa il nuovo endpoint

    try {
     // print('Inviando richiesta POST a: $url con quantità: $newQuantity e barcode: $barcodeId');
      
      // Invio la richiesta POST
      final response = await dio.post(
        url,
     //   options: Options(headers: {'DOLAPIKEY': DOLAPIKEY}), // Aggiungi la chiave API nell'header
        data: {
          'id': id ,
          'ref': ref,
          'stockReel': stockReel,
         
        },
      );

      print('Risposta dal server: ${response.data}');
      
      if (response.statusCode != 200) {
        throw Exception('Errore nell\'aggiornamento della quantità');
      }
    } catch (e) {
      print('Errore nella richiesta API: $e');
      throw Exception('Errore nella richiesta API: $e');
    }
  }
}
