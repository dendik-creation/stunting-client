import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class CustomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const CustomNavigationBar({super.key, required this.currentIndex});

  @override
  // ignore: library_private_types_in_public_api
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar>
    with TickerProviderStateMixin {
  late int _currentIndex;
  List<String> tabList = ['Beranda', 'Anak Sakit', 'Hasil Tes', 'Buku Saku'];
  MotionTabBarController? _motionTabBarController;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: tabList.length,
      vsync: this,
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/home-keluarga');
        break;
      case 1:
        Navigator.of(context).pushNamed('/anak-sakit');
        break;
      case 2:
        Navigator.of(context).pushNamed('/result-test-list');
        break;
      case 3:
        Navigator.of(context).pushNamed('/buku-saku');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      labels: tabList,
      controller: _motionTabBarController,
      initialSelectedTab: tabList[_currentIndex],
      icons: const [
        Icons.home,
        Icons.sick_rounded,
        Icons.track_changes_rounded,
        Icons.menu_book_rounded
      ],
      tabIconColor: AppColors.green[500]!,
      tabSelectedColor: AppColors.green[600]!,
      textStyle: TextStyle(
        color: AppColors.green[600],
        fontWeight: FontWeight.bold,
      ),
      onTabItemSelected: (int index) {
        _onItemTapped(context, index);
        setState(() {
          _motionTabBarController!.index = index;
        });
      },
    );
  }
}
