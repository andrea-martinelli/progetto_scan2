import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:progetto_scan2/data/datasources/api_client.dart';
import 'package:progetto_scan2/domain/repositories/product_repository.dart';
import 'package:progetto_scan2/data/repositories/product_repository_impl.dart';


// Definisci la tua chiave API di Dolibarr

//const String DOLAPIKEY = '3482pXRT06WOuqxam4U69jFGuCOnu4Eg';

// Provider per il ProductRepository
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  // Crea un'istanza di ApiClient con Dio
  final apiClient = ApiClient(Dio() );
  return ProductRepositoryImpl(apiClient);
});
