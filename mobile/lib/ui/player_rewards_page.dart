import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../state/auth_controller.dart';
import '../services/player_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/home_design.dart';

class PlayerRewardsPage extends StatefulWidget {
  final AuthController auth;
  const PlayerRewardsPage({super.key, required this.auth});

  @override
  State<PlayerRewardsPage> createState() => _PlayerRewardsPageState();
}

class _PlayerRewardsPageState extends State<PlayerRewardsPage>
    with SingleTickerProviderStateMixin {
  late PlayerService _playerService;
  late Future<Map<String, dynamic>> _rewardsFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _playerService = PlayerService(ApiClient(token: widget.auth.token));
    _rewardsFuture = _playerService.getMyRewards();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _reload() => setState(() {
        _rewardsFuture = _playerService.getMyRewards();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomePalette.background,
      appBar: AppBar(
        title: const Text('Mes Récompenses', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: HomePalette.title)),
        backgroundColor: Colors.white,
        foregroundColor: HomePalette.title,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: HomePalette.link,
          indicatorWeight: 3,
          labelColor: HomePalette.link,
          unselectedLabelColor: const Color(0xFF94A3B8),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.emoji_events, size: 18), text: 'Badges'),
            Tab(icon: Icon(Icons.card_giftcard, size: 18), text: 'Récompenses'),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _rewardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }

          final badges = snapshot.data?['badges'] as List? ?? [];
          final rewards = snapshot.data?['rewards'] as List? ?? [];

          return TabBarView(
            controller: _tabController,
            children: [
              _BadgesTab(badges: badges),
              _RewardsTab(rewards: rewards),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Badges tab
// ─────────────────────────────────────────────────────────────────────────────

class _BadgesTab extends StatelessWidget {
  final List badges;
  const _BadgesTab({required this.badges});

  static const _order = ['legendary', 'epic', 'rare', 'uncommon', 'common'];

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return _EmptyState(
        lottie: 'assets/trophy.json',
        title: 'Aucun badge pour le moment',
        subtitle: 'Performez sur le terrain pour débloquer vos premiers badges !',
      );
    }

    final sorted = badges.cast<Map<String, dynamic>>().toList()
      ..sort((a, b) => _order.indexOf(a['rarity'] ?? 'common').compareTo(_order.indexOf(b['rarity'] ?? 'common')));
    final total = sorted.fold<int>(0, (s, b) => s + ((b['count'] as int?) ?? 1));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: diagonal(HomePalette.navy),
            boxShadow: [BoxShadow(color: HomePalette.navy.last.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 5))],
          ),
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.military_tech, color: Color(0xFFFBBF24), size: 30),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$total', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, height: 1)),
              const SizedBox(height: 2),
              Text('badges obtenus', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12)),
            ]),
            const Spacer(),
            for (final r in _order.take(4))
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: diagonal(_rarityGradient(r))),
                  ),
                  const SizedBox(height: 4),
                  Text('${sorted.where((b) => b['rarity'] == r).length}',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                ]),
              ),
          ]),
        ),
        const SizedBox(height: 22),
        const HomeSectionHeader('Ma collection', Icons.workspace_premium),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: sorted.length,
          itemBuilder: (_, i) => _BadgeMedal(badge: sorted[i]),
        ),
      ],
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// Rewards tab
// ─────────────────────────────────────────────────────────────────────────────

class _RewardsTab extends StatelessWidget {
  final List rewards;
  const _RewardsTab({required this.rewards});

