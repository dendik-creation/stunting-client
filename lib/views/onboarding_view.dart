// lib/views/onboarding_view.dart
import 'dart:async';

import 'package:flutter/material.dart';
import '../controllers/onboarding_controller.dart';
import '../models/onboarding_model.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  int operatorLoginAction = 1;
  final OnboardingController _onboardingController = OnboardingController();

  @override
  void initState() {
    setState(() {
      currentIndex = 0;
      operatorLoginAction = 1;
    });
    super.initState();
  }

  void _operatorAction() {
    if (operatorLoginAction >= 5) {
      Timer(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushNamed('/login-operator');
      });
    } else {
      setState(() {
        operatorLoginAction++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<OnboardingModel> contents =
        _onboardingController.onboardingPages;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _operatorAction,
                            child: Container(
                              margin: const EdgeInsets.only(top: 20.0),
                              child: Image.asset(
                                contents[index].image,
                                height: 400 /
                                    MediaQuery.textScalerOf(context).scale(1.2),
                                width: 400 /
                                    MediaQuery.textScalerOf(context).scale(1.2),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                contents[index].title,
                                textAlign: TextAlign.center,
                                textScaler: TextScaler.linear(
                                    MediaQuery.textScalerOf(context)
                                        .scale(1.0)),
                                style: const TextStyle(
                                    fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                contents[index].description,
                                textScaler: TextScaler.linear(
                                    MediaQuery.textScalerOf(context)
                                        .scale(1.0)),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            buildDot(contents.length),
            nextButton(contents.length)
          ],
        ),
      ),
    );
  }

  Container nextButton(int contentLength) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(40.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF12d516),
        ),
        onPressed: () {
          if (currentIndex == contentLength - 1) {
            Navigator.of(context).pushNamed('/login-keluarga');
          } else {
            _controller.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Text(
          currentIndex == contentLength - 1 ? "Mulai Sekarang" : "Berikutnya",
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Row buildDot(int contentLength) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        contentLength,
        (index) => Container(
          height: 10.0,
          margin: const EdgeInsets.only(right: 10.0),
          width: currentIndex == index ? 30.0 : 10.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF12d516),
          ),
        ),
      ),
    );
  }
}
