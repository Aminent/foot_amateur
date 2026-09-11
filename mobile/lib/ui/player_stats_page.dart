import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../services/player_service.dart';
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

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

// ─── Position detection ───────────────────────────────────────────────────────
enum PlayerPosition { gardien, defenseur, milieu, attaquant, autre }

PlayerPosition _detectPosition(String? pos) {
  if (pos == null) return PlayerPosition.autre;
  final p = pos.toLowerCase();
  if (p.contains('gard') || p == 'gk' || p == 'goalkeeper') return PlayerPosition.gardien;
  if (p.contains('def') || p == 'cb' || p == 'lb' || p == 'rb' || p == 'rwb' || p == 'lwb') return PlayerPosition.defenseur;
  if (p.contains('mil') || p == 'cm' || p == 'cdm' || p == 'cam' || p == 'lm' || p == 'rm' || p == 'dm') return PlayerPosition.milieu;
  if (p.contains('att') || p.contains('avant') || p == 'st' || p == 'cf' || p == 'lw' || p == 'rw' || p == 'ss') return PlayerPosition.attaquant;
  return PlayerPosition.autre;
}

// ─── Position-specific stat chips for line chart ──────────────────────────────
List<Map<String, dynamic>> _chartStatsForPosition(PlayerPosition pos) {
  switch (pos) {
    case PlayerPosition.gardien:
      return [
        {'key': 'saves',        'name': 'Arrêts',      'color': const Color(0xFF3B82F6)},
        {'key': 'cleanSheets',  'name': 'Clean sheets','color': const Color(0xFF10B981)},
        {'key': 'goalsConceded','name': 'Buts encaissés','color': const Color(0xFFEF4444)},
        {'key': 'yellowCards',  'name': 'Cartons j.',  'color': const Color(0xFFF59E0B)},
      ];
    case PlayerPosition.defenseur:
      return [
        {'key': 'tackles',      'name': 'Tacles',      'color': const Color(0xFF3B82F6)},
        {'key': 'interceptions','name': 'Interceptions','color': const Color(0xFF10B981)},
        {'key': 'goals',        'name': 'Buts',        'color': const Color(0xFF8B5CF6)},
        {'key': 'yellowCards',  'name': 'Cartons j.',  'color': const Color(0xFFF59E0B)},
      ];
    case PlayerPosition.milieu:
      return [
        {'key': 'passes',       'name': 'Passes',      'color': const Color(0xFF3B82F6)},
        {'key': 'assists',      'name': 'Passes déc.', 'color': const Color(0xFF10B981)},
        {'key': 'goals',        'name': 'Buts',        'color': const Color(0xFF8B5CF6)},
        {'key': 'yellowCards',  'name': 'Cartons j.',  'color': const Color(0xFFF59E0B)},
      ];
    case PlayerPosition.attaquant:
    case PlayerPosition.autre:
      return [
        {'key': 'goals',        'name': 'Buts',        'color': const Color(0xFF10B981)},
        {'key': 'assists',      'name': 'Passes déc.', 'color': const Color(0xFF3B82F6)},
        {'key': 'shots',        'name': 'Tirs',        'color': const Color(0xFF8B5CF6)},
        {'key': 'yellowCards',  'name': 'Cartons j.',  'color': const Color(0xFFF59E0B)},
      ];
  }
}

// ─── Radar axes per position ──────────────────────────────────────────────────
List<String> _radarLabelsForPosition(PlayerPosition pos) {
  switch (pos) {
    case PlayerPosition.gardien:
      return ['ARRÊTS', 'CLEAN\nSHEETS', 'PASSES', 'RÉFLEXES', 'POSITION', 'AÉRIEN'];
    case PlayerPosition.defenseur:
      return ['TACLES', 'INTERC.', 'DÉGAG.', 'PASSES', 'DUELS', 'AÉRIEN'];
    case PlayerPosition.milieu:
      return ['PASSES', 'PASSES D.', 'BUTS', 'TACLES', 'DRIBBLES', 'PHYSIQUE'];
    case PlayerPosition.attaquant:
    case PlayerPosition.autre:
      return ['BUTS', 'PASSES D.', 'TIRS', 'DRIBBLES', 'VITESSE', 'PHYSIQUE'];
  }
}

