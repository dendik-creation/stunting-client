import 'package:client/models/buku_saku_model.dart';

class BukuSakuController {
  final List<BukuSakuModel> dataList = [
    BukuSakuModel(
        slug: "si1", title: "Stunting", assetFile: 'assets/pdf/example.pdf'),
    BukuSakuModel(
        slug: "si2", title: "Stunting", assetFile: 'assets/pdf/example.pdf'),
    BukuSakuModel(
        slug: "si3", title: "Stunting", assetFile: 'assets/pdf/example.pdf'),
  ];

  BukuSakuModel? findOneBySlug(String slug) {
    return dataList.firstWhere((element) => element.slug == slug,
        orElse: () => BukuSakuModel(slug: "", title: "", assetFile: ""));
  }
}
