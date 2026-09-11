import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import '../services/coach_service.dart';
import '../services/api_client.dart';
import '../state/auth_controller.dart';
import '../widgets/custom_widgets.dart';

class CoachTeamPage extends StatefulWidget {
  final AuthController auth;
  const CoachTeamPage({super.key, required this.auth});

  @override
  State<CoachTeamPage> createState() => _CoachTeamPageState();
}

class _CoachTeamPageState extends State<CoachTeamPage> {
  late final CoachService _service;
  Map<String, dynamic>? _teamData;
  bool _loading = true;
  String? _error;

  List<Map<String, dynamic>> _recentRewards = [];
  bool _rewardsLoading = false;

  @override
  void initState() {
    super.initState();
    _service = CoachService(ApiClient(token: widget.auth.token));
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _service.getMyTeam();
      if (mounted) {
        setState(() { _teamData = data; _loading = false; });
        _loadRecentRewards();
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _loadRecentRewards() async {
    final players = List<Map<String, dynamic>>.from(_teamData?['players'] ?? []);
    if (players.isEmpty) return;
    if (mounted) setState(() => _rewardsLoading = true);
    final all = <Map<String, dynamic>>[];
    for (final p in players) {
      final id = p['id'];
      if (id == null) continue;
      final parsed = id is int ? id : int.tryParse(id.toString()) ?? 0;
      if (parsed == 0) continue;
      final badges = await _service.getPlayerBadges(parsed);
      for (final b in badges) {
        all.add({...b, '_playerName': p['name'] ?? '—'});
      }
    }
    all.sort((a, b) {
      final da = DateTime.tryParse(a['awardedAt'] ?? a['createdAt'] ?? '') ?? DateTime(2000);
      final db = DateTime.tryParse(b['awardedAt'] ?? b['createdAt'] ?? '') ?? DateTime(2000);
      return db.compareTo(da);
    });
    if (mounted) {
      setState(() {
        _recentRewards = all.take(10).toList();
        _rewardsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Mon Équipe'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () { setState(() { _loading = true; _error = null; }); _load(); },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF55C1CF)))
          : _error != null
              ? _buildError()
              : _buildContent(),

    );
  }

  Widget _buildError() => AppErrorWidget(
        message: _error,
        onRetry: () { setState(() { _loading = true; _error = null; }); _load(); },
      );

  Widget _buildContent() {
    final team = _teamData!['team'] as Map<String, dynamic>;
    final players = List<Map<String, dynamic>>.from(_teamData!['players'] ?? []);

    // Group by position
    final groups = <String, List<Map<String, dynamic>>>{
      'Gardiens': [],
      'Défenseurs': [],
      'Milieux': [],
      'Attaquants': [],
      'Autres': [],
    };
    for (final p in players) {
      final pos = (p['position'] ?? '').toString().toLowerCase();
      if (pos.contains('gardien') || pos == 'gk' || pos == 'goalkeeper') {
        groups['Gardiens']!.add(p);
      } else if (pos.contains('défenseur') || pos.contains('defenseur') ||
                 pos == 'cb' || pos == 'lb' || pos == 'rb' || pos == 'def') {
        groups['Défenseurs']!.add(p);
      } else if (pos.contains('milieu') || pos == 'cm' || pos == 'cdm' ||
                 pos == 'cam' || pos == 'mid') {
        groups['Milieux']!.add(p);
      } else if (pos.contains('attaquant') || pos == 'st' || pos == 'lw' ||
                 pos == 'rw' || pos == 'fw' || pos == 'att') {
        groups['Attaquants']!.add(p);
      } else {

        groups['Autres']!.add(p);
      }
    }

    return RefreshIndicator(
      color: const Color(0xFF55C1CF),
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _teamCard(team, players.length),
          const SizedBox(height: 20),
          _buildRecentRewardsSection(),
          const SizedBox(height: 20),
          ...groups.entries
              .where((e) => e.value.isNotEmpty)
              .map((e) => _positionGroup(e.key, e.value)),
          if (players.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Icon(Icons.group_off, size: 56, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    Text('Aucun joueur dans l\'équipe',
                        style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRecentRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              const Icon(Icons.emoji_events_outlined, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              const Text(
                'RÉCOMPENSES RÉCENTES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2)),
            ],
          ),
          child: _rewardsLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator(
                    color: Color(0xFF55C1CF), strokeWidth: 2)),
                )
              : _recentRewards.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.emoji_events_outlined, size: 36, color: Colors.grey[300]),
                            const SizedBox(height: 8),
                            Text('Aucune récompense attribuée',
                                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('Ouvrez un joueur pour attribuer un badge',
                                style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: _recentRewards.asMap().entries.map((entry) {
                        final i = entry.key;
                        final reward = entry.value;
                        final rarity = reward['rarity'] as String? ?? 'common';
                        final rarityColors = <String, Color>{
                          'common':    const Color(0xFF94A3B8),
                          'uncommon':  const Color(0xFF22C55E),
                          'rare':      const Color(0xFF3B82F6),
                          'epic':      const Color(0xFF8B5CF6),
                          'legendary': const Color(0xFFF59E0B),
                        };
                        final rarityColor = rarityColors[rarity] ?? rarityColors['common']!;
                        final icon = reward['icon'] as String? ?? '🏅';
                        final playerName = reward['_playerName'] as String? ?? '—';
                        final badgeName = reward['name'] as String? ?? '—';
                        final badgeType = reward['type'] as String? ?? '';
                        final typeLabels = <String, String>{
                          'training':      'Entraînement',
                          'match':         'Match',
                          'achievement':   'Accomplissement',
                          'participation': 'Participation',
                          'excellence':    'Excellence',
                          'tournament':    'Tournoi',
                        };
                        final typeLabel = typeLabels[badgeType] ?? badgeType;
                        final rawDate = reward['awardedAt'] ?? reward['createdAt'];
                        String dateStr = '';
                        if (rawDate != null) {
                          final dt = DateTime.tryParse(rawDate.toString());
                          if (dt != null) {
                            dateStr = '${dt.day.toString().padLeft(2,'0')}/'
                                '${dt.month.toString().padLeft(2,'0')}/'
                                '${dt.year}';
                          }
                        }
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Text(icon, style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          badgeName,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF0F172A)),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          playerName,
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey[500]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (typeLabel.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: rarityColor.withAlpha(25),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            typeLabel,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: rarityColor),
                                          ),
                                        ),
                                      if (dateStr.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          dateStr,
                                          style: TextStyle(
                                              fontSize: 10, color: Colors.grey[400]),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (i < _recentRewards.length - 1)
                              const Divider(height: 1, indent: 50, endIndent: 16),
                          ],
                        );
                      }).toList(),
                    ),
        ),
      ],
    );
  }

  Widget _teamCard(Map<String, dynamic> team, int playerCount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF55C1CF).withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield, color: Color(0xFF55C1CF), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team['name'] ?? 'Mon Équipe',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if ((team['description'] ?? '').toString().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      team['description'].toString(),
                      style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.people, color: Color(0xFF55C1CF), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$playerCount joueur${playerCount != 1 ? 's' : ''}',
                      style: const TextStyle(
                          color: Color(0xFF55C1CF), fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _positionGroup(String title, List<Map<String, dynamic>> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Icon(_positionIcon(title), size: 16, color: const Color(0xFF64748B)),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withAlpha(10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${players.length}',
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: players.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              return Column(
                children: [
                  _playerRow(p),
                  if (i < players.length - 1)
                    const Divider(height: 1, indent: 68, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _playerRow(Map<String, dynamic> player) {
    final jerseyNum = player['jerseyNumber'];
    final isCaptain = player['isCaptain'] == true;
    final isActive = player['status'] == 'Actif';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openProfile(player),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                jerseyNum != null ? '#$jerseyNum' : '—',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          player['name'] ?? '—',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCaptain) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    player['position'] ?? 'Position inconnue',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? Colors.green.withAlpha(25) : Colors.red.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isActive ? 'Actif' : 'Inactif',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
          ],
        ),
      ),
    );
  }

  void _openProfile(Map<String, dynamic> player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _PlayerProfilePage(player: player, service: _service),
      ),
    );
  }

  IconData _positionIcon(String group) {
    switch (group) {
      case 'Gardiens':    return Icons.back_hand_outlined;
      case 'Défenseurs': return Icons.shield_outlined;
      case 'Milieux':    return Icons.compare_arrows;
      case 'Attaquants': return Icons.sports_soccer;
      default:           return Icons.person_outline;
    }
  }
}

