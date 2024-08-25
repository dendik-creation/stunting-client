import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class OperatorNavbar extends StatelessWidget {
  final int currentIndex;

  const OperatorNavbar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home-operator');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/keluarga-list');
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
        itemCornerRadius: 10.0,
        borderRadius: const BorderRadius.all(Radius.circular(18.0)),
        shadowColor: Colors.transparent,
        containerHeight: 60.0,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: Colors.transparent,
        onItemSelected: (index) => _onItemTapped(context, index),
        items: [
          navbarItem(Icons.home, 'Beranda'),
          navbarItem(Icons.family_restroom_rounded, 'Keluarga'),
        ],
      ),
    );
  }

  BottomNavyBarItem navbarItem(IconData icon, String label) {
    return BottomNavyBarItem(
      icon: Icon(
        icon,
        size: 32.0,
      ),
      title: Container(
          margin: const EdgeInsets.only(left: 12.0), child: Text(label)),
      activeColor: AppColors.green[700]!,
      inactiveColor: AppColors.green[400]!,
    );
  }
}
