import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class OperatorNavbar extends StatefulWidget {
  final int currentIndex;

  const OperatorNavbar({super.key, required this.currentIndex});

  @override
  State<OperatorNavbar> createState() => _OperatorNavbarState();
}

class _OperatorNavbarState extends State<OperatorNavbar>
    with TickerProviderStateMixin {
  late int _currentIndex;
  List<String> tabList = ['Beranda', 'Data Keluarga'];
  List<IconData> tabIcons = [
    Icons.home,
    Icons.family_restroom_rounded,
  ];
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
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/home-operator');
        break;
      case 1:
        Navigator.of(context).pushNamed('/operator-keluarga-list');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      labels: tabList,
      controller: _motionTabBarController,
      initialSelectedTab: tabList[_currentIndex],
      icons: tabIcons,
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
