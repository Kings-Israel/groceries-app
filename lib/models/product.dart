class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
      categoryId: json['category_id'],
    );
  }
}
