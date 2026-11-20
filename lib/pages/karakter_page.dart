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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white70,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const ValorantLogo(size: 32),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const SizedBox(height: 20),
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
