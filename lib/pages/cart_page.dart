import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/cart_item.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/order_list.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color,
                      ),
                    ),
                  ),
                  Spacer(),
                  CartButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => CartItemWidget(
                (items[i]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _CartButtonState createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    return _isLoading
        ? Padding(
            child: CircularProgressIndicator(),
            padding: EdgeInsets.only(
              right: 10,
            ),
          )
        : TextButton(
            onPressed: widget.cart.itemsCount == 0
                ? null
                : () async {
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      await Provider.of<OrderList>(
                        context,
                        listen: false,
                      ).addOrder(widget.cart);
                      widget.cart.clear();
                    } catch (e) {
                      msg.showSnackBar(
                        SnackBar(
                          content: Text('Falha ao efetuar compra.'),
                        ),
                      );
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: Text(
              'COMPRAR',
            ),
          );
  }
}