  @override
  Widget build(BuildContext context) {
    if (rewards.isEmpty) {
      return _EmptyState(
        lottie: 'assets/trophy.json',
        title: 'Aucune récompense pour le moment',
        subtitle: 'Les récompenses spéciales attribuées par votre coach apparaîtront ici.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SummaryBar(
          items: [
            _SummaryItem('Total', rewards.length, const Color(0xFF10B981), Icons.card_giftcard),
            _SummaryItem('Tournoi', rewards.where((r) => r['category'] == 'tournament').length, const Color(0xFFF59E0B), Icons.emoji_events),
            _SummaryItem('Spécial', rewards.where((r) => r['category'] == 'special').length, const Color(0xFFEF4444), Icons.stars),
            _SummaryItem('Milestone', rewards.where((r) => r['category'] == 'milestone').length, const Color(0xFF3B82F6), Icons.flag),
          ],
        ),
        const SizedBox(height: 20),
        ...rewards.map((r) => _RewardCard(reward: r as Map<String, dynamic>)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Badge : médaille compacte + fiche détaillée au toucher
// ─────────────────────────────────────────────────────────────────────────────

class _BadgeMedal extends StatelessWidget {
  final Map<String, dynamic> badge;
  const _BadgeMedal({required this.badge});

  @override
  Widget build(BuildContext context) {
    final name = badge['name'] as String? ?? 'Badge';
    final type = badge['type'] as String? ?? 'achievement';
    final rarity = badge['rarity'] as String? ?? 'common';
    final count = badge['count'] as int? ?? 1;
    final g = _rarityGradient(rarity);

    return GestureDetector(
      onTap: () => _showBadge(context, badge),
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: diagonal(g),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: g.first.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: _iconWidget(badge['icon'] as String?, type, Colors.white, size: 24),
            ),
            if (count > 1)
              Positioned(
                right: -8,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: HomePalette.title,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text('x$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
              ),
          ]),
          const Spacer(),
          Text(name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: HomePalette.title, height: 1.2)),
          const SizedBox(height: 4),
          Text(_rarityLabel(rarity), style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: g.first)),
        ]),
      ),
    );
  }
}

void _showBadge(BuildContext context, Map<String, dynamic> badge) {
  final name = badge['name'] as String? ?? 'Badge';
  final type = badge['type'] as String? ?? 'achievement';
  final rarity = badge['rarity'] as String? ?? 'common';
  final count = badge['count'] as int? ?? 1;
  final description = badge['description'] as String? ?? '';
  final awardedBy = badge['awardedBy'] as String? ?? 'Système';
  final tournamentName = badge['tournamentName'] as String?;
  final date = _fmtDate(badge['date'] as String?);
  final g = _rarityGradient(rarity);

  Widget info(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(children: [
          Icon(icon, size: 18, color: Colors.grey[500]),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF334155)))),
        ]),
      );

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Container(
            width: 84,
            height: 84,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: diagonal(g),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [BoxShadow(color: g.first.withOpacity(0.45), blurRadius: 18, offset: const Offset(0, 6))],
            ),
            child: _iconWidget(badge['icon'] as String?, type, Colors.white, size: 38),
          ),
          const SizedBox(height: 14),
          Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: HomePalette.title)),
          const SizedBox(height: 8),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(gradient: diagonal(g), borderRadius: BorderRadius.circular(20)),
              child: Text(_rarityLabel(rarity), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 6),
            _Chip(_typeLabel(type), const Color(0xFF64748B)),
            if (count > 1) ...[const SizedBox(width: 6), _Chip('x$count', HomePalette.link)],
          ]),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14.5, color: Color(0xFF64748B))),
          ],
          const SizedBox(height: 10),
          const Divider(),
          info(Icons.person_outline, 'Attribué par $awardedBy'),
          if (tournamentName != null) info(Icons.emoji_events_outlined, tournamentName),
          if (date.isNotEmpty) info(Icons.calendar_today_outlined, 'Obtenu le $date'),
        ]),
      ),
    ),
  );
}

