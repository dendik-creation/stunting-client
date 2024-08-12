class RegisterModel {
  final String nik;
  final String namaLengkap;
  final String desa;
  final String rt;
  final String rw;
  final String noTelepon;
  final String alamatLengkap;
  final String puskesmasTerdekat;

  RegisterModel({
    required this.nik,
    required this.namaLengkap,
    required this.desa,
    required this.rt,
    required this.rw,
    required this.noTelepon,
    required this.alamatLengkap,
    required this.puskesmasTerdekat,
  });

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'nama_lengkap': namaLengkap,
      'desa': desa,
      'rt': rt,
      'rw': rw,
      'no_telp': noTelepon,
      'alamat': alamatLengkap,
      'puskesmas_id': puskesmasTerdekat,
    };
  }
}

class PuskesmasModel {
  final int id;
  final String namaPuskesmas;
  final String alamat;

  PuskesmasModel({
    required this.id,
    required this.namaPuskesmas,
    required this.alamat,
  });

  factory PuskesmasModel.fromJson(Map<String, dynamic> json) {
    return PuskesmasModel(
      id: json['id'],
      namaPuskesmas: json['nama_puskesmas'],
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_puskesmas': namaPuskesmas,
      'alamat': alamat,
    };
  }
}
