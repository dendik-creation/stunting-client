import 'dart:async';

import 'package:client/components/custom_alert.dart';
import 'package:client/components/custom_navbar.dart';
import 'package:client/components/operator_navbar.dart';
import 'package:client/controllers/screening_test_result_controller.dart';
import 'package:client/models/screening_test_result_model.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultTestListView extends StatefulWidget {
  const ResultTestListView({super.key});

  @override
  State<ResultTestListView> createState() => _KeluargaResultTestListViewState();
}

class _KeluargaResultTestListViewState extends State<ResultTestListView> {
  bool isFirst = true;

  void getInitial(int? keluargaId) {
    if (keluargaId != null) {
      Provider.of<ScreeningTestResultController>(context, listen: false)
          .getTestListByOperator(keluargaId);
    } else {
      Provider.of<ScreeningTestResultController>(context, listen: false)
          .getTestListByKeluarga();
    }
  }

  void goDetailTest(
      int keluargaId, int step, ScreeningTestResultController controller) {
    Timer(const Duration(milliseconds: 750), () {
      Navigator.of(context).pushNamed('/result-test-detail', arguments: {
        'keluargaId': keluargaId,
        'step': step,
        'isOperator': controller.isOperatorAction
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final int? keluargaId = ModalRoute.of(context)!.settings.arguments as int?;
    if (isFirst) {
      getInitial(keluargaId);
      setState(() {
        isFirst = false;
      });
    }
    final controller = Provider.of<ScreeningTestResultController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: controller.testList == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.track_changes_rounded,
                          size: 84.0,
                          color: AppColors.green[500],
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Hasil Tes Screening",
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        keluargaName(controller),
                        const SizedBox(height: 30.0),
                        if (controller.testList!.screeningTest.length >= 2)
                          _buildResult(
                              controller.testList!.screeningTest, controller),
                        const SizedBox(height: 15.0),
                        _buildTestList(controller),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: controller.testList == null
          ? null
          : controller.isOperatorAction
              ? const OperatorNavbar(currentIndex: 1)
              : const PopScope(
                  canPop: false, child: CustomNavigationBar(currentIndex: 2)),
    );
  }

  CustomAlert _buildResult(
      List<TestListData> testList, ScreeningTestResultController controller) {
    // Latest test sort
    if (int.parse(testList[0].tingkatKemandirian.tingkatan) >
        int.parse(testList[1].tingkatKemandirian.tingkatan)) {
      return CustomAlert(
        title:
            "${controller.isOperatorAction ? 'Keluarga ini' : 'Anda'} mengalami peningkatan dari tes sebelumnya. Dengan ini tes  berhasil dan berakhir.",
      );
    } else if (int.parse(testList[1].tingkatKemandirian.tingkatan) ==
        int.parse(testList[0].tingkatKemandirian.tingkatan)) {
      return CustomAlert(
        color: Colors.red[600],
        title:
            "${controller.isOperatorAction ? 'Keluarga ini' : 'Anda'} tidak mengalami peningkatan dari tes sebelumnya. Dengan ini tes berakhir.",
      );
    } else {
      return CustomAlert(
        color: Colors.red[600],
        title:
            "Sayang sekali ${controller.isOperatorAction ? 'Keluarga ini' : 'Anda'} tidak mengalami peningkatan bahkan menurun dari tes sebelumnya. Dengan ini tes berakhir",
      );
    }
  }

  Text keluargaName(ScreeningTestResultController controller) {
    return Text(
      "Keluarga ${controller.isOperatorAction ? controller.testList!.keluarga!.namaLengkap : controller.keluargaAuth['nama_lengkap']}",
      style: const TextStyle(fontSize: 18.0),
    );
  }

  Widget _buildTestList(ScreeningTestResultController controller) {
    final testList = controller.testList?.screeningTest;
    if (testList == null || testList.isEmpty) {
      return const Text(
        'Tidak ada hasil tes',
        textAlign: TextAlign.start,
      );
    }
    return Column(
      children:
          testList.map((test) => _buildTestItem(controller, test)).toList(),
    );
  }

  Widget _buildTestItem(
      ScreeningTestResultController controller, TestListData test) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white,
          splashColor: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onTap: () {
            if (controller.isOperatorAction) {
              goDetailTest(
                  controller.testList!.keluarga!.id, test.step, controller);
            } else {
              goDetailTest(
                  controller.keluargaAuth['id'], test.step, controller);
            }
          },
          contentPadding: const EdgeInsets.all(0.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hasil Tes Ke-${test.step.toString()}",
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    controller.parseToIdDate(test.tanggal),
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      // Tingkat Kemandirian
                      child: Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: AppColors.green[600],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.leaderboard_rounded,
                              color: Colors.white,
                              size: 64.0,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              controller.parseTingkatan(
                                  test.tingkatKemandirian.tingkatan),
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
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    // Kesehatan Lingkungan
                    if (test.kesehatanLingkungan != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.blue[600],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.health_and_safety_rounded,
                                color: Colors.white,
                                size: 64.0,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                controller.showKesehatan(
                                    test.kesehatanLingkungan!.isHealthy,
                                    test.kesehatanLingkungan!.nilaiTotal
                                        .toString()),
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
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26.0)
      ],
    );
  }
}
