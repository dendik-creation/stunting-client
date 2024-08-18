import 'dart:async';
import 'dart:convert';

import 'package:client/models/home_operator_model.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class OperatorApprovalController {
  Future<ApprovalRequest> getDetailApproval(String id) async {
    var response = await http.get(
        Uri.parse("${Constants.apiBaseUrl}/operator/approval/detail/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await Constants.getApiToken()}"
        });

    final dynamic jsonResponse = await jsonDecode(response.body);

    return ApprovalRequest.fromJson(jsonResponse['data']);
  }

  Future<void> approveKeluarga(String id, BuildContext context) async {
    var response = await http.put(
        Uri.parse("${Constants.apiBaseUrl}/operator/approve/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await Constants.getApiToken()}"
        });
    final dynamic data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: data['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF0a8b0d),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Timer(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushNamed('/home-operator');
      });
    }
  }
}
