class PertanyaanKemandirian {
  final int id;
  final String pertanyaan;

  PertanyaanKemandirian({required this.id, required this.pertanyaan});

  factory PertanyaanKemandirian.fromJson(Map<String, dynamic> json) {
    return PertanyaanKemandirian(
      id: json['id'],
      pertanyaan: json['pertanyaan'],
    );
  }
}
