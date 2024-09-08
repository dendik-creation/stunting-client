import 'package:client/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final String _title;
  final String? _routeUrl;
  final Color? _color;

  const CustomAlert({
    super.key,
    required String title,
    String? routeUrl,
    Color? color,
  })  : _title = title,
        _routeUrl = routeUrl,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor:
          _color?.withOpacity(0.2) ?? AppColors.green[200]?.withOpacity(0.7),
      splashColor: _color?.withOpacity(0.8) ?? AppColors.green[400],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      leading: Icon(
        Icons.track_changes_rounded,
        color: _color ?? AppColors.green[600],
        size: 25.0,
      ),
      title: Text(
        _title,
        style: const TextStyle(fontSize: 14.0),
      ),
      trailing: _routeUrl == null
          ? null
          : Icon(
              Icons.chevron_right_rounded,
              color: _color?.withOpacity(0.5) ?? AppColors.green[700],
              size: 25.0,
            ),
      onTap: () {
        if (_routeUrl != null && _routeUrl != "#") {
          Navigator.of(context).pushReplacementNamed(_routeUrl);
        }
      },
    );
  }
}
