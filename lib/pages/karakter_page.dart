import 'package:flutter/material.dart';

import '../models/valorant_agent.dart';
import '../services/api_service.dart';
import '../routes/app_routing.dart';
import '../utils/agent_filter.dart';
import 'home_page.dart';

class KarakterPage extends StatefulWidget {
  const KarakterPage({super.key});

  @override
  State<KarakterPage> createState() => _KarakterPageState();
}

class _KarakterPageState extends State<KarakterPage> {
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
            // Top Bar with back button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF162232),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
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
                  const ValorantLogo(size: 32),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // Headline
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Text(
                'Agent Roster\n& Karakter',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.22,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            // Search Bar
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
                    hintText: 'Cari karakter agen...',
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
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFD4556),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                style: TextStyle(color: Colors.white),
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
