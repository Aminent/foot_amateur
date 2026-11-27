import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../services/coach_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';

// ─── helpers ──────────────────────────────────────────────────────────────────
int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}

// ─── Position detection ───────────────────────────────────────────────────────
enum _Pos { gardien, defenseur, milieu, attaquant, autre }

_Pos _detectPos(String? raw) {
  if (raw == null) return _Pos.autre;
  final p = raw.toLowerCase();
  if (p.contains('gard') || p == 'gk') return _Pos.gardien;
  if (p.contains('def') || p == 'cb' || p == 'lb' || p == 'rb') return _Pos.defenseur;
  if (p.contains('mil') || p == 'cm' || p == 'cdm' || p == 'cam') return _Pos.milieu;
  if (p.contains('att') || p.contains('avant') || p == 'st' || p == 'cf' || p == 'lw' || p == 'rw') return _Pos.attaquant;
  return _Pos.autre;
}

Color _posColor(_Pos pos) {
  switch (pos) {
    case _Pos.gardien:   return const Color(0xFF3B82F6);
    case _Pos.defenseur: return const Color(0xFF10B981);
    case _Pos.milieu:    return const Color(0xFF8B5CF6);
    case _Pos.attaquant: return const Color(0xFFEF4444);
    case _Pos.autre:     return const Color(0xFF64748B);
  }
}

String _posLabel(_Pos pos) {
  switch (pos) {
    case _Pos.gardien:   return 'Gardien';
    case _Pos.defenseur: return 'Défenseur';
    case _Pos.milieu:    return 'Milieu';
    case _Pos.attaquant: return 'Attaquant';
    case _Pos.autre:     return 'Joueur';
  }
}

IconData _posIcon(_Pos pos) {
  switch (pos) {
    case _Pos.gardien:   return Icons.back_hand_outlined;
    case _Pos.defenseur: return Icons.shield_outlined;
    case _Pos.milieu:    return Icons.compare_arrows;
    case _Pos.attaquant: return Icons.sports_soccer;
    case _Pos.autre:     return Icons.person_outline;
  }
}

// ─── Radar axes per position ──────────────────────────────────────────────────
Map<String, double> _radarValues(_Pos pos, Map<String, dynamic> stats) {
  switch (pos) {
    case _Pos.gardien:
      return {
        'ARRÊTS':    (_toInt(stats['saves']) * 8.0).clamp(0, 99),
        'CLEAN SH.': (_toInt(stats['cleanSheets']) * 20.0).clamp(0, 99),
        'PASSES':    (_toInt(stats['passes']) * 0.8).clamp(0, 99),
        'RÉFLEXES':  (_toInt(stats['saves']) * 6.0 + _toInt(stats['penaltiesSaved']) * 15.0).clamp(0, 99),
        'POSITION':  (_toInt(stats['saves']) * 4.0 + _toInt(stats['cleanSheets']) * 10.0).clamp(0, 99),
        'AÉRIEN':    (_toInt(stats['aerialDuelsWon']) * 8.0 + _toInt(stats['clearances']) * 5.0).clamp(0, 99),
      };
    case _Pos.defenseur:
      return {
        'TACLES':   (_toInt(stats['tackles']) * 8.0).clamp(0, 99),
        'INTERC.':  (_toInt(stats['interceptions']) * 8.0).clamp(0, 99),
        'DÉGAG.':   (_toInt(stats['clearances']) * 6.0).clamp(0, 99),
        'PASSES':   (_toInt(stats['passes']) * 0.5).clamp(0, 99),
        'DUELS':    (_toInt(stats['duelsWon']) * 5.0).clamp(0, 99),
        'AÉRIEN':   (_toInt(stats['aerialDuelsWon']) * 8.0).clamp(0, 99),
      };
    case _Pos.milieu:
      return {
        'PASSES':    (_toInt(stats['passes']) * 0.5).clamp(0, 99),
        'PASSES D.': (_toInt(stats['assists']) * 15.0 + _toInt(stats['keyPasses']) * 8.0).clamp(0, 99),
        'BUTS':      (_toInt(stats['goals']) * 20.0).clamp(0, 99),
        'TACLES':    (_toInt(stats['tackles']) * 8.0).clamp(0, 99),
        'DRIBBLES':  (_toInt(stats['dribbles']) * 10.0).clamp(0, 99),
        'PHYSIQUE':  (_toInt(stats['minutesPlayed']) / 10.0).clamp(0, 99),
      };
    case _Pos.attaquant:
    case _Pos.autre:
      return {
        'BUTS':      (_toInt(stats['goals']) * 20.0).clamp(0, 99),
        'PASSES D.': (_toInt(stats['assists']) * 15.0).clamp(0, 99),
        'TIRS':      (_toInt(stats['shots']) * 5.0 + _toInt(stats['shotsOnTarget']) * 8.0).clamp(0, 99),
        'DRIBBLES':  (_toInt(stats['dribbles']) * 10.0).clamp(0, 99),
        'VITESSE':   (_toInt(stats['dribbles']) * 8.0 + _toInt(stats['offsides']) * 3.0).clamp(0, 99),
        'PHYSIQUE':  (_toInt(stats['minutesPlayed']) / 10.0).clamp(0, 99),
      };
  }
}

