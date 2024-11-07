class ProductInfo {
  // final int id; // Campo richiesto
  final String reference;
  final int qty; // Quantità, può essere negativa
  final String label;
  
  ProductInfo({
  //  required this.id,
     required this.reference,
    required this.qty,
    required this.label,
   });

  // Metodo per aggiornare i campi con copyWith
  ProductInfo copyWith({
    int? id,
    String? ref,
    int? qty,
     }) {
    return ProductInfo(
    //  id: id ?? this.id,
      reference: reference ?? this.reference,
      qty: qty ?? this.qty,
      label: label ?? this.label,
     );
  }

  // Funzione per deserializzare un oggetto JSON
  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
    //   id: json['id'] ?? 0,
      reference: json['reference'] ?? '',
      qty: json['qty'] ?? 0,
      label: json['label'] ?? '', 
    );
  }

  // Funzione per serializzare un oggetto in JSON
  Map<String, dynamic> toJson() {
    return {
    //  'id': id,
      'ref': reference,
      'qty': qty,
      'label' : label,
     };
  }
}
