class Category {
  final int id;
  final String name;
  final String? image;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    this.image,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      isActive: json['is_active'] ?? true,
    );
  }
}