// ─── KPI items per position ───────────────────────────────────────────────────
class _KpiDef {
  final String label;
  final String key;
  final IconData icon;
  const _KpiDef(this.label, this.key, this.icon);
}

List<_KpiDef> _kpisForPos(_Pos pos) {
  switch (pos) {
    case _Pos.gardien:
      return [
        _KpiDef('Arrêts',        'saves',          Icons.pan_tool),
        _KpiDef('Clean sheets',  'cleanSheets',    Icons.verified),
        _KpiDef('Buts enc.',     'goalsConceded',  Icons.sports_soccer),
        _KpiDef('Pén. arrêtés', 'penaltiesSaved', Icons.security),
      ];
    case _Pos.defenseur:
      return [
        _KpiDef('Tacles',        'tackles',       Icons.shield),
        _KpiDef('Interceptions', 'interceptions', Icons.pan_tool),
        _KpiDef('Dégagements',   'clearances',    Icons.arrow_upward),
        _KpiDef('Duels gagnés',  'duelsWon',      Icons.emoji_events),
      ];
    case _Pos.milieu:
      return [
        _KpiDef('Passes',       'passes',    Icons.swap_horiz),
        _KpiDef('Passes clés',  'keyPasses', Icons.star),
        _KpiDef('Passes déc.',  'assists',   Icons.assistant),
        _KpiDef('Buts',         'goals',     Icons.sports_soccer),
      ];
    case _Pos.attaquant:
    case _Pos.autre:
      return [
        _KpiDef('Buts',         'goals',         Icons.sports_soccer),
        _KpiDef('Passes déc.',  'assists',       Icons.assistant),
        _KpiDef('Tirs',         'shots',         Icons.gps_fixed),
        _KpiDef('Tirs cadrés',  'shotsOnTarget', Icons.my_location),
      ];
  }
}

// ─── Secondary stats per position ─────────────────────────────────────────────
List<_KpiDef> _secondaryForPos(_Pos pos) {
  switch (pos) {
    case _Pos.gardien:
      return [
        _KpiDef('Passes',       'passes',        Icons.swap_horiz),
        _KpiDef('Passes clés',  'keyPasses',     Icons.star),
        _KpiDef('Dégagements',  'clearances',    Icons.arrow_upward),
        _KpiDef('Duels aériens','aerialDuelsWon',Icons.flight),
      ];
    case _Pos.defenseur:
      return [
        _KpiDef('Passes',       'passes',        Icons.swap_horiz),
        _KpiDef('Buts',         'goals',         Icons.sports_soccer),
        _KpiDef('Duels aériens','aerialDuelsWon',Icons.flight),
        _KpiDef('Fautes',       'foulsCommitted',Icons.report_problem),
      ];
    case _Pos.milieu:
      return [
        _KpiDef('Tacles',       'tackles',       Icons.shield),
        _KpiDef('Interceptions','interceptions', Icons.pan_tool),
        _KpiDef('Dribbles',     'dribbles',      Icons.directions_run),
        _KpiDef('Fautes',       'foulsCommitted',Icons.report_problem),
      ];
    case _Pos.attaquant:
    case _Pos.autre:
      return [
        _KpiDef('Passes',       'passes',    Icons.swap_horiz),
        _KpiDef('Dribbles',     'dribbles',  Icons.directions_run),
        _KpiDef('Hors-jeu',     'offsides',  Icons.flag),
        _KpiDef('Fautes',       'foulsCommitted',Icons.report_problem),
      ];
  }
}

