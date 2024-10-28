class ProductInfoUpdate {
  final String barcode;
  final int qty;
  
  ProductInfoUpdate({
    required this.barcode,
    required this.qty,  
   });
    
    ProductInfoUpdate copyWith({
    String? barcode,
    int? qty,
     }) {
    return ProductInfoUpdate(
    barcode: barcode ?? this.barcode,
      qty: qty ?? this.qty,
     );
  }

 factory ProductInfoUpdate.fromJson(Map<String, dynamic> json) {
    return ProductInfoUpdate(
      barcode: json['barcode'] ?? '',
      qty: json['qty'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
       'barcode': barcode,
      'qty': qty,

    };
  }
}