import 'package:flutter/material.dart';

import '../state/auth_controller.dart';
import '../services/player_service.dart';
import '../services/notification_prefs_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/home_design.dart';
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
      backgroundColor: HomePalette.background,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: HomePalette.link,
        child: FutureBuilder<_PlayerDashData>(
          future: _dashFuture,
          builder: (context, snap) {
            final data = snap.data;
            final profile = data?.profile ?? {};
            final playerMap = profile['player'] as Map<String, dynamic>? ?? {};
            final teamMap = profile['team'] as Map<String, dynamic>? ?? {};
            final statsMap = data?.stats ?? {};
            final recentMatches = List<Map<String, dynamic>>.from(profile['recentMatches'] ?? []);
            final upcomingMatches = List<Map<String, dynamic>>.from(profile['upcomingMatches'] ?? []);
            final upcomingTrainings = (data?.trainings ?? []).where((t) => t['statusRaw'] == 'scheduled').toList();
            final name = playerMap['name'] as String? ?? widget.auth.user?.name ?? 'Joueur';
            final position = playerMap['position'] as String? ?? '';
            final jerseyNum = playerMap['jerseyNumber'];
            final teamName = teamMap['name'] as String? ?? '';
            final loading = snap.connectionState == ConnectionState.waiting;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                HomeSliverHeader(
                  initials: initialsOf(name),
                  avatarColors: HomePalette.cyan,
                  name: name,
                  chips: [
                    if (jerseyNum != null) HeaderChip('#$jerseyNum', fill: const Color(0xFF12B4D6)),
                    if (position.isNotEmpty) HeaderChip(position, fill: Colors.white.withOpacity(0.15)),
                    if (playerMap['isCaptain'] == true) const Icon(Icons.star, color: Colors.amber, size: 18),
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
                            GradientStatCard(value: '${statsMap['goals'] ?? 0}', label: 'Buts', icon: Icons.sports_soccer,
                                colors: HomePalette.navy, lottie: 'assets/Soccer_player_kick_on_the_ball.json', onTap: () => _goToTab(5)),
                            GradientStatCard(value: '${statsMap['assists'] ?? 0}', label: 'Passes D.', icon: Icons.assistant,
                                colors: HomePalette.purple, lottie: 'assets/Football_team_players.json', onTap: () => _goToTab(5)),
                            GradientStatCard(value: '${statsMap['matchesPlayed'] ?? 0}', label: 'Matchs', icon: Icons.emoji_events,
                                colors: HomePalette.green, lottie: 'assets/socccerfield.json', onTap: () => _goToTab(2)),
                            GradientStatCard(value: '${statsMap['minutesPlayed'] ?? 0}', label: 'Minutes', icon: Icons.timer_outlined,
                                colors: HomePalette.orange, lottie: 'assets/Calendar.json', onTap: () => _goToTab(5)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const HomeSectionHeader('Accès rapide', Icons.bolt),
                        const SizedBox(height: 14),
                        Row(children: [
                          QuickTile(icon: Icons.sports_soccer, label: 'Matchs', colors: HomePalette.orange, onTap: () => _goToTab(2)),
                          const SizedBox(width: 10),
                          QuickTile(icon: Icons.fitness_center, label: 'Entraîn.', colors: HomePalette.purple, onTap: () => _goToTab(3)),
                          const SizedBox(width: 10),
                          QuickTile(icon: Icons.bar_chart, label: 'Stats', colors: HomePalette.navy, onTap: () => _goToTab(5)),
                          const SizedBox(width: 10),
                          QuickTile(icon: Icons.chat_bubble, label: 'Chat', colors: HomePalette.cyan, onTap: () => _goToTab(4)),
                        ]),
                        const SizedBox(height: 26),
                        HomeSectionHeader('Prochains matchs', Icons.sports_soccer, onSeeAll: () => _goToTab(2)),
                        const SizedBox(height: 12),
                        if (upcomingMatches.isEmpty)
                          _emptyCard(icon: Icons.sports_soccer, message: 'Aucun match à venir')
                        else
                          ...upcomingMatches.take(3).map((m) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _matchRow(m, teamMap['id']))),
                        const SizedBox(height: 26),
                        HomeSectionHeader('Derniers résultats', Icons.history, onSeeAll: () => _goToTab(2)),
                        const SizedBox(height: 12),
                        if (recentMatches.isEmpty)
                          _emptyCard(icon: Icons.history, message: 'Aucun résultat récent')
                        else
                          ...recentMatches.take(3).map((m) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _resultRow(m, teamMap['id']))),
                        const SizedBox(height: 26),
                        HomeSectionHeader('Prochaines séances', Icons.fitness_center, onSeeAll: () => _goToTab(3)),
                        const SizedBox(height: 12),
                        if (upcomingTrainings.isEmpty)
                          _emptyCard(icon: Icons.fitness_center, message: 'Aucune séance planifiée')
                        else
                          ...upcomingTrainings.take(3).map((t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _trainingRow(t))),
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

  // ── Helpers ──────────────────────────────────────────────────────────────

  BoxDecoration get _whiteCard => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 3))],
      );

  Widget _meta(IconData icon, String text, {bool flexible = false}) {
    final grey = Colors.grey[500];
    final label = Text(text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: grey));
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: grey),
      const SizedBox(width: 4),
      flexible ? Flexible(child: label) : label,
    ]);
  }

  Widget _matchRow(Map<String, dynamic> match, dynamic teamId) {
    final homeTeam = match['homeTeam'] as Map<String, dynamic>? ?? {};
    final awayTeam = match['awayTeam'] as Map<String, dynamic>? ?? {};
    final isHome = match['homeTeamId'] == teamId;
    final opponent = isHome ? awayTeam : homeTeam;
    final time = match['time'] as String? ?? '';
    final location = match['location'] as String? ?? '';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _whiteCard,
      child: Row(children: [
        const GradientSquare(colors: HomePalette.orange, size: 44, child: Icon(Icons.sports_soccer, color: Colors.white, size: 22)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('vs ${opponent['name'] ?? 'Inconnu'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: HomePalette.title)),
            const SizedBox(height: 5),
            Row(children: [
              _meta(Icons.calendar_today_outlined, _formatDate(match['date'] as String?)),
              if (time.isNotEmpty) ...[const SizedBox(width: 10), _meta(Icons.access_time, time)],
              if (location.isNotEmpty) ...[const SizedBox(width: 10), Flexible(child: _meta(Icons.location_on_outlined, location, flexible: true))],
            ]),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: const Color(0xFFFDF0C4), borderRadius: BorderRadius.circular(20)),
          child: Text(isHome ? 'Domicile' : 'Extérieur',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFD97706))),
        ),
      ]),
    );
  }

  Widget _resultRow(Map<String, dynamic> match, dynamic teamId) {
    final homeTeam = match['homeTeam'] as Map<String, dynamic>? ?? {};
    final awayTeam = match['awayTeam'] as Map<String, dynamic>? ?? {};
    final isHome = match['homeTeamId'] == teamId;
    final opponent = isHome ? awayTeam : homeTeam;
    final homeScore = match['homeTeamScore'] as int? ?? 0;
    final awayScore = match['awayTeamScore'] as int? ?? 0;
    final myScore = isHome ? homeScore : awayScore;
    final oppScore = isHome ? awayScore : homeScore;
    final won = myScore > oppScore, draw = myScore == oppScore;
    final colors = won ? HomePalette.green : draw ? HomePalette.orange : HomePalette.red;
    final dt = DateTime.tryParse(match['date'] as String? ?? '')?.toLocal();
    final date = dt == null ? '—' : '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _whiteCard,
      child: Row(children: [
        GradientSquare(
          colors: colors,
          size: 44,
          child: Text(won ? 'V' : draw ? 'N' : 'D', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('vs ${opponent['name'] ?? 'Inconnu'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: HomePalette.title)),
            const SizedBox(height: 4),
            Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ]),
        ),
        Text('$myScore — $oppScore', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: colors.first)),
      ]),
    );
  }

  Widget _trainingRow(Map<String, dynamic> t) {
    final colors = trainingColors(t['typeRaw']);
    final time = t['time'] as String? ?? '';
    final location = t['location'] as String? ?? '';
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
              _meta(Icons.calendar_today_outlined, t['date'] ?? ''),
              if (time.isNotEmpty) ...[const SizedBox(width: 10), _meta(Icons.access_time, time)],
              if (location.isNotEmpty) ...[const SizedBox(width: 10), Flexible(child: _meta(Icons.location_on_outlined, location, flexible: true))],
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

  Widget _emptyCard({required IconData icon, required String message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: _whiteCard,
      child: Column(children: [
        Icon(icon, size: 36, color: const Color(0xFFB8C4D2)),
        const SizedBox(height: 10),
        Text(message, style: const TextStyle(color: Color(0xFF9AA8B8), fontSize: 15)),
      ]),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateString);
      final diff = DateTime.now().difference(date);
      if (diff.isNegative) {
        final left = -diff.inDays;
        if (left == 0) return 'Aujourd\'hui';
        if (left == 1) return 'Demain';
        if (left < 7) return 'Dans ${left}j';
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }
      if (diff.inDays == 0) return 'Aujourd\'hui';
      if (diff.inDays == 1) return 'Hier';
      if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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