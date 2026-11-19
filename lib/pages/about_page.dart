import 'package:flutter/material.dart';
import 'home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1726),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'About App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Center(
              child: ValorantLogo(size: 72),
            ),
            const SizedBox(height: 16),
            const Text(
              'VALORANT AGENTS',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF7E8B9B),
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF162232),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '// PROJECT DESCRIPTION',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aplikasi katalog karakter game Valorant dengan desain modern Dribbble. Menampilkan informasi agen, role, latar belakang cerita, dan seluruh kemampuan khusus (special abilities).',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF162232),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.school, color: Color(0xFFFD4556)),
                    title: Text(
                      'Developer',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Muhamad Galih Ramadani',
                      style: TextStyle(color: Color(0xFF7E8B9B)),
                    ),
                  ),
                  Divider(color: Colors.white10, height: 1),
                  ListTile(
                    leading: Icon(Icons.code, color: Colors.blueAccent),
                    title: Text(
                      'Tech Stack',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Flutter, Dart, REST API',
                      style: TextStyle(color: Color(0xFF7E8B9B)),
                    ),
                  ),
                  Divider(color: Colors.white10, height: 1),
                  ListTile(
                    leading: Icon(Icons.cloud, color: Colors.tealAccent),
                    title: Text(
                      'API Source',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'https://valorant-api.com',
                      style: TextStyle(color: Color(0xFF7E8B9B)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
