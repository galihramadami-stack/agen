import 'package:flutter/material.dart';
import '../models/agen_vaLorant.dart';
import 'home_page.dart';

class DetailPage extends StatelessWidget {
  final Datum? agent;

  const DetailPage({super.key, this.agent});

  @override
  Widget build(BuildContext context) {
    final Datum? currentAgent =
        agent ?? ModalRoute.of(context)?.settings.arguments as Datum?;

    if (currentAgent == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F1722),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'Data agen tidak ditemukan.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final roleName = currentAgent.role != null
        ? (displayNameValues.reverse[currentAgent.role!.displayName] ?? '')
        : '';
    final heroColor = getAgentThemeColor(
      currentAgent.displayName,
      currentAgent.role?.displayName,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F1722),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Banner Card
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: heroColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: heroColor.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Watermark background
                  if (currentAgent.background != null)
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.22,
                        child: Image.network(
                          currentAgent.background!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                    ),
                  // Left info (Name & Role pill)
                  Positioned(
                    top: 28,
                    left: 20,
                    right: 170,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentAgent.displayName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (roleName.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF101724).withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              roleName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Right Full Portrait
                  Positioned(
                    top: -10,
                    right: -10,
                    bottom: -10,
                    width: 200,
                    child: Image.network(
                      currentAgent.fullPortrait ??
                          currentAgent.displayIcon ??
                          '',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 80, color: Colors.white30),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Biography Section
            const Text(
              '// BIOGRAPHY',
              style: TextStyle(
                color: Color(0xFF5E6D7E),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              currentAgent.description.isNotEmpty
                  ? currentAgent.description
                  : 'Tidak ada informasi biografi.',
              style: const TextStyle(
                color: Color(0xFF8B9BAE),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // Special Abilities Section
            const Text(
              '// SPECIAL ABILITIES',
              style: TextStyle(
                color: Color(0xFF5E6D7E),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 14),

            if (currentAgent.abilities.isEmpty)
              const Text(
                'Tidak ada data kemampuan.',
                style: TextStyle(color: Colors.white60),
              )
            else
              ...currentAgent.abilities.map((ability) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141D29),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ability Icon box
                      Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F1722),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ability.displayIcon != null
                            ? Image.network(
                                ability.displayIcon!,
                                color: Colors.white,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.flash_on,
                                        color: Colors.white70, size: 22),
                              )
                            : const Icon(Icons.flash_on,
                                color: Colors.white70, size: 22),
                      ),
                      const SizedBox(width: 14),
                      // Ability Name & Description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ability.displayName.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ability.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF728193),
                                fontSize: 11,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
