import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  @override
  void dispose(){
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('formulario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
            child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocus),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Preço',
              ),
              focusNode: _priceFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Descrição',
              ),
              focusNode: _descriptionFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
          ],
        )),
      ),
    );
  }
}