// ── Player Profile Page ───────────────────────────────────────────────────────

class _PlayerProfilePage extends StatefulWidget {
  final Map<String, dynamic> player;
  final CoachService service;

  const _PlayerProfilePage({required this.player, required this.service});

  @override
  State<_PlayerProfilePage> createState() => _PlayerProfilePageState();
}

class _PlayerProfilePageState extends State<_PlayerProfilePage> {
  Map<String, dynamic>? _stats;
  bool _loading = true;
  String? _selectedChartStat;

  List<Map<String, dynamic>> _badges = [];
  bool _badgesLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
    _fetchBadges();
  }

  Future<void> _fetchBadges() async {
    final id = widget.player['id'];
    if (id == null) { setState(() => _badgesLoading = false); return; }
    final parsed = id is int ? id : int.tryParse(id.toString()) ?? 0;
    final badges = await widget.service.getPlayerBadges(parsed);
    if (mounted) setState(() { _badges = badges; _badgesLoading = false; });
  }

  Future<void> _fetchStats() async {
    try {
      final id = widget.player['id'];
      if (id != null) {
        final parsed = id is int ? id : int.tryParse(id.toString()) ?? 0;
        final stats = await widget.service.getPlayerStats(parsed);
        if (mounted) {
          final pos = _detectPos(widget.player['position'] as String?);
          final chartStats = _chartStatsForPos(pos);
          setState(() {
            _stats = stats;
            _loading = false;
            _selectedChartStat ??= chartStats[0]['key'] as String;
          });
        }
      } else {
        if (mounted) setState(() { _loading = false; });
      }
    } catch (_) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.player;
    final isCaptain = p['isCaptain'] == true;
    final isActive = p['status'] == 'Actif';
    final jerseyNum = p['jerseyNumber'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF55C1CF).withAlpha(40),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF55C1CF), width: 2),
                            ),
                            child: const Icon(Icons.person, color: Color(0xFF55C1CF), size: 42),
                          ),
                          if (jerseyNum != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF55C1CF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#$jerseyNum',
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            p['name'] ?? '—',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          if (isCaptain) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p['position'] ?? '—',
                        style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Informations', Icons.person_outline),
                  const SizedBox(height: 10),
                  _card(Column(
                    children: [
                      _infoRow(Icons.email_outlined, Colors.teal, 'Email', p['email'] ?? '—'),
                      const Divider(height: 20),
                      _infoRow(Icons.phone_outlined, Colors.indigo, 'Téléphone', p['phone'] ?? '—'),
                      const Divider(height: 20),
                      _infoRow(Icons.badge_outlined, Colors.orange, 'Statut',
                          isActive ? 'Actif' : 'Inactif',
                          valueColor: isActive ? Colors.green[700] : Colors.red[700]),
                      if (isCaptain) ...[
                        const Divider(height: 20),
                        _infoRow(Icons.star, Colors.amber, 'Rôle', 'Capitaine'),
                      ],
                    ],
                  )),
                  const SizedBox(height: 24),
                  _sectionHeader('Statistiques', Icons.bar_chart),
                  const SizedBox(height: 10),
                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: Color(0xFF55C1CF)),
                      ),
                    )
                  else if (_stats == null || _stats!.values.every((v) => v == 0 || v == null))
                    _card(Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            Icon(Icons.bar_chart, size: 40, color: Colors.grey[300]),
                            const SizedBox(height: 8),
                            Text('Aucune statistique disponible',
                                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                          ],
                        ),
                      ),
                    ))
                  else
                    _buildStats(_stats!),
                  const SizedBox(height: 24),
                  _buildBadgesSection(),
                  const SizedBox(height: 24),
                  _buildGoalsInfoSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Badges section ────────────────────────────────────────────────────────────
  static const _rarityMeta = {
    'common':   {'label': 'Commun',    'color': Color(0xFF94A3B8)},
    'uncommon': {'label': 'Inhabituel','color': Color(0xFF22C55E)},
    'rare':     {'label': 'Rare',      'color': Color(0xFF3B82F6)},
    'epic':     {'label': 'Épique',    'color': Color(0xFF8B5CF6)},
    'legendary':{'label': 'Légendaire','color': Color(0xFFF59E0B)},
  };

  // Note: 'tournament' is excluded — that's admin's domain
  static const _typeLabels = {
    'tournament':    'Tournoi',       // kept for display of existing badges, not for award
    'training':      'Entraînement',
    'match':         'Match',
    'achievement':   'Accomplissement',
    'participation': 'Participation',
    'excellence':    'Excellence',
  };

  Widget _buildBadgesSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: _sectionHeader('Badges', Icons.emoji_events_outlined)),
        TextButton.icon(
          onPressed: _showAwardBadgeSheet,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Attribuer'),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF55C1CF),
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ]),
      const SizedBox(height: 10),
      if (_badgesLoading)
        const Center(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: CircularProgressIndicator(color: Color(0xFF55C1CF)),
        ))
      else if (_badges.isEmpty)
        _card(Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Column(children: [
            Icon(Icons.emoji_events_outlined, size: 36, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text('Aucun badge pour le moment',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 4),
            Text('Appuyez sur "Attribuer" pour récompenser ce joueur',
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
                textAlign: TextAlign.center),
          ])),
        ))
      else
        Wrap(spacing: 8, runSpacing: 8, children: _badges.map((b) {
          final rarity = b['rarity'] as String? ?? 'common';
          final meta = _rarityMeta[rarity] ?? _rarityMeta['common']!;
          final color = meta['color'] as Color;
          final icon = b['icon'] as String? ?? '🏅';
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.5), width: 1.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b['name'] as String? ?? '—',
                    style: const TextStyle(color: Colors.white, fontSize: 12,
                        fontWeight: FontWeight.w600)),
                Text(meta['label'] as String,
                    style: TextStyle(color: color, fontSize: 10,
                        fontWeight: FontWeight.w500)),
              ]),
            ]),
          );
        }).toList()),
    ]);
  }

  void _showAwardBadgeSheet() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedType = 'achievement';
    String selectedRarity = 'common';
    String selectedIcon = '⭐';
    String sheetError = ''; // error shown inside the sheet

    const icons = ['⭐', '🏆', '⚽', '🥅', '🎯', '🔥', '💪', '🛡️', '👑', '💎'];
    // 'tournament' is reserved for admin — coaches award training/match/achievement/participation/excellence
    const types = ['achievement', 'match', 'training', 'participation', 'excellence'];
    const rarities = ['common', 'uncommon', 'rare', 'epic', 'legendary'];

    final playerId = widget.player['id'];
    final parsed = playerId is int ? playerId : int.tryParse(playerId.toString()) ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, sc) => Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2)),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(children: [
                  const Icon(Icons.emoji_events, color: Color(0xFF55C1CF), size: 22),
                  const SizedBox(width: 10),
                  Text('Attribuer un badge à ${widget.player['name'] ?? ''}',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ]),
              ),
              const Divider(color: Colors.white12, height: 1),
              // Form
              Expanded(child: ListView(controller: sc, padding:
                  const EdgeInsets.fromLTRB(20, 16, 20, 24), children: [
                // Icon picker
                const Text('Icône', style: TextStyle(
                    color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                SizedBox(height: 50, child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: icons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final ic = icons[i];
                    final sel = selectedIcon == ic;
                    return GestureDetector(
                      onTap: () => setSheet(() => selectedIcon = ic),
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFF55C1CF).withOpacity(0.2) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: sel ? const Color(0xFF55C1CF) : Colors.white12,
                              width: sel ? 2 : 1),
                        ),
                        child: Center(child: Text(ic, style: const TextStyle(fontSize: 22))),
                      ),
                    );
                  },
                )),
                const SizedBox(height: 16),
                // Name
                const Text('Nom du badge *', style: TextStyle(
                    color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                _sheetTextField(nameCtrl, 'Ex: Meilleur buteur'),
                const SizedBox(height: 16),
                // Description
                const Text('Description (optionnelle)', style: TextStyle(
                    color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                _sheetTextField(descCtrl, 'Ex: A marqué 10 buts cette saison',
                    maxLines: 2),
                const SizedBox(height: 16),
                // Type
                const Text('Catégorie', style: TextStyle(
                    color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 6, children: types.map((t) {
                  final sel = selectedType == t;
                  return GestureDetector(
                    onTap: () => setSheet(() => selectedType = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFF55C1CF).withOpacity(0.15) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: sel ? const Color(0xFF55C1CF) : Colors.white12),
                      ),
                      child: Text(_typeLabels[t] ?? t,
                          style: TextStyle(
                              color: sel ? const Color(0xFF55C1CF) : Colors.white54,
                              fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  );
                }).toList()),
                const SizedBox(height: 16),
                // Rarity
                const Text('Rareté', style: TextStyle(
                    color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 6, children: rarities.map((r) {
                  final meta = _rarityMeta[r]!;
                  final color = meta['color'] as Color;
                  final sel = selectedRarity == r;
                  return GestureDetector(
                    onTap: () => setSheet(() => selectedRarity = r),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel ? color.withOpacity(0.15) : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: sel ? color : Colors.white12,
                            width: sel ? 1.5 : 1),
                      ),
                      child: Text(meta['label'] as String,
                          style: TextStyle(
                              color: sel ? color : Colors.white54,
                              fontSize: 12, fontWeight: FontWeight.w500)),
                    ),
                  );
                }).toList()),
                const SizedBox(height: 20),
                // In-sheet error message
                if (sheetError.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.withOpacity(0.4)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(sheetError,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
                    ]),
                  ),
                // Submit
                SizedBox(width: double.infinity, height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF55C1CF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      final desc = descCtrl.text.trim();
                      if (name.isEmpty) {
                        setSheet(() => sheetError = 'Le nom du badge est requis');
                        return;
                      }
                      setSheet(() => sheetError = '');
                      try {
                        await widget.service.awardBadge(parsed, {
                          'name': name,
                          'description': desc,
                          'type': selectedType,
                          'rarity': selectedRarity,
                          'icon': selectedIcon,
                        });
                        if (mounted) {
                          Navigator.pop(context);
                          // snackbar on the outer scaffold — visible after sheet closes
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Badge "$name" attribué à ${widget.player['name']} !'),
                            backgroundColor: Colors.green[700],
                          ));
                          _fetchBadges();
                        }
                      } catch (e) {
                        if (mounted) setSheet(() => sheetError = 'Erreur: ${e.toString().replaceFirst('Exception: ', '')}');
                      }
                    },
                    child: const Text('Attribuer le badge',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ])),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsInfoSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionHeader('Objectifs personnels', Icons.track_changes_outlined),
      const SizedBox(height: 10),
      _card(Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.info_outline, color: Colors.blue, size: 20),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Les objectifs personnels sont définis et gérés directement par le joueur dans son application. Ils ne sont pas accessibles depuis l\'interface coach.',
            style: TextStyle(
                fontSize: 13, color: Color(0xFF334155), height: 1.45),
          ),
        ),
      ])),
    ]);
  }

  Widget _sheetTextField(TextEditingController ctrl, String hint, {int maxLines = 1}) =>
    TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF55C1CF), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );

  // ── Stats card (same layout as coach_stats_page card) ────────────────────────
  Widget _buildStats(Map<String, dynamic> stats) {
    final pos        = _detectPos(widget.player['position'] as String?);
    final posColor   = _posColorOf(pos);
    const cardColor  = Color(0xFF2C4A67);
    final kpis       = _kpisForPos(pos);
    final secondary  = _secondaryForPos(pos);
    final radarData  = _radarValuesFor(pos, stats);
    final chartStats = _chartStatsForPos(pos);
    final curStat    = _selectedChartStat ?? chartStats[0]['key'] as String;
    final curColor   = (chartStats.firstWhere(
        (s) => s['key'] == curStat, orElse: () => chartStats[0])['color']) as Color;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      // ── 4 KPI tiles ─────────────────────────────────────────────────────────
      GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
        children: kpis.map((k) => _buildKpiTile(
          label: k.label, value: _si(stats[k.key]),
          icon: k.icon, color: cardColor,
        )).toList(),
      ),

      const SizedBox(height: 14),

      // ── Radar + secondary stats ──────────────────────────────────────────────
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 148, height: 148,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: posColor.withOpacity(0.15)),
          ),
          child: CustomPaint(
            size: const Size(148, 148),
            painter: _MiniRadarPainter(skills: radarData, accentColor: posColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.5,
          children: secondary.map((k) => _buildSmallTile(
            label: k.label, value: _si(stats[k.key]),
            icon: k.icon, color: cardColor,
          )).toList(),
        )),
      ]),

      const SizedBox(height: 14),

      // ── Evolution chart ──────────────────────────────────────────────────────
      _buildEvolution(stats, chartStats, curStat, curColor),

      const SizedBox(height: 12),

      // ── Discipline + temps de jeu ────────────────────────────────────────────
      Row(children: [
        _buildDisciplineChip(Icons.warning_rounded, const Color(0xFFF59E0B), 'Jaunes',  _si(stats['yellowCards'])),
        const SizedBox(width: 8),
        _buildDisciplineChip(Icons.dangerous,       const Color(0xFFEF4444), 'Rouges',  _si(stats['redCards'])),
        const Spacer(),
        _buildDisciplineChip(Icons.timer_outlined,  cardColor,               'Minutes', _si(stats['minutesPlayed'])),
        const SizedBox(width: 8),
        _buildDisciplineChip(Icons.sports,          cardColor,               'Matchs',  _si(stats['matchesPlayed'])),
      ]),
    ]);
  }

  int _si(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  Widget _buildKpiTile({required String label, required int value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color, height: 1.1)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[500]),
            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _buildSmallTile({required String label, required int value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('$value', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A), height: 1.1)),
          Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[500]),
              overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }

  Widget _buildDisciplineChip(IconData icon, Color color, String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$value', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color, height: 1.1)),
          Text(label, style: TextStyle(fontSize: 9, color: color.withOpacity(0.7))),
        ]),
      ]),
    );
  }

  Widget _buildEvolution(Map<String, dynamic> stats,
      List<Map<String, dynamic>> chartStats, String curStat, Color curColor) {
    final total = _si(stats[curStat]);
    final spots = List.generate(6, (i) {
      final v = i < 5
          ? (total * (i + 1) / 6.0 * (0.5 + (i * 13 + total) % 7 / 10.0))
          : total.toDouble();
      return FlSpot(i.toDouble(), v.clamp(0, (total + 1).toDouble()));
    });
    final maxY = (total + 2).toDouble().clamp(3.0, double.infinity);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.show_chart, size: 14, color: Color(0xFF64748B)),
          const SizedBox(width: 6),
          const Text('ÉVOLUTION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              color: Color(0xFF64748B), letterSpacing: 0.5)),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: chartStats.map((s) {
              final key = s['key'] as String;
              final c   = s['color'] as Color;
              final sel = key == curStat;
              return GestureDetector(
                onTap: () => setState(() => _selectedChartStat = key),
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: sel ? c : c.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: sel ? c : c.withOpacity(0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(s['icon'] as IconData, size: 11, color: sel ? Colors.white : c),
                    const SizedBox(width: 4),
                    Text(s['name'] as String, style: TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w600, color: sel ? Colors.white : c)),
                  ]),
                ),
              );
            }).toList()),
          ),
        ]),
        const SizedBox(height: 10),
        RichText(text: TextSpan(children: [
          TextSpan(text: '$total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: curColor)),
          TextSpan(text: '  total saison', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ])),
        const SizedBox(height: 10),
        SizedBox(
          height: 90,
          child: LineChart(LineChartData(
            clipData: const FlClipData.all(),
            gridData: FlGridData(show: true, drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade100, strokeWidth: 1)),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles:  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true, reservedSize: 18, interval: 1,
                getTitlesWidget: (v, m) => SideTitleWidget(axisSide: m.axisSide,
                  child: Text('M${v.toInt() + 1}',
                      style: TextStyle(fontSize: 9, color: Colors.grey[400]))),
              )),
            ),
            borderData: FlBorderData(show: false),
            minX: 0, maxX: 5, minY: 0, maxY: maxY,
            lineBarsData: [LineChartBarData(
              spots: spots, isCurved: true,
              color: curColor, barWidth: 2.5, isStrokeCapRound: true,
              dotData: FlDotData(show: true, getDotPainter: (s, _, __, ___) =>
                FlDotCirclePainter(radius: 3.5, color: curColor, strokeWidth: 2, strokeColor: Colors.white)),
              belowBarData: BarAreaData(show: true, gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [curColor.withOpacity(0.14), curColor.withOpacity(0.01)])),
            )],
          )),
        ),
      ]),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: Color(0xFF64748B), letterSpacing: 1.2),
        ),
      ],
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  Widget _infoRow(IconData icon, Color color, String label, String value,
      {Color? valueColor}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 14),
        Text(label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 14, color: valueColor ?? Colors.grey[600])),
      ],
    );
  }
}

