import 'package:progetto_scan2/data/models/product_info.dart';

abstract class ProductRepository {
  Future<ProductInfo> getProductByBarcode(String barcode);
  Future<void> updateProductQuantityOnServer(int id,String ref, int stockReel,); // Aggiungi questo metodo
}
//finisce un metodo per ottenere le informazioni di un prodotto tramite un codice a barre