import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../services/coach_service.dart';
import '../services/api_client.dart';
import 'coach_lineup_page.dart';
import '../widgets/custom_widgets.dart';

class CoachTournamentsPage extends StatefulWidget {
  final AuthController auth;
  final VoidCallback? onBackToProfile;
  const CoachTournamentsPage({super.key, required this.auth, this.onBackToProfile});

  @override
  State<CoachTournamentsPage> createState() => _CoachTournamentsPageState();
}

class _CoachTournamentsPageState extends State<CoachTournamentsPage>
    with SingleTickerProviderStateMixin {
  late CoachService _coachService;
  late TabController _tabController;

  Map<String, dynamic>? _data;      // from getMyTournament()
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _coachService = CoachService(ApiClient(token: widget.auth.token));
    _tabController = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _coachService.getMyTournament();
      setState(() { _data = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  String _fmtDate(dynamic d) {
    if (d == null) return '—';
    try {
      final dt = DateTime.parse(d.toString());
      return '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year}';
    } catch (_) { return d.toString(); }
  }

  String _fmtTime(dynamic d) {
    if (d == null) return '';
    try {
      final dt = DateTime.parse(d.toString());
      return '${dt.hour.toString().padLeft(2,'0')}h${dt.minute.toString().padLeft(2,'0')}';
    } catch (_) { return ''; }
  }

  Color _resultColor(String? r) {
    switch (r) {
      case 'V': return Colors.green;
      case 'D': return Colors.red;
      case 'N': return Colors.orange;
      default:  return Colors.blueGrey;
    }
  }

  String _resultLabel(String? r) {
    switch (r) {
      case 'V': return 'Victoire';
      case 'D': return 'Défaite';
      case 'N': return 'Nul';
      default:  return 'Programmé';
    }
  }

  Color _statusColor(String? s) {
    switch (s) {
      case 'active':    return Colors.green;
      case 'completed': return Colors.blueGrey;
      case 'cancelled': return Colors.red;
      default:          return Colors.orange;
    }
  }

  String _statusLabel(String? s) {
    switch (s) {
      case 'active':    return 'Actif';
      case 'completed': return 'Terminé';
      case 'cancelled': return 'Annulé';
      default:          return 'Brouillon';
    }
  }

  String _formatLabel(String? f) {
    switch (f) {
      case 'league':              return 'Championnat';
      case 'knockout':            return 'Élimination';
      case 'group_then_knockout': return 'Poules + Élim.';
      default: return f ?? '—';
    }
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Mon tournoi'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.onBackToProfile != null) widget.onBackToProfile!();
            else if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load, tooltip: 'Actualiser'),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF55C1CF)))
          : _error != null
              ? _buildError()
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    final tournament = _data?['tournament'];
    if (tournament == null) return _buildNoTournament();
    return _buildTournamentView(tournament);
  }

  // ── no tournament state ────────────────────────────────────────────────────

  Widget _buildNoTournament() {
    final applications = (_data?['applications'] as List? ?? []);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Pending applications
          if (applications.isNotEmpty) ...[
            _sectionTitle('Candidatures en cours'),
            const SizedBox(height: 12),
            ...applications.map((a) => _applicationCard(a)),
            const SizedBox(height: 24),
          ],
          // Empty state
          SizedBox(
            height: 260,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 120, height: 120, child: Lottie.asset('assets/empty_state.json')),
                const SizedBox(height: 16),
                Text(
                  applications.isEmpty
                      ? 'Aucun tournoi en cours'
                      : 'En attente d\'approbation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Postulez à un tournoi actif pour participer',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showApplySheet,
              icon: const Icon(Icons.add),
              label: const Text('Postuler à un tournoi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _applicationCard(Map<String, dynamic> a) {
    final status = a['status'] as String? ?? 'pending';
    final Color color;
    final String label;
    final IconData icon;
    switch (status) {
      case 'approved': color = Colors.green;   label = 'Approuvée'; icon = Icons.check_circle; break;
      case 'rejected': color = Colors.red;     label = 'Rejetée';   icon = Icons.cancel;       break;
      default:         color = Colors.orange;  label = 'En attente'; icon = Icons.hourglass_empty;
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a['tournament']?['name'] ?? '—',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                Text(
                  'Soumise le ${_fmtDate(a['appliedAt'])}',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                if ((a['notes'] as String? ?? '').isNotEmpty)
                  Text(
                    a['notes'] as String,
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
            child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── tournament view ────────────────────────────────────────────────────────

  Widget _buildTournamentView(Map<String, dynamic> t) {
    final standings = (_data?['standings'] as List? ?? []).cast<Map<String, dynamic>>();
    final matches   = (_data?['matches']   as List? ?? []).cast<Map<String, dynamic>>();
    final myPos     = _data?['myPosition'] as int?;

    return Column(
      children: [
        // Tournament header card
        _buildHeader(t, myPos, standings, matches),

        // Tabs
        Container(
          color: const Color(0xFF0F172A),
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF3B82F6),
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            tabs: const [
              Tab(text: 'Matchs'),
              Tab(text: 'Classement'),
              Tab(text: 'Infos'),
            ],
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMatchesTab(matches),
              _buildStandingsTab(standings),
              _buildInfoTab(t),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(Map<String, dynamic> t, int? myPos,
      List<Map<String, dynamic>> standings, List<Map<String, dynamic>> matches) {
    final completed = matches.where((m) => m['result'] != null).length;
    final wins      = matches.where((m) => m['result'] == 'V').length;
    final myRow     = standings.firstWhere((r) => r['isMyTeam'] == true, orElse: () => {});
    final pts       = myRow['Pts'] ?? 0;

    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t['name'] ?? '—',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(t['status'] as String?).withAlpha(40),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _statusColor(t['status'] as String?).withAlpha(120)),
                ),
                child: Text(
                  _statusLabel(t['status'] as String?),
                  style: TextStyle(
                    color: _statusColor(t['status'] as String?),
                    fontSize: 11, fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _formatLabel(t['format'] as String?),
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),
          // KPI row
          Row(
            children: [
              _kpi('${myPos ?? '—'}', 'Position', Icons.emoji_events, Colors.amber),
              _kpi('$pts', 'Points', Icons.star, const Color(0xFF3B82F6)),
              _kpi('$wins', 'Victoires', Icons.check_circle, Colors.green),
              _kpi('$completed', 'Matchs', Icons.sports_soccer, Colors.white54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kpi(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }

  // ── matches tab ────────────────────────────────────────────────────────────

  Widget _buildMatchesTab(List<Map<String, dynamic>> matches) {
    if (matches.isEmpty) {
      return const Center(child: Text('Aucun match programmé', style: TextStyle(color: Colors.grey)));
    }

    final upcoming  = matches.where((m) => m['status'] == 'scheduled').toList();
    final completed = matches.where((m) => m['status'] == 'completed').toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (upcoming.isNotEmpty) ...[
            _sectionTitle('À venir'),
            const SizedBox(height: 10),
            ...upcoming.map(_matchCard),
            const SizedBox(height: 20),
          ],
          if (completed.isNotEmpty) ...[
            _sectionTitle('Résultats'),
            const SizedBox(height: 10),
            ...completed.map(_matchCard),
          ],
        ],
      ),
    );
  }

  Widget _matchCard(Map<String, dynamic> m) {
    final result  = m['result'] as String?;
    final isHome  = m['isHome'] as bool? ?? true;
    final gf      = m['goalsFor']     as int? ?? 0;
    final ga      = m['goalsAgainst'] as int? ?? 0;
    final rColor  = _resultColor(result);
    final home    = (m['homeTeam'] as Map?)?['name'] ?? '?';
    final away    = (m['awayTeam'] as Map?)?['name'] ?? '?';
    final isDone  = result != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: isDone ? rColor : Colors.blueGrey.shade200, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            // Date / round
            Row(
              children: [
                Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  m['date'] != null ? '${_fmtDate(m['date'])}  ${_fmtTime(m['date'])}'.trim() : '—',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                const Spacer(),
                if (m['roundNumber'] != null)
                  Text('Tour ${m['roundNumber']}',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 10),
            // Teams + score
            Row(
              children: [
                Expanded(
                  child: Text(
                    home,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: isHome ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 14,
                      color: isHome ? const Color(0xFF0F172A) : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDone ? rColor.withAlpha(20) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isDone
                      ? Text(
                          '$gf – $ga',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: rColor),
                        )
                      : const Text('vs', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    away,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: !isHome ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 14,
                      color: !isHome ? const Color(0xFF0F172A) : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            if (isDone) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: rColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _resultLabel(result),
                    style: TextStyle(color: rColor, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
            if ((m['location'] as String? ?? '').isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(m['location'] as String,
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ],
            const SizedBox(height: 10),
            // Lineup button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoachLineupPage(
                      auth: widget.auth,
                      match: {
                        'id': m['id'],
                        'opponent': m['opponent'] ?? '?',
                        'date': m['date'],
                        'location': m['location'] ?? '',
                        'status': m['status'] ?? '',
                      },
                    ),
                  ),
                ),
                icon: const Icon(Icons.format_list_numbered, size: 15),
                label: const Text('Composition'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── standings tab ──────────────────────────────────────────────────────────

  Widget _buildStandingsTab(List<Map<String, dynamic>> standings) {
    if (standings.isEmpty) {
      return const Center(
        child: Text('Classement disponible dès le premier match terminé',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey)),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                SizedBox(width: 28, child: Text('#', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w700))),
                Expanded(child: Text('Équipe', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w700))),
                _StdCell('J'),
                _StdCell('V'),
                _StdCell('N'),
                _StdCell('D'),
                _StdCell('DB'),
                _StdCell('Pts', bold: true),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...standings.map((r) => _standingRow(r)),
        ],
      ),
    );
  }

  Widget _standingRow(Map<String, dynamic> r) {
    final isMe  = r['isMyTeam'] == true;
    final pos   = r['position'] as int? ?? 0;
    final Color posColor;
    if (pos == 1)      posColor = const Color(0xFFF59E0B);
    else if (pos == 2) posColor = const Color(0xFF94A3B8);
    else if (pos == 3) posColor = const Color(0xFFB45309);
    else               posColor = Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF3B82F6).withAlpha(15) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isMe ? const Color(0xFF3B82F6).withAlpha(80) : Colors.grey.shade100,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: posColor != Colors.transparent
                ? Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(color: posColor, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$pos',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
                  )
                : Text('$pos',
                    style: TextStyle(
                        color: isMe ? const Color(0xFF3B82F6) : Colors.black54,
                        fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(
              r['name'] as String? ?? '—',
              style: TextStyle(
                fontWeight: isMe ? FontWeight.w800 : FontWeight.w500,
                fontSize: 13,
                color: isMe ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
              ),
            ),
          ),
          _dataCell('${r['P'] ?? 0}'),
          _dataCell('${r['W'] ?? 0}', color: Colors.green),
          _dataCell('${r['D'] ?? 0}'),
          _dataCell('${r['L'] ?? 0}', color: Colors.red),
          _dataCell(_gdLabel(r['GD']), color: (r['GD'] as int? ?? 0) > 0 ? Colors.green : null),
          _dataCell('${r['Pts'] ?? 0}', bold: true,
              color: isMe ? const Color(0xFF3B82F6) : const Color(0xFF0F172A)),
        ],
      ),
    );
  }

  String _gdLabel(dynamic v) {
    final i = v as int? ?? 0;
    return i > 0 ? '+$i' : '$i';
  }

  Widget _dataCell(String text, {bool bold = false, Color? color}) {
    return SizedBox(
      width: 34,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          color: color ?? Colors.black54,
        ),
      ),
    );
  }

  // ── info tab ───────────────────────────────────────────────────────────────

  Widget _buildInfoTab(Map<String, dynamic> t) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _infoCard('📋 Détails', [
            _infoRow(Icons.emoji_events, 'Nom', t['name'] ?? '—'),
            _infoRow(Icons.sports, 'Format', _formatLabel(t['format'] as String?)),
            _infoRow(Icons.group, 'Équipes', '${t['teamsCount'] ?? '—'} / ${t['maxTeams'] ?? '—'}'),
            _infoRow(Icons.calendar_today, 'Début', _fmtDate(t['startDate'])),
            _infoRow(Icons.event, 'Fin', _fmtDate(t['endDate'])),
            _infoRow(Icons.location_on, 'Lieu', t['location'] ?? '—'),
          ]),
          if ((t['description'] as String? ?? '').isNotEmpty) ...[
            const SizedBox(height: 14),
            _infoCard('📝 Description', [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(t['description'] as String,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _infoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF0F172A))),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)))),
        ],
      ),
    );
  }

  // ── apply sheet ────────────────────────────────────────────────────────────

  Future<void> _showApplySheet() async {
    final available = await _coachService.getAvailableTournaments();

    if (!mounted) return;

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun tournoi actif disponible pour le moment'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            const Text('Choisir un tournoi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            const SizedBox(height: 16),
            ...available.map((t) => _applyTile(ctx, t)),
          ],
        ),
      ),
    );
  }

  Widget _applyTile(BuildContext sheetCtx, Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.emoji_events, color: Color(0xFF3B82F6), size: 22),
        ),
        title: Text(t['name'] ?? '—',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Text(
          '${_formatLabel(t['format'] as String?)} · ${_fmtDate(t['startDate'])}',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: ElevatedButton(
          onPressed: () => _apply(sheetCtx, t),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Postuler', style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  Future<void> _apply(BuildContext sheetCtx, Map<String, dynamic> t) async {
    Navigator.pop(sheetCtx);
    try {
      await _coachService.applyForTournament(t['id'] as int);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Candidature envoyée pour "${t['name']}" ✓'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── shared widgets ─────────────────────────────────────────────────────────

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A), letterSpacing: 0.3),
      );

  Widget _buildError() => AppErrorWidget(
        title: 'Impossible de charger les tournois',
        message: _error,
        onRetry: _load,
      );
}

// Column header for standings table
class _StdCell extends StatelessWidget {
  final String text;
  final bool bold;
  const _StdCell(this.text, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
        ),
      ),
    );
  }
}
