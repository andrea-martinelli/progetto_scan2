class ProductInfoUpdate {
  final String barcode;
  final int qty;
  final int warehouseId;
  
  ProductInfoUpdate({
    required this.barcode,
    required this.qty,  
    required this.warehouseId,
   });
    
    ProductInfoUpdate copyWith({
    String? barcode,
    int? qty,
    int? warehouseId,
     })
      {

    return ProductInfoUpdate(
    barcode: barcode ?? this.barcode,
      qty: qty ?? this.qty,
     warehouseId: warehouseId ?? this.warehouseId,
     );
  }

 factory ProductInfoUpdate.fromJson(Map<String, dynamic> json) {
    return ProductInfoUpdate(
      barcode: json['barcode'] ?? '',
      qty: json['qty'] ?? 0,
      warehouseId: json['warehouseId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
       'barcode': barcode,
      'qty': qty,
      

    };
  }
}