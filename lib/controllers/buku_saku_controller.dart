import 'package:client/models/buku_saku_model.dart';

class BukuSakuController {
  final List<BukuSakuModel> dataList = [
    BukuSakuModel(
        slug: "saku1",
        title: "Apa itu Family Care Stunting",
        assetFile: 'assets/pdf/1.pdf'),
    BukuSakuModel(
        slug: "saku2",
        title: "Penyakit Penyerta dan Komplikasi pada Stunting",
        assetFile: 'assets/pdf/2.pdf'),
    BukuSakuModel(
        slug: "saku3",
        title: "Penanganan Stunting Untuk Penderita Tuberculossis",
        assetFile: 'assets/pdf/3.pdf'),
    BukuSakuModel(
        slug: "saku4",
        title: "Penanganan Stunting Untuk Penderita Pneumoni Darah",
        assetFile: 'assets/pdf/4.pdf'),
    BukuSakuModel(
        slug: "saku5",
        title: "Penanganan Stunting Untuk Penderita ISPA",
        assetFile: 'assets/pdf/5.pdf'),
    BukuSakuModel(
        slug: "saku6",
        title: "Penanganan Stunting Untuk Penderita Diare",
        assetFile: 'assets/pdf/6.pdf'),
    BukuSakuModel(
        slug: "saku7",
        title: "Penanganan Stunting Untuk Penderita HIV",
        assetFile: 'assets/pdf/7.pdf'),
    BukuSakuModel(
        slug: "saku8",
        title: "Kontrol Gizi pada Anak Stunting Usia 1-5 Tahun",
        assetFile: 'assets/pdf/8.pdf'),
    BukuSakuModel(
        slug: "saku9",
        title: "Stimulasi Tumbuh Kembang Anak Stunting Usia 1-5 tahun",
        assetFile: 'assets/pdf/9.pdf'),
    BukuSakuModel(
        slug: "saku10",
        title: "Sanitasi Lingkungan Sehat Bebas Stunting",
        assetFile: 'assets/pdf/10.pdf'),
    BukuSakuModel(
        slug: "saku11",
        title: "Jenis PMT Bagi Anak Stunting Usia 1-5 Tahun",
        assetFile: 'assets/pdf/11.pdf'),
  ];

  BukuSakuModel? findOneBySlug(String slug) {
    return dataList.firstWhere((element) => element.slug == slug,
        orElse: () => BukuSakuModel(slug: "", title: "", assetFile: ""));
  }
}