List<Color> _rarityGradient(String r) {
  switch (r) {
    case 'legendary': return HomePalette.orange;
    case 'epic':      return HomePalette.purple;
    case 'rare':      return HomePalette.sky;
    case 'uncommon':  return HomePalette.green;
    default:          return const [Color(0xFF64748B), Color(0xFF94A3B8)];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reward card
// ─────────────────────────────────────────────────────────────────────────────

class _RewardCard extends StatelessWidget {
  final Map<String, dynamic> reward;
  const _RewardCard({required this.reward});

  @override
  Widget build(BuildContext context) {
    final name = reward['name'] as String? ?? 'Récompense';
    final description = reward['description'] as String? ?? '';
    final type = reward['type'] as String? ?? 'special';
    final category = reward['category'] as String? ?? 'special';
    final value = reward['value'] as int? ?? 0;
    final awardedBy = reward['awardedBy'] as String? ?? 'Système';
    final tournamentName = reward['tournamentName'] as String?;
    final dateRaw = reward['date'] as String?;
    final iconStr = reward['icon'] as String?;

    final color = _categoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(children: [
        // colored top stripe
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withAlpha(60)),
              ),
              child: _iconWidget(iconStr, type, color, size: 28),
            ),
            const SizedBox(width: 14),

            // info
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A))),
                  ),
                  if (value > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: color, borderRadius: BorderRadius.circular(12)),
                      child: Text('+$value',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                ]),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 4, children: [
                  _Chip(_categoryLabel(category), color),
                  if (tournamentName != null)
                    _Chip(tournamentName, const Color(0xFFF59E0B)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.person_outline, size: 12, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 4),
                  Text(awardedBy,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  const Spacer(),
                  Text(_fmtDate(dateRaw),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                ]),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary bar
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryItem {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  const _SummaryItem(this.label, this.value, this.color, this.icon);
}

class _SummaryBar extends StatelessWidget {
  final List<_SummaryItem> items;
  const _SummaryBar({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items
            .map((item) => Column(children: [
                  Icon(item.icon, color: item.color, size: 20),
                  const SizedBox(height: 4),
                  Text('${item.value}',
                      style: TextStyle(
                          color: item.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Text(item.label,
                      style: const TextStyle(color: Colors.white54, fontSize: 10)),
                ]))
            .toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers / small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 10, color: color, fontWeight: FontWeight.w600)),
      );
}

class _EmptyState extends StatelessWidget {
  final String lottie;
  final String title;
  final String subtitle;
  const _EmptyState(
      {required this.lottie, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Lottie.asset(lottie, height: 140, width: 140),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

/// Displays icon: emoji string if available, otherwise MaterialIcon fallback.
Widget _iconWidget(String? iconStr, String type, Color color, {double size = 24}) {
  if (iconStr != null && iconStr.trim().isNotEmpty) {
    return Text(iconStr, style: TextStyle(fontSize: size));
  }
  return Icon(_typeIcon(type), color: color, size: size);
}

// ── lookup maps ───────────────────────────────────────────────────────────────


Color _categoryColor(String c) {
  switch (c) {
    case 'tournament': return const Color(0xFFF59E0B);
    case 'training':   return const Color(0xFF10B981);
    case 'special':    return const Color(0xFFEF4444);
    case 'milestone':  return const Color(0xFF3B82F6);
    default:           return const Color(0xFF64748B);
  }
}

IconData _typeIcon(String type) {
  switch (type) {
    case 'tournament':   return Icons.emoji_events;
    case 'training':     return Icons.fitness_center;
    case 'match':        return Icons.sports_soccer;
    case 'achievement':  return Icons.military_tech;
    case 'participation':return Icons.star;
    case 'excellence':   return Icons.workspace_premium;
    case 'special':      return Icons.card_giftcard;
    case 'milestone':    return Icons.flag;
    default:             return Icons.emoji_events;
  }
}

String _rarityLabel(String r) {
  const m = {
    'legendary': 'Légendaire', 'epic': 'Épique',
    'rare': 'Rare', 'uncommon': 'Peu commun', 'common': 'Commun',
  };
  return m[r] ?? 'Commun';
}

String _typeLabel(String t) {
  const m = {
    'tournament': 'Tournoi', 'training': 'Entraîn.', 'match': 'Match',
    'achievement': 'Succès', 'participation': 'Particip.', 'excellence': 'Excellence',
    'special': 'Spécial', 'milestone': 'Milestone',
  };
  return m[t] ?? t;
}

String _categoryLabel(String c) {
  const m = {
    'tournament': 'Tournoi', 'training': 'Entraînement',
    'special': 'Spécial', 'milestone': 'Milestone',
  };
  return m[c] ?? c;
}

String _fmtDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    final d = DateTime.parse(raw);
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  } catch (_) {
    return '';
  }
}