// ─── Position helpers (shared) ────────────────────────────────────────────────
enum _PosType { gardien, defenseur, milieu, attaquant, autre }

_PosType _detectPos(String? raw) {
  if (raw == null) return _PosType.autre;
  final p = raw.toLowerCase();
  if (p.contains('gard') || p == 'gk') return _PosType.gardien;
  if (p.contains('def') || p == 'cb' || p == 'lb' || p == 'rb') return _PosType.defenseur;
  if (p.contains('mil') || p == 'cm' || p == 'cdm' || p == 'cam') return _PosType.milieu;
  if (p.contains('att') || p.contains('avant') || p == 'st' || p == 'cf' || p == 'lw' || p == 'rw') return _PosType.attaquant;
  return _PosType.autre;
}

Color _posColorOf(_PosType pos) => const Color(0xFF406A94);

class _KpiDef { final String label; final String key; final IconData icon;
  const _KpiDef(this.label, this.key, this.icon); }

List<_KpiDef> _kpisForPos(_PosType pos) {
  switch (pos) {
    case _PosType.gardien:
      return [_KpiDef('Arrêts','saves',Icons.pan_tool), _KpiDef('Clean sheets','cleanSheets',Icons.verified),
              _KpiDef('Buts enc.','goalsConceded',Icons.sports_soccer), _KpiDef('Pén. arrêtés','penaltiesSaved',Icons.security)];
    case _PosType.defenseur:
      return [_KpiDef('Tacles','tackles',Icons.shield), _KpiDef('Interceptions','interceptions',Icons.pan_tool),
              _KpiDef('Dégagements','clearances',Icons.arrow_upward), _KpiDef('Duels gagnés','duelsWon',Icons.emoji_events)];
    case _PosType.milieu:
      return [_KpiDef('Passes','passes',Icons.swap_horiz), _KpiDef('Passes clés','keyPasses',Icons.star),
              _KpiDef('Passes déc.','assists',Icons.assistant), _KpiDef('Buts','goals',Icons.sports_soccer)];
    case _PosType.attaquant:
    case _PosType.autre:
      return [_KpiDef('Buts','goals',Icons.sports_soccer), _KpiDef('Passes déc.','assists',Icons.assistant),
              _KpiDef('Tirs','shots',Icons.gps_fixed), _KpiDef('Tirs cadrés','shotsOnTarget',Icons.my_location)];
  }
}

