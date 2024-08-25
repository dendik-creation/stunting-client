class QuestionList {
  final int id;
  final String namaKomponen;
  final List<KriteriaKesehatan> kriteriaKesehatan;

  QuestionList({
    required this.id,
    required this.namaKomponen,
    required this.kriteriaKesehatan,
  });

  factory QuestionList.fromJson(Map<String, dynamic> json) {
    var list = json['kriteria_kesehatan'] as List;
    List<KriteriaKesehatan> kriteriaList =
        list.map((i) => KriteriaKesehatan.fromJson(i)).toList();

    return QuestionList(
      id: json['id'],
      namaKomponen: json['nama_komponen'],
      kriteriaKesehatan: kriteriaList,
    );
  }
}

class KriteriaKesehatan {
  final int id;
  final int komponenKesehatanId;
  final String kriteria;
  final int nilai;

  KriteriaKesehatan({
    required this.id,
    required this.komponenKesehatanId,
    required this.kriteria,
    required this.nilai,
  });

  factory KriteriaKesehatan.fromJson(Map<String, dynamic> json) {
    return KriteriaKesehatan(
      id: json['id'],
      komponenKesehatanId: json['komponen_kesehatan_id'],
      kriteria: json['kriteria'],
      nilai: json['nilai'],
    );
  }
}
