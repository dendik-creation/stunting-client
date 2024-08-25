import 'package:client/components/custom_alert.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:client/controllers/kemandirian_controller.dart';
import 'package:provider/provider.dart';

class TestKemandirianView extends StatefulWidget {
  const TestKemandirianView({super.key});

  @override
  State<TestKemandirianView> createState() => _TestKemandirianViewState();
}

class _TestKemandirianViewState extends State<TestKemandirianView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KemandirianController>(context, listen: false)
          .fetchQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<KemandirianController>(context);

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
                'Tes Kriteria Kemandirian',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            )),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: controller.questions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomAlert(
                        title:
                            "Jawab pertanyaan dengan jawaban yang paling sesuai",
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        (controller.currentIndex + 1).toString(),
                        style: TextStyle(
                            fontSize: 65.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.green[700]),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        controller
                            .questions[controller.currentIndex].pertanyaan,
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RadioListTile<bool>(
                            value: true,
                            title: const Text('Ya'),
                            groupValue: controller.selectedOpt,
                            onChanged: controller.handleRadioValueChange,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            tileColor: AppColors.green[100],
                          ),
                          const SizedBox(height: 15.0),
                          RadioListTile<bool>(
                            title: const Text('Tidak'),
                            value: false,
                            groupValue: controller.selectedOpt,
                            onChanged: controller.handleRadioValueChange,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            tileColor: Colors.red[100],
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: controller.questions.isEmpty
            ? const Text("")
            : Container(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF12d516),
                  ),
                  onPressed: () => controller.onSubmitting!
                      ? null
                      : controller.nextQuestion(context),
                  child: controller.onSubmitting!
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Selanjutnya",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              ),
      ),
    );
  }
}
