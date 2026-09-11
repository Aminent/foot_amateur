import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../state/auth_controller.dart';
import '../services/player_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';

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
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Mes Récompenses'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFBBF24),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
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

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return _EmptyState(
        lottie: 'assets/trophy.json',
        title: 'Aucun badge pour le moment',
        subtitle: 'Performez sur le terrain pour débloquer vos premiers badges !',
      );
    }

    // Group by rarity order for display
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // summary bar
        _SummaryBar(
          items: [
            _SummaryItem('Total', badges.length, const Color(0xFFF59E0B), Icons.emoji_events),
            _SummaryItem('Légendaire', badges.where((b) => b['rarity'] == 'legendary').length, const Color(0xFFFF6B00), Icons.local_fire_department),
            _SummaryItem('Épique', badges.where((b) => b['rarity'] == 'epic').length, const Color(0xFF8B5CF6), Icons.auto_awesome),
            _SummaryItem('Rare', badges.where((b) => b['rarity'] == 'rare').length, const Color(0xFF3B82F6), Icons.diamond),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemCount: badges.length,
          itemBuilder: (_, i) => _BadgeCard(badge: badges[i] as Map<String, dynamic>),
        ),
      ]),
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
// Badge card
// ─────────────────────────────────────────────────────────────────────────────

class _BadgeCard extends StatelessWidget {
  final Map<String, dynamic> badge;
  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    final name = badge['name'] as String? ?? 'Badge';
    final type = badge['type'] as String? ?? 'achievement';
    final rarity = badge['rarity'] as String? ?? 'common';
    final count = badge['count'] as int? ?? 1;
    final awardedBy = badge['awardedBy'] as String? ?? 'Système';
    final tournamentName = badge['tournamentName'] as String?;
    final dateRaw = badge['date'] as String?;
    final iconStr = badge['icon'] as String?;

    final color = _rarityColor(rarity);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withAlpha(38), color.withAlpha(18)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(100), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withAlpha(40), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // icon + count
          Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _iconWidget(iconStr, type, color, size: 26),
            ),
            const Spacer(),
            if (count > 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('x$count',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
          ]),
          const SizedBox(height: 10),

          // name
          Text(name,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),

          // rarity + type chips
          Row(children: [
            _Chip(_rarityLabel(rarity), color),
            const SizedBox(width: 4),
            _Chip(_typeLabel(type), const Color(0xFF64748B)),
          ]),

          const Spacer(),

          // awarded by / tournament
          if (tournamentName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(children: [
                const Icon(Icons.emoji_events, size: 11, color: Color(0xFFF59E0B)),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(tournamentName,
                      style: const TextStyle(fontSize: 10, color: Color(0xFFF59E0B)),
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
          Row(children: [
            const Icon(Icons.person, size: 11, color: Color(0xFF94A3B8)),
            const SizedBox(width: 3),
            Expanded(
              child: Text(awardedBy,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                  overflow: TextOverflow.ellipsis),
            ),
            Text(_fmtDate(dateRaw),
                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          ]),
        ]),
      ),
    );
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

Color _rarityColor(String r) {
  switch (r) {
    case 'legendary': return const Color(0xFFFF6B00);
    case 'epic':      return const Color(0xFF8B5CF6);
    case 'rare':      return const Color(0xFF3B82F6);
    case 'uncommon':  return const Color(0xFF10B981);
    default:          return const Color(0xFF94A3B8);
  }
}

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
