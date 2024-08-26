
import 'package:client/components/custom_alert.dart';
import 'package:client/controllers/anak_sakit_controller.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnakSakitView extends StatefulWidget {
  const AnakSakitView({super.key});

  @override
  State<AnakSakitView> createState() => _AnakSakitViewState();
}

class _AnakSakitViewState extends State<AnakSakitView> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnakSakitController>(context, listen: false)
          .fetchPenyakitList();
    });
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
              : Form(
                  key: _formKey,
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
            ? const Text("")
            : Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.all(40.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Colors.red[300],
                        foregroundColor: Colors.transparent,
                        minimumSize: const Size(160.0, 60.0),
                      ),
                      onPressed: () {
                        if (controller.onSubmitting == false) {
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: AppColors.green[500]?.withOpacity(0.6),
                        foregroundColor: Colors.transparent,
                        minimumSize: const Size(160.0, 60.0),
                      ),
                      onPressed: () {
                        if (!controller.onSubmitting!) {
                          if (controller.currentIndex == controller.maxIndex) {
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
                                  : "Selanjutnya",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ],
                )),
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
      List<DropdownMenuItem<dynamic>> items, AnakSakitController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headLabel, style: const TextStyle(fontSize: 16.0)),
        const SizedBox(
          height: 10.0,
        ),
        DropdownButtonFormField<dynamic>(
          key: Key(key),
          value: key == "usia" && controller.answerData!.usia != ""
              ? controller.answerData!.usia
              : key == "jenisKelamin" &&
                      controller.answerData!.jenisKelamin != ""
                  ? controller.answerData!.jenisKelamin
                  : key == "ibuBekerja" &&
                          controller.answerData!.ibuBekerja != null
                      ? controller.answerData!.ibuBekerja
                      : key == "pendidikanIbu" &&
                              controller.answerData!.pendidikanIbu != ""
                          ? controller.answerData!.pendidikanIbu
                          : key == "riwayatLahirAnak" &&
                                  controller.answerData!.riwayatLahirAnak != ""
                              ? controller.answerData!.riwayatLahirAnak
                              : key == "orangTuaMerokok" &&
                                      controller.answerData!.orangTuaMerokok !=
                                          null
                                  ? controller.answerData!.orangTuaMerokok
                                  : null,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 14.0),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color(0xFF12d516), width: 2.0),
            ),
          ),
          items: items.isEmpty ? [] : items.toList(),
          validator: (value) => value == null ? 'Wajib terisi' : null,
          onChanged: (dynamic value) {
            controller.dropdownHandleChange(key, value);
          },
        ),
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

  Expanded quest0(AnakSakitController controller) => Expanded(
          child: Column(
        children: [
          _buildTextField("namaAnak", "Nama", "Siapa nama anak Anda",
              Icons.child_care_rounded, TextInputType.text, controller),
          _buildDropdownButton(
              "usia",
              "Usia",
              "Berapa usianya",
              [
                const DropdownMenuItem(
                  value: "1-23",
                  child: Text("1 - 23 Bulan"),
                ),
                const DropdownMenuItem(
                  value: "24-36",
                  child: Text("24 - 36 Bulan"),
                ),
                const DropdownMenuItem(
                  value: "37-48",
                  child: Text("37 - 48 Bulan"),
                ),
                const DropdownMenuItem(
                  value: "49-60",
                  child: Text("49 - 60 Bulan"),
                ),
              ],
              controller),
          _buildDropdownButton(
              "jenisKelamin",
              "Jenis kelamin",
              "Jenis kelamin anak Anda",
              [
                const DropdownMenuItem(
                  value: "L",
                  child: Text("Laki-laki"),
                ),
                const DropdownMenuItem(
                  value: "P",
                  child: Text("Perempuan"),
                ),
              ],
              controller),
        ],
      ));

  Expanded quest1(AnakSakitController controller) => Expanded(
          child: Column(
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
                const DropdownMenuItem(
                  value: "normal",
                  child: Text("Normal (lebih dari 2,5 kg)"),
                ),
                const DropdownMenuItem(
                  value: "rendah",
                  child: Text("Rendah (kurang dari 2,5 kg)"),
                ),
              ],
              controller),
        ],
      ));

  Expanded quest2(AnakSakitController controller) => Expanded(
          child: Column(
        children: [
          _buildDropdownButton(
              "ibuBekerja",
              "Ibu bekerja",
              "Apakah Ibu bekerja",
              [
                const DropdownMenuItem(
                  value: true,
                  child: Text("Ya"),
                ),
                const DropdownMenuItem(
                  value: false,
                  child: Text("Tidak"),
                ),
              ],
              controller),
          _buildDropdownButton(
              "pendidikanIbu",
              "Pendidikan Ibu",
              "Apa pendidikan terakhir Ibu",
              [
                const DropdownMenuItem(
                  value: "SMP",
                  child: Text("SMP"),
                ),
                const DropdownMenuItem(
                  value: "SMA",
                  child: Text("SMA"),
                ),
                const DropdownMenuItem(
                  value: "Sarjana",
                  child: Text("Sarjana"),
                ),
              ],
              controller),
          _buildDropdownButton(
              "orangTuaMerokok",
              "Orang tua merokok",
              "Apakah orang tua merokok",
              [
                const DropdownMenuItem(
                  value: true,
                  child: Text("Ya"),
                ),
                const DropdownMenuItem(
                  value: false,
                  child: Text("Tidak"),
                ),
              ],
              controller),
        ],
      ));

  Expanded quest3(dynamic listPenyerta, AnakSakitController controller) =>
      Expanded(
          child: Column(children: [
        _buildMultipleCheckbox(listPenyerta, controller,
            "Penyakit penyerta yang diderita anak Anda", "penyerta")
      ]));

  Expanded quest4(dynamic listKomplikasi, AnakSakitController controller) =>
      Expanded(
          child: Column(children: [
        _buildMultipleCheckbox(listKomplikasi, controller,
            "Riwayat penyakit komplikasi kehamilan Ibu", "komplikasi")
      ]));
}