List<_KpiDef> _secondaryForPos(_PosType pos) {
  switch (pos) {
    case _PosType.gardien:
      return [_KpiDef('Passes','passes',Icons.swap_horiz), _KpiDef('Passes clés','keyPasses',Icons.star),
              _KpiDef('Dégagements','clearances',Icons.arrow_upward), _KpiDef('Duels aériens','aerialDuelsWon',Icons.flight)];
    case _PosType.defenseur:
      return [_KpiDef('Passes','passes',Icons.swap_horiz), _KpiDef('Buts','goals',Icons.sports_soccer),
              _KpiDef('Duels aériens','aerialDuelsWon',Icons.flight), _KpiDef('Fautes','foulsCommitted',Icons.report_problem)];
    case _PosType.milieu:
      return [_KpiDef('Tacles','tackles',Icons.shield), _KpiDef('Interceptions','interceptions',Icons.pan_tool),
              _KpiDef('Dribbles','dribbles',Icons.directions_run), _KpiDef('Fautes','foulsCommitted',Icons.report_problem)];
    case _PosType.attaquant:
    case _PosType.autre:
      return [_KpiDef('Passes','passes',Icons.swap_horiz), _KpiDef('Dribbles','dribbles',Icons.directions_run),
              _KpiDef('Hors-jeu','offsides',Icons.flag), _KpiDef('Fautes','foulsCommitted',Icons.report_problem)];
  }
}

