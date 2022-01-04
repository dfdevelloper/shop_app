import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/components/product_item.dart';
import 'package:shop_app/models/product_list.dart';
import 'package:shop_app/utils/app_routes.dart';

class ProductPage extends StatelessWidget {
  Future<void> _reloadProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ProductList products = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM),
            icon: Icon(
              Icons.add,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _reloadProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, i) => Column(
              children: <Widget>[
                ProductItem(
                  product: products.items[i],
                ),
                Divider()
              ],
            ),
            itemCount: products.itemsCount,
          ),
        ),
      ),
    );
  }
}
