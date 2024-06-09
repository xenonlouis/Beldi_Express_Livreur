import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier{

  static final CartModel _cart = CartModel._internal();

  factory CartModel() {
    return _cart;
  }

  CartModel._internal();

  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(Map<String, dynamic> item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(Map<String, dynamic> item) {
    _items.remove(item);
    notifyListeners();

  }

  double get totalPrice {
    if (_items.isEmpty) return 0.0;
    return _items.fold(0, (total, current) => total + (current['price'] as double));
  }

  void clearCart() {
    _items.clear();
  }
}
