import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _imageUrlFocus = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.dispose();
    _imageUrlController.removeListener(updateImage);
  }

  void updateImage() {
    print('atualizando img');
    setState(() {});
  }

  bool _isValidImageUrl(String url) {
    final lowerCasedUrl = url;
    bool isValid = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    print('isValid $isValid');
    bool isImgExtension = lowerCasedUrl.endsWith('jpg') ||
        lowerCasedUrl.endsWith('png') ||
        lowerCasedUrl.endsWith('jpeg');
    print('img extension $isImgExtension');
    return isValid && isImgExtension;
  }

  void _submitForm() {
    final bool isValid = _formkey.currentState?.validate() ?? false;

    if (!isValid) return;

    _formkey.currentState?.save();
    Provider.of<ProductList>(context, listen: false).saveProduct(_formData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('formulario'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(
              Icons.save,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                initialValue: _formData['name']?.toString(),
                validator: (value) {
                  final name = value ?? '';

                  if (name.trim().isEmpty) {
                    return 'O nome está invalido';
                  }

                  if (name.trim().length < 3) {
                    return 'Mínimo de 3 caractéres';
                  }

                  return null;
                },
                textInputAction: TextInputAction.next,
                onSaved: (value) => _formData['name'] = value ?? '',
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_priceFocus),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Preço',
                ),
                initialValue: _formData['price']?.toString(),
                focusNode: _priceFocus,
                validator: (value) {
                  final priceString = value ?? '';
                  final price = double.tryParse(priceString) ?? -1;

                  if (price <= 0) return 'Informe um preço válido';

                  return null;
                },
                onSaved: (value) =>
                    _formData['price'] = double.parse(value ?? '0'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descrição',
                ),
                onSaved: (value) => _formData['description'] = value ?? '',
                initialValue: _formData['description']?.toString(),
                validator: (value) {
                  final description = value ?? '';

                  if (description.trim().isEmpty)
                    return 'A descrição está invalido';

                  if (description.trim().length < 10)
                    return 'Mínimo 10 caractéres';

                  return null;
                },
                focusNode: _descriptionFocus,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Url da imagem',
                      ),
                      focusNode: _imageUrlFocus,
                      keyboardType: TextInputType.url,
                      onSaved: (value) => _formData['imageUrl'] = value ?? '',
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        String stringUrl = value ?? '';
                        if (!_isValidImageUrl(stringUrl)) return 'Url inválida';
                        return null;
                      },
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _submitForm(),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(
                              _imageUrlController.text,
                            ),
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