// ─── Chart stat options per position ─────────────────────────────────────────
List<Map<String, dynamic>> _chartStatsForPos(_Pos pos) {
  switch (pos) {
    case _Pos.gardien:
      return [
        {'name': 'Arrêts',       'key': 'saves',        'icon': Icons.pan_tool,    'color': const Color(0xFF3B82F6)},
        {'name': 'Clean sheets', 'key': 'cleanSheets',  'icon': Icons.verified,    'color': const Color(0xFF10B981)},
        {'name': 'Buts enc.',    'key': 'goalsConceded','icon': Icons.sports_soccer,'color': const Color(0xFFEF4444)},
        {'name': 'Cartons j.',   'key': 'yellowCards',  'icon': Icons.warning,     'color': const Color(0xFFF59E0B)},
      ];
    case _Pos.defenseur:
      return [
        {'name': 'Tacles',       'key': 'tackles',      'icon': Icons.shield,      'color': const Color(0xFF3B82F6)},
        {'name': 'Interceptions','key': 'interceptions','icon': Icons.pan_tool,    'color': const Color(0xFF10B981)},
        {'name': 'Buts',         'key': 'goals',        'icon': Icons.sports_soccer,'color': const Color(0xFF8B5CF6)},
        {'name': 'Cartons j.',   'key': 'yellowCards',  'icon': Icons.warning,     'color': const Color(0xFFF59E0B)},
      ];
    case _Pos.milieu:
      return [
        {'name': 'Passes',       'key': 'passes',       'icon': Icons.swap_horiz,  'color': const Color(0xFF3B82F6)},
        {'name': 'Passes déc.',  'key': 'assists',      'icon': Icons.assistant,   'color': const Color(0xFF10B981)},
        {'name': 'Buts',         'key': 'goals',        'icon': Icons.sports_soccer,'color': const Color(0xFF8B5CF6)},
        {'name': 'Cartons j.',   'key': 'yellowCards',  'icon': Icons.warning,     'color': const Color(0xFFF59E0B)},
      ];
    case _Pos.attaquant:
    case _Pos.autre:
      return [
        {'name': 'Buts',         'key': 'goals',        'icon': Icons.sports_soccer,'color': const Color(0xFF10B981)},
        {'name': 'Passes déc.',  'key': 'assists',      'icon': Icons.assistant,   'color': const Color(0xFF3B82F6)},
        {'name': 'Tirs',         'key': 'shots',        'icon': Icons.gps_fixed,   'color': const Color(0xFF8B5CF6)},
        {'name': 'Cartons j.',   'key': 'yellowCards',  'icon': Icons.warning,     'color': const Color(0xFFF59E0B)},
      ];
  }
}

// ─── Page widget ──────────────────────────────────────────────────────────────
class CoachStatsPage extends StatefulWidget {
  final AuthController auth;
  const CoachStatsPage({super.key, required this.auth});

  @override
  State<CoachStatsPage> createState() => _CoachStatsPageState();
}

class _CoachStatsPageState extends State<CoachStatsPage> {
  late CoachService _coachService;
  late Future<List<Map<String, dynamic>>> _future;

  // selectedStat per player id
  final Map<int, String> _selectedStats = {};

