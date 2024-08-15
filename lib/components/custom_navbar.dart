import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavigationBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home-keluarga');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/anak-sakit');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/buku-saku');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      fixedColor: Colors.white,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      backgroundColor: Colors.white,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        navbarItem(Icons.home_filled, 'Beranda'),
        navbarItem(Icons.sick_rounded, 'Anak Sakit'),
        navbarItem(Icons.menu_book_rounded, 'Buku Saku'),
      ],
    );
  }

  BottomNavigationBarItem navbarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 28.0,
          color: AppColors.green[400],
        ),
      ),
      activeIcon: Container(
        decoration: BoxDecoration(
          color: Colors.green[600],
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 28.0,
            color: Colors.white,
          ),
        ),
      ),
      label: label,
      tooltip: label,
    );
  }
}