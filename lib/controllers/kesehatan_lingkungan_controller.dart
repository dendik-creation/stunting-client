import 'package:client/components/push_snackbar.dart';
import 'package:client/models/kesehatan_lingkungan_model.dart';
import 'dart:async';
import 'dart:convert';

import 'package:client/utils/auth_user.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KesehatanLingkunganController with ChangeNotifier {
  List<QuestionList> _questions = [];
  int _questionIndex = 0;
  bool _onSubmitting = false;
  List<Map<String, int>> _answers = [];

  List<QuestionList> get questions => _questions;
  int get questionIndex => _questionIndex;
  bool? get onSubmitting => _onSubmitting;
  List<Map<String, int>> get answers => _answers;

  Future<void> fetchQuestions() async {
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    final response = await http.get(Uri.parse(
        '${Constants.apiBaseUrl}/kesehatan-lingkungan/questions/${currentKeluarga?['id']}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _questions = (data['data'] as List)
          .map((question) => QuestionList.fromJson(question))
          .toList();
      _answers = _questions.map((question) {
        return {
          'komponen_kesehatan_id': question.id,
          'kriteria_kesehatan_id': 0,
        };
      }).toList();
      notifyListeners();
    }
  }

  void handleChangeQuestion(String direction) {
    if (direction == 'next' && _questionIndex < _questions.length - 1) {
      _questionIndex++;
    } else if (direction == 'back' && _questionIndex > 0) {
      _questionIndex--;
    }
    notifyListeners();
  }

  bool validateAnswer() {
    notifyListeners();
    return _answers.every((answer) => answer['kriteria_kesehatan_id'] != 0);
  }

  void handleSubmit(BuildContext context) async {
    if (!validateAnswer()) {
      PushSnackbar.liveSnackbar(
          "Lengkapi seluruh jawaban dahulu", SnackbarType.warning);
      return;
    }
    _onSubmitting = true;
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    final response = await http
        .post(
      Uri.parse(
          '${Constants.apiBaseUrl}/kesehatan-lingkungan/store/${currentKeluarga?['id']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'data': _answers}),
    )
        .whenComplete(() {
      _onSubmitting = false;
      notifyListeners();
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      PushSnackbar.liveSnackbar(data['message'], SnackbarType.success);

      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed("/home-keluarga");
        _answers.clear();
        _questionIndex = 0;
      });
    }
    _onSubmitting = false;
    notifyListeners();
  }

  void handleChangeAnswer(Map<String, int> newAnswer) {
    int index = answers.indexWhere((prevAnswer) =>
        prevAnswer['komponen_kesehatan_id'] ==
        newAnswer['komponen_kesehatan_id']);
    if (index != -1) {
      _answers[index] = newAnswer;
    } else {
      _answers.add(newAnswer);
    }
    notifyListeners();
  }
}
