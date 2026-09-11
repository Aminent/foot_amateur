import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../state/auth_controller.dart';
import '../services/player_service.dart';
import '../services/notification_prefs_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';
import 'player_settings_page.dart';
import 'main_navigation_wrapper.dart';

class PlayerHomePage extends StatefulWidget {
  final AuthController auth;
  const PlayerHomePage({super.key, required this.auth});

  @override
  State<PlayerHomePage> createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  late PlayerService _playerService;
  late Future<_PlayerDashData> _dashFuture;
  int _notifCount = 0;

  @override
  void initState() {
    super.initState();
    _playerService = PlayerService(ApiClient(token: widget.auth.token));
    _dashFuture = _loadDashboard();
    _loadNotifCount();
  }

  Future<_PlayerDashData> _loadDashboard() async {
    final results = await Future.wait([
      _playerService.getMyPlayerProfile(),
      _playerService.getMyStats(),
      _playerService.getMyTrainingSessions(),
    ]);
    return _PlayerDashData(
      profile:   results[0] as Map<String, dynamic>,
      stats:     results[1] as Map<String, dynamic>,
      trainings: results[2] as List<Map<String, dynamic>>,
    );
  }

  Future<void> _loadNotifCount() async {
    final count = await NotificationPrefsService.instance.getTotal();
    if (mounted) setState(() => _notifCount = count);
  }

  Future<void> _refreshData() async {
    setState(() => _dashFuture = _loadDashboard());
    _loadNotifCount();
  }

