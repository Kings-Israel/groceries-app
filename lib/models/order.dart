import 'order_item.dart';

class Order {
  final int id;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final String deliveryLocation;
  final List<OrderItem> items;
  final int? rating;
  final String? review;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.deliveryLocation,
    required this.items,
    this.rating,
    this.review,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['order_number'],
      totalAmount: double.parse(json['total_amount'].toString()),
      status: json['status'],
      deliveryLocation: json['delivery_location'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      rating: json['rating'],
      review: json['review'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
