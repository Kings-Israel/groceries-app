import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/grocery.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.subtotal;
    });
    return total;
  }

  void addItem(Grocery grocery) {
    if (_items.containsKey(grocery.id)) {
      _items.update(
        grocery.id,
        (existing) => CartItem(
          grocery: existing.grocery,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(grocery.id, () => CartItem(grocery: grocery));
    }
    notifyListeners();
  }

  void removeItem(int groceryId) {
    _items.remove(groceryId);
    notifyListeners();
  }

  void updateQuantity(int groceryId, int quantity) {
    if (quantity <= 0) {
      removeItem(groceryId);
    } else {
      _items.update(
        groceryId,
        (existing) => CartItem(grocery: existing.grocery, quantity: quantity),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> getCartItemsForOrder() {
    return _items.values
        .map(
          (item) => {'grocery_id': item.grocery.id, 'quantity': item.quantity},
        )
        .toList();
  }
}
