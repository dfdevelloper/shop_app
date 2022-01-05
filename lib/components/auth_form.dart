import 'package:flutter/material.dart';

enum AuthMode { Login, Signup }

class AuthForm extends StatefulWidget {
  @override
  AuthFormState createState() => new AuthFormState();
}

class AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _formData = {};
  final _passwordFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid) return;

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    if(_isLogin()){
      // login
    }else{
      // registrar
    }

    setState(() => _isLoading = false);
  }

  void _switchAuthMode() {
    setState(() => _authMode = _isLogin() ? AuthMode.Signup : AuthMode.Login);
  }

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 320 : 400,
        width: screenSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _formData['email'] = value ?? '',
                validator: (value) {
                  final email = value ?? '';
                  if (email.isEmpty) return 'Informe um email';
                  if (!email.contains("@")) return 'Email inválido';
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.text,
                obscureText: true,
                onSaved: (value) => _formData['password'] = value ?? '',
                controller: _passwordFieldController,
              ),
              if (_isSignup())
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirmar senha'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) {
                    final password = value ?? '';
                    if (password != _passwordFieldController.text)
                      return 'As senhas não conhecidem';
                    if (password.isEmpty) return 'Confirme a senha';
                    return null;
                  },
                ),
              SizedBox(
                height: 40,
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        _isLogin() ? 'Entrar' : 'Cadastrar',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
              Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
