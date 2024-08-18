import 'dart:async';
import 'dart:convert';

import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      Fluttertoast.showToast(
        msg: data['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 190, 12, 12),
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