List<Map<String, dynamic>> _chartStatsForPos(_PosType pos) {
  switch (pos) {
    case _PosType.gardien:
      return [
        {'name':'Arrêts','key':'saves','icon':Icons.pan_tool,'color':const Color(0xFF3B82F6)},
        {'name':'Clean sheets','key':'cleanSheets','icon':Icons.verified,'color':const Color(0xFF10B981)},
        {'name':'Buts enc.','key':'goalsConceded','icon':Icons.sports_soccer,'color':const Color(0xFFEF4444)},
        {'name':'Cartons j.','key':'yellowCards','icon':Icons.warning,'color':const Color(0xFFF59E0B)},
      ];
    case _PosType.defenseur:
      return [
        {'name':'Tacles','key':'tackles','icon':Icons.shield,'color':const Color(0xFF3B82F6)},
        {'name':'Interceptions','key':'interceptions','icon':Icons.pan_tool,'color':const Color(0xFF10B981)},
        {'name':'Buts','key':'goals','icon':Icons.sports_soccer,'color':const Color(0xFF8B5CF6)},
        {'name':'Cartons j.','key':'yellowCards','icon':Icons.warning,'color':const Color(0xFFF59E0B)},
      ];
    case _PosType.milieu:
      return [
        {'name':'Passes','key':'passes','icon':Icons.swap_horiz,'color':const Color(0xFF3B82F6)},
        {'name':'Passes déc.','key':'assists','icon':Icons.assistant,'color':const Color(0xFF10B981)},
        {'name':'Buts','key':'goals','icon':Icons.sports_soccer,'color':const Color(0xFF8B5CF6)},
        {'name':'Cartons j.','key':'yellowCards','icon':Icons.warning,'color':const Color(0xFFF59E0B)},
      ];
    case _PosType.attaquant:
    case _PosType.autre:
      return [
        {'name':'Buts','key':'goals','icon':Icons.sports_soccer,'color':const Color(0xFF10B981)},
        {'name':'Passes déc.','key':'assists','icon':Icons.assistant,'color':const Color(0xFF3B82F6)},
        {'name':'Tirs','key':'shots','icon':Icons.gps_fixed,'color':const Color(0xFF8B5CF6)},
        {'name':'Cartons j.','key':'yellowCards','icon':Icons.warning,'color':const Color(0xFFF59E0B)},
      ];
  }
}

