import 'package:attendance_front/includes/login.dart';
import 'package:attendance_front/includes/splash.dart';
import 'package:flutter/material.dart';

import 'includes/homepage.dart';

// ignore: camel_case_types
class genRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case 'home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case 'login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
