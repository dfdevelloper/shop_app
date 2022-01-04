import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/components/order.dart';
import 'package:shop_app/models/order_list.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (snapshot.error != null)
            return Center(
              child: Text(
                'Ocorreu um erro.',
              ),
            );
          else {
            return Consumer<OrderList>(
              builder: (ctx, orders, child) => ListView.builder(
                itemCount: orders.items.length,
                itemBuilder: (ctx, i) => OrderWidget(
                  order: orders.items[i],
                ),
              ),
            );
          }
        },
      ),
      // body: _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : RefreshIndicator(
      //       onRefresh: () => _reloadOrders(),
      //       child: ListView.builder(
      //           itemBuilder: (ctx, i) => OrderWidget(
      //             order: orders.items[i],
      //           ),
      //           itemCount: orders.items.length,
      //         ),
      //     ),
    );
  }
}
