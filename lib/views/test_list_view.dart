import 'package:client/utils/auth_user.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class TestListView extends StatefulWidget {
  const TestListView({super.key});

  @override
  State<TestListView> createState() => _TestListViewState();
}

class _TestListViewState extends State<TestListView> {
  List<String> tests = [];

  void generateList() async {
    var keluarga = await AuthUser.getData('keluarga_auth');
    if (await keluarga?['screening_test']['current_step'] > 1) {
      setState(() {
        tests = [
          'Tes kriteria kemandirian keluarga',
        ];
      });
    } else {
      setState(() {
        tests = [
          'Tes kriteria kemandirian keluarga',
          'Entri data anak yang sakit (pertama kali)',
          'Tes kesehatan lingkungan (sanitasi)',
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    generateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.track_changes_rounded,
                    color: AppColors.green[600],
                    size: 55.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Tes yang akan Anda ikuti',
                    style:
                        TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Ada ${tests.length.toString()} form tes yang akan Anda jalani : ",
                    style: const TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tests.isEmpty
                        ? []
                        : List.generate(
                            tests.length,
                            (int index) => Column(
                                  children: [
                                    Text(
                                      "${index + 1}. ${tests[index]}",
                                      style: const TextStyle(fontSize: 20.0),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(
                                      height: 6.0,
                                    )
                                  ],
                                )),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Harap jawaban yang diberikan adalah benar dan sesuai.',
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.all(40.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF12d516),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/test-kemandirian');
          },
          child: const Text(
            "Mulai Tes",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
