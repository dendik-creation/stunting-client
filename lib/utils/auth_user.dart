import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  static Future<void> saveData(
      String sharedKey, Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(userData);
    await prefs.setString(sharedKey, jsonData);
  }

  static Future<Map<String, dynamic>?> getData(String sharedKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(sharedKey);
    if (jsonData != null) {
      return jsonDecode(jsonData);
    }
    return null;
  }

  static Future<String?> getToken(String sharedKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(sharedKey);
    if (jsonData != null) {
      var data = jsonDecode(jsonData);
      return data?['access_token'];
    }
    return null;
  }

  static Future<void> removeData(String sharedKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(sharedKey);
  }
}
