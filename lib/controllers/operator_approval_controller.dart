import 'dart:async';
import 'dart:convert';

import 'package:client/components/push_snackbar.dart';
import 'package:client/models/home_operator_model.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
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
      PushSnackbar.liveSnackbar(data['message'], SnackbarType.success);

      Timer(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushNamed('/home-operator');
      });
    }
  }
}
