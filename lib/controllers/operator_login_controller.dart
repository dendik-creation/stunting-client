import 'dart:async';
import 'dart:convert';

import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class OperatorLoginController with ChangeNotifier {
  String _username = '';
  String _password = '';

  String get username => _username;
  String get password => _password;

  Future<void> login(BuildContext context) async {
    final Map<String, dynamic> authData = {
      'username': username,
      'password': password,
    };
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(authData),
      );
      final data = await jsonDecode(response.body);
      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 190, 12, 12),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        AuthUser.saveData('operator_auth', data['data']);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/home-operator');
      }
    } finally {
      notifyListeners();
    }
  }

  void handleChange(String value, String target) {
    switch (target) {
      case 'username':
        _username = value;
        break;
      case 'password':
        _password = value;
        break;
    }
    notifyListeners();
  }
}
