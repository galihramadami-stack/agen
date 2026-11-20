import 'package:flutter/material.dart';

import '../models/valorant_agent.dart';
import '../services/api_service.dart';
import '../routes/app_routing.dart';
import '../utils/agent_filter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Datum>> _agentsFuture;
  List<Datum> _allAgents = [];
  List<Datum> _filteredAgents = [];
  String _selectedTab = 'Popular';

  final List<String> _tabs = [
    'Popular',
    'New One',
    'Trending',
    'Duelist',
    'Initiator',
    'Controller',
    'Sentinel',
  ];

  @override
  void initState() {
    super.initState();
    _agentsFuture = ApiService.getAgents();
  }

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
      _filteredAgents = filterAgentsForTab(_allAgents, tab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1722),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Centered Valorant Red Logo & Info Action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40),
                      const ValorantLogo(size: 32),
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouting.about);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Headline Text
                  const Text(
                    'Choose your\nawesome agents',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Filter Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _tabs.map((tab) {
                        final isSelected = _selectedTab == tab;
                        return GestureDetector(
                          onTap: () => _onTabSelected(tab),
                          child: Container(
                            margin: const EdgeInsets.only(right: 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tab,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF637385),
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (isSelected)
                                  Container(
                                    width: 24,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFD4556),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  )
                                else
                                  const SizedBox(height: 3),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            // 2-Column Agent Grid
            Expanded(
              child: FutureBuilder<List<Datum>>(
                future: _agentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFD4556),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFFD4556),
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal memuat data agen',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFD4556),
                            ),
                            onPressed: () {
                              setState(() {
                                _agentsFuture = ApiService.getAgents();
                              });
                            },
                            child: const Text(
                              'Coba Lagi',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Data agen tidak ditemukan.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  if (_allAgents.isEmpty) {
                    _allAgents = snapshot.data!;
                    _filteredAgents = filterAgentsForTab(
                      _allAgents,
                      _selectedTab,
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.80,
                        ),
                    itemCount: _filteredAgents.length,
                    itemBuilder: (context, index) {
                      final agent = _filteredAgents[index];
                      return AgentCardWidget(
                        agent: agent,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouting.detail,
                            arguments: agent,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AgentCardWidget extends StatelessWidget {
  final Datum agent;
  final VoidCallback onTap;

  const AgentCardWidget({super.key, required this.agent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final roleName = agent.role != null
        ? displayNameValues.reverse[agent.role!.displayName] ?? ''
        : '';
    final cardColor = getAgentThemeColor(
      agent.displayName,
      agent.role?.displayName,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background watermark art
            if (agent.background != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.18,
                  child: Image.network(
                    agent.background!,
                    fit: BoxFit.cover,
                    cacheWidth: 600,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  ),
                ),
              ),
            // Agent Character Portrait
            Positioned(
              top: 8,
              left: 4,
              right: 4,
              bottom: 40,
              child: Image.network(
                agent.fullPortrait ?? agent.displayIcon ?? '',
                fit: BoxFit.contain,
                cacheWidth: 600,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 70, color: Colors.white30),
              ),
            ),
            // Bottom Name and Role
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    agent.displayName.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    roleName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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

Color getAgentThemeColor(String name, DisplayName? role) {
  final n = name.toLowerCase();
  if (n.contains('omen')) return const Color(0xFF3B487A);
  if (n.contains('phoenix')) return const Color(0xFFD67733);
  if (n.contains('raze')) return const Color(0xFFDC4D2E);
  if (n.contains('viper')) return const Color(0xFF1B6B46);
  if (n.contains('jett')) return const Color(0xFF537E94);
  if (n.contains('sova')) return const Color(0xFF315C85);
  if (n.contains('reyna')) return const Color(0xFF733368);
  if (n.contains('killjoy')) return const Color(0xFFC7922A);
  if (n.contains('cypher')) return const Color(0xFF4C5D6C);
  if (n.contains('brimstone')) return const Color(0xFF8A4F32);
  if (n.contains('sage')) return const Color(0xFF287265);
  if (n.contains('breach')) return const Color(0xFF8B5131);
  if (n.contains('skye')) return const Color(0xFF3E6F4E);
  if (n.contains('yoru')) return const Color(0xFF26457B);
  if (n.contains('astra')) return const Color(0xFF5B3878);
  if (n.contains('kay/o')) return const Color(0xFF455768);
  if (n.contains('chamber')) return const Color(0xFF846D42);
  if (n.contains('neon')) return const Color(0xFF22588C);
  if (n.contains('fade')) return const Color(0xFF384357);
  if (n.contains('harbor')) return const Color(0xFF1B5F61);
  if (n.contains('gekko')) return const Color(0xFF748633);
  if (n.contains('deadlock')) return const Color(0xFF4D5A64);
  if (n.contains('iso')) return const Color(0xFF4C3B78);
  if (n.contains('clove')) return const Color(0xFF834471);
  if (n.contains('vyse')) return const Color(0xFF543C62);

  switch (role) {
    case DisplayName.duelist:
      return const Color(0xFFB8432F);
    case DisplayName.controller:
      return const Color(0xFF3B487A);
    case DisplayName.initiator:
      return const Color(0xFF2E6F65);
    case DisplayName.sentinel:
      return const Color(0xFF4C5D6C);
    default:
      return const Color(0xFF1E293B);
  }
}

class ValorantLogo extends StatelessWidget {
  final double size;

  const ValorantLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ValorantLogoPainter()),
    );
  }
}

class _ValorantLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFD4556)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(size.width * 0.08, 0);
    path1.lineTo(size.width * 0.44, 0);
    path1.lineTo(size.width * 0.56, size.height * 0.58);
    path1.lineTo(size.width * 0.38, size.height);
    path1.close();
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.60, 0);
    path2.lineTo(size.width * 0.94, 0);
    path2.lineTo(size.width * 0.72, size.height * 0.65);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
