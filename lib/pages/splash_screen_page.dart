import 'dart:async';
import 'package:flutter/material.dart';
import '../routes/app_routing.dart';
import 'home_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRouting.home);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0E1726),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValorantLogo(size: 80),
            SizedBox(height: 28),
            Text(
              'VALORANT',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Choose your awesome agents',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF7E8B9B),
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              color: Color(0xFFFD4556),
            ),
          ],
        ),
      ),
    );
  }
}
