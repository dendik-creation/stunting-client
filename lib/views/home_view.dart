import 'dart:developer';

import 'package:client/components/custom_navbar.dart';
import 'package:client/models/home_models.dart';
import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool approved = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60.0,
        leadingWidth: 60.0,
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
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
              //
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            greeting(),
            const SizedBox(height: 24.0),
            Column(
              children: [],
            )
          ],
        ),
      )),
      bottomNavigationBar: const CustomNavigationBar(currentIndex: 0),
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
      const Text('15 Juli 2024',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
      const SizedBox(height: 15),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        screeningItem(ScreeningItem(
            icon: Icons.bar_chart_rounded,
            title: 'Tingkat 2',
            description: 'Tingkat Kemandirian',
            color: AppColors.green[600])),
        const SizedBox(width: 15.0),
        screeningItem(ScreeningItem(
            icon: Icons.thermostat_rounded,
            title: 'Sehat (365 poin)',
            description: 'Kesehatan Lingkungan',
            color: Colors.blue[600])),
      ]),
    ]);
  }

  Expanded screeningItem(ScreeningItem item) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 165.0,
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

  InkWell firstScreening() {
    return InkWell(
      onTap: () {
        //
      },
      splashColor: AppColors.green[300],
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        width: double.infinity,
        height: 135.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: AppColors.green[200]?.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.track_changes_rounded,
                      color: AppColors.green[600], size: 64.0),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Ayo tes screening pertama Anda!",
                    style: TextStyle(
                        color: AppColors.green[800],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                ],
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
        height: 135.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: Colors.blue[200]?.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.menu_book_rounded,
                      color: Colors.blue[600], size: 64.0),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Tambah wawasan mengenai stunting Anda",
                    style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                ],
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

  Container notYetApproved() {
    return Container(
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

  Container greeting() {
    return Container(
      width: double.infinity,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Halo,',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          Text(
            "Dendi' Setiawan  👋",
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
