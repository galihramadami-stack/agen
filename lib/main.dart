import 'package:flutter/material.dart';
import 'routes/app_routing.dart';

void main() {
  runApp(const ValorantApp());
}

class ValorantApp extends StatelessWidget {
  const ValorantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valorant Agents',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1722),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFD4556),
          surface: Color(0xFF141D29),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1722),
          elevation: 0,
        ),
      ),
      initialRoute: AppRouting.initialRoute,
      routes: AppRouting.routes,
    );
  }
}
