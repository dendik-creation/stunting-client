import 'dart:async';
import 'dart:convert';

import 'package:client/components/push_snackbar.dart';
import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
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
        PushSnackbar.liveSnackbar(data['message'], SnackbarType.error);
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
