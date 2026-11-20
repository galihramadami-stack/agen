import 'package:flutter/material.dart';

import '../models/valorant_agent.dart';
import 'home_page.dart';

class DetailPage extends StatefulWidget {
  final Datum? agent;

  const DetailPage({super.key, this.agent});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorite = false;

  void _toggleFavorite(String agentName) {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF162232),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: const Color(0xFFFD4556),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _isFavorite
                  ? '$agentName ditambahkan ke favorit!'
                  : '$agentName dihapus dari favorit.',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAbilityDetail(BuildContext context, Ability ability, Color themeColor) {
    final slotLabel = _getSlotBadge(ability.slot);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Color(0xFF121B28),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Color(0xFFFD4556), width: 2),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal drag handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header: Icon + Name + Slot Badge
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: ability.displayIcon != null
                        ? Image.network(
                            ability.displayIcon!,
                            color: Colors.white,
                            cacheWidth: 150,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.flash_on_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                          )
                        : const Icon(
                            Icons.flash_on_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFD4556),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            slotLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ability.displayName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),

              // Description Title
              const Text(
                '// DESKRIPSI KEMAMPUAN',
                style: TextStyle(
                  color: Color(0xFF728396),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),

              // Full description text
              Text(
                ability.description.isNotEmpty
                    ? ability.description
                    : 'Tidak ada deskripsi rinci untuk kemampuan ini.',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 13.5,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 28),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFD4556),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'TUTUP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getSlotBadge(Slot? slot) {
    if (slot == null) return 'ABILITY';
    switch (slot) {
      case Slot.ability1:
        return 'KEY [ Q ]';
      case Slot.ability2:
        return 'KEY [ E ] SIGNATURE';
      case Slot.grenade:
        return 'KEY [ C ]';
      case Slot.ultimate:
        return 'KEY [ X ] ULTIMATE';
      case Slot.passive:
        return 'PASSIVE';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Datum? currentAgent =
        widget.agent ?? ModalRoute.of(context)?.settings.arguments as Datum?;

    if (currentAgent == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F1722),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF162232).withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isFavorite ? const Color(0xFFFD4556) : Colors.white70,
                size: 22,
              ),
              onPressed: () => _toggleFavorite(currentAgent.displayName),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner Card with Hero Animation
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: heroColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: heroColor.withValues(alpha: 0.4),
                    blurRadius: 18,
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
                          cacheWidth: 800,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                    ),

                  // Left info (Name & Role pill & Developer Tag)
                  Positioned(
                    top: 26,
                    left: 20,
                    right: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentAgent.displayName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (roleName.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F1722).withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.shield_outlined,
                                  color: Color(0xFFFD4556),
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  roleName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (currentAgent.developerName != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'CODENAME: ${currentAgent.developerName}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Right Full Portrait with Hero Animation
                  Positioned(
                    top: -10,
                    right: -10,
                    bottom: -10,
                    width: 210,
                    child: Hero(
                      tag: 'agent-portrait-${currentAgent.uuid}',
                      child: Image.network(
                        currentAgent.fullPortrait ??
                            currentAgent.displayIcon ??
                            '',
                        fit: BoxFit.contain,
                        cacheWidth: 600,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person_rounded,
                              size: 80,
                              color: Colors.white30,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Biography Section
            Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFD4556),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '// BIOGRAPHY',
                  style: TextStyle(
                    color: Color(0xFF6B7D93),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141D29),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
              child: Text(
                currentAgent.description.isNotEmpty
                    ? currentAgent.description
                    : 'Tidak ada informasi biografi.',
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13.5,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Special Abilities Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD4556),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '// SPECIAL ABILITIES',
                      style: TextStyle(
                        color: Color(0xFF6B7D93),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Tap untuk detail',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (currentAgent.abilities.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Tidak ada data kemampuan.',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
              )
            else
              ...currentAgent.abilities.map((ability) {
                final slotKey = _getSlotBadge(ability.slot);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showAbilityDetail(context, ability, heroColor),
                      borderRadius: BorderRadius.circular(16),
                      splashColor: const Color(0xFFFD4556).withValues(alpha: 0.2),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141D29),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Ability Icon box
                            Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F1722),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: ability.displayIcon != null
                                  ? Image.network(
                                      ability.displayIcon!,
                                      color: Colors.white,
                                      cacheWidth: 128,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.flash_on_rounded,
                                                color: Colors.white70,
                                                size: 24,
                                              ),
                                    )
                                  : const Icon(
                                      Icons.flash_on_rounded,
                                      color: Colors.white70,
                                      size: 24,
                                    ),
                            ),
                            const SizedBox(width: 14),

                            // Ability Name & Slot
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ability.displayName.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    slotKey,
                                    style: const TextStyle(
                                      color: Color(0xFFFD4556),
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ability.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Color(0xFF728193),
                                      fontSize: 11.5,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Color(0xFF637385),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
