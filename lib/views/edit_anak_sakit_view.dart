import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:client/components/custom_navbar.dart';
import 'package:client/components/operator_navbar.dart';
import 'package:client/controllers/anak_sakit_controller.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAnakSakitView extends StatefulWidget {
  const EditAnakSakitView({super.key});

  @override
  State<EditAnakSakitView> createState() => _EditAnakSakitViewState();
}

class _EditAnakSakitViewState extends State<EditAnakSakitView> {
  bool isFirst = true;
  bool onLoading = false;
  final Map<String, SingleSelectController<dynamic>> _dropdownControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeDropdownControllers([
      "usia",
      "jenisKelamin",
      "riwayatLahirAnak",
      "ibuBekerja",
      "pendidikanIbu",
      "orangTuaMerokok"
    ]);
  }

  void _initializeDropdownControllers(List<String> keys) {
    for (var key in keys) {
      _dropdownControllers[key] = SingleSelectController<String>(null);
    }
  }

  void getInitial(int? keluargaId, AnakSakitController controller) async {
    setState(() {
      onLoading = true;
    });
    await controller.getAnakSakit(keluargaId, true);
    setState(() {
      onLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AnakSakitController>(context);
    final int? keluargaId = ModalRoute.of(context)!.settings.arguments as int?;
    if (isFirst) {
      getInitial(keluargaId, controller);
      setState(() {
        isFirst = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: onLoading || controller.penyakitList == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 30.0),
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
                        const Text(
                          "Edit data anak sakit",
                          style: TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                                "namaAnak",
                                "Nama",
                                "Nama anak",
                                Icons.child_care_rounded,
                                TextInputType.text,
                                controller),
                            _buildDropdownButton(
                                "usia",
                                "Usia",
                                "Usia (bulan)",
                                [
                                  {
                                    "label": "1-23 Bulan",
                                    "value": "1-23",
                                  },
                                  {
                                    "label": "24-36 Bulan",
                                    "value": "24-36",
                                  },
                                  {
                                    "label": "37-48 Bulan",
                                    "value": "37-48",
                                  },
                                  {
                                    "label": "49-60 Bulan",
                                    "value": "49-60",
                                  }
                                ],
                                controller),
                            _buildDropdownButton(
                                "jenisKelamin",
                                "Jenis kelamin",
                                "Jenis kelamin anak",
                                [
                                  {
                                    "label": "Laki-laki",
                                    "value": "L",
                                  },
                                  {
                                    "label": "Perempuan",
                                    "value": "P",
                                  }
                                ],
                                controller),
                            _buildTextField(
                                "tinggiBadan",
                                "Tinggi badan",
                                "Tinggi badan anak (cm)",
                                Icons.height_rounded,
                                TextInputType.number,
                                controller),
                            _buildTextField(
                                "beratBadan",
                                "Berat badan",
                                "Berat badan anak (kg)",
                                Icons.line_weight_rounded,
                                TextInputType.number,
                                controller),
                            _buildDropdownButton(
                                "riwayatLahirAnak",
                                "Riwayat kelahiran",
                                "Riwayat berat badan ketika lahir",
                                [
                                  {
                                    "label": "Normal (Lebih dari 2,5 kg)",
                                    "value": "normal",
                                  },
                                  {
                                    "label": "Rendah (kurang dari 2,5 kg)",
                                    "value": "rendah",
                                  }
                                ],
                                controller),
                            _buildDropdownButton(
                                "ibuBekerja",
                                "Ibu bekerja",
                                "Apakah Ibu bekerja",
                                [
                                  {
                                    "label": "Ya",
                                    "value": true,
                                  },
                                  {
                                    "label": "Tidak",
                                    "value": false,
                                  }
                                ],
                                controller),
                            _buildDropdownButton(
                                "pendidikanIbu",
                                "Pendidikan Ibu",
                                "Pendidikan terakhir Ibu",
                                [
                                  {
                                    "label": "SMP",
                                    "value": "SMP",
                                  },
                                  {
                                    "label": "SMA",
                                    "value": "SMA",
                                  },
                                  {
                                    "label": "Sarjana",
                                    "value": "Sarjana",
                                  },
                                ],
                                controller),
                            _buildDropdownButton(
                                "orangTuaMerokok",
                                "Orang tua merokok",
                                "Apakah orang tua merokok",
                                [
                                  {
                                    "label": "Ya",
                                    "value": true,
                                  },
                                  {
                                    "label": "Tidak",
                                    "value": false,
                                  }
                                ],
                                controller),
                            _buildMultipleCheckbox(
                                controller.answerData!.penyakitPenyertaList,
                                controller,
                                "Penyakit penyerta yang diderita anak",
                                "penyerta"),
                            _buildMultipleCheckbox(
                                controller.answerData!.penyakitKomplikasiList,
                                controller,
                                "Riwayat penyakit komplikasi kehamilan Ibu",
                                "komplikasi"),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  backgroundColor:
                                      AppColors.green[500]?.withOpacity(0.6),
                                  minimumSize: const Size(160.0, 60.0),
                                ),
                                onPressed: () => controller.updateAnakSakit(
                                    context, keluargaId!),
                                child: controller.onSubmitting!
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        "Update",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: const OperatorNavbar(currentIndex: 1),
    );
  }

  Widget _buildTextField(
    String key,
    String label,
    String headLabel,
    IconData icon,
    TextInputType type,
    AnakSakitController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headLabel, style: const TextStyle(fontSize: 16.0)),
        const SizedBox(
          height: 10.0,
        ),
        TextFormField(
          key: Key(key),
          initialValue: key == "namaAnak"
              ? controller.answerData!.namaAnak
              : key == "beratBadan"
                  ? controller.answerData!.beratBadan.toString()
                  : key == "tinggiBadan"
                      ? controller.answerData!.tinggiBadan.toString()
                      : "",
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
              borderSide:
                  const BorderSide(color: Color(0xFF12d516), width: 2.0),
            ),
          ),
          validator: (value) => value == "" ? 'Wajib terisi' : null,
          onChanged: (value) => {controller.inputHandleChange(key, value)},
        ),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  Widget _buildDropdownButton(String key, String label, String headLabel,
      List<dynamic> items, AnakSakitController controller) {
    dynamic initialValue = items.firstWhere((item) =>
        item['value'] == controller.dropdownInitialValue(key))['label'];
    setState(() {
      _dropdownControllers[key]!.value = initialValue;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headLabel, style: const TextStyle(fontSize: 16.0)),
        const SizedBox(
          height: 10.0,
        ),
        CustomDropdown(
            key: Key(key),
            controller: _dropdownControllers[key],
            decoration: CustomDropdownDecoration(
                closedBorder: Border.all(color: Colors.black54, width: 1.0)),
            hintText: "Pilih $label",
            items: items.map((item) => item!['label']).toList(),
            onChanged: (dynamic selected) {
              var selectedValue = items
                  .firstWhere((item) => item['label'] == selected)['value'];
              controller.dropdownHandleChange(key, selectedValue);
              if (mounted) {
                setState(() {
                  _dropdownControllers[key]!.value = selected;
                });
              }
            }),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }

  Widget _buildMultipleCheckbox(List<dynamic> penyakit,
      AnakSakitController controller, String label, String target) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16.0)),
        const SizedBox(
          height: 10.0,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: penyakit.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                CheckboxListTile(
                  activeColor: AppColors.green[600],
                  tileColor: penyakit[index]['selected']
                      ? AppColors.green[100]?.withOpacity(0.6)
                      : null,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  title: Text(penyakit[index]['nama_penyakit']),
                  value: penyakit[index]['selected'],
                  onChanged: (bool? value) {
                    controller.multiCheckboxHandleChange(target, value, index);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                )
              ],
            );
          },
        ),
        const SizedBox(
          height: 30.0,
        )
      ],
    );
  }
}
