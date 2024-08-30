import 'dart:convert';

import 'package:client/models/screening_test_result_model.dart';
import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ScreeningTestResultController with ChangeNotifier {
  ScreeningTestList? _testList;
  ScreeningTestDetail? _testDetail;
  dynamic _keluargaAuth;
  bool _isOperatorAction = false;

  ScreeningTestList? get testList => _testList;
  ScreeningTestDetail? get testDetail => _testDetail;
  dynamic get keluargaAuth => _keluargaAuth;
  bool get isOperatorAction => _isOperatorAction;

  Future<void> getTestListByOperator(int keluargaId) async {
    _isOperatorAction = true;
    _testList = null;
    final token = await Constants.getApiToken();
    final response = await http.get(
        Uri.parse(
            "${Constants.apiBaseUrl}/operator/keluarga/${keluargaId.toString()}/test"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        });
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body)['data'];
      _testList = ScreeningTestList.fromJson(data);
      notifyListeners();
    }
  }

  Future<void> getTestDetailByOperator(int keluargaId, int step) async {
    _isOperatorAction = true;
    _testDetail = null;
    final token = await Constants.getApiToken();
    final response = await http.get(
        Uri.parse(
            "${Constants.apiBaseUrl}/operator/keluarga/${keluargaId.toString()}/test/${step.toString()}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        });
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body)['data'];
      _testDetail = ScreeningTestDetail.fromJson(data);
      notifyListeners();
    }
  }

  Future<void> getTestListByKeluarga() async {
    _isOperatorAction = false;
    _testList = null;
    final keluarga = await AuthUser.getData('keluarga_auth');
    _keluargaAuth = keluarga;
    final response = await http.get(
        Uri.parse(
            "${Constants.apiBaseUrl}/keluarga/test/list/${keluarga?['id']}"),
        headers: {
          "Content-Type": "application/json",
        });
    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body)['data'];
      _testList = ScreeningTestList.fromJson(data);
      notifyListeners();
    }
  }

  Future<void> getTestDetailByKeluarga(int step) async {
    _isOperatorAction = false;
    _testDetail = null;
    final keluarga = await AuthUser.getData('keluarga_auth');
    _keluargaAuth = keluarga;
    final response = await http.get(
        Uri.parse(
            "${Constants.apiBaseUrl}/keluarga/test/detail/${keluarga?['id']}/${step.toString()}}"),
        headers: {
          "Content-Type": "application/json",
        });

    if (response.statusCode == 200) {
      final data = await jsonDecode(response.body)['data'];
      _testDetail = ScreeningTestDetail.fromJson(data);
      notifyListeners();
    }
  }

  String parseToIdDate(String dateString) {
    initializeDateFormatting('id_ID', null);
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat("d MMMM y", "id_ID").format(date);
    return formattedDate;
  }

  String parseTingkatan(String tingkatan) {
    final tingkatans = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII'];
    final index = int.parse(tingkatan) - 1;
    return "Tingkatan ${tingkatans[index]}";
  }

  String showKesehatan(int isHealthy, String nilai) {
    String health = isHealthy == 1 ? 'Sehat' : 'Tidak Sehat';
    return "$health ($nilai poin)";
  }

  IconData showIconKemandirian(int tingkatan) {
    switch (tingkatan) {
      case 4:
        return Icons.sentiment_very_satisfied;
      case 3:
        return Icons.sentiment_satisfied_alt;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 1:
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  IconData showIconKesehatanLingkungan(int nilaiTotal) {
    switch (nilaiTotal) {
      case > 334:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_very_dissatisfied;
    }
  }
}
