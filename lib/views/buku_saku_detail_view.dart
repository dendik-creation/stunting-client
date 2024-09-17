import 'package:client/controllers/buku_saku_controller.dart';
import 'package:client/models/buku_saku_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BukuSakuDetailView extends StatefulWidget {
  const BukuSakuDetailView({super.key});

  @override
  State<BukuSakuDetailView> createState() => _BukuSakuDetailViewState();
}

class _BukuSakuDetailViewState extends State<BukuSakuDetailView> {
  final BukuSakuController controller = BukuSakuController();
  late BukuSakuModel? dataDetail;
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    final String? slug = ModalRoute.of(context)!.settings.arguments as String?;
    if (isFirst) {
      setState(() {
        dataDetail = controller.findOneBySlug(slug!);
        isFirst = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
          title: Text(
            dataDetail!.title,
            style: const TextStyle(fontSize: 18.0),
          )),
      body: SafeArea(
          child: isFirst
              ? const Center(child: CircularProgressIndicator())
              : SfPdfViewer.asset(
                  dataDetail!.assetFile,
                )),
    );
  }
}
