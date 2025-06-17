import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // ✅ Getter itemCount
  int get itemCount => _items.length;

  // ✅ Getter totalPrice
  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      final price = double.tryParse(
              item.product.price.replaceAll(RegExp(r'[^\d]'), '')) ??
          0;
      total += price * item.quantity;
    }
    return total;
  }

  // ✅ Tambahkan produk ke keranjang
  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  // ✅ Update jumlah produk
  void updateQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1 && quantity > 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  // ✅ Hapus produk dari keranjang
  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  // ✅ Kosongkan keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
