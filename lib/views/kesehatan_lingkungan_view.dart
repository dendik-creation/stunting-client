import 'package:client/components/custom_alert.dart';
import 'package:client/controllers/kesehatan_lingkungan_controller.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KesehatanLingkunganView extends StatefulWidget {
  const KesehatanLingkunganView({super.key});

  @override
  State<KesehatanLingkunganView> createState() =>
      _KesehatanLingkunganViewState();
}

class _KesehatanLingkunganViewState extends State<KesehatanLingkunganView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KesehatanLingkunganController>(context, listen: false)
          .fetchQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<KesehatanLingkunganController>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Tes Kesehatan Lingkungan (Sanitasi)',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            )),
        backgroundColor: Colors.white,
        body: controller.questions.isEmpty
            ? const Center(
                // Pastikan menggunakan Center
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAlert(
                          title:
                              "Jawablah sesuai kondisi lingkungan Anda saat ini",
                        ),
                        const SizedBox(height: 30.0),
                        Text(
                          (controller.questionIndex + 1).toString(),
                          style: TextStyle(
                            fontSize: 65.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.green[700],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        questionText(controller
                            .questions[controller.questionIndex].namaKomponen),
                        const SizedBox(height: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: controller.questions.isEmpty
                              ? []
                              : _buildOption(controller),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        bottomNavigationBar: controller.questions.isNotEmpty
            ? _buildDirectionButton(controller)
            : null,
      ),
    );
  }

  Container _buildDirectionButton(KesehatanLingkunganController controller) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: Colors.red[300],
                  foregroundColor: Colors.transparent,
                  minimumSize: const Size(160.0, 60.0),
                ),
                onPressed: () => !controller.onSubmitting!
                    ? controller.handleChangeQuestion('back')
                    : null,
                child: const Text(
                  "Kembali",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: AppColors.green[500]?.withOpacity(0.6),
                  foregroundColor: Colors.transparent,
                  minimumSize: const Size(160.0, 60.0),
                ),
                onPressed: () {
                  if (!controller.onSubmitting!) {
                    if (controller.questionIndex ==
                        controller.questions.length - 1) {
                      controller.handleSubmit(context);
                    } else {
                      controller.handleChangeQuestion('next');
                    }
                  }
                },
                child: controller.onSubmitting!
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        controller.questionIndex ==
                                controller.questions.length - 1
                            ? "Submit"
                            : "Berikutnya",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOption(KesehatanLingkunganController controller) {
    final currentQuestion = controller.questions[controller.questionIndex];

    return currentQuestion.kriteriaKesehatan.map<Widget>((kriteria) {
      return Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        child: RadioListTile<int>(
          value: kriteria.id,
          title: Text(kriteria.kriteria),
          groupValue: controller.answers.firstWhere(
              (answer) => answer['komponen_kesehatan_id'] == currentQuestion.id,
              orElse: () => {})['kriteria_kesehatan_id'],
          onChanged: (value) {
            if (value != null) {
              controller.handleChangeAnswer({
                'komponen_kesehatan_id': currentQuestion.id,
                'kriteria_kesehatan_id': value,
              });
            }
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.black45, width: 0.8)),
          tileColor: kriteria.id ==
                  controller.answers[controller.questionIndex]
                      ['kriteria_kesehatan_id']
              ? AppColors.green[100]
              : Colors.transparent,
        ),
      );
    }).toList();
  }

  Text questionText(String question) {
    return Text(
      "Bagaimana kondisi ${question.toLowerCase()} Anda ?",
      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
    );
  }
}
