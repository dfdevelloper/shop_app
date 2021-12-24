import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  final cardMargin = const EdgeInsets.symmetric(
    horizontal: 15,
    vertical: 4,
  );

  CartItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(item.productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 25,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 20,
        ),
        margin: cardMargin,
      ),
      child: Card(
        margin: cardMargin,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('${item.price}'),
                ),
              ),
            ),
            title: Text(item.name),
            subtitle: Text('Total R\$ ${item.quantity * item.price}'),
            trailing: Text('${item.quantity}x'),
          ),
        ),
      ),
    );
  }
}
