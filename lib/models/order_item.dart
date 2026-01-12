class OrderItem {
  final int id;
  final int groceryId;
  final String groceryName;
  final int quantity;
  final double price;
  final double subtotal;
  final String? groceryImage;

  OrderItem({
    required this.id,
    required this.groceryId,
    required this.groceryName,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.groceryImage,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      groceryId: json['grocery_id'],
      groceryName: json['grocery']['name'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
      groceryImage: json['grocery']['image'],
    );
  }
}
