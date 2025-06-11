import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> items = [];

  void addItem(Product product) {
    final existingIndex =
        items.indexWhere((item) => item.product.name == product.name);
    if (existingIndex >= 0) {
      items[existingIndex].quantity++;
    } else {
      items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      items.removeAt(index);
    } else {
      items[index].quantity = quantity;
    }
    notifyListeners();
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  double get totalPrice {
    return items.fold(0.0, (sum, item) {
      final price = double.parse(item.product.price
          .replaceAll('Rp. ', '')
          .replaceAll('.', '')
          .replaceAll(',00', ''));
      return sum + (price * item.quantity);
    });
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  int get itemCount => items.length;

  void clear() {
    items.clear();
    notifyListeners();
  }
}
