import 'package:flutter/material.dart';
import 'dart:async';

class SplashController {
  void goOnboarding(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushNamed('/onboarding');
    });
  }
}
