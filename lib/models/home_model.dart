import 'package:flutter/material.dart';

class ScreeningItem {
  final IconData icon;
  final String title;
  final String description;
  final Color? color;

  ScreeningItem({
    required this.icon,
    required this.title,
    required this.description,
    this.color,
  });
}

class KeluargaData {
  final int id;
  final String nik;
  final String nama_lengkap;
  final String alamat;
  final String desa;
  final String rt;
  final String rw;
  final String no_telp;
  final String is_approved;
  final String is_free_stunting;
  final PuskesmasKeluargaData puskesmas;
  final dynamic latest_tingkat_kemandirian;
  final dynamic latest_kesehatan_lingkungan;

  KeluargaData({
    required this.id,
    required this.nik,
    required this.nama_lengkap,
    required this.alamat,
    required this.desa,
    required this.rt,
    required this.rw,
    required this.no_telp,
    required this.is_approved,
    required this.is_free_stunting,
    required this.puskesmas,
    required this.latest_tingkat_kemandirian,
    required this.latest_kesehatan_lingkungan,
  });
}

class PuskesmasKeluargaData {
  final int id;
  final String nama_puskesmas;
  final String alamat;

  PuskesmasKeluargaData({
    required this.id,
    required this.nama_puskesmas,
    required this.alamat,
  });
}
