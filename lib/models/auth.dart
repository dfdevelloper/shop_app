import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/auth_excepetion.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiryDate;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get uid {
    return isAuth ? _uid : null;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> _authenticate(
      String email, String password, String authType) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$authType?key=AIzaSyCoAyvSwjpiquTU3rf4ntZJQGxXNV7N9Kc";

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['refreshToken'];
      _email = body['email'];
      _uid = body['uid'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );
      notifyListeners();
    }
  }
}
