import 'dart:developer';

import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class KeluargaProfileView extends StatelessWidget {
  const KeluargaProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic keluarga = ModalRoute.of(context)!.settings.arguments;
    log(keluarga.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    size: 84.0,
                    color: AppColors.green[500],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "Profil Keluarga Anda",
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  buildIdentity(keluarga),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildIdentity(dynamic keluarga) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildField('NIK', keluarga['nik']),
        buildField('Nama Lengkap', keluarga['nama_lengkap']),
        buildField('No. Telepon', keluarga['no_telp']),
        buildField('Desa',
            "${keluarga['desa']} - RT ${keluarga['rt']} / RW ${keluarga['rw']}"),
        buildField('Alamat Lengkap', keluarga['alamat']),
        buildField(
            'Puskesmas Pengampu', keluarga['puskesmas']['nama_puskesmas']),
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
}
