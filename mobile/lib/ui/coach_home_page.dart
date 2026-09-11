import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../services/coach_service.dart';
import '../services/notification_prefs_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';
import 'coach_settings_page.dart';
import 'coach_stats_page.dart';
import 'main_navigation_wrapper.dart';

class CoachHomePage extends StatefulWidget {
  final AuthController auth;
  const CoachHomePage({super.key, required this.auth});

  @override
  State<CoachHomePage> createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {
  late CoachService _coachService;
  late Future<_DashboardData> _dashFuture;
  int _notifCount = 0;

  @override
  void initState() {
    super.initState();
    _coachService = CoachService(ApiClient(token: widget.auth.token));
    _dashFuture = _loadDashboard();
    _loadNotifCount();
  }

  Future<_DashboardData> _loadDashboard() async {
    final results = await Future.wait([
      _coachService.getCoachStats(),
      _coachService.getMyTeam(),
      _coachService.getMyTrainings(),
      _coachService.getMyTeamMatches(),
    ]);
    final stats     = results[0] as Map<String, int>;
    final teamData  = results[1] as Map<String, dynamic>;
    final trainings = results[2] as List<Map<String, dynamic>>;
    final matches   = results[3] as List<Map<String, dynamic>>;
    return _DashboardData(stats: stats, teamData: teamData, trainings: trainings, matches: matches);
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
      MaterialPageRoute(builder: (_) => CoachSettingsPage(auth: widget.auth)),
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
                    decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      _notifCount > 99 ? '99+' : '$_notifCount',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF55C1CF),
        child: FutureBuilder<_DashboardData>(
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
            final stats = data?.stats ?? {'teamsCount': 0, 'playersCount': 0, 'matchesCount': 0, 'upcomingMatches': 0};
            final players = List<Map<String, dynamic>>.from(data?.teamData['players'] ?? []);
            final teamName = (data?.teamData['team'] as Map<String, dynamic>?)?['name'] ?? '';
            final upcomingTrainings = (data?.trainings ?? [])
                .where((t) => t['statusRaw'] == 'scheduled')
                .toList();

            // Next scheduled match (soonest future date)
            final scheduledMatches = (data?.matches ?? [])
                .where((m) => m['status'] == 'scheduled')
                .toList()
              ..sort((a, b) {
                final da = DateTime.tryParse(a['date'] ?? '') ?? DateTime(9999);
                final db = DateTime.tryParse(b['date'] ?? '') ?? DateTime(9999);
                return da.compareTo(db);
              });
            final nextMatch = scheduledMatches.isNotEmpty ? scheduledMatches.first : null;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero header ───────────────────────────────────────────
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonjour,',
                                style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.auth.user?.name ?? 'Coach',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                              ),
                              if (teamName.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.shield, color: Color(0xFF55C1CF), size: 14),
                                    const SizedBox(width: 5),
                                    Text(teamName,
                                        style: const TextStyle(
                                            color: Color(0xFF55C1CF),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                'Voici votre vue d\'ensemble',
                                style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Lottie.asset('assets/hello.json'),
                        ),
                      ],
                    ),
                  ),

                  // ── Stat cards ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: snap.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(color: Color(0xFF55C1CF)),
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
                                label: 'Équipe',
                                value: stats['teamsCount'].toString(),
                                icon: Icons.shield,
                                color: const Color(0xFF55C1CF),
                                lottie: 'assets/Football_team_players.json',
                                onTap: () => _goToTab(1),
                              ),
                              _statCard(
                                label: 'Joueurs',
                                value: stats['playersCount'].toString(),
                                icon: Icons.people,
                                color: const Color(0xFF8B5CF6),
                                lottie: 'assets/Soccer_player_kick_on_the_ball.json',
                                onTap: () => _goToTab(1),
                              ),
                              _statCard(
                                label: 'Matchs',
                                value: stats['matchesCount'].toString(),
                                icon: Icons.sports_soccer,
                                color: const Color(0xFF10B981),
                                lottie: 'assets/socccerfield.json',
                                onTap: () => _goToTab(3),
                              ),
                              _statCard(
                                label: 'À venir',
                                value: stats['upcomingMatches'].toString(),
                                icon: Icons.calendar_today,
                                color: const Color(0xFFF59E0B),
                                lottie: 'assets/Coming_Soon.json',
                                onTap: () => _goToTab(3),
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick actions ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _sectionHeader('Accès rapide', Icons.bolt),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _quickAction(Icons.group, 'Mon\nÉquipe', const Color(0xFF55C1CF), () => _goToTab(1)),
                        const SizedBox(width: 10),
                        _quickAction(Icons.fitness_center, 'Entraî-\nnements', const Color(0xFF8B5CF6), () => _goToTab(2)),
                        const SizedBox(width: 10),
                        _quickAction(Icons.emoji_events, 'Tournois\n& Matchs', const Color(0xFF10B981), () => _goToTab(3)),
                        const SizedBox(width: 10),
                        _quickAction(Icons.bar_chart, 'Statis-\ntiques', const Color(0xFFF59E0B), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CoachStatsPage(auth: widget.auth),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Next match ────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _sectionHeader('Prochain match', Icons.sports_soccer)),
                        TextButton(
                          onPressed: () => _goToTab(3),
                          child: const Text('Voir tout', style: TextStyle(color: Color(0xFF55C1CF), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (snap.connectionState == ConnectionState.waiting)
                    const SizedBox()
                  else if (nextMatch == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _emptyCard(
                        icon: Icons.sports_soccer,
                        message: 'Aucun match programmé',
                        actionLabel: 'Voir les tournois',
                        onAction: () => _goToTab(3),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: _nextMatchCard(nextMatch),
                    ),

                  const SizedBox(height: 24),

                  // ── Upcoming trainings ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _sectionHeader('Prochaines séances', Icons.fitness_center)),
                        TextButton(
                          onPressed: () => _goToTab(2),
                          child: const Text('Voir tout', style: TextStyle(color: Color(0xFF55C1CF), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (snap.connectionState == ConnectionState.waiting)
                    const SizedBox()
                  else if (upcomingTrainings.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _emptyCard(
                        icon: Icons.fitness_center,
                        message: 'Aucune séance planifiée',
                        actionLabel: 'Créer une séance',
                        onAction: () => _goToTab(2),
                      ),
                    )
                  else
                    ...upcomingTrainings.take(3).map((t) => Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: _trainingRow(t),
                        )),

                  const SizedBox(height: 24),

                  // ── Squad snapshot ────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _sectionHeader('Effectif', Icons.people)),
                        TextButton(
                          onPressed: () => _goToTab(1),
                          child: const Text('Voir tout', style: TextStyle(color: Color(0xFF55C1CF), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (snap.connectionState == ConnectionState.waiting)
                    const SizedBox()
                  else if (players.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _emptyCard(icon: Icons.group_off, message: 'Aucun joueur dans l\'équipe'),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _squadSnapshot(players),
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 6),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: Color(0xFF64748B), letterSpacing: 1.1),
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required String lottie,
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
            BoxShadow(color: color.withAlpha(20), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -4, right: -4,
              child: SizedBox(
                width: 80, height: 80,
                child: Lottie.asset(lottie, fit: BoxFit.contain),
              ),
            ),
            Padding(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800, color: color)),
                      Text(label,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
            ),
            // Tap ripple hint
            Positioned(
              bottom: 10, right: 10,
              child: Icon(Icons.arrow_forward_ios, size: 11, color: color.withAlpha(120)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trainingRow(Map<String, dynamic> t) {
    final typeColors = <String, Color>{
      'technique': Colors.blue,
      'tactique': Colors.purple,
      'physique': Colors.orange,
      'match': Colors.green,
    };
    final color = typeColors[t['typeRaw']] ?? const Color(0xFF55C1CF);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4, height: 44,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['title'] ?? '',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 11, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(t['date'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    if ((t['time'] as String? ?? '').isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.access_time, size: 11, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(t['time'] ?? '', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
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
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(t['type'] ?? '',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _squadSnapshot(List<Map<String, dynamic>> players) {
    final shown = players.take(5).toList();
    final remaining = players.length - shown.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          ...shown.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            final jerseyNum = p['jerseyNumber'];
            final isCaptain = p['isCaptain'] == true;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        jerseyNum != null ? '#$jerseyNum' : '—',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(p['name'] ?? '—',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                    ),
                    if (isCaptain)
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(p['position'] ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
                if (i < shown.length - 1 || remaining > 0)
                  const Divider(height: 16, indent: 46),
              ],
            );
          }),
          if (remaining > 0)
            GestureDetector(
              onTap: () => _goToTab(1),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '+ $remaining autre${remaining > 1 ? 's' : ''} joueur${remaining > 1 ? 's' : ''}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF55C1CF), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, size: 11, color: Color(0xFF55C1CF)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _nextMatchCard(Map<String, dynamic> match) {
    DateTime? dt;
    try { dt = DateTime.parse(match['date'] ?? ''); } catch (_) {}

    final dateStr = dt != null
        ? '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}'
        : '';
    final timeStr = dt != null
        ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
        : '';

    // Countdown
    String countdown = '';
    if (dt != null) {
      final diff = dt.difference(DateTime.now());
      if (diff.inDays > 0) {
        countdown = 'Dans ${diff.inDays} jour${diff.inDays > 1 ? 's' : ''}';
      } else if (diff.inHours > 0) {
        countdown = 'Dans ${diff.inHours}h';
      } else if (diff.inMinutes > 0) {
        countdown = 'Dans ${diff.inMinutes} min';
      } else {
        countdown = 'Aujourd\'hui';
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tournament + countdown row
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF55C1CF).withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF55C1CF).withOpacity(0.4)),
              ),
              child: Text(
                match['tournament'] ?? '-',
                style: const TextStyle(color: Color(0xFF55C1CF), fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            if (countdown.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(countdown,
                    style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 10, fontWeight: FontWeight.w700)),
              ),
          ]),
          const SizedBox(height: 14),

          // Teams vs
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Text(
                'Mon équipe',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('VS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
            ),
            Expanded(
              child: Text(
                match['opponent'] ?? '-',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ]),

          const SizedBox(height: 14),

          // Date + time row
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.calendar_today, size: 12, color: Color(0xFF94A3B8)),
            const SizedBox(width: 4),
            Text(dateStr, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            if (timeStr.isNotEmpty) ...[
              const SizedBox(width: 12),
              const Icon(Icons.access_time, size: 12, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(timeStr, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _emptyCard({required IconData icon, required String message, String? actionLabel, VoidCallback? onAction}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel, style: const TextStyle(color: Color(0xFF55C1CF), fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Data container ────────────────────────────────────────────────────────────

class _DashboardData {
  final Map<String, int> stats;
  final Map<String, dynamic> teamData;
  final List<Map<String, dynamic>> trainings;
  final List<Map<String, dynamic>> matches;
  _DashboardData({required this.stats, required this.teamData, required this.trainings, required this.matches});
}
