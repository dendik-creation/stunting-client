import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class PushSnackbar {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static void liveSnackbar(String text, SnackbarType type) {
    final context = navigatorKey.currentState!.overlay!.context;
    AnimatedSnackBar.material(text,
            type: _getSnackBarType(type),
            animationCurve: Curves.easeInOutCirc,
            duration: const Duration(seconds: 4),
            mobileSnackBarPosition: MobileSnackBarPosition.top,
            mobilePositionSettings: const MobilePositionSettings(
                topOnAppearance: 60.0, topOnDissapear: -100.0))
        .show(context);
  }

  static AnimatedSnackBarType _getSnackBarType(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return AnimatedSnackBarType.success;
      case SnackbarType.error:
        return AnimatedSnackBarType.error;
      case SnackbarType.warning:
        return AnimatedSnackBarType.warning;
      case SnackbarType.info:
        return AnimatedSnackBarType.info;
    }
  }
}
