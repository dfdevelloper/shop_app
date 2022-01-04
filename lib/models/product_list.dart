import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_execpetions.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/utils/constants.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favoriteItems =>
      _items.where((element) => element.isFavorite).toList();

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = new Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId)
      return updateProduct(product);
    else
      return addProduct(product);
  }

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    _items = [];
    data.forEach((key, value) {
      _items.add(Product(
        id: key,
        name: value['name'],
        description: value['description'],
        price: value['price'],
        imageUrl: value['imageUrl'],
        isFavorite: value['isFavorite'],
      ));
    });
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
      body: json.encode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite,
      }),
    );

    final id = json.decode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int idx = _items.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      _items[idx] = product;
      await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
        body: json.encode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );
      notifyListeners();
    }
  }

  Future<void> removeProduct(String productId) async {
    final response = await http.delete(Uri.parse('${Constants.PRODUCT_BASE_URL}/$productId.json'));

    if (response.statusCode >= 400) {
      throw HttpException(
        msg: 'Falha ao deletar produto',
        statusCode: response.statusCode,
      );
    } else {
      _items.removeWhere((product) => product.id == productId);
      notifyListeners();
    }
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
