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
      title: 'Daftar Agen Valorant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      initialRoute: AppRouting.initialRoute,
      routes: AppRouting.routes,
    );
  }
}
