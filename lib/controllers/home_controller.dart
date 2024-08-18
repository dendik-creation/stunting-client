import 'dart:async';
import 'dart:convert';

import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeController {
  Future<Map<String, dynamic>?> getCurrentKeluarga() async {
    final latest = await AuthUser.getData('keluarga_auth');
    var response = await http.get(
      Uri.parse("${Constants.apiBaseUrl}/keluarga/find")
          .replace(queryParameters: {"nik": latest?['nik']}),
      headers: {
        "Content-Type": "application/json",
      },
    );
    final result = jsonDecode(response.body);
    return result['data'];
  }

  void pushLogout(BuildContext context, String targetKey) {
    AuthUser.removeData(targetKey);
    Timer(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  String parseTingkatan(String tingkatan) {
    final tingkatans = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII'];
    final index = int.parse(tingkatan) - 1;
    return "Tingkatan ${tingkatans[index]}";
  }

  String parseToIdDate(String dateString) {
    initializeDateFormatting('id_ID', null);
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat("d MMMM y", "id_ID").format(date);
    return formattedDate;
  }
}
