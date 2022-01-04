import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/cart_item.dart';
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

  void _clearItems() {
    _items = [];
  }

  Future<void> loadOrders() async {
    _clearItems();
    final response =
        await http.get(Uri.parse('${Constants.ORDER_BASE_URL}.json'));

    if (response.body == "null") return;

    Map<String, dynamic> data = json.decode(response.body);

    data.forEach((key, value) {
      _items.add(
        Order(
          id: key,
          total: value['total'],
          products: (value['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    productId: item['productId'],
                    name: item['name'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
          date: DateTime.parse(value['date']),
        ),
      );
    });

    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    print('tentando adicionar');
    try {
      final response = await http.post(
        Uri.parse('${Constants.ORDER_BASE_URL}.json'),
        body: json.encode(
          {
            "total": cart.totalAmount,
            "date": date.toIso8601String(),
            "products": cart.items.values
                .map(
                  (item) => {
                    "id": item.id,
                    "name": item.name,
                    "price": item.price,
                    "productId": item.productId,
                    "quantity": item.quantity
                  },
                )
                .toList()
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
    } catch (e) {
      print('erro $e');
    }
  }
}
