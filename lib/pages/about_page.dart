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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.only(left: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF162232).withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF162232),
                  border: Border.all(
                    color: const Color(0xFFFD4556).withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFD4556).withValues(alpha: 0.2),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: const ValorantLogo(size: 64),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'VALORANT AGENTS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFD4556).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFD4556).withValues(alpha: 0.4),
                ),
              ),
              child: const Text(
                'Version 1.0.0 (Release Optimized)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFD4556),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Project Description Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF162232),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: Color(0xFFFD4556),
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'PROJECT DESCRIPTION',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Aplikasi katalog karakter game Valorant dengan antarmuka modern khas Riot Games. Menampilkan seluruh data agen secara real-time dari REST API, pencarian instan, filter kategori role (Duelist, Initiator, Controller, Sentinel), serta eksplorasi kemampuan khusus (special abilities).',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFFCBD5E1),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Developer & Tech Details Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF162232),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF202E42),
                      child: Icon(Icons.person_rounded, color: Color(0xFFFD4556)),
                    ),
                    title: Text(
                      'Developer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Muhamad Galih Ramadani',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  ),
                  Divider(color: Colors.white10, height: 1),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF202E42),
                      child: Icon(Icons.code_rounded, color: Colors.blueAccent),
                    ),
                    title: Text(
                      'Tech Stack',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Flutter 3.47, Dart 3.13, REST API',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  ),
                  Divider(color: Colors.white10, height: 1),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF202E42),
                      child: Icon(Icons.cloud_sync_rounded, color: Colors.tealAccent),
                    ),
                    title: Text(
                      'Data Source API',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'https://valorant-api.com',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
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
