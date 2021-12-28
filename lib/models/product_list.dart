import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = new Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    hasId ? updateProduct(product) : addProduct(product);
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void updateProduct(Product product) {
    int idx = _items.indexWhere((p) => p.id == product.id);
    if (idx >= 0) _items[idx] = product;
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }
}

  // bool _showFavoriteOnly = false;

  // List<Product> get items {
  //   return _showFavoriteOnly
  //       ? _items.where((product) => product.isFavorite).toList()
  //       : [..._items];
  // }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
