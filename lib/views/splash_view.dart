import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  final SplashController _controller = SplashController();

  SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    _controller.goOnboarding(context);

    return const Scaffold(
      body: Center(
        child: Text(
          'Icon App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
