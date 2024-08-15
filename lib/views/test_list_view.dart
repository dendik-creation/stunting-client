import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class TestListView extends StatefulWidget {
  const TestListView({super.key});

  @override
  State<TestListView> createState() => _TestListViewState();
}

class _TestListViewState extends State<TestListView> {
  List<String> tests = [
    'Tes Kriteria Kemandirian Keluarga',
    'Entri Data Anak yang Sakit',
    'Tes Kesehatan Lingkungan'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  'Ada 3 Form yang akan Anda jalani : ',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 10.0),
                Column(
                  children: List.generate(
                      tests.length,
                      (int index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20.0),
                              Text(
                                '${index + 1}.',
                                style: const TextStyle(fontSize: 20.0),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                tests[index],
                                style: const TextStyle(fontSize: 20.0),
                              ),
                            ],
                          )),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Harap jawaban yang diberikan adalah benar dan sesuai.',
                  style: TextStyle(fontSize: 18.0),
                  softWrap: true,
                ),
              ],
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
