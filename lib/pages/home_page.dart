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
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
    _fetchAgents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchAgents() {
    _agentsFuture = ApiService.getAgents();
    _agentsFuture.then((data) {
      if (mounted) {
        setState(() {
          _allAgents = data;
          _applyFilter();
        });
      }
    }).catchError((_) {});
  }

  void _applyFilter() {
    var result = filterAgentsForTab(_allAgents, _selectedTab);
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      result = result.where((agent) {
        final nameMatches = agent.displayName.toLowerCase().contains(query);
        final roleName = agent.role != null
            ? (displayNameValues.reverse[agent.role!.displayName] ?? '')
            : '';
        final roleMatches = roleName.toLowerCase().contains(query);
        return nameMatches || roleMatches;
      }).toList();
    }
    setState(() {
      _filteredAgents = result;
    });
  }

  void _onTabSelected(String tab) {
    setState(() {
      _selectedTab = tab;
      _applyFilter();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _applyFilter();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _applyFilter();
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
            // Top Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: 'Daftar Karakter',
                    icon: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white70,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouting.karakter);
                    },
                  ),
                  const ValorantLogo(size: 34),
                  IconButton(
                    tooltip: 'Tentang Aplikasi',
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white70,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouting.about);
                    },
                  ),
                ],
              ),
            ),

            // Header Headline
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your\nawesome agents',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.22,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Modern Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF162232),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _searchQuery.isNotEmpty
                        ? const Color(0xFFFD4556)
                        : Colors.white.withValues(alpha: 0.08),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  cursorColor: const Color(0xFFFD4556),
                  decoration: InputDecoration(
                    hintText: 'Cari agen (contoh: Jett, Reyna)...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF6B7B8E),
                      fontSize: 13.5,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFFFD4556),
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Horizontal Tab Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: _tabs.map((tab) {
                  final isSelected = _selectedTab == tab;
                  return GestureDetector(
                    onTap: () => _onTabSelected(tab),
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
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
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: isSelected ? 24 : 0,
                            height: 3,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFD4556),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFFD4556)
                                            .withValues(alpha: 0.6),
                                        blurRadius: 6,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Agent Count Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'HASIL PENCARIAN (${_filteredAgents.length})'
                        : 'TOTAL AGEN: ${_filteredAgents.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Color(0xFF728396),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    GestureDetector(
                      onTap: _clearSearch,
                      child: const Text(
                        'Reset Filter',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFD4556),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Grid View with FutureBuilder and Pull to Refresh
            Expanded(
              child: FutureBuilder<List<Datum>>(
                future: _agentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      _allAgents.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFD4556),
                      ),
                    );
                  }

                  if (snapshot.hasError && _allAgents.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              color: Color(0xFFFD4556),
                              size: 54,
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Gagal Memuat Data Agen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Pastikan HP kamu terhubung dengan internet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF8899A6),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFD4556),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _fetchAgents();
                                });
                              },
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Coba Lagi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (_filteredAgents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 56,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Tidak ada agen bernama "$_searchQuery"'
                                : 'Data agen kosong.',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _clearSearch,
                              child: const Text(
                                'Tampilkan Semua Agen',
                                style: TextStyle(color: Color(0xFFFD4556)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: const Color(0xFFFD4556),
                    backgroundColor: const Color(0xFF162232),
                    onRefresh: () async {
                      _fetchAgents();
                      await _agentsFuture;
                    },
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.78,
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
                    ),
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
        ? (displayNameValues.reverse[agent.role!.displayName] ?? '')
        : '';
    final cardColor = getAgentThemeColor(
      agent.displayName,
      agent.role?.displayName,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
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
                    opacity: 0.20,
                    child: Image.network(
                      agent.background!,
                      fit: BoxFit.cover,
                      cacheWidth: 600,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    ),
                  ),
                ),

              // Agent Character Portrait with Hero animation
              Positioned(
                top: 6,
                left: 4,
                right: 4,
                bottom: 46,
                child: Hero(
                  tag: 'agent-portrait-${agent.uuid}',
                  child: Image.network(
                    agent.fullPortrait ?? agent.displayIcon ?? '',
                    fit: BoxFit.contain,
                    cacheWidth: 600,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(
                          Icons.person_rounded,
                          size: 70,
                          color: Colors.white30,
                        ),
                  ),
                ),
              ),

              // Bottom Role & Name Badge
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1722).withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFD4556),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              roleName.isNotEmpty ? roleName : 'AGENT',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
