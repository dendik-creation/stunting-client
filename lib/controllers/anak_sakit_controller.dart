import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/models/anak_sakit_model.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:client/utils/auth_user.dart';
import 'package:http/http.dart' as http;

class AnakSakitController with ChangeNotifier {
  PenyakitList? _penyakitList;
  final int _maxIndex = 4;
  int _currentIndex = 0;
  bool _onSubmitting = false;
  final AnakSakitModel _answerData = AnakSakitModel(
    namaAnak: '',
    usia: '',
    jenisKelamin: '',
    tinggiBadan: '',
    beratBadan: '',
    penyakitPenyertaList: [],
    ibuBekerja: null,
    pendidikanIbu: '',
    riwayatLahirAnak: '',
    penyakitKomplikasiList: [],
    orangTuaMerokok: null,
  );

  PenyakitList? get penyakitList => _penyakitList;
  int get currentIndex => _currentIndex;
  int get maxIndex => _maxIndex;
  bool? get onSubmitting => _onSubmitting;
  AnakSakitModel? get answerData => _answerData;

  Future<void> fetchPenyakitList() async {
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    final response = await http.get(Uri.parse(
        "${Constants.apiBaseUrl}/anak-sakit/penyakit-list/${currentKeluarga?['id']}"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      _penyakitList = PenyakitList.fromJson(data);
      _answerData.penyakitPenyertaList = data['penyerta'];
      _answerData.penyakitKomplikasiList = data['komplikasi'];
      notifyListeners();
    }
  }

  void changeQuestion(String direction) {
    if (direction == 'next' && _currentIndex < _maxIndex) {
      _currentIndex++;
    } else if (direction == 'back' && _currentIndex > 0) {
      _currentIndex--;
    }
    notifyListeners();
  }

  void inputHandleChange(String key, dynamic value) {
    switch (key) {
      case 'namaAnak':
        _answerData.namaAnak = value;
        break;
      case 'tinggiBadan':
        _answerData.tinggiBadan = value;
        break;
      case 'beratBadan':
        _answerData.beratBadan = value;
        break;
    }
    notifyListeners();
  }

  void dropdownHandleChange(String key, dynamic value) {
    switch (key) {
      case 'usia':
        _answerData.usia = value;
        break;
      case 'jenisKelamin':
        _answerData.jenisKelamin = value;
        break;
      case 'ibuBekerja':
        _answerData.ibuBekerja = value;
        break;
      case 'pendidikanIbu':
        _answerData.pendidikanIbu = value;
        break;
      case 'riwayatLahirAnak':
        _answerData.riwayatLahirAnak = value;
        break;
      case 'orangTuaMerokok':
        _answerData.orangTuaMerokok = value;
        break;
    }
    notifyListeners();
  }

  void multiCheckboxHandleChange(String key, dynamic value, int index) {
    if (key == 'penyerta') {
      _answerData.penyakitPenyertaList[index]['selected'] = value;
    } else {
      _answerData.penyakitKomplikasiList[index]['selected'] = value;
    }
    notifyListeners();
  }

  bool validateData() {
    int penyertaLength = 0;
    int komplikasiLength = 0;
    if (answerData!.namaAnak.isEmpty) return false;
    if (answerData!.usia.isEmpty) return false;
    if (answerData!.jenisKelamin == null ||
        answerData!.jenisKelamin.toString().isEmpty) {
      return false;
    }
    if (answerData!.tinggiBadan == null ||
        answerData!.tinggiBadan.toString().isEmpty) {
      return false;
    }
    if (answerData!.beratBadan == null ||
        answerData!.beratBadan.toString().isEmpty) {
      return false;
    }
    if (answerData!.ibuBekerja == null) return false;
    if (answerData!.pendidikanIbu.isEmpty) return false;
    if (answerData!.riwayatLahirAnak.isEmpty) return false;
    if (answerData!.orangTuaMerokok == null) return false;

    for (var item in answerData!.penyakitPenyertaList) {
      if (item['selected'] == true) penyertaLength++;
    }
    if (penyertaLength < 1) return false;
    for (var item in answerData!.penyakitKomplikasiList) {
      if (item['selected'] == true) komplikasiLength++;
    }
    if (komplikasiLength < 1) return false;

    return true;
  }

  void storeAnakSakit(BuildContext context) {
    if (validateData()) {
      submitData(context);
    } else {
      Fluttertoast.showToast(
        msg: 'Lengkapi data terlebih dahulu',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 190, 12, 12),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    notifyListeners();
  }

  void submitData(BuildContext context) async {
    _onSubmitting = true;
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    final response = await http
        .post(
            Uri.parse(
                "${Constants.apiBaseUrl}/anak-sakit/store-anak-sakit/${currentKeluarga?['id']}"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode(answerData))
        .whenComplete(() {
      _onSubmitting = false;
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 190, 12, 12),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Timer(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed("/home-keluarga");
      });
    }
    notifyListeners();
  }
}
