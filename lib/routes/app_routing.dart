import 'package:flutter/material.dart';
import '../models/agen_vaLorant.dart';
import '../pages/splash_screen_page.dart';
import '../pages/home_page.dart';
import '../pages/karakter_page.dart';
import '../pages/detail_page.dart';
import '../pages/about_page.dart';

class AppRouting {
  static const String initialRoute = '/';
  static const String home = '/home';
  static const String karakter = '/karakter';
  static const String detail = '/detail';
  static const String about = '/about';

  static Map<String, WidgetBuilder> get routes => {
        initialRoute: (context) => const SplashScreenPage(),
        home: (context) => const HomePage(),
        karakter: (context) => const KarakterPage(),
        detail: (context) {
          final agent =
              ModalRoute.of(context)?.settings.arguments as Datum?;
          return DetailPage(agent: agent);
        },
        about: (context) => const AboutPage(),
      };
}
