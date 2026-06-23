class ProductModel {
  final int? id;
  final String category;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String location;
  final bool isDeliveryAvailable;
  final String? imageData;

  ProductModel({
    this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.location,
    required this.isDeliveryAvailable,
    this.imageData,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      category: map['category'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: double.tryParse(map['price'].toString()) ?? 0.0,
      quantity: int.tryParse(map['quantity'].toString()) ?? 0,
      location: map['location'] ?? '',
      isDeliveryAvailable: (map['isDeliveryAvailable'] ?? 0) == 1,
      imageData: map['image_data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'category': category,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'location': location,
      'isDeliveryAvailable': isDeliveryAvailable ? 1 : 0,
      'image_data': imageData,
    };
  }
}
