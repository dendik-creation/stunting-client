// ignore_for_file: use_build_context_synchronously

import 'package:client/utils/auth_user.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashController {
  void hasUserAuth(BuildContext context) async {
    final keluargaAuth = await AuthUser.getData('keluarga_auth');
    final operatorAuth = await AuthUser.getData('operator_auth');

    if (keluargaAuth != null) {
      keluargaHome(context);
    } else if (operatorAuth != null) {
      operatorHome(context);
    } else {
      goOnboarding(context);
    }
  }

  void goOnboarding(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  void keluargaHome(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home-keluarga');
    });
  }

  void operatorHome(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home-operator');
    });
  }
}
