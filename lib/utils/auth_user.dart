import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KeluargaAuth {
  static const String sharedKey = 'keluarga_auth';

  static Future<void> saveData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(userData);
    await prefs.setString(sharedKey, jsonData);
  }

  static Future<Map<String, dynamic>?> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(sharedKey);
    if (jsonData != null) {
      return jsonDecode(jsonData);
    }
    return null;
  }

  static Future<void> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(sharedKey);
  }
}
