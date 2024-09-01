import 'dart:convert';

import 'package:client/components/custom_navbar.dart';
import 'package:client/components/operator_navbar.dart';
import 'package:client/controllers/anak_sakit_controller.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ResultAnakSakitView extends StatefulWidget {
  const ResultAnakSakitView({super.key});

  @override
  State<ResultAnakSakitView> createState() => _ResultAnakSakitViewState();
}

class _ResultAnakSakitViewState extends State<ResultAnakSakitView> {
  bool isFirst = true;
  bool onLoading = false;

  void getInitial(int? keluargaId, AnakSakitController controller) async {
    setState(() {
      onLoading = true;
    });
    await controller.getAnakSakit(keluargaId, false);
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
    return PopScope(
      canPop: keluargaId != null ? true : false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: onLoading
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
                            Icons.child_care_rounded,
                            size: 84.0,
                            color: AppColors.green[500],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Data anak sakit keluarga ${keluargaId == null ? 'Anda' : ''}",
                            style: const TextStyle(
                                fontSize: 32.0, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          if (keluargaId != null)
                            buildTile(
                                Icons.edit_note_rounded,
                                Colors.blue[600],
                                "Edit data anak sakit",
                                "/edit-anak-sakit",
                                keluargaId),
                          const SizedBox(
                            height: 20.0,
                          ),
                          buildIdentity(controller.anakSakitResult),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: keluargaId == null
            ? const CustomNavigationBar(currentIndex: 1)
            : const OperatorNavbar(currentIndex: 1),
      ),
    );
  }

  Card buildTile(
      IconData icon, Color? color, String text, String url, int? keluargaId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      borderOnForeground: false,
      shadowColor: Colors.transparent,
      child: ListTile(
        tileColor: color?.withOpacity(0.8),
        splashColor: color?.withOpacity(0.9),
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
          Navigator.pushNamed(context, url, arguments: keluargaId);
        },
      ),
    );
  }

  Column buildIdentity(dynamic anakSakitResult) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildField('Nama lengkap', anakSakitResult['nama_anak'], 'string'),
        buildField('Usia', "${anakSakitResult['usia']} Bulan", 'string'),
        buildField('Jenis kelamin', anakSakitResult['jenis_kelamin'], 'string'),
        buildField('Berat badan (Kg)', anakSakitResult['berat_badan'], 'int'),
        buildField('Tinggi badan (Cm)', anakSakitResult['tinggi_badan'], 'int'),
        buildField(
            'Riwayat berat badan ketika lahir',
            anakSakitResult['berat_lahir'] == 'normal'
                ? 'Normal (lebih dari 2,5 kg)'
                : 'Rendah (kurang dari 2,5 kg)',
            'string'),
        buildField(
            'Status Ibu bekerja', anakSakitResult['ibu_bekerja'], 'bool'),
        buildField('Pendidikan terakhir Ibu', anakSakitResult['pendidikan_ibu'],
            'string'),
        buildField('Status orang tua merokok',
            anakSakitResult['orang_tua_merokok'], 'bool'),
        buildList('Penyakit penyerta', anakSakitResult['penyakit_penyerta']),
        buildList('Penyakit komplikasi kehamilan Ibu',
            anakSakitResult['penyakit_komplikasi']),
      ],
    );
  }

  Column buildField(String fieldName, dynamic content, String type) {
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
        if (type == 'string')
          Text(
            content,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          )
        else if (type == 'int')
          Text(
            content.toString(),
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          )
        else if (type == 'bool')
          Text(
            content == 1 ? 'Ya' : 'Tidak',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Column buildList(String fieldName, List<dynamic> penyakit) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: penyakit
              .map((item) => Text(
                    "• ${item['penyakit']['nama_penyakit']}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ))
              .toList()),
      const SizedBox(
        height: 15.0,
      ),
    ]);
  }
}