  void _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlayerSettingsPage(auth: widget.auth)),
    );
    _loadNotifCount();
  }

  void _goToTab(int index) {
    MainNavigationWrapper.of(context)?.navigateToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Tableau de bord',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: _openSettings,
              ),
              if (_notifCount > 0)
                Positioned(
                  right: 6, top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Color(0xFFEF4444), shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      _notifCount > 99 ? '99+' : '$_notifCount',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
              icon: const Icon(Icons.settings_outlined), onPressed: _openSettings),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF55C1CF),
        child: FutureBuilder<_PlayerDashData>(
          future: _dashFuture,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF55C1CF)),
              );
            }
            if (snap.hasError) {
              return AppErrorWidget(
                message: snap.error.toString(),
                onRetry: _refreshData,
              );
            }

            final data = snap.data;
            final profile = data?.profile ?? {};
            final playerMap = profile['player'] as Map<String, dynamic>? ?? {};
            final teamMap   = profile['team']   as Map<String, dynamic>? ?? {};
            final statsMap  = data?.stats ?? {};
            final recentMatches = List<Map<String, dynamic>>.from(
                profile['recentMatches'] ?? []);
            final upcomingMatches = List<Map<String, dynamic>>.from(
                profile['upcomingMatches'] ?? []);
            final upcomingTrainings = (data?.trainings ?? [])
                .where((t) => t['statusRaw'] == 'scheduled')
                .toList();

            final name = playerMap['name'] as String?
                ?? widget.auth.user?.name
                ?? 'Joueur';
            final position   = playerMap['position'] as String? ?? '';
            final jerseyNum  = playerMap['jerseyNumber'];
            final isCaptain  = playerMap['isCaptain'] == true;
            final teamName   = teamMap['name'] as String? ?? '';
            final loading    = snap.connectionState == ConnectionState.waiting;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero header ─────────────────────────────────────────
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bonjour,',
                                  style: TextStyle(
                                      color: Colors.white.withAlpha(160), fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 6),
                              Row(children: [
                                if (jerseyNum != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF55C1CF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text('#$jerseyNum',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12)),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                if (position.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(20),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(position,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ),
                                if (isCaptain) ...[
                                  const SizedBox(width: 8),
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                ],
                              ]),
                              if (teamName.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Row(children: [
                                  const Icon(Icons.shield,
                                      color: Color(0xFF55C1CF), size: 14),
                                  const SizedBox(width: 5),
                                  Text(teamName,
                                      style: const TextStyle(
                                          color: Color(0xFF55C1CF),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                ]),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 90, height: 90,
                          child: Lottie.asset('assets/hello.json'),
                        ),
                      ],
                    ),
                  ),

                  // ── Stats cards ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: loading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(
                                  color: Color(0xFF55C1CF)),
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.55,
                            children: [
                              _statCard(
                                label: 'Buts',
                                value: '${statsMap['goals'] ?? 0}',
                                icon: Icons.sports_soccer,
                                color: const Color(0xFF10B981),
                                onTap: () => _goToTab(5),
                              ),
                              _statCard(
                                label: 'Passes D.',
                                value: '${statsMap['assists'] ?? 0}',
                                icon: Icons.assistant,
                                color: const Color(0xFF3B82F6),
                                onTap: () => _goToTab(5),
                              ),
                              _statCard(
                                label: 'Matchs',
                                value: '${statsMap['matchesPlayed'] ?? 0}',
                                icon: Icons.emoji_events,
                                color: const Color(0xFFF59E0B),
                                onTap: () => _goToTab(2),
                              ),
                              _statCard(
                                label: 'Minutes',
                                value: '${statsMap['minutesPlayed'] ?? 0}',
                                icon: Icons.timer,
                                color: const Color(0xFF8B5CF6),
                                onTap: () => _goToTab(5),
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick actions ──────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _sectionHeader('Accès rapide', Icons.bolt),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      _quickAction(Icons.emoji_events, 'Mes\nMatchs',
                          const Color(0xFFF59E0B), () => _goToTab(2)),
                      const SizedBox(width: 10),
                      _quickAction(Icons.fitness_center, 'Entraî-\nnements',
                          const Color(0xFF8B5CF6), () => _goToTab(3)),
                      const SizedBox(width: 10),
                      _quickAction(Icons.bar_chart, 'Mes\nStats',
                          const Color(0xFF10B981), () => _goToTab(5)),
                      const SizedBox(width: 10),
                      _quickAction(Icons.chat_bubble_outline, 'Chat\nÉquipe',
                          const Color(0xFF55C1CF), () => _goToTab(4)),
                    ]),
                  ),

                  const SizedBox(height: 24),

                  // ── Upcoming matches ───────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Expanded(
                          child: _sectionHeader(
                              'Prochains matchs', Icons.sports_soccer)),
                      TextButton(
                        onPressed: () => _goToTab(2),
                        child: const Text('Voir tout',
                            style: TextStyle(
                                color: Color(0xFF55C1CF), fontSize: 12)),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  if (!loading)
                    upcomingMatches.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _emptyCard(
                              icon: Icons.sports_soccer,
                              message: 'Aucun match à venir',
                            ),
                          )
                        : Column(
                            children: upcomingMatches
                                .take(3)
                                .map((m) => Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 10),
                                      child: _matchRow(m, teamMap['id']),
                                    ))
                                .toLi
                                st(),
                          ),

                  const SizedBox(height: 24),

                  // ── Recent results ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Expanded(
                          child: _sectionHeader(
                              'Derniers résultats', Icons.history)),
                      TextButton(
                        onPressed: () => _goToTab(2),
                        child: const Text('Voir tout',
                            style: TextStyle(
                                color: Color(0xFF55C1CF), fontSize: 12)),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  if (!loading)
                    recentMatches.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _emptyCard(
                              icon: Icons.history,
                              message: 'Aucun résultat récent',
                            ),
                          )
                        : Column(
                            children: recentMatches
                                .take(3)
                                .map((m) => Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 10),
                                      child: _resultRow(m, teamMap['id']),
                                    ))
                                .toList(),
                          ),

                  const SizedBox(height: 24),

                  // ── Upcoming trainings ─────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Expanded(
                          child: _sectionHeader(
                              'Prochaines séances', Icons.fitness_center)),
                      TextButton(
                        onPressed: () => _goToTab(3),
                        child: const Text('Voir tout',
                            style: TextStyle(
                                color: Color(0xFF55C1CF), fontSize: 12)),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  if (!loading)
                    upcomingTrainings.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _emptyCard(
                              icon: Icons.fitness_center,
                              message: 'Aucune séance planifiée',
                            ),
                          )
                        : Column(
                            children: upcomingTrainings
                                .take(3)
                                .map((t) => Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 10),
                                      child: _trainingRow(t),
                                    ))
                                .toList(),
                          ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) {
    return Row(children: [
      Icon(icon, size: 16, color: const Color(0xFF64748B)),
      const SizedBox(width: 6),
      Text(
        title.toUpperCase(),
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
            letterSpacing: 1.1),
      ),
    ]);
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withAlpha(40), color.withAlpha(15)],
          ),
          border: Border.all(color: color.withAlpha(40)),
          boxShadow: [
            BoxShadow(
                color: color.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w800, color: color)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155)),
                textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  Widget _matchRow(Map<String, dynamic> match, dynamic teamId) {
    final homeTeam = match['homeTeam'] as Map<String, dynamic>? ?? {};
    final awayTeam = match['awayTeam'] as Map<String, dynamic>? ?? {};
    final isHome   = match['homeTeamId'] == teamId;
    final opponent = isHome ? awayTeam : homeTeam;
    final date     = _formatDate(match['date'] as String?);
    final time     = match['time'] as String? ?? '';
    final location = match['location'] as String? ?? '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.sports_soccer,
              color: Color(0xFFF59E0B), size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'vs ${opponent['name'] ?? 'Inconnu'}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 3),
            Row(children: [
              Icon(Icons.calendar_today, size: 11, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(date, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              if (time.isNotEmpty) ...[
                const SizedBox(width: 8),
                Icon(Icons.access_time, size: 11, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
              if (location.isNotEmpty) ...[
                const SizedBox(width: 8),
                Icon(Icons.location_on, size: 11, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(location,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ]),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(isHome ? 'Domicile' : 'Extérieur',
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF59E0B))),
        ),
      ]),
    );
  }

  Widget _resultRow(Map<String, dynamic> match, dynamic teamId) {
    final homeTeam  = match['homeTeam']  as Map<String, dynamic>? ?? {};
    final awayTeam  = match['awayTeam']  as Map<String, dynamic>? ?? {};
    final isHome    = match['homeTeamId'] == teamId;
    final opponent  = isHome ? awayTeam : homeTeam;
    final homeScore = match['homeTeamScore'] as int? ?? 0;
    final awayScore = match['awayTeamScore'] as int? ?? 0;
    final myScore   = isHome ? homeScore : awayScore;
    final oppScore  = isHome ? awayScore : homeScore;
    final won       = myScore > oppScore;
    final draw      = myScore == oppScore;
    final Color resultColor = won
        ? Colors.green
        : draw
            ? const Color(0xFFF59E0B)
            : Colors.red;
    final String resultLabel = won ? 'V' : draw ? 'N' : 'D';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: resultColor.withAlpha(30), shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(resultLabel,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: resultColor)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'vs ${opponent['name'] ?? 'Inconnu'}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 2),
            Text(_formatDate(match['date'] as String?),
                style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ]),
        ),
        Text(
          '$myScore — $oppScore',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: resultColor),
        ),
      ]),
    );
  }

  Widget _trainingRow(Map<String, dynamic> t) {
    final typeColors = <String, Color>{
      'technique': Colors.blue,
      'tactique':  Colors.purple,
      'physique':  Colors.orange,
      'match':     Colors.green,
    };
    final color = typeColors[t['typeRaw']] ?? const Color(0xFF55C1CF);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        Container(
            width: 4,
            height: 44,
            decoration:
                BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t['title'] ?? '',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A))),
            const SizedBox(height: 3),
            Row(children: [
              Icon(Icons.calendar_today, size: 11, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(t['date'] ?? '',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              if ((t['time'] as String? ?? '').isNotEmpty) ...[
                const SizedBox(width: 8),
                Icon(Icons.access_time, size: 11, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(t['time'] ?? '',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
              if ((t['location'] as String? ?? '').isNotEmpty) ...[
                const SizedBox(width: 8),
                Icon(Icons.location_on, size: 11, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(t['location'] ?? '',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ]),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
              color: color.withAlpha(25), borderRadius: BorderRadius.circular(20)),
          child: Text(t['type'] ?? '',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ),
      ]),
    );
  }

  Widget _emptyCard({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(children: [
        Icon(icon, size: 36, color: Colors.grey[300]),
        const SizedBox(height: 8),
        Text(message, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
      ]),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateString);
      final now  = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays == 0) return 'Aujourd\'hui';
      if (diff.inDays == 1) return 'Hier';
      if (diff.inDays < 7)  return 'Il y a ${diff.inDays}j';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateString;
    }
  }
}

// ── Data container ────────────────────────────────────────────────────────────

class _PlayerDashData {
  final Map<String, dynamic> profile;
  final Map<String, dynamic> stats;
  final List<Map<String, dynamic>> trainings;
  _PlayerDashData(
      {required this.profile, required this.stats, required this.trainings});
}