Map<String, double> _radarValuesForPosition(PlayerPosition pos, Map<String, dynamic> stats) {
  switch (pos) {
    case PlayerPosition.gardien:
      return {
        'ARRÊTS':       (_toInt(stats['saves']) * 8.0).clamp(0, 99),
        'CLEAN\nSHEETS':(_toInt(stats['cleanSheets']) * 20.0).clamp(0, 99),
        'PASSES':       (_toInt(stats['passes']) * 0.8).clamp(0, 99),
        'RÉFLEXES':     (_toInt(stats['saves']) * 6.0 + _toInt(stats['penaltiesSaved']) * 15.0).clamp(0, 99),
        'POSITION':     (_toInt(stats['saves']) * 4.0 + _toInt(stats['cleanSheets']) * 10.0).clamp(0, 99),
        'AÉRIEN':       (_toInt(stats['aerialDuelsWon']) * 8.0 + _toInt(stats['clearances']) * 5.0).clamp(0, 99),
      };
    case PlayerPosition.defenseur:
      return {
        'TACLES':   (_toInt(stats['tackles']) * 8.0).clamp(0, 99),
        'INTERC.':  (_toInt(stats['interceptions']) * 8.0).clamp(0, 99),
        'DÉGAG.':   (_toInt(stats['clearances']) * 6.0).clamp(0, 99),
        'PASSES':   (_toInt(stats['passes']) * 0.5).clamp(0, 99),
        'DUELS':    (_toInt(stats['duelsWon']) * 5.0).clamp(0, 99),
        'AÉRIEN':   (_toInt(stats['aerialDuelsWon']) * 8.0).clamp(0, 99),
      };
    case PlayerPosition.milieu:
      return {
        'PASSES':    (_toInt(stats['passes']) * 0.5).clamp(0, 99),
        'PASSES D.': (_toInt(stats['assists']) * 15.0 + _toInt(stats['keyPasses']) * 8.0).clamp(0, 99),
        'BUTS':      (_toInt(stats['goals']) * 20.0).clamp(0, 99),
        'TACLES':    (_toInt(stats['tackles']) * 8.0).clamp(0, 99),
        'DRIBBLES':  (_toInt(stats['dribbles']) * 10.0).clamp(0, 99),
        'PHYSIQUE':  (_toInt(stats['minutesPlayed']) / 10.0).clamp(0, 99),
      };
    case PlayerPosition.attaquant:
    case PlayerPosition.autre:
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

// ─── Header key stats per position ───────────────────────────────────────────
List<Map<String, dynamic>> _headerStatsForPosition(PlayerPosition pos, Map<String, dynamic> stats) {
  switch (pos) {
    case PlayerPosition.gardien:
      return [
        {'label': 'Arrêts',        'value': _toInt(stats['saves']).toString(),       'icon': Icons.pan_tool, 'color': const Color(0xFF3B82F6)},
        {'label': 'Clean sheets',  'value': _toInt(stats['cleanSheets']).toString(),  'icon': Icons.shield, 'color': const Color(0xFF10B981)},
        {'label': 'Matchs',        'value': _toInt(stats['matchesPlayed']).toString(),'icon': Icons.sports, 'color': const Color(0xFFF59E0B)},
        {'label': 'Pénaltys arr.', 'value': _toInt(stats['penaltiesSaved']).toString(),'icon': Icons.security,'color': const Color(0xFF8B5CF6)},
      ];
    case PlayerPosition.defenseur:
      return [
        {'label': 'Tacles',      'value': _toInt(stats['tackles']).toString(),      'icon': Icons.sports_soccer, 'color': const Color(0xFF3B82F6)},
        {'label': 'Interceptions','value': _toInt(stats['interceptions']).toString(),'icon': Icons.pan_tool,      'color': const Color(0xFF10B981)},
        {'label': 'Matchs',      'value': _toInt(stats['matchesPlayed']).toString(),'icon': Icons.sports,        'color': const Color(0xFFF59E0B)},
        {'label': 'Duels gagnés','value': _toInt(stats['duelsWon']).toString(),     'icon': Icons.emoji_events,  'color': const Color(0xFF8B5CF6)},
      ];
    case PlayerPosition.milieu:
      return [
        {'label': 'Passes',      'value': _toInt(stats['passes']).toString(),   'icon': Icons.swap_horiz,   'color': const Color(0xFF3B82F6)},
        {'label': 'Passes déc.', 'value': _toInt(stats['assists']).toString(),  'icon': Icons.share,        'color': const Color(0xFF10B981)},
        {'label': 'Buts',        'value': _toInt(stats['goals']).toString(),    'icon': Icons.sports_soccer,'color': const Color(0xFF8B5CF6)},
        {'label': 'Matchs',      'value': _toInt(stats['matchesPlayed']).toString(),'icon': Icons.sports,  'color': const Color(0xFFF59E0B)},
      ];
    case PlayerPosition.attaquant:
    case PlayerPosition.autre:
      return [
        {'label': 'Buts',        'value': _toInt(stats['goals']).toString(),    'icon': Icons.sports_soccer,'color': const Color(0xFF10B981)},
        {'label': 'Passes déc.', 'value': _toInt(stats['assists']).toString(),  'icon': Icons.share,        'color': const Color(0xFF3B82F6)},
        {'label': 'Matchs',      'value': _toInt(stats['matchesPlayed']).toString(),'icon': Icons.sports,  'color': const Color(0xFFF59E0B)},
        {'label': 'Tirs cadrés', 'value': _toInt(stats['shotsOnTarget']).toString(),'icon': Icons.gps_fixed,'color': const Color(0xFFEF4444)},
      ];
  }
}

// ─── Stat sections per position ───────────────────────────────────────────────
class _StatDef {
  final String label;
  final String key;
  final IconData icon;
  const _StatDef(this.label, this.key, this.icon);
}

List<Map<String, dynamic>> _sectionsForPosition(PlayerPosition pos) {
  switch (pos) {
    case PlayerPosition.gardien:
      return [
        {
          'title': 'Gardiennage',
          'icon': Icons.shield,
          'color': const Color(0xFF3B82F6),
          'stats': [
            _StatDef('Arrêts', 'saves', Icons.pan_tool),
            _StatDef('Clean sheets', 'cleanSheets', Icons.verified),
            _StatDef('Buts encaissés', 'goalsConceded', Icons.sports_soccer),
            _StatDef('Pénaltys arrêtés', 'penaltiesSaved', Icons.security),
          ],
        },
        {
          'title': 'Jeu au pied',
          'icon': Icons.swap_horiz,
          'color': const Color(0xFF10B981),
          'stats': [
            _StatDef('Passes', 'passes', Icons.swap_horiz),
            _StatDef('Passes clés', 'keyPasses', Icons.star),
            _StatDef('Dégagements', 'clearances', Icons.clear),
          ],
        },
        {
          'title': 'Jeu aérien',
          'icon': Icons.flight,
          'color': const Color(0xFF8B5CF6),
          'stats': [
            _StatDef('Duels aériens gagnés', 'aerialDuelsWon', Icons.flight),
          ],
        },
        {
          'title': 'Discipline',
          'icon': Icons.gavel,
          'color': const Color(0xFFF59E0B),
          'stats': [
            _StatDef('Cartons jaunes', 'yellowCards', Icons.warning),
            _StatDef('Cartons rouges', 'redCards', Icons.dangerous),
          ],
        },
      ];
    case PlayerPosition.defenseur:
      return [
        {
          'title': 'Défense',
          'icon': Icons.shield,
          'color': const Color(0xFF3B82F6),
          'stats': [
            _StatDef('Tacles', 'tackles', Icons.sports_soccer),
            _StatDef('Interceptions', 'interceptions', Icons.pan_tool),
            _StatDef('Dégagements', 'clearances', Icons.clear),
            _StatDef('Duels gagnés', 'duelsWon', Icons.emoji_events),
          ],
        },
        {
          'title': 'Jeu aérien',
          'icon': Icons.flight,
          'color': const Color(0xFF8B5CF6),
          'stats': [
            _StatDef('Duels aériens gagnés', 'aerialDuelsWon', Icons.flight),
          ],
        },
        {
          'title': 'Passes',
          'icon': Icons.swap_horiz,
          'color': const Color(0xFF10B981),
          'stats': [
            _StatDef('Passes', 'passes', Icons.swap_horiz),
            _StatDef('Passes clés', 'keyPasses', Icons.star),
          ],
        },
        {
          'title': 'Attaque',
          'icon': Icons.trending_up,
          'color': const Color(0xFF10B981),
          'stats': [
            _StatDef('Buts', 'goals', Icons.sports_soccer),
            _StatDef('Passes déc.', 'assists', Icons.share),
          ],
        },
        {
          'title': 'Fautes',
          'icon': Icons.report_problem,
          'color': const Color(0xFFEF4444),
          'stats': [
            _StatDef('Fautes commises', 'foulsCommitted', Icons.report_problem),
            _StatDef('Fautes subies', 'foulsSuffered', Icons.person_off),
          ],
        },
        {
          'title': 'Discipline',
          'icon': Icons.gavel,
          'color': const Color(0xFFF59E0B),
          'stats': [
            _StatDef('Cartons jaunes', 'yellowCards', Icons.warning),
            _StatDef('Cartons rouges', 'redCards', Icons.dangerous),
          ],
        },
      ];
    case PlayerPosition.milieu:
      return [
        {
          'title': 'Passes',
          'icon': Icons.swap_horiz,
          'color': const Color(0xFF3B82F6),
          'stats': [
            _StatDef('Passes', 'passes', Icons.swap_horiz),
            _StatDef('Passes clés', 'keyPasses', Icons.star),
            _StatDef('Passes déc.', 'assists', Icons.share),
          ],
        },
        {
          'title': 'Attaque',
          'icon': Icons.trending_up,
          'color': const Color(0xFF10B981),
          'stats': [
            _StatDef('Buts', 'goals', Icons.sports_soccer),
            _StatDef('Tirs', 'shots', Icons.gps_fixed),
            _StatDef('Tirs cadrés', 'shotsOnTarget', Icons.my_location),
            _StatDef('Dribbles', 'dribbles', Icons.directions_run),
          ],
        },
        {
          'title': 'Défense',
          'icon': Icons.shield,
          'color': const Color(0xFF8B5CF6),
          'stats': [
            _StatDef('Tacles', 'tackles', Icons.sports_soccer),
            _StatDef('Interceptions', 'interceptions', Icons.pan_tool),
          ],
        },
        {
          'title': 'Fautes',
          'icon': Icons.report_problem,
          'color': const Color(0xFFEF4444),
          'stats': [
            _StatDef('Fautes commises', 'foulsCommitted', Icons.report_problem),
            _StatDef('Fautes subies', 'foulsSuffered', Icons.person_off),
          ],
        },
        {
          'title': 'Discipline',
          'icon': Icons.gavel,
          'color': const Color(0xFFF59E0B),
          'stats': [
            _StatDef('Cartons jaunes', 'yellowCards', Icons.warning),
            _StatDef('Cartons rouges', 'redCards', Icons.dangerous),
          ],
        },
      ];
    case PlayerPosition.attaquant:
    case PlayerPosition.autre:
      return [
        {
          'title': 'Attaque',
          'icon': Icons.trending_up,
          'color': const Color(0xFF10B981),
          'stats': [
            _StatDef('Buts', 'goals', Icons.sports_soccer),
            _StatDef('Passes déc.', 'assists', Icons.share),
            _StatDef('Tirs', 'shots', Icons.gps_fixed),
            _StatDef('Tirs cadrés', 'shotsOnTarget', Icons.my_location),
            _StatDef('Dribbles', 'dribbles', Icons.directions_run),
            _StatDef('Hors-jeu', 'offsides', Icons.flag),
          ],
        },
        {
          'title': 'Passes',
          'icon': Icons.swap_horiz,
          'color': const Color(0xFF3B82F6),
          'stats': [
            _StatDef('Passes', 'passes', Icons.swap_horiz),
            _StatDef('Passes clés', 'keyPasses', Icons.star),
          ],
        },
        {
          'title': 'Fautes',
          'icon': Icons.report_problem,
          'color': const Color(0xFFEF4444),
          'stats': [
            _StatDef('Fautes commises', 'foulsCommitted', Icons.report_problem),
            _StatDef('Fautes subies', 'foulsSuffered', Icons.person_off),
          ],
        },
        {
          'title': 'Discipline',
          'icon': Icons.gavel,
          'color': const Color(0xFFF59E0B),
          'stats': [
            _StatDef('Cartons jaunes', 'yellowCards', Icons.warning),
            _StatDef('Cartons rouges', 'redCards', Icons.dangerous),
          ],
        },
      ];
  }
}

String _positionLabel(PlayerPosition pos) {
  switch (pos) {
    case PlayerPosition.gardien: return 'Gardien de but';
    case PlayerPosition.defenseur: return 'Défenseur';
    case PlayerPosition.milieu: return 'Milieu de terrain';
    case PlayerPosition.attaquant: return 'Attaquant';
    case PlayerPosition.autre: return 'Joueur';
  }
}

Color _positionColor(PlayerPosition pos) {
  switch (pos) {
    case PlayerPosition.gardien: return const Color(0xFF3B82F6);
    case PlayerPosition.defenseur: return const Color(0xFF10B981);
    case PlayerPosition.milieu: return const Color(0xFF8B5CF6);
    case PlayerPosition.attaquant: return const Color(0xFFEF4444);
    case PlayerPosition.autre: return const Color(0xFF64748B);
  }
}

// ─── Widget ───────────────────────────────────────────────────────────────────
class PlayerStatsPage extends StatefulWidget {
  final AuthController auth;
  final VoidCallback? onBackToProfile;
  const PlayerStatsPage({super.key, required this.auth, this.onBackToProfile});

  @override
  State<PlayerStatsPage> createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {
  late PlayerService _playerService;
  late Future<_StatsData> _future;
  String _selectedStat = 'goals';

  @override
  void initState() {
    super.initState();
    _playerService = PlayerService(ApiClient(token: widget.auth.token));
    _future = _load();
  }

  Future<_StatsData> _load() async {
    final results = await Future.wait([
      _playerService.getMyPlayerProfile(),
      _playerService.getMyStats(),
    ]);
    final profile = results[0] as Map<String, dynamic>;
    final stats   = results[1] as Map<String, dynamic>;
    final posRaw  = profile['player']?['position'] as String?;
    final pos     = _detectPosition(posRaw);
    // Set default selected stat for position
    final chartStats = _chartStatsForPosition(pos);
    return _StatsData(stats: stats, position: pos, positionRaw: posRaw ?? '', chartStats: chartStats);
  }

  // ── Line chart ───────────────────────────────────────────────────────────────
  ({List<FlSpot> spots, List<String> labels, double maxY})
      _buildChartData(List perMatch, String statKey) {
    if (perMatch.isEmpty) {
      return (spots: [const FlSpot(0, 0)], labels: ['M1'], maxY: 4);
    }
    final spots  = <FlSpot>[];
    final labels = <String>[];
    for (int i = 0; i < perMatch.length; i++) {
      final m = perMatch[i] as Map<String, dynamic>;
      spots.add(FlSpot(i.toDouble(), _toInt(m[statKey]).toDouble()));
      final opp = (m['opponent'] as String? ?? '').split(' ').first;
      labels.add('M${i + 1}${opp.isNotEmpty ? '\n$opp' : ''}');
    }
    final maxVal = spots.map((s) => s.y).fold(0.0, math.max);
    final maxY   = maxVal < 1 ? 3.0 : (maxVal + 1).ceilToDouble();
    return (spots: spots, labels: labels, maxY: maxY);
  }

  Widget _buildLineChartSection(Map<String, dynamic> stats, List<Map<String, dynamic>> availableStats) {
    final perMatch = stats['perMatchStats'] as List? ?? [];
    final color     = _chartStatColor(availableStats, _selectedStat);
    final chartData = _buildChartData(perMatch, _selectedStat);
    final spots     = chartData.spots;
    final labels    = chartData.labels;
    final maxY      = chartData.maxY;
    final maxX      = (spots.length - 1).toDouble().clamp(1.0, double.infinity);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(children: [
                  Icon(Icons.show_chart, size: 15, color: Color(0xFF0F172A)),
                  SizedBox(width: 6),
                  Text('PAR MATCH', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ]),
              ),
              const Spacer(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: availableStats.map((s) {
                    final key      = s['key'] as String;
                    final c        = s['color'] as Color;
                    final selected = key == _selectedStat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedStat = key),
                      child: Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: selected ? c : c.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? c : c.withOpacity(0.3)),
                        ),
                        child: Text(s['name'] as String,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : c)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            if (perMatch.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Column(children: [
                  Icon(Icons.bar_chart, size: 40, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text('Aucun match joué pour l\'instant',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                ])),
              )
            else ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  _summaryChip('Total', '${spots.map((s) => s.y).fold(0.0, (a, b) => a + b).toInt()}', color),
                  const SizedBox(width: 8),
                  _summaryChip('Matchs', '${perMatch.length}', const Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  _summaryChip('Moy.', '${(spots.map((s) => s.y).fold(0.0, (a, b) => a + b) / spots.length).toStringAsFixed(1)}', const Color(0xFF8B5CF6)),
                ]),
              ),
              SizedBox(
                height: 200,
                child: LineChart(LineChartData(
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true, drawVerticalLine: false,
                    horizontalInterval: maxY <= 4 ? 1 : (maxY / 4).ceilToDouble(),
                    getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true, reservedSize: 28, interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= labels.length) return const SizedBox();
                        return SideTitleWidget(axisSide: meta.axisSide,
                          child: Text(labels[idx].split('\n').first,
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade500)));
                      },
                    )),
                    leftTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true, reservedSize: 28,
                      interval: maxY <= 4 ? 1 : (maxY / 4).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max) return const SizedBox();
                        return SideTitleWidget(axisSide: meta.axisSide,
                          child: Text(value.toInt().toString(),
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade400)));
                      },
                    )),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF0F172A),
                      getTooltipItems: (touchedSpots) => touchedSpots.map((ts) {
                        final idx    = ts.x.toInt();
                        final opp    = idx < perMatch.length ? (perMatch[idx] as Map)['opponent'] as String? ?? '' : '';
                        final result = idx < perMatch.length ? (perMatch[idx] as Map)['result'] as String? ?? '' : '';
                        final rColor = result == 'V' ? const Color(0xFF10B981) : result == 'D' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
                        return LineTooltipItem(
                          '${ts.y.toInt()} ${_chartStatName(availableStats, _selectedStat)}\n',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          children: [
                            TextSpan(text: 'vs $opp  ', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                            TextSpan(text: result, style: TextStyle(color: rColor, fontWeight: FontWeight.bold, fontSize: 10)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  minX: 0, maxX: maxX, minY: 0, maxY: maxY,
                  lineBarsData: [LineChartBarData(
                    spots: spots, isCurved: spots.length > 2,
                    color: color, barWidth: 2.5, isStrokeCapRound: true,
                    dotData: FlDotData(show: true, getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                      radius: 4, color: spot.y == 0 ? Colors.grey.shade300 : color,
                      strokeWidth: 2, strokeColor: Colors.white,
                    )),
                    belowBarData: BarAreaData(show: true, gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [color.withOpacity(0.15), color.withOpacity(0.01)],
                    )),
                  )],
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 28),
                child: Row(children: List.generate(perMatch.length, (i) {
                  final r = (perMatch[i] as Map)['result'] as String? ?? '';
                  final c = r == 'V' ? const Color(0xFF10B981) : r == 'D' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);
                  return Expanded(child: Center(child: Container(
                    width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle))));
                })),
              ),
              const SizedBox(height: 4),
              Row(children: [
                const SizedBox(width: 28),
                _dot(const Color(0xFF10B981)), const SizedBox(width: 4),
                Text('V', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                const SizedBox(width: 8),
                _dot(const Color(0xFFF59E0B)), const SizedBox(width: 4),
                Text('N', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                const SizedBox(width: 8),
                _dot(const Color(0xFFEF4444)), const SizedBox(width: 4),
                Text('D', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Color _chartStatColor(List<Map<String, dynamic>> list, String key) =>
      (list.firstWhere((s) => s['key'] == key, orElse: () => list[0])['color'] as Color);

  String _chartStatName(List<Map<String, dynamic>> list, String key) =>
      (list.firstWhere((s) => s['key'] == key, orElse: () => list[0])['name'] as String);

  Widget _summaryChip(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: RichText(text: TextSpan(children: [
      TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
      TextSpan(text: ' $label', style: TextStyle(fontSize: 11, color: color.withOpacity(0.7))),
    ])),
  );

  Widget _dot(Color c) => Container(width: 7, height: 7, decoration: BoxDecoration(color: c, shape: BoxShape.circle));

  // ── Radar chart ──────────────────────────────────────────────────────────────
  Widget _buildRadarChartSection(Map<String, dynamic> stats, PlayerPosition pos) {
    final skills = _radarValuesForPosition(pos, stats);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue.withOpacity(0.05), AppColors.secondaryGreen.withOpacity(0.05)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Icon(Icons.radar, color: AppColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text('PROFIL JOUEUR', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 20),
          Container(
            height: 320,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: CustomPaint(
              size: const Size(280, 280),
              painter: RadarChartPainter(skills: skills),
              child: const SizedBox(width: 280, height: 280),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 12, runSpacing: 8,
            children: skills.entries.map((e) => Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.7), shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('${e.key}: ${e.value.toInt()}',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            ])).toList(),
          ),
        ]),
      ),
    );
  }

  // ── Stat sections ─────────────────────────────────────────────────────────────
  Widget _buildStatsSection(Map<String, dynamic> stats, Map<String, dynamic> section) {
    final color  = section['color'] as Color;
    final defs   = section['stats'] as List<_StatDef>;
    final title  = section['title'] as String;
    final icon   = section['icon'] as IconData;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(title.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ]),
      ),
      const SizedBox(height: 12),
      GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12, mainAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.6,
        children: defs.map((d) => _buildStatItem(d.label, _toInt(stats[d.key]).toString(), d.icon, color)).toList(),
      ),
    ]);
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: accentColor),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accentColor)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }

  Widget _buildSeparator(Color color) => Container(
    height: 2, margin: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(1),
      gradient: LinearGradient(
        colors: [Colors.transparent, color.withOpacity(0.4), color.withOpacity(0.4), Colors.transparent],
        stops: const [0, 0.3, 0.7, 1],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes statistiques'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.onBackToProfile != null) {
              widget.onBackToProfile!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: FutureBuilder<_StatsData>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return AppErrorWidget(
              message: snap.error.toString(),
              onRetry: () => setState(() { _future = _load(); }),
            );
          }

          final data       = snap.data!;
          final stats      = data.stats;
          final pos        = data.position;
          final posColor   = _positionColor(pos);
          final chartStats = data.chartStats;
          final sections   = _sectionsForPosition(pos);
          final headerKpis = _headerStatsForPosition(pos, stats);

          // Ensure _selectedStat is valid for current position
          if (!chartStats.any((s) => s['key'] == _selectedStat)) {
            _selectedStat = chartStats[0]['key'] as String;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ── Position badge + header KPI card ─────────────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF0F172A), const Color(0xFF1E293B)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: posColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: posColor.withOpacity(0.4)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(_positionIcon(pos), size: 14, color: posColor),
                          const SizedBox(width: 6),
                          Text(_positionLabel(pos),
                            style: TextStyle(color: posColor, fontSize: 12, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      const Spacer(),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('${_toInt(stats['matchesPlayed'])}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        Text('matchs joués', style: TextStyle(color: Colors.white54, fontSize: 11)),
                      ]),
                    ]),
                    const SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12, mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.0,
                      children: headerKpis.map((k) => _buildHeaderKpi(
                        k['label'] as String, k['value'] as String,
                        k['icon'] as IconData, k['color'] as Color,
                      )).toList(),
                    ),
                  ]),
                ),
              ),

              const SizedBox(height: 20),

              // ── Radar chart ───────────────────────────────────────────────────
              _buildRadarChartSection(stats, pos),

              _buildSeparator(posColor),

              // ── Line chart ────────────────────────────────────────────────────
              _buildLineChartSection(stats, chartStats),

              _buildSeparator(posColor),

              // ── Position-specific sections ────────────────────────────────────
              ...sections.expand((section) => [
                _buildStatsSection(stats, section),
                _buildSeparator((section['color'] as Color).withOpacity(0.5)),
              ]),

              // ── Temps de jeu ──────────────────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [posColor.withOpacity(0.08), posColor.withOpacity(0.04)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: posColor.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.timer, color: posColor, size: 18),
                      const SizedBox(width: 8),
                      Text('TEMPS DE JEU', style: TextStyle(color: posColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    ]),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(child: _buildStatItem('Minutes jouées', _toInt(stats['minutesPlayed']).toString(), Icons.timer, posColor)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatItem('Matchs joués', _toInt(stats['matchesPlayed']).toString(), Icons.sports, posColor)),
                    ]),
                  ]),
                ),
              ),

              const SizedBox(height: 24),
            ]),
          );
        },
      ),
    );
  }

  IconData _positionIcon(PlayerPosition pos) {
    switch (pos) {
      case PlayerPosition.gardien:   return Icons.shield;
      case PlayerPosition.defenseur: return Icons.security;
      case PlayerPosition.milieu:    return Icons.swap_horiz;
      case PlayerPosition.attaquant: return Icons.sports_soccer;
      case PlayerPosition.autre:     return Icons.person;
    }
  }

  Widget _buildHeaderKpi(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60), maxLines: 1, overflow: TextOverflow.ellipsis),
        ])),
      ]),
    );
  }
}

