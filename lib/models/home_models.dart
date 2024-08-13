import 'package:flutter/material.dart';

class ScreeningItem {
  final IconData icon;
  final String title;
  final String description;
  final Color? color;

  ScreeningItem({
    required this.icon,
    required this.title,
    required this.description,
    this.color,
  });
}
