import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:client/components/custom_alert.dart';
import 'package:client/components/custom_navbar.dart';
import 'package:client/controllers/home_controller.dart';
import 'package:client/models/home_model.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = false;
  String nextRouteIfNotComplete = "";
  dynamic keluargaAuth;
  final _controller = HomeController();

  void keluargaLogout() {
    _controller.pushLogout(context, 'keluarga_auth');
  }

  void getNextTest() async {
    final nextTest = await _controller.whatNextTest();
    setState(() {
      nextRouteIfNotComplete = nextTest;
    });
    return;
  }

  Future<void> getKeluarga() async {
    setState(() {
      isLoading = true;
    });

    final data = await _controller.getCurrentKeluarga();

    setState(() {
      keluargaAuth = data;
      isLoading = false;
    });

    getNextTest();
  }

  @override
  void initState() {
    super.initState();
    getKeluarga();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 60.0,
          leadingWidth: 60.0,
          backgroundColor: Colors.white,
          leading: Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: CircleAvatar(
              child: Image.asset(
                'assets/images/global/avatar.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 24.0),
              icon: Icon(
                Icons.logout_outlined,
                color: AppColors.green[600],
              ),
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.bottomSlide,
                  title: 'Konfirmasi Logout',
                  desc: 'Apakah Anda yakin ingin logout?',
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    keluargaLogout();
                  },
                  btnOkColor: AppColors.green[600],
                ).show();
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator.adaptive(
                backgroundColor: AppColors.green[100],
                color: AppColors.green[600],
                onRefresh: () async {
                  Timer(const Duration(milliseconds: 1000), () {
                    getKeluarga();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      greeting(),
                      const SizedBox(height: 24.0),
                      if (keluargaAuth?['is_approved'] == 0)
                        notYetApproved()
                      else
                        Column(
                          children: [
                            if (keluargaAuth?['screening_test']?['test_result']
                                    ?['tingkat_kemandirian'] ==
                                null)
                              testCTA(
                                  step: keluargaAuth?['screening_test']
                                      ?['current_step'])
                            else
                              latestScreening(),
                            const SizedBox(height: 24.0),
                            bukuSakuWdt(),
                          ],
                        )
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: const CustomNavigationBar(currentIndex: 0),
      ),
    );
  }

  Column latestScreening() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Screening Terakhir Anda',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
          GestureDetector(
              onTap: () {},
              child: Text(
                'Lihat Semua',
                style: TextStyle(
                    fontSize: 14.0,
                    color: AppColors.green[600],
                    fontWeight: FontWeight.w600),
              ))
        ],
      ),
      const SizedBox(height: 5.0),
      if (keluargaAuth?['screening_test']?['test_result']
              ?['tingkat_kemandirian'] !=
          null)
        Text(
            _controller.parseToIdDate(keluargaAuth?['screening_test']
                ?['test_result']?['tingkat_kemandirian']?['tanggal']),
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
      const SizedBox(height: 15),
      testStatus(keluargaAuth?['screening_test']?['is_complete']?['status']),
      const SizedBox(height: 15),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (keluargaAuth?['screening_test']?['current_test_status']
                    ?['tingkat_kemandirian'] ==
                true)
              screeningItem(ScreeningItem(
                icon: Icons.leaderboard_rounded,
                title: _controller.parseTingkatan(
                    keluargaAuth?['screening_test']?['test_result']
                        ?['tingkat_kemandirian']?['tingkatan']),
                description: 'Tingkat Kemandirian',
                color: AppColors.green[600],
              )),
            if (keluargaAuth?['screening_test']?['current_test_status']
                    ?['kesehatan_lingkungan'] ==
                true)
              const SizedBox(width: 15.0),
            if (keluargaAuth?['screening_test']?['current_test_status']
                    ?['kesehatan_lingkungan'] ==
                true)
              screeningItem(ScreeningItem(
                icon: Icons.health_and_safety_rounded,
                title: _controller.showKesehatan(
                    keluargaAuth?['screening_test']?['test_result']
                        ['kesehatan_lingkungan']['is_healthy'],
                    keluargaAuth!['screening_test']!['test_result']![
                            'kesehatan_lingkungan']!['nilai_total']
                        .toString()),
                description: 'Kesehatan Lingkungan',
                color: Colors.blue[600],
              )),
          ],
        ),
      ),
    ]);
  }

  CustomAlert testStatus(bool status) {
    if (status == true) {
      return CustomAlert(
        title:
            "Tes Berikutnya pada ${_controller.parseToIdDate(keluargaAuth?['screening_test']?['is_complete']?['next_test'])}",
      );
    } else {
      return CustomAlert(
          title: "Ada tes yang belum diselesaikan",
          routeUrl: nextRouteIfNotComplete);
    }
  }

  Expanded screeningItem(ScreeningItem item) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                color: Colors.white,
                size: 64.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                item.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell testCTA({int? step}) {
    return InkWell(
      onTap: () {
        Timer(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushNamed('/test-list');
        });
      },
      splashColor: AppColors.green[300],
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: AppColors.green[200]?.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.track_changes_rounded,
                        color: AppColors.green[600], size: 64.0),
                    const SizedBox(
                      height: 10.0,
                    ),
                    if (step == 0 || step == 1)
                      Text(
                        "Ayo tes screening pertama Anda",
                        style: TextStyle(
                            color: AppColors.green[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      )
                    else
                      Text(
                        "Ayo tes screening ke-$step Anda",
                        style: TextStyle(
                            color: AppColors.green[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.green[800],
                size: 32.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell bukuSakuWdt() {
    return InkWell(
      onTap: () {
        //
      },
      splashColor: Colors.blue[300],
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: Colors.blue[200]?.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Colors.blue[600],
                      size: 64.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Tambah wawasan Anda mengenai stunting",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.blue[800],
                size: 32.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox notYetApproved() {
    return SizedBox(
      width: double.infinity,
      height: 165.0,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: AppColors.green[600],
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.hourglass_bottom_rounded,
                    color: Colors.white, size: 64.0),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Data keluarga Anda dalam tahap verifikasi petugas",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )),
    );
  }

  SizedBox greeting() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Halo,',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            '${_controller.separateName(keluargaAuth?['nama_lengkap'])}  👋',
            style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