// ─── Data container ───────────────────────────────────────────────────────────
class _StatsData {
  final Map<String, dynamic> stats;
  final PlayerPosition position;
  final String positionRaw;
  final List<Map<String, dynamic>> chartStats;
  const _StatsData({required this.stats, required this.position, required this.positionRaw, required this.chartStats});
}

// ─── Radar chart painter ──────────────────────────────────────────────────────
class RadarChartPainter extends CustomPainter {
  final Map<String, double> skills;
  RadarChartPainter({required this.skills});

  @override
  void paint(Canvas canvas, Size size) {
    final center    = Offset(size.width / 2, size.height / 2);
    final radius    = size.width / 2 - 45;
    final n         = skills.length;
    final angleStep = 2 * math.pi / n;
    final primaryColor = AppColors.primaryBlue;

    // Background rings
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radius * i / 5,
        Paint()..color = Colors.grey.withOpacity(0.15)..style = PaintingStyle.stroke..strokeWidth = 1);
    }

    // Axes
    for (int i = 0; i < n; i++) {
      final angle = i * angleStep - math.pi / 2;
      canvas.drawLine(center, Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle)),
        Paint()..color = Colors.grey.withOpacity(0.25)..strokeWidth = 1);
    }

    // Data polygon
    final pts = <Offset>[];
    for (int i = 0; i < n; i++) {
      final val   = (skills.values.elementAt(i) / 100).clamp(0.0, 1.0);
      final angle = i * angleStep - math.pi / 2;
      pts.add(Offset(center.dx + radius * val * math.cos(angle), center.dy + radius * val * math.sin(angle)));
    }

    final path = Path()..addPolygon(pts, true);
    canvas.drawPath(path, Paint()..color = primaryColor.withOpacity(0.18)..style = PaintingStyle.fill);
    canvas.drawPath(path, Paint()..color = primaryColor..strokeWidth = 2..style = PaintingStyle.stroke);

    for (final pt in pts) {
      canvas.drawCircle(pt, 4, Paint()..color = primaryColor..style = PaintingStyle.fill);
      canvas.drawCircle(pt, 4, Paint()..color = Colors.white..strokeWidth = 2..style = PaintingStyle.stroke);
    }

    // Labels
    for (int i = 0; i < n; i++) {
      final key   = skills.keys.elementAt(i);
      final angle = i * angleStep - math.pi / 2;
      final lr    = radius + 28;
      final lp    = Offset(center.dx + lr * math.cos(angle), center.dy + lr * math.sin(angle));
      final tp    = TextPainter(
        text: TextSpan(text: key, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        textDirection: TextDirection.ltr, textAlign: TextAlign.center,
      )..layout(maxWidth: 60);
      tp.paint(canvas, Offset(lp.dx - tp.width / 2, lp.dy - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}
