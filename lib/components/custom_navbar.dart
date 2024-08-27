import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavigationBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/home-keluarga');
        break;
      case 1:
        Navigator.of(context).pushNamed('/anak-sakit');
        break;
      case 2:
        Navigator.of(context).pushNamed('/buku-saku');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        iconSize: 24.0,
        itemCornerRadius: 10.0,
        borderRadius: const BorderRadius.all(Radius.circular(18.0)),
        shadowColor: Colors.transparent,
        containerHeight: 60.0,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: Colors.transparent,
        onItemSelected: (index) => _onItemTapped(context, index),
        items: [
          navbarItem(Icons.home, 'Beranda'),
          navbarItem(Icons.sick_rounded, 'Anak Sakit'),
          navbarItem(Icons.menu_book_rounded, 'Buku Saku'),
        ],
      ),
    );
  }

  BottomNavyBarItem navbarItem(IconData icon, String label) {
    return BottomNavyBarItem(
      icon: Icon(
        icon,
      ),
      title: Container(
          margin: const EdgeInsets.only(left: 12.0), child: Text(label)),
      activeColor: AppColors.green[700]!,
      inactiveColor: AppColors.green[400]!,
    );
  }
}
