import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatelessWidget {
  final SplashController _controller = SplashController();

  SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    _controller.hasUserAuth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset('assets/images/icon/splash_icon.png',
                width: 256, height: 256),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "v ${Constants.appVersion}",
                  style: const TextStyle(fontSize: 15.0),
                )),
          )
        ],
      ),
    );
  }
}
