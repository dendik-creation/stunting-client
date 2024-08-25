import 'package:client/controllers/anak_sakit_controller.dart';
import 'package:client/controllers/keluarga_login_controller.dart';
import 'package:client/controllers/kemandirian_controller.dart';
import 'package:client/controllers/kesehatan_lingkungan_controller.dart';
import 'package:client/controllers/operator_home_controller.dart';
import 'package:client/controllers/operator_login_controller.dart';
import 'package:client/views/anak_sakit_view.dart';
import 'package:client/views/home_operator_view.dart';
import 'package:client/views/home_view.dart';
import 'package:client/views/keluarga_login_view.dart';
import 'package:client/views/kesehatan_lingkungan_view.dart';
import 'package:client/views/login_operator_view.dart';
import 'package:client/views/onboarding_view.dart';
import 'package:client/views/operator_approval_view.dart';
import 'package:client/views/register_view.dart';
import 'package:client/views/splash_view.dart';
import 'package:client/views/test_kemandirian_view.dart';
import 'package:client/views/test_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KemandirianController()),
        ChangeNotifierProvider(create: (_) => KeluargaLoginController()),
        ChangeNotifierProvider(create: (_) => OperatorLoginController()),
        ChangeNotifierProvider(create: (_) => OperatorHomeController()),
        ChangeNotifierProvider(create: (_) => AnakSakitController()),
        ChangeNotifierProvider(create: (_) => KesehatanLingkunganController()),
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
        '/login-keluarga': (context) => const KeluargaLoginView(),
        '/login-operator': (context) => const LoginOperatorView(),
        '/home-keluarga': (context) => const HomeView(),
        '/home-operator': (context) => const HomeOperatorView(),
        '/operator-approval': (context) => const OperatorApprovalView(),
        '/test-list': (context) => const TestListView(),
        '/test-kemandirian': (context) => const TestKemandirianView(),
        '/anak-sakit': (context) => const AnakSakitView(),
        '/kesehatan-lingkungan': (context) => const KesehatanLingkunganView(),
      },
    );
  }
}
