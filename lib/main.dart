import 'package:client/controllers/kemandirian_controller.dart';
import 'package:client/views/home_view.dart';
import 'package:client/views/onboarding_view.dart';
import 'package:client/views/register_view.dart';
import 'package:client/views/splash_view.dart';
import 'package:client/views/test_kemandirian_view.dart';
import 'package:client/views/test_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KemandirianController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Nunito Sans'),
      debugShowCheckedModeBanner: false,
      title: "Family Care Stunting",
      home: SplashView(),
      routes: {
        '/onboarding': (context) => const OnboardingView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/test-list': (context) => const TestListView(),
        '/test-kemandirian': (context) => const TestKemandirianView(),
      },
    );
  }
}