  @override
  void initState() {
    super.initState();
    _coachService = CoachService(ApiClient(token: widget.auth.token));
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() async {
    final teamData = await _coachService.getMyTeam();
    final players  = (teamData['players'] as List<dynamic>? ?? []);
    final result   = <Map<String, dynamic>>[];
    for (final p in players) {
      final pm    = p as Map<String, dynamic>;
      final stats = await _coachService.getPlayerStats(pm['id']);
      result.add({
        'id':           pm['id'],
        'name':         pm['name'] ?? 'Joueur',
        'position':     pm['position'] ?? '',
        'jerseyNumber': pm['jerseyNumber'],
        'isCaptain':    pm['isCaptain'] == true,
        'stats':        stats,
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Statistiques des Joueurs'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() { _future = _load(); }),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF55C1CF)));
          }
          if (snap.hasError) {
            return AppErrorWidget(
              message: snap.error.toString(),
              onRetry: () => setState(() { _future = _load(); }),
            );
          }

          final players = snap.data ?? [];
          if (players.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Lottie.asset('assets/empty_state.json', width: 150, height: 150),
              const SizedBox(height: 16),
              Text('Aucune statistique disponible',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Text('Les stats apparaîtront après les matchs',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ]));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) return _TeamSummaryCard(players: players);
              final p = players[i - 1];
              return _PlayerCard(
                player: p,
                selectedStat: _selectedStats[p['id'] as int],
                onStatChanged: (key) => setState(() {
                  _selectedStats[p['id'] as int] = key;
                }),
              );
            },
          );
        },
      ),
    );
  }
}

// ─── Team summary card ────────────────────────────────────────────────────────
class _TeamSummaryCard extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  const _TeamSummaryCard({required this.players});

  @override
  Widget build(BuildContext context) {
    // Aggregate team stats
    int totalGoals = 0, totalAssists = 0, totalYellow = 0, totalRed = 0, totalMinutes = 0;
    final scorers  = <Map<String, dynamic>>[];
    final assisters = <Map<String, dynamic>>[];

    for (final p in players) {
      final s = p['stats'] as Map<String, dynamic>? ?? {};
      final goals   = _toInt(s['goals']);
      final assists = _toInt(s['assists']);
      totalGoals   += goals;
      totalAssists += assists;
      totalYellow  += _toInt(s['yellowCards']);
      totalRed     += _toInt(s['redCards']);
      totalMinutes += _toInt(s['minutesPlayed']);
      if (goals > 0)   scorers.add({'name': p['name'] ?? '?', 'value': goals});
      if (assists > 0) assisters.add({'name': p['name'] ?? '?', 'value': assists});
    }

    scorers.sort((a, b) => (b['value'] as int).compareTo(a['value'] as int));
    assisters.sort((a, b) => (b['value'] as int).compareTo(a['value'] as int));

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF0F172A).withOpacity(0.12), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: const Color(0xFF55C1CF).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.bar_chart_rounded, color: Color(0xFF55C1CF), size: 24),
            ),
            const SizedBox(width: 12),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Résumé de l\'équipe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              Text('Vue d\'ensemble de la saison', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ]),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── 4 KPIs ──────────────────────────────────────────────────────
            Row(children: [
              _SummaryKpi(icon: Icons.sports_soccer, color: const Color(0xFF16A34A), label: 'Buts', value: totalGoals),
              const SizedBox(width: 8),
              _SummaryKpi(icon: Icons.assistant, color: const Color(0xFF3B82F6), label: 'Passes D.', value: totalAssists),
              const SizedBox(width: 8),
              _SummaryKpi(icon: Icons.warning_rounded, color: const Color(0xFFF59E0B), label: 'Jaunes', value: totalYellow),
              const SizedBox(width: 8),
              _SummaryKpi(icon: Icons.dangerous, color: const Color(0xFFEF4444), label: 'Rouges', value: totalRed),
            ]),

            const SizedBox(height: 14),

            // ── Top scorers ──────────────────────────────────────────────────
            if (scorers.isNotEmpty) ...[
              _subHeader('⚽ Meilleurs buteurs'),
              const SizedBox(height: 8),
              ...scorers.take(3).toList().asMap().entries.map((e) =>
                _RankRow(rank: e.key + 1, name: e.value['name'] as String, value: e.value['value'] as int, label: 'but${(e.value['value'] as int) > 1 ? 's' : ''}', color: const Color(0xFF16A34A)),
              ),
              const SizedBox(height: 12),
            ],

            // ── Top assisters ─────────────────────────────────────────────────
            if (assisters.isNotEmpty) ...[
              _subHeader('🎯 Meilleurs passeurs'),
              const SizedBox(height: 8),
              ...assisters.take(3).toList().asMap().entries.map((e) =>
                _RankRow(rank: e.key + 1, name: e.value['name'] as String, value: e.value['value'] as int, label: 'passe${(e.value['value'] as int) > 1 ? 's' : ''} déc.', color: const Color(0xFF3B82F6)),
              ),
              const SizedBox(height: 4),
            ],

            // ── Minutes total ─────────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(children: [
                const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Text('Total minutes jouées cette saison : ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text('$totalMinutes min', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _subHeader(String text) => Text(text,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.3));
}

