import 'dart:async';
import 'dart:developer';

import 'package:client/utils/auth_user.dart';
import 'package:flutter/material.dart';

import '../models/onboarding_model.dart';

class OnboardingController {
  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      title: 'Family Care Stunting',
      description: 'Solusi untuk mencegah stunting pada keluarga Indonesia.',
      image: 'assets/images/onboarding/1.png',
    ),
    OnboardingModel(
      title: 'Lindungi Anak Anda',
      description:
          'Pantau dan analisa kondisi anak Anda dengan cepat dan akurat.',
      image: 'assets/images/onboarding/2.png',
    ),
    OnboardingModel(
      title: 'Bersama Cegah Stunting',
      description:
          'Kenali stunting dan pencegahannya dengan puluhan materi yang telah kami sediakan.',
      image: 'assets/images/onboarding/3.png',
    ),
  ];

  void goLoginOrHome(BuildContext context) async {
    dynamic hasKeluargaData = await KeluargaAuth.getData();
    Timer(const Duration(seconds: 2), () {
      // WALIK
      if (hasKeluargaData != null) {
        Navigator.of(context).pushReplacementNamed('/login-keluarga');
      } else {
        Navigator.of(context).pushReplacementNamed('/home-keluarga');
      }
    });
  }
}