Map<String, double> _radarValuesFor(_PosType pos, Map<String, dynamic> s) {
  int v(String k) { final x = s[k]; if (x == null) return 0; if (x is int) return x; if (x is double) return x.toInt(); return int.tryParse(x.toString()) ?? 0; }
  switch (pos) {
    case _PosType.gardien:
      return {'ARRÊTS':(v('saves')*8.0).clamp(0,99),'CLEAN SH.':(v('cleanSheets')*20.0).clamp(0,99),
              'PASSES':(v('passes')*0.8).clamp(0,99),'RÉFLEXES':(v('saves')*6.0+v('penaltiesSaved')*15.0).clamp(0,99),
              'POSITION':(v('saves')*4.0+v('cleanSheets')*10.0).clamp(0,99),'AÉRIEN':(v('aerialDuelsWon')*8.0+v('clearances')*5.0).clamp(0,99)};
    case _PosType.defenseur:
      return {'TACLES':(v('tackles')*8.0).clamp(0,99),'INTERC.':(v('interceptions')*8.0).clamp(0,99),
              'DÉGAG.':(v('clearances')*6.0).clamp(0,99),'PASSES':(v('passes')*0.5).clamp(0,99),
              'DUELS':(v('duelsWon')*5.0).clamp(0,99),'AÉRIEN':(v('aerialDuelsWon')*8.0).clamp(0,99)};
    case _PosType.milieu:
      return {'PASSES':(v('passes')*0.5).clamp(0,99),'PASSES D.':(v('assists')*15.0+v('keyPasses')*8.0).clamp(0,99),
              'BUTS':(v('goals')*20.0).clamp(0,99),'TACLES':(v('tackles')*8.0).clamp(0,99),
              'DRIBBLES':(v('dribbles')*10.0).clamp(0,99),'PHYSIQUE':(v('minutesPlayed')/10.0).clamp(0,99)};
    case _PosType.attaquant:
    case _PosType.autre:
      return {'BUTS':(v('goals')*20.0).clamp(0,99),'PASSES D.':(v('assists')*15.0).clamp(0,99),
              'TIRS':(v('shots')*5.0+v('shotsOnTarget')*8.0).clamp(0,99),'DRIBBLES':(v('dribbles')*10.0).clamp(0,99),
              'VITESSE':(v('dribbles')*8.0+v('offsides')*3.0).clamp(0,99),'PHYSIQUE':(v('minutesPlayed')/10.0).clamp(0,99)};
  }
}

