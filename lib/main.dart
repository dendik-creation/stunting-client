import 'package:client/components/push_snackbar.dart';
import 'package:client/controllers/anak_sakit_controller.dart';
import 'package:client/controllers/keluarga_login_controller.dart';
import 'package:client/controllers/kemandirian_controller.dart';
import 'package:client/controllers/kesehatan_lingkungan_controller.dart';
import 'package:client/controllers/operator_home_controller.dart';
import 'package:client/controllers/operator_login_controller.dart';
import 'package:client/controllers/screening_test_result_controller.dart';
import 'package:client/views/anak_sakit_view.dart';
import 'package:client/views/buku_saku_detail_view.dart';
import 'package:client/views/buku_saku_list_view.dart';
import 'package:client/views/edit_anak_sakit_view.dart';
import 'package:client/views/edit_keluarga_view.dart';
import 'package:client/views/home_operator_view.dart';
import 'package:client/views/home_view.dart';
import 'package:client/views/keluarga_login_view.dart';
import 'package:client/views/keluarga_profile_view.dart';
import 'package:client/views/kesehatan_lingkungan_view.dart';
import 'package:client/views/login_operator_view.dart';
import 'package:client/views/onboarding_view.dart';
import 'package:client/views/operator_approval_view.dart';
import 'package:client/views/operator_keluarga_detail_view.dart';
import 'package:client/views/operator_keluarga_list_view.dart';
import 'package:client/views/register_view.dart';
import 'package:client/views/result_anak_sakit_view.dart';
import 'package:client/views/result_test_detail_view.dart';
import 'package:client/views/result_test_list_view.dart';
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
        ChangeNotifierProvider(create: (_) => ScreeningTestResultController()),
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
      navigatorKey: PushSnackbar.navigatorKey,
      theme: ThemeData(fontFamily: 'Nunito Sans'),
      debugShowCheckedModeBanner: false,
      title: "Family Care Stunting",
      home: SplashView(),
      routes: {
        // All
        '/onboarding': (context) => const OnboardingView(),
        '/register': (context) => const RegisterView(),
        '/result-test-list': (context) => const ResultTestListView(),
        '/result-test-detail': (context) => const ResultTestDetailView(),
        '/result-anak-sakit': (context) => const ResultAnakSakitView(),

        // Keluarga
        '/login-keluarga': (context) => const KeluargaLoginView(),
        '/home-keluarga': (context) => const HomeView(),
        '/profile-keluarga': (context) => const KeluargaProfileView(),
        '/test-list': (context) => const TestListView(),
        '/test-kemandirian': (context) => const TestKemandirianView(),
        '/test-anak-sakit': (context) => const AnakSakitView(),
        '/test-kesehatan-lingkungan': (context) =>
            const KesehatanLingkunganView(),
        '/buku-saku': (context) => const BukuSakuListView(),
        '/buku-saku-detail': (context) => const BukuSakuDetailView(),

        // Operator
        '/login-operator': (context) => const LoginOperatorView(),
        '/home-operator': (context) => const HomeOperatorView(),
        '/operator-keluarga-list': (context) =>
            const OperatorKeluargaListView(),
        '/operator-keluarga-detail': (context) =>
            const OperatorKeluargaDetailView(),
        '/operator-approval': (context) => const OperatorApprovalView(),
        '/edit-anak-sakit': (context) => const EditAnakSakitView(),
        '/edit-data-keluarga': (context) => const EditKeluargaView(),
      },
    );
  }
}
