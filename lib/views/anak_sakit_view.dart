import 'package:client/components/custom_alert.dart';
import 'package:client/controllers/anak_sakit_controller.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:provider/provider.dart';

class AnakSakitView extends StatefulWidget {
  const AnakSakitView({super.key});

  @override
  State<AnakSakitView> createState() => _AnakSakitViewState();
}

class _AnakSakitViewState extends State<AnakSakitView> {
  final Map<String, SingleSelectController<dynamic>> _dropdownControllers = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnakSakitController>(context, listen: false)
          .fetchPenyakitList();
    });
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

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AnakSakitController>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Entri Data Anak Sakit',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: controller.penyakitList == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAlert(
                        title:
                            "Data digunakan sebagai pendukung berjalannya tes screening ini",
                      ),
                      const SizedBox(height: 30.0),
                      if (controller.currentIndex == 0) quest0(controller),
                      if (controller.currentIndex == 1) quest1(controller),
                      if (controller.currentIndex == 2) quest2(controller),
                      if (controller.currentIndex == 3)
                        quest3(controller.answerData!.penyakitPenyertaList,
                            controller),
                      if (controller.currentIndex == 4)
                        quest4(controller.answerData!.penyakitKomplikasiList,
                            controller),
                    ],
                  ),
                ),
        )),
        bottomNavigationBar: controller.penyakitList == null
            ? const SizedBox.shrink()
            : Container(
                height: 60,
                color: Colors.white,
                width: double.infinity,
                margin: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor: Colors.red[300],
                          minimumSize: const Size(160.0, 60.0),
                        ),
                        onPressed: () {
                          if (!controller.onSubmitting!) {
                            controller.changeQuestion("back");
                          }
                        },
                        child: const Text(
                          "Kembali",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          backgroundColor:
                              AppColors.green[500]?.withOpacity(0.6),
                          minimumSize: const Size(160.0, 60.0),
                        ),
                        onPressed: () {
                          if (!controller.onSubmitting!) {
                            if (controller.currentIndex ==
                                controller.maxIndex) {
                              controller.storeAnakSakit(context);
                            } else {
                              controller.changeQuestion('next');
                            }
                          }
                        },
                        child: controller.onSubmitting!
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                controller.currentIndex == controller.maxIndex
                                    ? "Submit"
                                    : "Berikutnya",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
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
                  .firstWhere((item) => item['label'] == selected)!['value'];
              controller.dropdownHandleChange(key, selectedValue);
              if (mounted == true) {
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

  Widget _buildMultipleCheckbox(dynamic penyakit,
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

  Column quest0(AnakSakitController controller) => Column(
        children: [
          _buildTextField("namaAnak", "Nama", "Siapa nama anak Anda",
              Icons.child_care_rounded, TextInputType.text, controller),
          _buildDropdownButton(
              "usia",
              "Usia",
              "Berapa usianya",
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
              "Jenis kelamin anak Anda",
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
        ],
      );

  Column quest1(AnakSakitController controller) => Column(
        children: [
          _buildTextField(
              "tinggiBadan",
              "Tinggi badan",
              "Berapa tinggi badan anak Anda (cm)",
              Icons.height_rounded,
              TextInputType.number,
              controller),
          _buildTextField(
              "beratBadan",
              "Berat badan",
              "Berapa berat badan anak Anda (kg)",
              Icons.line_weight_rounded,
              TextInputType.number,
              controller),
          _buildDropdownButton(
              "riwayatLahirAnak",
              "Riwayat kelahiran",
              "Bagaimana riwayat berat badan ketika lahir",
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
        ],
      );

  Column quest2(AnakSakitController controller) => Column(
        children: [
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
              "Apa pendidikan terakhir Ibu",
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
        ],
      );

  Column quest3(dynamic listPenyerta, AnakSakitController controller) =>
      Column(children: [
        _buildMultipleCheckbox(listPenyerta, controller,
            "Penyakit penyerta yang diderita anak Anda", "penyerta")
      ]);

  Column quest4(dynamic listKomplikasi, AnakSakitController controller) =>
      Column(children: [
        _buildMultipleCheckbox(listKomplikasi, controller,
            "Riwayat penyakit komplikasi kehamilan Ibu", "komplikasi")
      ]);
}
