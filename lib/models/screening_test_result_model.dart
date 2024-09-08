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

class Keluarga {
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
  final int? puskesmasId;
  final Puskesmas puskesmas;

  Keluarga({
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
    this.puskesmasId,
    required this.puskesmas,
  });

  factory Keluarga.fromJson(Map<String, dynamic> json) {
    return Keluarga(
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

class TingkatKemandirian {
  final int id;
  final String tingkatan;
  final int step;
  final String tanggal;
  final int keluargaId;
  final List<JawabanKriteriaKemandirian>? jawabanKemandirian;

  TingkatKemandirian({
    required this.id,
    required this.tingkatan,
    required this.step,
    required this.tanggal,
    required this.keluargaId,
    required this.jawabanKemandirian,
  });

  factory TingkatKemandirian.fromJson(Map<String, dynamic> json) {
    return TingkatKemandirian(
      id: json['id'],
      tingkatan: json['tingkatan'],
      step: json['step'],
      tanggal: json['tanggal'],
      keluargaId: json['keluarga_id'],
      jawabanKemandirian: json['jawaban_kriteria_kemandirian'] != null
          ? List<JawabanKriteriaKemandirian>.from(
              json['jawaban_kriteria_kemandirian']
                  .map((item) => JawabanKriteriaKemandirian.fromJson(item)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tingkatan': tingkatan,
      'step': step,
      'tanggal': tanggal,
      'keluarga_id': keluargaId,
      'jawaban_kriteria_kemandirian':
          jawabanKemandirian?.map((item) => item.toJson()).toList(),
    };
  }
}

class KesehatanLingkungan {
  final int id;
  final int keluargaId;
  final int nilaiTotal;
  final String tanggal;
  final int step;
  final int isHealthy;
  final int? bobot;
  final List<JawabanKriteriaKesehatan>? jawabanKesehatan;

  KesehatanLingkungan({
    required this.id,
    required this.keluargaId,
    required this.nilaiTotal,
    required this.tanggal,
    required this.step,
    required this.isHealthy,
    required this.bobot,
    required this.jawabanKesehatan,
  });

  factory KesehatanLingkungan.fromJson(Map<String, dynamic> json) {
    return KesehatanLingkungan(
      id: json['id'],
      keluargaId: json['keluarga_id'],
      nilaiTotal: json['nilai_total'],
      tanggal: json['tanggal'],
      step: json['step'],
      isHealthy: json['is_healthy'],
      bobot: json['bobot'],
      jawabanKesehatan: json['jawaban_kriteria_kesehatan'] != null
          ? List<JawabanKriteriaKesehatan>.from(
              json['jawaban_kriteria_kesehatan']
                  .map((item) => JawabanKriteriaKesehatan.fromJson(item)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keluarga_id': keluargaId,
      'nilai_total': nilaiTotal,
      'tanggal': tanggal,
      'step': step,
      'is_healthy': isHealthy,
      'bobot': bobot,
      'jawaban_kriteria_kesehatan':
          jawabanKesehatan?.map((item) => item.toJson()).toList(),
    };
  }
}

class TestListData {
  final int step;
  final String tanggal;
  final TingkatKemandirian tingkatKemandirian;
  final KesehatanLingkungan? kesehatanLingkungan;

  TestListData({
    required this.step,
    required this.tanggal,
    required this.tingkatKemandirian,
    this.kesehatanLingkungan,
  });

  factory TestListData.fromJson(Map<String, dynamic> json) {
    return TestListData(
      step: json['step'],
      tanggal: json['tanggal'],
      tingkatKemandirian:
          TingkatKemandirian.fromJson(json['tingkat_kemandirian']),
      kesehatanLingkungan: json['kesehatan_lingkungan'] != null
          ? KesehatanLingkungan.fromJson(json['kesehatan_lingkungan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'tanggal': tanggal,
      'tingkat_kemandirian': tingkatKemandirian.toJson(),
      'kesehatan_lingkungan': kesehatanLingkungan?.toJson(),
    };
  }
}

class ScreeningTestList {
  final Keluarga? keluarga;
  final List<TestListData> screeningTest;

  ScreeningTestList({
    this.keluarga,
    required this.screeningTest,
  });

  factory ScreeningTestList.fromJson(Map<String, dynamic> json) {
    return ScreeningTestList(
      keluarga:
          json['keluarga'] != null ? Keluarga.fromJson(json['keluarga']) : null,
      screeningTest: List<TestListData>.from(
          json['screening_test'].map((test) => TestListData.fromJson(test))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keluarga': keluarga?.toJson(),
      'screening_test': screeningTest.map((test) => test.toJson()).toList(),
    };
  }
}

class JawabanKriteriaKemandirian {
  final int id;
  final int tingkatKemandirianId;
  final int kriteriaKemandirianId;
  final int keluargaId;
  final KriteriaKemandirian kriteriaKemandirian;

  JawabanKriteriaKemandirian({
    required this.id,
    required this.tingkatKemandirianId,
    required this.kriteriaKemandirianId,
    required this.keluargaId,
    required this.kriteriaKemandirian,
  });

  factory JawabanKriteriaKemandirian.fromJson(Map<String, dynamic> json) {
    return JawabanKriteriaKemandirian(
      id: json['id'],
      tingkatKemandirianId: json['tingkat_kemandirian_id'],
      kriteriaKemandirianId: json['kriteria_kemandirian_id'],
      keluargaId: json['keluarga_id'],
      kriteriaKemandirian:
          KriteriaKemandirian.fromJson(json['kriteria_kemandirian']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tingkat_kemandirian_id': tingkatKemandirianId,
      'kriteria_kemandirian_id': kriteriaKemandirianId,
      'keluarga_id': keluargaId,
      'kriteria_kemandirian': kriteriaKemandirian.toJson(),
    };
  }
}

class KriteriaKemandirian {
  final int id;
  final String pertanyaan;

  KriteriaKemandirian({
    required this.id,
    required this.pertanyaan,
  });

  factory KriteriaKemandirian.fromJson(Map<String, dynamic> json) {
    return KriteriaKemandirian(
      id: json['id'],
      pertanyaan: json['pertanyaan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pertanyaan': pertanyaan,
    };
  }
}

class JawabanKriteriaKesehatan {
  final int id;
  final int komponenKesehatanId;
  final int kriteriaKesehatanId;
  final int kesehatanLingkunganId;
  final KriteriaKesehatan kriteriaKesehatan;
  final KomponenKesehatan komponenKesehatan;

  JawabanKriteriaKesehatan({
    required this.id,
    required this.komponenKesehatanId,
    required this.kriteriaKesehatanId,
    required this.kesehatanLingkunganId,
    required this.kriteriaKesehatan,
    required this.komponenKesehatan,
  });

  factory JawabanKriteriaKesehatan.fromJson(Map<String, dynamic> json) {
    return JawabanKriteriaKesehatan(
      id: json['id'],
      komponenKesehatanId: json['komponen_kesehatan_id'],
      kriteriaKesehatanId: json['kriteria_kesehatan_id'],
      kesehatanLingkunganId: json['kesehatan_lingkungan_id'],
      kriteriaKesehatan: KriteriaKesehatan.fromJson(json['kriteria_kesehatan']),
      komponenKesehatan: KomponenKesehatan.fromJson(json['komponen_kesehatan']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'komponen_kesehatan_id': komponenKesehatanId,
      'kriteria_kesehatan_id': kriteriaKesehatanId,
      'kesehatan_lingkungan_id': kesehatanLingkunganId,
      'kriteria_kesehatan': kriteriaKesehatan.toJson(),
      'komponen_kesehatan': komponenKesehatan.toJson(),
    };
  }
}

class KriteriaKesehatan {
  final int id;
  final String kriteria;
  final int nilai;

  KriteriaKesehatan({
    required this.id,
    required this.kriteria,
    required this.nilai,
  });

  factory KriteriaKesehatan.fromJson(Map<String, dynamic> json) {
    return KriteriaKesehatan(
      id: json['id'],
      kriteria: json['kriteria'],
      nilai: json['nilai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kriteria': kriteria,
      'nilai': nilai,
    };
  }
}

class KomponenKesehatan {
  final int id;
  final String namaKomponen;

  KomponenKesehatan({
    required this.id,
    required this.namaKomponen,
  });

  factory KomponenKesehatan.fromJson(Map<String, dynamic> json) {
    return KomponenKesehatan(
      id: json['id'],
      namaKomponen: json['nama_komponen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_komponen': namaKomponen,
    };
  }
}

class TestDetailData {
  final TingkatKemandirian tingkatKemandirian;
  final KesehatanLingkungan? kesehatanLingkungan;

  TestDetailData({
    required this.tingkatKemandirian,
    this.kesehatanLingkungan,
  });

  factory TestDetailData.fromJson(Map<String, dynamic> json) {
    return TestDetailData(
      tingkatKemandirian:
          TingkatKemandirian.fromJson(json['tingkat_kemandirian']),
      kesehatanLingkungan: json['kesehatan_lingkungan'] != null
          ? KesehatanLingkungan.fromJson(json['kesehatan_lingkungan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tingkat_kemandirian': tingkatKemandirian.toJson(),
      if (kesehatanLingkungan != null)
        'kesehatan_lingkungan': kesehatanLingkungan?.toJson(),
    };
  }
}

class ScreeningTestDetail {
  final Keluarga? keluarga;
  final TestDetailData screeningTest;

  ScreeningTestDetail({
    this.keluarga,
    required this.screeningTest,
  });

  factory ScreeningTestDetail.fromJson(Map<String, dynamic> json) {
    return ScreeningTestDetail(
      keluarga:
          json['keluarga'] != null ? Keluarga.fromJson(json['keluarga']) : null,
      screeningTest: TestDetailData.fromJson(json['screening_test']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'keluarga': keluarga?.toJson(),
      'screening_test': screeningTest.toJson(),
    };
  }
}
