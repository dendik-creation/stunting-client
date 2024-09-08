class BukuSakuModel {
  final String slug;
  final String title;
  final String assetFile;
  final String? networkFile;

  BukuSakuModel({
    required this.slug,
    required this.title,
    required this.assetFile,
    this.networkFile,
  });
}