// ─── Mini radar painter ───────────────────────────────────────────────────────
class _MiniRadarPainter extends CustomPainter {
  final Map<String, double> skills;
  final Color accentColor;
  const _MiniRadarPainter({required this.skills, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 24;
    final n = skills.length;
    final step = 2 * math.pi / n;
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4,
        Paint()..color = Colors.grey.withOpacity(0.12)..style = PaintingStyle.stroke..strokeWidth = 1);
    }
    for (int i = 0; i < n; i++) {
      final a = i * step - math.pi / 2;
      canvas.drawLine(center, Offset(center.dx + radius * math.cos(a), center.dy + radius * math.sin(a)),
        Paint()..color = Colors.grey.withOpacity(0.18)..strokeWidth = 1);
    }
    final pts = <Offset>[];
    for (int i = 0; i < n; i++) {
      final val = (skills.values.elementAt(i) / 100).clamp(0.0, 1.0);
      final a = i * step - math.pi / 2;
      pts.add(Offset(center.dx + radius * val * math.cos(a), center.dy + radius * val * math.sin(a)));
    }
    final path = Path()..addPolygon(pts, true);
    canvas.drawPath(path, Paint()..color = accentColor.withOpacity(0.18)..style = PaintingStyle.fill);
    canvas.drawPath(path, Paint()..color = accentColor..strokeWidth = 1.8..style = PaintingStyle.stroke);
    for (final pt in pts) {
      canvas.drawCircle(pt, 3, Paint()..color = accentColor..style = PaintingStyle.fill);
      canvas.drawCircle(pt, 3, Paint()..color = Colors.white..strokeWidth = 1.5..style = PaintingStyle.stroke);
    }
    for (int i = 0; i < n; i++) {
      final a = i * step - math.pi / 2;
      final lr = radius + 14;
      final lp = Offset(center.dx + lr * math.cos(a), center.dy + lr * math.sin(a));
      final tp = TextPainter(
        text: TextSpan(text: skills.keys.elementAt(i),
          style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 44);
      tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _MiniRadarPainter old) =>
      old.skills != skills || old.accentColor != accentColor;
}
