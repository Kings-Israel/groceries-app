import 'grocery.dart';

class CartItem {
  final Grocery grocery;
  int quantity;

  CartItem({required this.grocery, this.quantity = 1});

  double get subtotal => grocery.price * quantity;
}
