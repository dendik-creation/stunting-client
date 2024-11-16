import 'dart:async';
import 'dart:convert';

import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:client/views/splash_view.dart';
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
    await AuthUser.saveData('keluarga_auth', result['data']);
    return result['data'];
  }

  void pushLogout(BuildContext context, String targetKey) {
    AuthUser.removeData(targetKey);
    Timer(const Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashView()),
      );
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

  String separateName(String name) {
    List<String> splitName = name.split(" ");
    if (splitName.length > 2) {
      return "${splitName[0]} ${splitName[1]}";
    } else {
      return splitName[0];
    }
  }

  String showKesehatan(int isHealthy, String nilai) {
    String health = isHealthy == 1 ? 'Sehat' : 'Tidak Sehat';

    return "$health ($nilai poin)";
  }

  Future<String> whatNextTest() async {
    final keluarga = await AuthUser.getData('keluarga_auth');
    var response = await http.get(
      Uri.parse("${Constants.apiBaseUrl}/anak-sakit/get/${keluarga?['id']}"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 404) {
      return "/test-anak-sakit";
    } else {
      return "/test-kesehatan-lingkungan";
    }
  }
}
