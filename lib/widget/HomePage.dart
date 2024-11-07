import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progetto_scan2/widget/BarcodeScannerPage.dart';
import 'package:progetto_scan2/data/datasources/api_client.dart';
import 'package:progetto_scan2/providers.dart'; // Importa il provider del magazzino

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  ApiClient? apiClient;
  List<dynamic> stockData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    apiClient = ApiClient(Dio());
    _fetchStockData(0, ''); // Inizializza con id e reference vuoti
  }

  Future<void> _fetchStockData(int warehouseId, String reference) async {
    try {
      final response = await apiClient!.fetchGetStock(warehouseId, reference);
      setState(() {
        stockData = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Errore durante il caricamento: $e';
        isLoading = false;
      });
    }
  }

  List<Widget> _buildWarehouseButtons() {
  return stockData.map((stock) {
    final warehouseId = stock['warehouse_id'];
    final reference = stock['reference'] ?? 'N/A';

    // Usa il provider per ottenere la disponibilità
    final warehouseAvailability = ref.watch(warehouseAvailabilityProvider(warehouseId));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: ElevatedButton(
          onPressed: () {
            // Aggiorna il warehouseId nel provider
            ref.read(warehouseIdProvider.notifier).state = warehouseId;

            // Naviga alla pagina di scansione
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarcodeScannerPage(warehouseId: warehouseId),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Magazzino $warehouseId - $reference',
                style: TextStyle(fontSize: 24, color: warehouseId == 1 ? Colors.green : Colors.blueAccent),
              ),
              // Usa un widget per mostrare la disponibilità
              warehouseAvailability.when(
                data: (availability) => Text(
                  'Disponibilità: $availability',
                  style: const TextStyle(fontSize: 18),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, stack) => Text(
                  'Errore: $e',
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleziona Magazzino'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : errorMessage.isNotEmpty
                  ? Text(errorMessage)
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildWarehouseButtons(),
                      ),
                    ),
        ),
      ),
    );
  }
}
