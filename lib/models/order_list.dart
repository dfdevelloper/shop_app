import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/utils/constants.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    try {
      final response = await http.post(
        Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
        body: json.encode(
          {
            "total": cart.totalAmount,
            "date": date.toIso8601String(),
            "products": cart.items.values.map(
              (item) => {
                "name": item.name,
                "price": item.price,
                "productId": item.productId,
                "quantity": item.quantity
              },
            )
          },
        ),
      );

      final id = json.decode(response.body)["name"];

      _items.insert(
        0,
        Order(
          id: id,
          total: cart.totalAmount,
          date: date,
          products: cart.items.values.toList(),
        ),
      );
      notifyListeners();
    } catch (e) {}
  }
}
