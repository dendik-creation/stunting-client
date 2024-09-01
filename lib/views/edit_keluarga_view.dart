import 'dart:async';
import 'dart:convert';

import 'package:client/components/push_snackbar.dart';
import 'package:client/models/screening_test_result_model.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class EditKeluargaView extends StatefulWidget {
  const EditKeluargaView({super.key});

  @override
  State<EditKeluargaView> createState() => _EditKeluargaViewState();
}

class _EditKeluargaViewState extends State<EditKeluargaView> {
  late Keluarga keluarga;
  final _formKey = GlobalKey<FormState>();

  List<Puskesmas> puskesmasList = [];

  late Map<String, dynamic> dataForm = {
    'nik': "",
    'nama_lengkap': "",
    'desa': "",
    'rt': "",
    'rw': "",
    'no_telp': "",
    'alamat': "",
    'puskesmas_id': null,
  };
  bool isFirst = true;
  bool isLoading = false;
  bool isSubmitting = false;

  void getInitial(int keluargaId) async {
    setState(() {
      isLoading = true;
    });
    await getKeluarga(keluargaId);
    await getPuskesmas();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> storeUpdateData() async {
    setState(() {
      isSubmitting = true;
    });
    var response = await http.put(
        Uri.parse(
            "${Constants.apiBaseUrl}/operator/keluarga/update/${keluarga.id.toString()}"),
        body: jsonEncode(dataForm),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await Constants.getApiToken()}",
        }).whenComplete(() {
      setState(() {
        isSubmitting = false;
      });
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      PushSnackbar.liveSnackbar(data['message'], SnackbarType.success);
      Timer(const Duration(milliseconds: 750), () {
        Navigator.of(context).pushReplacementNamed("/operator-keluarga-detail",
            arguments: keluarga.id);
      });
    }
  }

  _updateData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      storeUpdateData();
    }
  }

  Future<void> getPuskesmas() async {
    var response = await http
        .get(Uri.parse("${Constants.apiBaseUrl}/puskesmas/list"), headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List<dynamic>;
      setState(() {
        puskesmasList =
            data.map<Puskesmas>((e) => Puskesmas.fromJson(e)).toList();
      });
    }
  }

  Future<void> getKeluarga(int keluargaId) async {
    var response = await http.get(
        Uri.parse(
            "${Constants.apiBaseUrl}/keluarga/home/${keluargaId.toString()}"),
        headers: {
          "Content-Type": "application/json",
        });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      setState(() {
        keluarga = Keluarga.fromJson(data);
        dataForm = {
          'nik': data['nik'],
          'nama_lengkap': data['nama_lengkap'],
          'desa': data['desa'],
          'rt': data['rt'],
          'rw': data['rw'],
          'no_telp': data['no_telp'],
          'alamat': data['alamat'],
          'puskesmas_id': data['puskesmas']['id'],
        };
      });
    }
  }

  void handleChange(String key, dynamic value) {
    setState(() {
      dataForm[key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int? keluargaId = ModalRoute.of(context)!.settings.arguments as int?;
    if (isFirst) {
      getInitial(keluargaId!);
      setState(() {
        isFirst = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        margin: const EdgeInsets.only(top: 30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.edit_note_rounded,
                                size: 84.0,
                                color: AppColors.green[500],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Edit data keluarga ${keluarga.namaLengkap}",
                                style: const TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              _buildTextField('nik', "NIK", Icons.credit_card,
                                  TextInputType.number,
                                  maxLength: 16),
                              const SizedBox(height: 10),
                              _buildTextField(
                                'nama_lengkap',
                                "Nama Lengkap",
                                Icons.person,
                                TextInputType.text,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: _buildTextField(
                                        'desa',
                                        "Desa",
                                        Icons.home,
                                        TextInputType.text,
                                      )),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      flex: 1,
                                      child: _buildTextField(
                                        'rt',
                                        "RT",
                                        Icons.place,
                                        TextInputType.number,
                                      )),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      flex: 1,
                                      child: _buildTextField(
                                        'rw',
                                        "RW",
                                        Icons.place,
                                        TextInputType.number,
                                      )),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                'no_telp',
                                "No Telepon",
                                Icons.phone,
                                TextInputType.number,
                              ),
                              const SizedBox(height: 10),
                              _buildTextField(
                                'alamat',
                                "Alamat Lengkap",
                                Icons.location_on,
                                TextInputType.text,
                              ),
                              const SizedBox(height: 10),
                              _buildPuskesmasDropdown(),
                              const SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isSubmitting ? null : _updateData,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF12d516),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isSubmitting
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Update',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                )),
    );
  }

  Widget _buildTextField(
      String key, String label, IconData icon, TextInputType type,
      {int maxLength = 100}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        onChanged: (value) => handleChange(key, value),
        initialValue: dataForm[key],
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14.0),
          suffixIcon: Icon(
            icon,
            color: const Color(0xFF08b10b),
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF12d516), width: 2.0),
          ),
        ),
        maxLength: maxLength == 16 ? maxLength : null,
        validator: (value) => value == "" ? 'Wajib terisi' : null,
      ),
    );
  }

  Widget _buildPuskesmasDropdown() {
    dynamic initialValue = puskesmasList
        .firstWhere((item) => item.id == dataForm['puskesmas_id'])
        .namaPuskesmas;
    return CustomDropdown.search(
      initialItem: initialValue,
      decoration: CustomDropdownDecoration(
          closedBorder: Border.all(color: Colors.black54, width: 1.0)),
      hintText: "Puskesmas Terdekat",
      items: puskesmasList.map((puskesmas) => puskesmas.namaPuskesmas).toList(),
      onChanged: (newValue) {
        setState(() {
          dataForm['puskesmas_id'] = puskesmasList
              .firstWhere((puskesmas) => puskesmas.namaPuskesmas == newValue)
              .id;
        });
      },
      validator: (value) => value == null ? 'Puskesmas harus dipilih' : null,
    );
  }
}
