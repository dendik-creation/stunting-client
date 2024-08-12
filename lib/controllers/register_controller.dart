import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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

  Future<void> register(RegisterModel register) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/keluarga/register'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.acceptHeader: 'application/json',
        },
        encoding: Encoding.getByName('utf-8'),
        body: jsonEncode(register.toJson()),
      );

      log(response.body);

      if (response.statusCode != 201) {
        throw Exception('Gagal register data');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
