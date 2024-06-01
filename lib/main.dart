import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../config/theme/app_theme.dart';
import '../pages/auth/reset_pass_page.dart';
import '../pages/auth/sign_in_page.dart';
import '../pages/main_page.dart';
import '../pages/report/add_report_page.dart';
import '../firebase_options.dart';
import 'pages/auth/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  String? pid = prefs.getString('pid');
  var initPage = pid == null ? '/signin_page' : '/';

  runApp(MainApp(initPage: initPage));
}

class MainApp extends StatelessWidget {
  final String initPage;
  const MainApp({super.key, required this.initPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      initialRoute: initPage,
      routes: {
        '/': (_) => const MainPage(),
        '/signin_page': (_) => const SignInPage(),
        '/signup_page': (_) => const SignUpPage(),
        '/add_report': (_) => const AddReportPage(),
        '/resetpass_page': (_) => const ResetPassPage(),
      },
    );
  }
}
