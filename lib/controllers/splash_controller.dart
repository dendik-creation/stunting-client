// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:client/utils/auth_user.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashController {
  void hasUserAuth(BuildContext context) async {
    final keluargaAuth = await AuthUser.getData('keluarga_auth');
    final userAuth = await AuthUser.getData('user_auth');

    if (keluargaAuth != null) {
      keluargaHome(context);
    } else if (userAuth != null) {
      userHome(context);
    } else {
      goOnboarding(context);
    }
  }

  void goOnboarding(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  void keluargaHome(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home-keluarga');
    });
  }

  void userHome(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home-user');
    });
  }
}
