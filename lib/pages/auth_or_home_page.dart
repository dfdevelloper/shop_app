import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/auth.dart';
import 'package:shop_app/pages/auth_page.dart';
import 'package:shop_app/pages/products_overview_page.dart';

class AuthOrHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    print('esta auth: ${auth.isAuth}');
    return auth.isAuth ? ProductsOverviewPage() : AuthPage();
  }
}
