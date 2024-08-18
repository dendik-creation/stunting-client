import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/models/home_operator_model.dart';
import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OperatorHomeController with ChangeNotifier {
  Future<Map<String, dynamic>?> getCurrentOperator() async {
    final latest = await AuthUser.getData('operator_auth');
    if (latest != null) {
      notifyListeners();
      return latest;
    }
    notifyListeners();
    return null;
  }

  Future<List<ApprovalRequest>?> getAvailableApproval() async {
    var response = await http.get(
      Uri.parse("${Constants.apiBaseUrl}/operator/home"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${await Constants.getApiToken()}"
      },
    );

    final List<dynamic> jsonResponse =
        jsonDecode(response.body)['data']['approval_request'];
    return jsonResponse.map((data) => ApprovalRequest.fromJson(data)).toList();
  }

  void pushLogout(BuildContext context, String targetKey) async {
    var response = await http
        .post(Uri.parse("${Constants.apiBaseUrl}/auth/logout"), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await Constants.getApiToken()}"
    });

    if (response.statusCode == 200) {
      Timer(const Duration(milliseconds: 500), () {
        AuthUser.removeData(targetKey);
        Navigator.of(context).pushReplacementNamed('/onboarding');
      });
    }

    notifyListeners();
  }
}
