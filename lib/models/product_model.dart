class ProductModel {
  String id;
  String name;
  String imageUrl;
  String price;
  String category;

  ProductModel(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.price,
      required this.category});

  // Create a factory constructor to convert Firestore data to a ProductModel
  factory ProductModel.fromFirestore(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price']?.toString() ?? '0.0',
      category: data['category'] ?? '',
    );
  }
}

class Category {
  final String name;
  final List<ProductModel> products;

  Category({required this.name, required this.products});
}
