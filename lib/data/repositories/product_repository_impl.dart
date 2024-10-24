import 'package:progetto_scan2/data/datasources/api_client.dart';
import 'package:progetto_scan2/data/models/product_info.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;

  ProductRepositoryImpl(this.apiClient);

  @override
  Future<ProductInfo> getProductByBarcode(String barcode) async {
    // Usa il nuovo metodo dell'ApiClient per ottenere i dettagli del prodotto
    final productData = await apiClient.fetchProductFromAPI(barcode);
    print('Product data received: $productData'); // Aggiungi questo per debug
    return ProductInfo.fromJson(productData); // Crea un'istanza di ProductInfo
  }
  @override
  Future<void> updateProductQuantityOnServer(int id, String ref, int stockReel) async {
    // Chiama il metodo di ApiClient per aggiornare la quantità del prodotto
    await apiClient.updateProductQuantityOnServer(id, ref, stockReel );
  }
}
