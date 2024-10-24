class ProductInfo {
   final int id; // Campo richiesto
  final String ref;
  final int stockReel; // Quantità, può essere negativa
  
  ProductInfo({
    required this.id,
     required this.ref,
    required this.stockReel,
   });

  // Metodo per aggiornare i campi con copyWith
  ProductInfo copyWith({
    int? id,
    String? ref,
    int? stockReel,
     }) {
    return ProductInfo(
      id: id ?? this.id,
      ref: ref ?? this.ref,
      stockReel: stockReel ?? this.stockReel,
     );
  }

  // Funzione per deserializzare un oggetto JSON
  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
       id: json['id'] ?? 0,
      ref: json['ref'] ?? '',
      stockReel: json['stockReel'] ?? 0,
    );
  }

  // Funzione per serializzare un oggetto in JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ref': ref,
      'stockReel': stockReel,
     };
  }
}
