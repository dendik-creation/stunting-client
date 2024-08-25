class ApprovalRequest {
  final int id;
  final String nik;
  final String namaLengkap;
  final String alamat;
  final String desa;
  final String rt;
  final String rw;
  final String noTelp;
  final int isApproved;
  final int isFreeStunting;
  final String puskesmasId;
  final Puskesmas puskesmas;

  ApprovalRequest({
    required this.id,
    required this.nik,
    required this.namaLengkap,
    required this.alamat,
    required this.desa,
    required this.rt,
    required this.rw,
    required this.noTelp,
    required this.isApproved,
    required this.isFreeStunting,
    required this.puskesmasId,
    required this.puskesmas,
  });

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) {
    return ApprovalRequest(
      id: json['id'],
      nik: json['nik'],
      namaLengkap: json['nama_lengkap'],
      alamat: json['alamat'],
      desa: json['desa'],
      rt: json['rt'],
      rw: json['rw'],
      noTelp: json['no_telp'],
      isApproved: json['is_approved'],
      isFreeStunting: json['is_free_stunting'],
      puskesmasId: json['puskesmas_id'],
      puskesmas: Puskesmas.fromJson(json['puskesmas']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nik': nik,
      'nama_lengkap': namaLengkap,
      'alamat': alamat,
      'desa': desa,
      'rt': rt,
      'rw': rw,
      'no_telp': noTelp,
      'is_approved': isApproved,
      'is_free_stunting': isFreeStunting,
      'puskesmas_id': puskesmasId,
      'puskesmas': puskesmas.toJson(),
    };
  }
}

class Puskesmas {
  final int id;
  final String namaPuskesmas;
  final String alamat;

  Puskesmas({
    required this.id,
    required this.namaPuskesmas,
    required this.alamat,
  });

  factory Puskesmas.fromJson(Map<String, dynamic> json) {
    return Puskesmas(
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
