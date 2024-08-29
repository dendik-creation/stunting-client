import 'dart:convert';
import 'dart:developer';

import 'package:client/components/operator_navbar.dart';
import 'package:client/models/screening_test_result_model.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OperatorKeluargaDetailView extends StatefulWidget {
  const OperatorKeluargaDetailView({super.key});

  @override
  State<OperatorKeluargaDetailView> createState() =>
      _OperatorKeluargaDetailViewState();
}

class _OperatorKeluargaDetailViewState
    extends State<OperatorKeluargaDetailView> {
  late Keluarga keluarga;
  bool isFirst = true;
  bool onLoading = false;
  void getInitial(int keluargaId) async {
    setState(() {
      onLoading = true;
    });
    final token = await Constants.getApiToken();
    var response = await http.get(
        Uri.parse(
            "${Constants.apiBaseUrl}/operator/keluarga/${keluargaId.toString()}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      setState(() {
        keluarga = Keluarga.fromJson(data);
        onLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int keluargaId = ModalRoute.of(context)!.settings.arguments as int;
    if (isFirst) {
      getInitial(keluargaId);
      setState(() {
        isFirst = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: onLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.person_pin_rounded,
                          size: 84.0,
                          color: AppColors.green[500],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          "Identitas Keluarga",
                          style: TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        buildIdentity(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        buildTile(Icons.child_care_rounded, Colors.blue[600],
                            "Data Anak Sakit"),
                        buildTile(
                            Icons.track_changes_rounded,
                            AppColors.green[600],
                            "Hasil Tes Screening",
                            "/result-test-list")
                      ],
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: const OperatorNavbar(currentIndex: 1),
    );
  }

  Column buildIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildField('NIK', keluarga.nik),
        buildField('Nama Lengkap', keluarga.namaLengkap),
        buildField('No. Telepon', keluarga.noTelp),
        buildField(
            'Desa', "${keluarga.desa} - RT ${keluarga.rt} / RW ${keluarga.rw}"),
        buildField('Alamat Lengkap', keluarga.alamat),
        buildField('Puskesmas Pengampu', keluarga.puskesmas.namaPuskesmas),
      ],
    );
  }

  Column buildField(String fieldName, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Card buildTile(IconData icon, Color? color, String text, [String? url]) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      borderOnForeground: false,
      shadowColor: Colors.transparent,
      child: ListTile(
        tileColor: color?.withOpacity(0.7),
        splashColor: color?.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        leading: Icon(
          icon,
          color: Colors.white,
          size: 32.0,
        ),
        title: Text(
          text,
          style: const TextStyle(fontSize: 14.0, color: Colors.white),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.white,
          size: 25.0,
        ),
        onTap: () {
          if (url != null) {
            Navigator.pushNamed(context, url, arguments: keluarga.id);
          }
        },
      ),
    );
  }
}
