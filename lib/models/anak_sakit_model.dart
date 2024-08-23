class PenyakitList {
  final List<Penyerta> penyertaList;
  final List<Komplikasi> komplikasiList;

  PenyakitList({
    required this.penyertaList,
    required this.komplikasiList,
  });

  factory PenyakitList.fromJson(Map<String, dynamic> json) {
    return PenyakitList(
      penyertaList: List<Penyerta>.from(
        json['penyerta'].map((x) => Penyerta.fromJson(x)),
      ),
      komplikasiList: List<Komplikasi>.from(
        json['komplikasi'].map((x) => Komplikasi.fromJson(x)),
      ),
    );
  }
}

class Penyerta {
  final int id;
  bool selected;
  final String namaPenyakit;
  final String jenisPenyakit;

  Penyerta({
    required this.id,
    required this.namaPenyakit,
    required this.selected,
    required this.jenisPenyakit,
  });

  factory Penyerta.fromJson(Map<String, dynamic> json) {
    return Penyerta(
      id: json['id'],
      selected: json['selected'],
      namaPenyakit: json['nama_penyakit'],
      jenisPenyakit: json['jenis_penyakit'],
    );
  }
}

class Komplikasi {
  final int id;
  bool selected;
  final String namaPenyakit;
  final String jenisPenyakit;

  Komplikasi({
    required this.id,
    required this.namaPenyakit,
    required this.selected,
    required this.jenisPenyakit,
  });

  factory Komplikasi.fromJson(Map<String, dynamic> json) {
    return Komplikasi(
      id: json['id'],
      selected: json['selected'],
      namaPenyakit: json['nama_penyakit'],
      jenisPenyakit: json['jenis_penyakit'],
    );
  }
}

class AnakSakitModel {
  String namaAnak;
  String usia;
  dynamic jenisKelamin;
  dynamic tinggiBadan;
  dynamic beratBadan;
  dynamic penyakitPenyertaList;
  dynamic ibuBekerja;
  dynamic pendidikanIbu;
  dynamic riwayatLahirAnak;
  dynamic penyakitKomplikasiList;
  dynamic orangTuaMerokok;

  AnakSakitModel({
    required this.namaAnak,
    required this.usia,
    required this.jenisKelamin,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.penyakitPenyertaList,
    required this.ibuBekerja,
    required this.pendidikanIbu,
    required this.riwayatLahirAnak,
    required this.penyakitKomplikasiList,
    required this.orangTuaMerokok,
  });

  factory AnakSakitModel.fromJson(Map<String, dynamic> json) {
    return AnakSakitModel(
      namaAnak: json['nama_anak'],
      usia: json['usia'],
      jenisKelamin: json['jenis_kelamin'],
      tinggiBadan: json['tinggi_badan'],
      beratBadan: json['berat_badan'],
      penyakitPenyertaList: json['penyakit_penyerta'],
      ibuBekerja: json['ibu_bekerja'],
      pendidikanIbu: json['pendidikan_ibu'],
      riwayatLahirAnak: json['riwayat_lahir_anak'],
      penyakitKomplikasiList: json['penyakit_komplikasi'],
      orangTuaMerokok: json['orang_tua_merokok'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_anak': namaAnak,
      'usia': usia,
      'jenis_kelamin': jenisKelamin,
      'tinggi_badan': tinggiBadan,
      'berat_badan': beratBadan,
      'penyakit_penyerta': penyakitPenyertaList,
      'ibu_bekerja': ibuBekerja,
      'pendidikan_ibu': pendidikanIbu,
      'riwayat_lahir_anak': riwayatLahirAnak,
      'penyakit_komplikasi': penyakitKomplikasiList,
      'orang_tua_merokok': orangTuaMerokok,
    };
  }
}
