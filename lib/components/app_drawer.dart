import 'package:flutter/material.dart';
import 'package:shop_app/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Bem vindo usuario!',
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
            ),
            title: Text(
              'Loja',
            ),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.HOME,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text(
              'Pedidos',
            ),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.ORDERS,
            ),
          ),
        ],
      ),
    );
  }
}