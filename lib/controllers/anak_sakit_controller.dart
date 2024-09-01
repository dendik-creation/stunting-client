import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:client/components/push_snackbar.dart';
import 'package:client/models/anak_sakit_model.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/auth_user.dart';
import 'package:http/http.dart' as http;

class AnakSakitController with ChangeNotifier {
  PenyakitList? _penyakitList;
  final int _maxIndex = 4;
  int _currentIndex = 0;
  bool _onSubmitting = false;
  dynamic _anakSakitResult;
  AnakSakitModel _answerData = AnakSakitModel(
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
  dynamic get anakSakitResult => _anakSakitResult;

  Future<void> fetchPenyakitList({int? keluargaId}) async {
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    final response = await http.get(Uri.parse(
        "${Constants.apiBaseUrl}/anak-sakit/penyakit-list/${keluargaId != null ? keluargaId.toString() : currentKeluarga?['id']}"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      _penyakitList = PenyakitList.fromJson(data);
      _answerData.penyakitPenyertaList = data['penyerta'];
      _answerData.penyakitKomplikasiList = data['komplikasi'];
      notifyListeners();
    }
  }

  dynamic groupPenyakitList(List<dynamic> penyakitList, dynamic data) {
    List<dynamic> penyerta = penyakitList
        .where((element) => element['penyakit']['jenis_penyakit'] == 'penyerta')
        .toList();
    List<dynamic> komplikasi = penyakitList
        .where(
            (element) => element['penyakit']['jenis_penyakit'] == 'komplikasi')
        .toList();
    data!.remove('penyakit_anak');
    data['penyakit_penyerta'] = penyerta;
    data['penyakit_komplikasi'] = komplikasi;
    return data;
  }

  dynamic selectedPenyakitInitialValue(String target, dynamic data) {
    List<dynamic> result = [];
    if (penyakitList != null) {
      if (target == 'penyerta') {
        for (var penyakit in penyakitList!.penyertaList) {
          bool isSelected =
              data.any((item) => item['penyakit_id'] == penyakit.id);
          result.add({
            'id': penyakit.id,
            'nama_penyakit': penyakit.namaPenyakit,
            'selected': isSelected
          });
        }
      } else if (target == 'komplikasi') {
        for (var penyakit in penyakitList!.komplikasiList) {
          bool isSelected =
              data.any((item) => item['penyakit_id'] == penyakit.id);
          result.add({
            'id': penyakit.id,
            'nama_penyakit': penyakit.namaPenyakit,
            'selected': isSelected
          });
        }
      }
    }

    return result;
  }

  Future<void> getAnakSakit(int? keluargaId, bool? isEdit) async {
    final currentKeluarga = await AuthUser.getData('keluarga_auth');
    _answerData = AnakSakitModel(
      namaAnak: '',
      usia: '',
      jenisKelamin: '',
      tinggiBadan: '',
      beratBadan: '',
      riwayatLahirAnak: '',
      ibuBekerja: '',
      pendidikanIbu: '',
      orangTuaMerokok: '',
      penyakitPenyertaList: [],
      penyakitKomplikasiList: [],
    );
    final response = await http.get(
        Uri.parse(
            "${Constants.apiBaseUrl}/anak-sakit/get/${keluargaId != null ? keluargaId.toString() : currentKeluarga?['id']}"),
        headers: {
          "Authorization":
              keluargaId != null ? 'Bearer ${Constants.getApiToken()}' : ''
        });
    if (response.statusCode == 200) {
      final data = groupPenyakitList(
          jsonDecode(response.body)!['data']!['penyakit_anak'],
          jsonDecode(response.body)!['data']);

      if (isEdit! == true) {
        await fetchPenyakitList(keluargaId: keluargaId);
        _answerData = AnakSakitModel(
          namaAnak: data!['nama_anak'],
          usia: data!['usia'],
          jenisKelamin: data!['jenis_kelamin'],
          tinggiBadan: data!['tinggi_badan'],
          beratBadan: data!['berat_badan'],
          riwayatLahirAnak: data!['berat_lahir'],
          ibuBekerja: data!['ibu_bekerja'] == 1 ? true : false,
          pendidikanIbu: data!['pendidikan_ibu'],
          orangTuaMerokok: data!['orang_tua_merokok'] == 1 ? true : false,
          penyakitPenyertaList: selectedPenyakitInitialValue(
              'penyerta', data!['penyakit_penyerta']),
          penyakitKomplikasiList: selectedPenyakitInitialValue(
              'komplikasi', data!['penyakit_komplikasi']),
        );
      } else {
        _anakSakitResult = data;
      }
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

  dynamic dropdownInitialValue(String key) {
    dynamic value;
    switch (key) {
      case 'usia':
        value = _answerData.usia;
        break;
      case 'jenisKelamin':
        value = _answerData.jenisKelamin;
        break;
      case 'riwayatLahirAnak':
        value = _answerData.riwayatLahirAnak;
        break;
      case 'ibuBekerja':
        value = _answerData.ibuBekerja;
        break;
      case 'pendidikanIbu':
        value = _answerData.pendidikanIbu;
        break;
      case 'orangTuaMerokok':
        value = _answerData.orangTuaMerokok;
        break;
    }
    return value;
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
      PushSnackbar.liveSnackbar(
          "Lengkapi form terlebih dahulu", SnackbarType.warning);
    }
    notifyListeners();
  }

  void updateAnakSakit(BuildContext context, int keluargaId) {
    if (validateData()) {
      updateData(context, keluargaId);
    } else {
      PushSnackbar.liveSnackbar(
          "Lengkapi form terlebih dahulu", SnackbarType.warning);
    }
    notifyListeners();
  }

  void updateData(BuildContext context, int keluargaId) async {
    _onSubmitting = true;
    final response = await http
        .put(
            Uri.parse(
                "${Constants.apiBaseUrl}/operator/keluarga/anak-sakit/update/${keluargaId.toString()}"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${await Constants.getApiToken()}"
            },
            body: jsonEncode(answerData))
        .whenComplete(() {
      _onSubmitting = false;
    });
    if (response.statusCode != 200) {
      log(jsonDecode(response.body).toString());
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      PushSnackbar.liveSnackbar(data['message'], SnackbarType.success);

      Timer(const Duration(seconds: 1), () {
        Navigator.of(context)
            .pushReplacementNamed("/result-anak-sakit", arguments: keluargaId);
        _currentIndex = 0;
      });
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
      PushSnackbar.liveSnackbar(data['message'], SnackbarType.success);

      Timer(const Duration(seconds: 1), () {
        _currentIndex = 0;
        _answerData = AnakSakitModel(
          namaAnak: '',
          usia: '',
          jenisKelamin: '',
          tinggiBadan: '',
          beratBadan: '',
          riwayatLahirAnak: '',
          ibuBekerja: '',
          pendidikanIbu: '',
          orangTuaMerokok: '',
          penyakitPenyertaList: [],
          penyakitKomplikasiList: [],
        );
        Navigator.of(context)
            .pushReplacementNamed("/test-kesehatan-lingkungan");
      });
    }
    notifyListeners();
  }
}
