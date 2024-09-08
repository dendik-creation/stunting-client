import 'package:client/components/custom_navbar.dart';
import 'package:client/components/operator_navbar.dart';
import 'package:client/controllers/screening_test_result_controller.dart';
import 'package:client/models/screening_test_result_model.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultTestDetailView extends StatefulWidget {
  const ResultTestDetailView({super.key});

  @override
  State<ResultTestDetailView> createState() => _ResultTestDetailViewState();
}

class _ResultTestDetailViewState extends State<ResultTestDetailView> {
  bool isFirst = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = 0;
    });
  }

  void getInitial(int keluargaId, int step, bool isOperator) {
    if (isOperator) {
      Provider.of<ScreeningTestResultController>(context, listen: false)
          .getTestDetailByOperator(keluargaId, step);
    } else {
      Provider.of<ScreeningTestResultController>(context, listen: false)
          .getTestDetailByKeluarga(step);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ScreeningTestResultController>(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final keluargaId = args['keluargaId'] as int;
    final step = args['step'] as int;
    final isOperator = args['isOperator'] as bool;

    if (isFirst) {
      getInitial(keluargaId, step, isOperator);
      setState(() {
        isFirst = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: controller.testDetail == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: PageView(
                      onPageChanged: (int index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          margin: const EdgeInsets.only(top: 30.0),
                          child: detailKemandirian(controller, step),
                        ),
                        if (controller.testDetail!.screeningTest
                                .kesehatanLingkungan !=
                            null)
                          Container(
                            padding: const EdgeInsets.all(24.0),
                            margin: const EdgeInsets.only(top: 30.0),
                            child: detailKesehatan(controller, step),
                          ),
                      ],
                    ),
                  ),
                  if (controller
                          .testDetail!.screeningTest.tingkatKemandirian.step <
                      2)
                    _buildDot(2),
                ],
              ),
      ),
      bottomNavigationBar: controller.testList == null
          ? null
          : controller.isOperatorAction
              ? const OperatorNavbar(currentIndex: 1)
              : const CustomNavigationBar(currentIndex: 2),
    );
  }

  Container _buildDot(int contentLength) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          contentLength,
          (index) => AnimatedContainer(
            height: 10.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(right: 10.0),
            width: currentIndex == index ? 40.0 : 10.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: index == 0 ? AppColors.green[600] : Colors.blue[600],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView detailKemandirian(
      ScreeningTestResultController controller, int step) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.leaderboard_rounded,
            size: 84.0,
            color: AppColors.green[500],
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Hasil Tingkat Kemandirian",
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            "Tes ke-${step.toString()} | Keluarga ${controller.isOperatorAction ? controller.testList!.keluarga!.namaLengkap : controller.keluargaAuth['nama_lengkap']}",
            style: const TextStyle(fontSize: 18.0),
          ),
          _heroBanner(controller,
              tingkatKemandirian:
                  controller.testDetail!.screeningTest.tingkatKemandirian),
          Text(
            "${controller.testDetail!.screeningTest.tingkatKemandirian.jawabanKemandirian!.length.toString()} / 7",
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
          const Text(
            "Pertanyaan berhasil diselesaikan",
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 30.0),
          const Text(
            "Hasil Tes",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10.0),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.testDetail!.screeningTest.tingkatKemandirian
                .jawabanKemandirian!.length,
            itemBuilder: (context, index) {
              return _kemandirianTestResult(
                controller.testDetail!.screeningTest.tingkatKemandirian
                    .jawabanKemandirian![index],
                index,
              );
            },
          ),
        ],
      ),
    );
  }

  SingleChildScrollView detailKesehatan(
      ScreeningTestResultController controller, int step) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.health_and_safety_rounded,
            size: 84.0,
            color: Colors.blue[500],
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Hasil Kesehatan Lingkungan",
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            "Tes ke-${step.toString()} | Keluarga ${controller.isOperatorAction ? controller.testList!.keluarga!.namaLengkap : controller.keluargaAuth['nama_lengkap']}",
            style: const TextStyle(fontSize: 18.0),
          ),
          _heroBanner(controller,
              kesehatanLingkungan:
                  controller.testDetail!.screeningTest.kesehatanLingkungan),
          const SizedBox(height: 20.0),
          const Text(
            "Hasil Tes",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10.0),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.testDetail!.screeningTest.kesehatanLingkungan!
                .jawabanKesehatan!.length,
            itemBuilder: (context, index) {
              return _kesehatanLingkunganResult(
                controller.testDetail!.screeningTest.kesehatanLingkungan!
                    .jawabanKesehatan![index],
                index,
              );
            },
          ),
          const SizedBox(height: 20.0),
          _calculateKesehatanLingkungan(
              controller.testDetail!.screeningTest.kesehatanLingkungan),
        ],
      ),
    );
  }

  Column _calculateKesehatanLingkungan(
      KesehatanLingkungan? kesehatanLingkungan) {
    int acumulateNilai = kesehatanLingkungan!.jawabanKesehatan!
        .map((item) => item.kriteriaKesehatan.nilai)
        .fold(0, (a, b) => a + b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kalkulasi Poin Akhir",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10.0),
        Text(
          "Total poin x ${kesehatanLingkungan.bobot.toString()} (bobot nilai)",
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          "= ${acumulateNilai.toString()} x 25",
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          "= ${kesehatanLingkungan.nilaiTotal.toString()}",
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.blue[700],
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  _heroBanner(ScreeningTestResultController controller,
      {TingkatKemandirian? tingkatKemandirian,
      KesehatanLingkungan? kesehatanLingkungan}) {
    if (tingkatKemandirian != null && kesehatanLingkungan == null) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 30.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: AppColors.green[600],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              controller
                  .showIconKemandirian(int.parse(tingkatKemandirian.tingkatan)),
              color: Colors.white,
              size: 64.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              controller.parseTingkatan(tingkatKemandirian.tingkatan),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Tingkat Kemandirian",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 30.0),
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue[600],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              controller
                  .showIconKesehatanLingkungan(kesehatanLingkungan!.nilaiTotal),
              color: Colors.white,
              size: 64.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              controller.showKesehatan(kesehatanLingkungan.isHealthy,
                  kesehatanLingkungan.nilaiTotal.toString()),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              "Kesehatan Lingkungan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      );
    }
  }

  Container _kemandirianTestResult(
          JawabanKriteriaKemandirian answerQuestion, int index) =>
      Container(
        margin: const EdgeInsets.only(bottom: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kriteria ${(index + 1).toString()}",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green[700]),
            ),
            const SizedBox(height: 5.0),
            Text(
              "${answerQuestion.kriteriaKemandirian.pertanyaan} (Ya)",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );

  Container _kesehatanLingkunganResult(
          JawabanKriteriaKesehatan answerQuestion, int index) =>
      Container(
        margin: const EdgeInsets.only(bottom: 26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle_sharp,
                  size: 20.0,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 8.0),
                Text(
                  "${answerQuestion.kriteriaKesehatan.nilai.toString()} poin",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Text(
              "Bagaimana kondisi ${answerQuestion.komponenKesehatan.namaKomponen.toLowerCase()} Anda ?",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              answerQuestion.kriteriaKesehatan.kriteria,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      );
}