class _SummaryKpi extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int value;
  const _SummaryKpi({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.07), borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(height: 4),
      Text('$value', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color, height: 1.1)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[500]), textAlign: TextAlign.center),
    ]),
  ));
}

class _RankRow extends StatelessWidget {
  final int rank, value;
  final String name, label;
  final Color color;
  const _RankRow({required this.rank, required this.name, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Container(
          width: 22, height: 22,
          decoration: BoxDecoration(
            color: rank == 1 ? const Color(0xFFF59E0B) : rank == 2 ? const Color(0xFF9CA3AF) : const Color(0xFFB45309),
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('$rank', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: Text('$value $label', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

// ─── Player card ──────────────────────────────────────────────────────────────
class _PlayerCard extends StatelessWidget {
  final Map<String, dynamic> player;
  final String? selectedStat;
  final ValueChanged<String> onStatChanged;

  const _PlayerCard({
    required this.player,
    required this.selectedStat,
    required this.onStatChanged,
  });

  @override
  Widget build(BuildContext context) {
    final stats      = player['stats'] as Map<String, dynamic>? ?? {};
    final pos        = _detectPos(player['position'] as String?);
    final posColor   = _posColor(pos);
    final chartStats = _chartStatsForPos(pos);
    final curStat    = selectedStat ?? chartStats[0]['key'] as String;
    final curColor   = (chartStats.firstWhere((s) => s['key'] == curStat,
        orElse: () => chartStats[0])['color']) as Color;
    final kpis       = _kpisForPos(pos);
    final secondary  = _secondaryForPos(pos);
    final radarData  = _radarValues(pos, stats);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        border: Border.all(color: posColor.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(color: posColor.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 6)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Header ─────────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF0F172A), Color.lerp(const Color(0xFF0F172A), posColor, 0.25)!],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(children: [
            // Jersey badge
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: posColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: posColor.withOpacity(0.4)),
              ),
              child: Center(child: Stack(alignment: Alignment.center, children: [
                Text(
                  player['jerseyNumber']?.toString() ?? '?',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: posColor),
                ),
                if (player['isCaptain'] == true)
                  Positioned(top: 2, right: 2,
                    child: Icon(Icons.star, size: 11, color: Colors.amber[400])),
              ])),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(
                  player['name'] ?? 'Joueur',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                )),
                if (player['isCaptain'] == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.star, size: 10, color: Colors.amber),
                      SizedBox(width: 3),
                      Text('Capitaine', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.w700)),
                    ]),
                  ),
              ]),
              const SizedBox(height: 5),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: posColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: posColor.withOpacity(0.4)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(_posIcon(pos), size: 11, color: posColor),
                    const SizedBox(width: 4),
                    Text(_posLabel(pos), style: TextStyle(color: posColor, fontSize: 11, fontWeight: FontWeight.w700)),
                  ]),
                ),
                const SizedBox(width: 8),
                Text('${_toInt(stats['matchesPlayed'])} matchs · ${_toInt(stats['minutesPlayed'])} min',
                    style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ]),
            ])),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── KPI row (4 primary stats) ───────────────────────────────────────
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.9,
              children: kpis.map((k) => _KpiTile(
                label: k.label,
                value: _toInt(stats[k.key]),
                icon: k.icon,
                color: posColor,
              )).toList(),
            ),

            const SizedBox(height: 14),

            // ── Radar + secondary stats ─────────────────────────────────────────
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Radar chart
              Container(
                width: 155, height: 155,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: posColor.withOpacity(0.15)),
                ),
                child: CustomPaint(
                  size: const Size(155, 155),
                  painter: _RadarPainter(skills: radarData, accentColor: posColor),
                ),
              ),

              const SizedBox(width: 12),

              // Secondary stats
              Expanded(child: Column(children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.5,
                  children: secondary.map((k) => _SmallStatTile(
                    label: k.label,
                    value: _toInt(stats[k.key]),
                    icon: k.icon,
                    color: posColor,
                  )).toList(),
                ),
              ])),
            ]),

            const SizedBox(height: 14),
            // ── Evolution chart ─────────────────────────────────────────────────
            _EvolutionSection(
              stats: stats,
              chartStats: chartStats,
              selectedKey: curStat,
              selectedColor: curColor,
              onChanged: onStatChanged,
            ),

            const SizedBox(height: 12),

            // ── Discipline & temps de jeu ───────────────────────────────────────
            Row(children: [
              _DisciplineChip(
                icon: Icons.warning_rounded,
                color: const Color(0xFFF59E0B),
                label: 'Jaunes',
                value: _toInt(stats['yellowCards']),
              ),
              const SizedBox(width: 8),
              _DisciplineChip(
                icon: Icons.dangerous,
                color: const Color(0xFFEF4444),
                label: 'Rouges',
                value: _toInt(stats['redCards']),
              ),
              const Spacer(),
              _DisciplineChip(
                icon: Icons.timer_outlined,
                color: posColor,
                label: 'Minutes',
                value: _toInt(stats['minutesPlayed']),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }
}

// ─── KPI tile ─────────────────────────────────────────────────────────────────
class _KpiTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _KpiTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color, height: 1.1)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[500], height: 1.1),
            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}

