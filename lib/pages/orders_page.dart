import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/components/order.dart';
import 'package:shop_app/models/order_list.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Meus pedidos'),
        ),
        drawer: AppDrawer(),
        body: ListView.builder(
          itemBuilder: (ctx, i) => OrderWidget(
            order: orders.items[i],
          ),
          itemCount: orders.items.length,
        ));
  }
}
