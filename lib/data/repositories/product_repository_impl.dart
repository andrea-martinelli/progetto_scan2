//import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:progetto_scan2/data/datasources/api_client.dart';
import 'package:progetto_scan2/data/models/product_info.dart';
import 'package:progetto_scan2/data/models/product_info_update.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl(this.apiClient);

  @override
  Future<ProductInfo> getProductByBarcode(String barcode, int warehouseId) async {
    // Usa il nuovo metodo dell'ApiClient per ottenere i dettagli del prodotto
    final productData = await apiClient.fetchProductFromAPI(barcode, warehouseId);
    print('Product data received: $productData'); // Aggiungi questo per debug
    return ProductInfo.fromJson(productData); // Crea un'istanza di ProductInfo
  }

  @override
  Future<ProductInfoUpdate> updateProductQuantityOnServer( String barcode, int qty, int warehouseId) 
  async {
    // Chiama il metodo di ApiClient per aggiornare la quantità del prodotto
    await apiClient.updateProductQuantityOnServer(barcode, qty, warehouseId);
    return ProductInfoUpdate(barcode: barcode, qty: qty, warehouseId: warehouseId);
  }
  @override
  Future<int> getDisponibilitaMagazzino(int warehouseId, ) async {
    // Chiama il metodo di ApiClient per ottenere la disponibilità del magazzino
    final disponibilitaMagazzino = await apiClient.getDisponibilitaMagazzino(warehouseId, );
    return disponibilitaMagazzino;
  }
  @override
  Future<List<Map<String, dynamic>>> fetchGetStock(int warehouseId, String reference) async {
    // Chiama il metodo di ApiClient per ottenere la disponibilità del magazzino
    final stockname= await apiClient.fetchGetStock(warehouseId, reference);
    return stockname;
  }

}