import 'dart:convert';
import 'dart:io';

import 'package:client/utils/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:client/utils/constant.dart';
import 'package:client/models/register_model.dart';

class RegisterController {
  Future<List<PuskesmasModel>> getPuskesmas() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.apiBaseUrl}/puskesmas/list'),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to load puskesmas data");
      }

      final responseData = jsonDecode(response.body);
      return (responseData['data'] as List<dynamic>)
          .map((dynamic item) =>
              PuskesmasModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Error fetching puskesmas data: ${e.toString()}");
    }
  }

  Future<void> register(RegisterModel register, BuildContext context) async {
    final response = await http.post(
      Uri.parse('${Constants.apiBaseUrl}/keluarga/register'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.acceptHeader: 'application/json',
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(register.toJson()),
    );

    final data = await jsonDecode(response.body);
    if (response.statusCode != 201) {
      Fluttertoast.showToast(
        msg: data['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF0a8b0d),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    await AuthUser.saveData('keluarga_auth', data['data']);
    await Navigator.of(context).pushReplacementNamed('/home');
  }
}