// ─── Small stat tile ──────────────────────────────────────────────────────────
class _SmallStatTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _SmallStatTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
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
          Text('$value', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
              color: AppColors.textPrimary, height: 1.1)),
          Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[500]),
              overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }
}

// ─── Discipline chip ──────────────────────────────────────────────────────────
class _DisciplineChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int value;
  const _DisciplineChip({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$value', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color, height: 1.1)),
          Text(label, style: TextStyle(fontSize: 9, color: color.withOpacity(0.7))),
        ]),
      ]),
    );
  }
}

// ─── Evolution section ────────────────────────────────────────────────────────
class _EvolutionSection extends StatelessWidget {
  final Map<String, dynamic> stats;
  final List<Map<String, dynamic>> chartStats;
  final String selectedKey;
  final Color selectedColor;
  final ValueChanged<String> onChanged;

  const _EvolutionSection({
    required this.stats,
    required this.chartStats,
    required this.selectedKey,
    required this.selectedColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Courbe réelle : cumul match par match (faits saisis), 8 derniers matchs joués
    final total = _toInt(stats[selectedKey]);
    final perMatch = (stats['perMatchStats'] as List? ?? [])
        .whereType<Map>()
        .toList();
    final supported = perMatch.isNotEmpty && perMatch.first.containsKey(selectedKey);
    final spots = <FlSpot>[];
    if (supported) {
      var cum = 0;
      final cumul = perMatch.map((m) => cum += _toInt(m[selectedKey])).toList();
      final last = cumul.length > 8 ? cumul.sublist(cumul.length - 8) : cumul;
      for (var i = 0; i < last.length; i++) {
        spots.add(FlSpot(i.toDouble(), last[i].toDouble()));
      }
    }
    final maxY = ((spots.isEmpty ? total : spots.last.y.toInt()) + 2).toDouble().clamp(3.0, double.infinity);
    final firstMatchNo = supported && perMatch.length > 8 ? perMatch.length - 8 : 0;

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
        // Header + chips
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
              final sel = key == selectedKey;
              return GestureDetector(
                onTap: () => onChanged(key),
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
                    Text(s['name'] as String, style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600,
                        color: sel ? Colors.white : c)),
                  ]),
                ),
              );
            }).toList()),
          ),
        ]),
        const SizedBox(height: 12),

        // Total label
        RichText(text: TextSpan(children: [
          TextSpan(text: '$total', style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: selectedColor)),
          TextSpan(text: '  total saison', style: TextStyle(
              fontSize: 11, color: Colors.grey[500])),
        ])),

        const SizedBox(height: 10),

        if (spots.isEmpty)
          SizedBox(
            height: 60,
            child: Center(child: Text(
              perMatch.isEmpty ? "Aucun match joué pour l'instant" : 'Pas de détail par match pour cette statistique',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            )),
          )
        else
        SizedBox(
          height: 100,
          child: LineChart(LineChartData(
            clipData: const FlClipData.all(),
            gridData: FlGridData(
              show: true, drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true, reservedSize: 20, interval: 1,
                getTitlesWidget: (v, m) => SideTitleWidget(axisSide: m.axisSide,
                  child: Text('M${firstMatchNo + v.toInt() + 1}',
                      style: TextStyle(fontSize: 9, color: Colors.grey[400]))),
              )),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            minX: 0, maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1, minY: 0, maxY: maxY,
            lineBarsData: [LineChartBarData(
              spots: spots,
              isCurved: true,
              color: selectedColor,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true, getDotPainter: (s, _, __, ___) =>
                FlDotCirclePainter(radius: 3.5, color: selectedColor, strokeWidth: 2, strokeColor: Colors.white)),
              belowBarData: BarAreaData(show: true, gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [selectedColor.withOpacity(0.15), selectedColor.withOpacity(0.01)],
              )),
            )],
          )),
        ),
      ]),
    );
  }
}

