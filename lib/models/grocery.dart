class Grocery {
  final int id;
  final int categoryId;
  final String name;
  final String? description;
  final String image;
  final double price;
  final String unit;
  final int stock;
  final bool isAvailable;

  Grocery({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.image,
    required this.price,
    required this.unit,
    required this.stock,
    required this.isAvailable,
  });

  factory Grocery.fromJson(Map<String, dynamic> json) {
    return Grocery(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: double.parse(json['price'].toString()),
      unit: json['unit'],
      stock: json['stock'],
      isAvailable: json['is_available'] ?? true,
    );
  }
}
