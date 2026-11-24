import 'package:flutter/material.dart';

import '../state/auth_controller.dart';
import '../services/coach_service.dart';
import '../services/notification_prefs_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/home_design.dart';
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
      backgroundColor: HomePalette.background,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: HomePalette.link,
        child: FutureBuilder<_DashboardData>(
          future: _dashFuture,
          builder: (context, snap) {
            final data = snap.data;
            final stats = data?.stats ?? {'teamsCount': 0, 'playersCount': 0, 'matchesCount': 0, 'upcomingMatches': 0};
            final players = List<Map<String, dynamic>>.from(data?.teamData['players'] ?? []);
            final teamName = (data?.teamData['team'] as Map<String, dynamic>?)?['name'] ?? '';
            final upcomingTrainings = (data?.trainings ?? []).where((t) => t['statusRaw'] == 'scheduled').toList();
            final scheduledMatches = (data?.matches ?? []).where((m) => m['status'] == 'scheduled').toList()
              ..sort((a, b) => (DateTime.tryParse(a['date'] ?? '') ?? DateTime(9999))
                  .compareTo(DateTime.tryParse(b['date'] ?? '') ?? DateTime(9999)));
            final nextMatch = scheduledMatches.isNotEmpty ? scheduledMatches.first : null;
            final loading = snap.connectionState == ConnectionState.waiting;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                HomeSliverHeader(
                  initials: initialsOf(widget.auth.user?.name),
                  avatarColors: HomePalette.orange,
                  name: widget.auth.user?.name ?? 'Coach',
                  chips: [
                    HeaderChip('Coach',
                        fill: const Color(0xFFF5B921).withOpacity(0.15),
                        border: const Color(0xFFF5B921).withOpacity(0.6),
                        textColor: const Color(0xFFF5B921)),
                  ],
                  club: teamName,
                  notifCount: _notifCount,
                  onBell: _openSettings,
                  onSettings: _openSettings,
                ),
                if (loading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator(color: HomePalette.link)),
                  )
                else if (snap.hasError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppErrorWidget(message: snap.error.toString(), onRetry: _refreshData),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 44, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.55,
                          children: [
                            GradientStatCard(value: '${stats['teamsCount']}', label: 'Équipe', icon: Icons.shield,
                                colors: HomePalette.navy, lottie: 'assets/Football_team_players.json', onTap: () => _goToTab(1)),
                            GradientStatCard(value: '${stats['playersCount']}', label: 'Joueurs', icon: Icons.people,
                                colors: HomePalette.purple, lottie: 'assets/Soccer_player_kick_on_the_ball.json', onTap: () => _goToTab(1)),
                            GradientStatCard(value: '${stats['matchesCount']}', label: 'Matchs', icon: Icons.sports_soccer,
                                colors: HomePalette.green, lottie: 'assets/socccerfield.json', onTap: () => _goToTab(3)),
                            GradientStatCard(value: '${stats['upcomingMatches']}', label: 'À venir', icon: Icons.calendar_today_outlined,
                                colors: HomePalette.orange, lottie: 'assets/Coming_Soon.json', onTap: () => _goToTab(3)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const HomeSectionHeader('Accès rapide', Icons.bolt),
                        const SizedBox(height: 14),
                        Row(children: [
                          QuickTile(icon: Icons.people, label: 'Équipe', colors: HomePalette.navy, onTap: () => _goToTab(1)),
                          const SizedBox(width: 10),
                          QuickTile(icon: Icons.fitness_center, label: 'Entraîn.', colors: HomePalette.purple, onTap: () => _goToTab(2)),
                          const SizedBox(width: 10),
                          QuickTile(icon: Icons.emoji_events, label: 'Tournois', colors: HomePalette.green, onTap: () => _goToTab(3)),
                          const SizedBox(width: 10),
                          QuickTile(
                            icon: Icons.bar_chart,
                            label: 'Stats',
                            colors: HomePalette.orange,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CoachStatsPage(auth: widget.auth))),
                          ),
                        ]),
                        const SizedBox(height: 26),
                        HomeSectionHeader('Prochain match', Icons.sports_soccer, onSeeAll: () => _goToTab(3)),
                        const SizedBox(height: 12),
                        nextMatch == null
                            ? _emptyCard(icon: Icons.sports_soccer, message: 'Aucun match programmé', actionLabel: 'Voir les tournois', onAction: () => _goToTab(3))
                            : _nextMatchCard(nextMatch),
                        const SizedBox(height: 26),
                        HomeSectionHeader('Prochaines séances', Icons.fitness_center, onSeeAll: () => _goToTab(2)),
                        const SizedBox(height: 12),
                        if (upcomingTrainings.isEmpty)
                          _emptyCard(icon: Icons.fitness_center, message: 'Aucune séance planifiée', actionLabel: 'Créer une séance', onAction: () => _goToTab(2))
                        else
                          ...upcomingTrainings.take(3).map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _trainingRow(t))),
                        const SizedBox(height: 26),
                        HomeSectionHeader('Effectif', Icons.people, onSeeAll: () => _goToTab(1)),
                        const SizedBox(height: 12),
                        players.isEmpty
                            ? _emptyCard(icon: Icons.group_off, message: 'Aucun joueur dans l\'équipe')
                            : _squadSnapshot(players),
                      ]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  BoxDecoration get _whiteCard => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 3))],
      );

  Widget _trainingRow(Map<String, dynamic> t) {
    final colors = trainingColors(t['typeRaw']);
    final grey = Colors.grey[500];
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: _whiteCard,
      child: Row(children: [
        Container(
          width: 4,
          height: 46,
          decoration: BoxDecoration(gradient: LinearGradient(colors: colors, begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t['title'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: HomePalette.title)),
            const SizedBox(height: 5),
            Row(children: [
              Icon(Icons.calendar_today_outlined, size: 12, color: grey),
              const SizedBox(width: 4),
              Text(t['date'] ?? '', style: TextStyle(fontSize: 12, color: grey)),
              if ((t['time'] as String? ?? '').isNotEmpty) ...[
                const SizedBox(width: 10),
                Icon(Icons.access_time, size: 12, color: grey),
                const SizedBox(width: 4),
                Text(t['time'] ?? '', style: TextStyle(fontSize: 12, color: grey)),
              ],
              if ((t['location'] as String? ?? '').isNotEmpty) ...[
                const SizedBox(width: 10),
                Icon(Icons.location_on_outlined, size: 12, color: grey),
                const SizedBox(width: 3),
                Flexible(child: Text(t['location'] ?? '', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: grey))),
              ],
            ]),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(gradient: diagonal(colors), borderRadius: BorderRadius.circular(20)),
          child: Text(t['type'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _squadSnapshot(List<Map<String, dynamic>> players) {
    final shown = players.take(5).toList();
    final remaining = players.length - shown.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 0, 4),
      decoration: _whiteCard,
      child: Column(children: [
        for (var i = 0; i < shown.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              GradientSquare(
                colors: positionColors(shown[i]['position']),
                size: 38,
                child: Text(shown[i]['jerseyNumber'] != null ? '#${shown[i]['jerseyNumber']}' : '—',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(shown[i]['name'] ?? '—',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: HomePalette.title)),
              ),
              if (shown[i]['isCaptain'] == true) const Icon(Icons.star, size: 14, color: Colors.amber),
              Container(
                margin: const EdgeInsets.only(right: 14, left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: positionColors(shown[i]['position']).last.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(shown[i]['position'] ?? '',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: positionColors(shown[i]['position']).first)),
              ),
            ]),
          ),
          if (i < shown.length - 1 || remaining > 0) const Divider(height: 1, indent: 50),
        ],
        if (remaining > 0)
          InkWell(
            onTap: () => _goToTab(1),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 14, 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('+ $remaining autre${remaining > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 14, color: HomePalette.link, fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 18, color: HomePalette.link),
              ]),
            ),
          ),
      ]),
    );
  }

  Widget _nextMatchCard(Map<String, dynamic> match) {
    final dt = DateTime.tryParse(match['date'] ?? '')?.toLocal();
    final dateStr = dt == null ? '' : '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final timeStr = dt == null ? '' : '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    String countdown = '';
    if (dt != null) {
      final diff = dt.difference(DateTime.now());
      countdown = diff.inDays > 0
          ? 'Dans ${diff.inDays}j'
          : diff.inHours > 0
              ? 'Dans ${diff.inHours}h'
              : diff.inMinutes > 0
                  ? 'Dans ${diff.inMinutes} min'
                  : 'Aujourd\'hui';
    }
    const muted = Color(0xFF9DB4C8);
    return Container(
      decoration: BoxDecoration(
        gradient: diagonal(const [Color(0xFF07304F), Color(0xFF05679B)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF05679B).withOpacity(0.3), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Positioned(
          right: -40,
          top: -10,
          child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05))),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              Expanded(
                child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1FB6D9).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1FB6D9).withOpacity(0.5)),
                  ),
                  child: Text(match['tournament'] ?? '-',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF1FB6D9), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                ),
              ),
              const SizedBox(width: 8),
              if (countdown.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFF5B921).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(countdown, style: const TextStyle(color: Color(0xFFF5B921), fontSize: 11, fontWeight: FontWeight.w700)),
                ),
            ]),
            const SizedBox(height: 18),
            Row(children: [
              const Expanded(
                child: Text('Mon équipe', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: const Text('VS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
              ),
              Expanded(
                child: Text(match['opponent'] ?? '-',
                    textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.calendar_today_outlined, size: 13, color: muted),
              const SizedBox(width: 5),
              Text(dateStr, style: const TextStyle(color: muted, fontSize: 13)),
              if (timeStr.isNotEmpty) ...[
                const SizedBox(width: 14),
                const Icon(Icons.access_time, size: 13, color: muted),
                const SizedBox(width: 5),
                Text(timeStr, style: const TextStyle(color: muted, fontSize: 13)),
              ],
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _emptyCard({required IconData icon, required String message, String? actionLabel, VoidCallback? onAction}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: _whiteCard,
      child: Column(children: [
        Icon(icon, size: 36, color: Colors.grey[300]),
        const SizedBox(height: 8),
        Text(message, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: 6),
          TextButton(onPressed: onAction, child: Text(actionLabel, style: const TextStyle(color: HomePalette.link, fontSize: 13))),
        ],
      ]),
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