// ─── Radar painter ────────────────────────────────────────────────────────────
class _RadarPainter extends CustomPainter {
  final Map<String, double> skills;
  final Color accentColor;
  const _RadarPainter({required this.skills, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center    = Offset(size.width / 2, size.height / 2);
    final radius    = size.width / 2 - 28;
    final n         = skills.length;
    final step      = 2 * math.pi / n;

    // Background rings
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4,
        Paint()..color = Colors.grey.withOpacity(0.12)..style = PaintingStyle.stroke..strokeWidth = 1);
    }
    // Axes
    for (int i = 0; i < n; i++) {
      final a = i * step - math.pi / 2;
      canvas.drawLine(center,
        Offset(center.dx + radius * math.cos(a), center.dy + radius * math.sin(a)),
        Paint()..color = Colors.grey.withOpacity(0.2)..strokeWidth = 1);
    }

    // Data polygon
    final pts = <Offset>[];
    for (int i = 0; i < n; i++) {
      final val = (skills.values.elementAt(i) / 100).clamp(0.0, 1.0);
      final a   = i * step - math.pi / 2;
      pts.add(Offset(center.dx + radius * val * math.cos(a), center.dy + radius * val * math.sin(a)));
    }
    final path = Path()..addPolygon(pts, true);
    canvas.drawPath(path, Paint()..color = accentColor.withOpacity(0.18)..style = PaintingStyle.fill);
    canvas.drawPath(path, Paint()..color = accentColor..strokeWidth = 1.8..style = PaintingStyle.stroke);

    for (final pt in pts) {
      canvas.drawCircle(pt, 3.5, Paint()..color = accentColor..style = PaintingStyle.fill);
      canvas.drawCircle(pt, 3.5, Paint()..color = Colors.white..strokeWidth = 1.5..style = PaintingStyle.stroke);
    }

    // Labels
    for (int i = 0; i < n; i++) {
      final a   = i * step - math.pi / 2;
      final lr  = radius + 16;
      final lp  = Offset(center.dx + lr * math.cos(a), center.dy + lr * math.sin(a));
      final tp  = TextPainter(
        text: TextSpan(text: skills.keys.elementAt(i),
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        textDirection: TextDirection.ltr, textAlign: TextAlign.center,
      )..layout(maxWidth: 50);
      tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.skills != skills || old.accentColor != accentColor;
}
