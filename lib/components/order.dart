import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  OrderWidget({required this.order});

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    print('product ${widget.order.id}');
    return Card(
      child: Column(children: <Widget>[
        ListTile(
          title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
          subtitle: Text(
            DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
          ),
          trailing: IconButton(
            icon: Icon(Icons.expand_more),
            onPressed: () => {
              setState(() {
                expanded = !expanded;
              })
            },
          ),
        ),
        if (expanded)
          Container(
            height: (widget.order.products.length * 25) + 10,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: ListView(
                children: widget.order.products
                    .map((product) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${product.name}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${product.quantity}x R\$ ${product.price}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList()),
          )
      ]),
    );
  }
}
