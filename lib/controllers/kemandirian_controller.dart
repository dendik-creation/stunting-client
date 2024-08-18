import 'dart:async';
import 'dart:convert';
import 'package:client/utils/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:client/models/kemandirian_models.dart';
import 'package:client/utils/constant.dart';

class KemandirianController with ChangeNotifier {
  List<PertanyaanKemandirian> _kemandirianQuestion = [];
  int _currentIndex = 0;
  bool? _selectedOpt;
  bool? _onSubmitting = false;
  final List<Map<String, dynamic>> _answers = [];

  List<PertanyaanKemandirian> get questions => _kemandirianQuestion;
  int get currentIndex => _currentIndex;
  bool? get selectedOpt => _selectedOpt;
  bool? get onSubmitting => _onSubmitting;
  List<Map<String, dynamic>> get answers => _answers;

  Future<void> fetchQuestions() async {
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    final response = await http.get(Uri.parse(
        '${Constants.apiBaseUrl}/kemandirian/questions/${currentKeluarga?['id']}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _kemandirianQuestion = (data['data'] as List)
          .map((question) => PertanyaanKemandirian.fromJson(question))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  void handleRadioValueChange(bool? value) {
    _selectedOpt = value;
    notifyListeners();
  }

  void saveAnswer() {
    if (_selectedOpt != null) {
      int id = _kemandirianQuestion[_currentIndex].id;
      int index = _answers.indexWhere((element) => element['id'] == id);

      if (index != -1) {
        _answers[index]['answer'] = _selectedOpt;
      } else {
        _answers.add({'kriteria_kemandirian_id': id, 'answer': _selectedOpt});
      }
      _selectedOpt = null;
      notifyListeners();
    }
  }

  void nextQuestion(BuildContext context) {
    if (_selectedOpt == null ||
        _selectedOpt == false ||
        _currentIndex + 1 == _kemandirianQuestion.length) {
      storeKemandirian(context);
    } else {
      saveAnswer();
      _currentIndex += 1;
      if (_currentIndex >= _kemandirianQuestion.length) {
        _currentIndex = _kemandirianQuestion.length - 1;
      }
    }
    notifyListeners();
  }

  void storeKemandirian(context) async {
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    _onSubmitting = true;
    final Map<String, dynamic> answerData = {
      'data': answers,
    };
    final response = await http.post(
        Uri.parse(
            '${Constants.apiBaseUrl}/kemandirian/answer-question/${currentKeluarga?['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(answerData));
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacementNamed('/test-list');
      final serverRes = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: serverRes['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF0a8b0d),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      final serverRes = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: serverRes['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red[200],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    _onSubmitting = false;
    _currentIndex = 0;
    _selectedOpt = null;
    notifyListeners();
  }
}
