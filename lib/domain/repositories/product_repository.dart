import 'package:progetto_scan2/data/models/product_info.dart';
import 'package:progetto_scan2/data/models/product_info_update.dart';

abstract class ProductRepository {
  Future<ProductInfo> getProductByBarcode(String barcode);
  Future<ProductInfoUpdate> updateProductQuantityOnServer(String barcode, int qty); // Aggiungi questo metodo
}
//finisce un metodo per ottenere le informazioni di un prodotto tramite un codice a barre