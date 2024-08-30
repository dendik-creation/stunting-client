import 'dart:async';
import 'dart:convert';
import 'package:client/components/push_snackbar.dart';
import 'package:client/utils/auth_user.dart';
import 'package:flutter/material.dart';
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
    if (_selectedOpt == null) {
      PushSnackbar.liveSnackbar(
          "Isi jawaban terlebih dahulu", SnackbarType.warning);
    } else if (_selectedOpt == false) {
      storeKemandirian(context);
    } else if (_selectedOpt == true &&
        _currentIndex + 1 == _kemandirianQuestion.length) {
      saveAnswer();
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

  void storeKemandirian(context) async {
    _onSubmitting = true;
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    final Map<String, dynamic> answerData = {
      'data': answers,
    };
    final response = await http
        .post(
            Uri.parse(
                '${Constants.apiBaseUrl}/kemandirian/answer-question/${currentKeluarga?['id']}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(answerData))
        .whenComplete(() {
      _onSubmitting = false;
      notifyListeners();
    });
    if (response.statusCode == 200) {
      final serverRes = jsonDecode(response.body);
      PushSnackbar.liveSnackbar(serverRes['message'], SnackbarType.success);
      if (currentKeluarga!['screening_test']['current_step'] < 2) {
        Navigator.of(context).pushReplacementNamed(await whatNextTest());
      } else {
        Navigator.of(context).pushReplacementNamed('/home-keluarga');
      }
      _currentIndex = 0;
      _answers.clear();
      _selectedOpt = null;
    } else {
      final serverRes = jsonDecode(response.body);
      PushSnackbar.liveSnackbar(serverRes['message'], SnackbarType.error);
    }
  }
}
