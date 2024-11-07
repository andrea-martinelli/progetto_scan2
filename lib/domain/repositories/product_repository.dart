import 'package:progetto_scan2/data/models/product_info.dart';
import 'package:progetto_scan2/data/models/product_info_update.dart';

abstract class ProductRepository {
  Future<ProductInfo> getProductByBarcode(String barcode, int warehouseId);
  Future<ProductInfoUpdate> updateProductQuantityOnServer(String barcode, int qty, int warehouseId); // Aggiungi questo metodo
  Future<int> getDisponibilitaMagazzino(int warehouseId, ); // Aggiungi questo metodo
  Future<List<Map<String, dynamic>>> fetchGetStock(int warehouseId, String reference);
 }

//finisce un metodo per ottenere le informazioni di un prodotto tramite un codice a barre