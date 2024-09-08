import 'dart:async';
import 'dart:convert';

import 'package:client/components/push_snackbar.dart';
import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KeluargaLoginController with ChangeNotifier {
  String _nik = '';

  String get nik => _nik;

  Future<void> login(BuildContext context) async {
    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/keluarga/find')
          .replace(queryParameters: {'nik': nik}),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final data = await jsonDecode(response.body);
    if (response.statusCode != 200) {
      PushSnackbar.liveSnackbar(data['message'], SnackbarType.error);
    } else {
      AuthUser.saveData('keluarga_auth', data['data']);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/home-keluarga');
    }
    notifyListeners();
  }

  void handleChangeNik(String value) {
    _nik = value;
    notifyListeners();
  }
}
