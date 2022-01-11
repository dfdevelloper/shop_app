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
    return FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null)
            return Center(
              child: Text(
                'Ocorreu um erro.',
              ),
            );
          else {
            return auth.isAuth ? ProductsOverviewPage() : AuthPage();
          }
        });
    // return
  }
}
