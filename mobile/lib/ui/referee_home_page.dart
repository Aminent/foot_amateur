// Espace Arbitre — reconstruit d'après l'APK du 15/10.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_client.dart';
import '../services/notification_service.dart';
import '../services/referee_service.dart';
import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import 'referee_history_page.dart';
import 'referee_match_sheet_page.dart';
import 'referee_missions_page.dart';
import 'referee_profile_page.dart';

const refereeAccent = Color(0xFF111827);

String formatMatchDate(DateTime d) {
  const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  const months = ['janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin', 'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'];
  final hh = d.hour.toString().padLeft(2, '0');
  final mm = d.minute.toString().padLeft(2, '0');
  return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]} · $hh:$mm';
}

/// Navigation principale de l'arbitre (4 onglets).
class RefereeShell extends StatefulWidget {
  final AuthController auth;
  const RefereeShell({super.key, required this.auth});

  @override
  State<RefereeShell> createState() => _RefereeShellState();
}

class _RefereeShellState extends State<RefereeShell> {
  int _index = 0;
  final _refreshKey = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    NotificationService.onNotificationTap = (data) {
      if (data['type'] == 'referee_mission') setState(() => _index = 1);
    };
  }

  @override
  void dispose() {
    NotificationService.onNotificationTap = null;
    _refreshKey.dispose();
    super.dispose();
  }

  void goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      RefereeHomePage(auth: widget.auth, onSeeMissions: () => goTo(1), refresh: _refreshKey),
      RefereeeMissionsPage(auth: widget.auth, refresh: _refreshKey),
      RefereeHistoryPage(auth: widget.auth, refresh: _refreshKey),
      RefereeProfilePage(auth: widget.auth),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: goTo,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Missions'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historique'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class RefereeHomePage extends StatefulWidget {
  final AuthController auth;
  final VoidCallback onSeeMissions;
  final ValueNotifier<int> refresh;
  const RefereeHomePage({super.key, required this.auth, required this.onSeeMissions, required this.refresh});

  @override
  State<RefereeHomePage> createState() => _RefereeHomePageState();
}

class _RefereeHomePageState extends State<RefereeHomePage> {
  late final RefereeService _service = RefereeService(ApiClient(token: widget.auth.token));
  RefereeStats? _stats;
  List<RefereeMission> _pending = [];
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    widget.refresh.addListener(_load);
    _load();
  }

  @override
  void dispose() {
    widget.refresh.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([_service.getMyStats(), _service.getMyMissions(status: 'pending')]);
      if (!mounted) return;
      setState(() {
        _stats = results[0] as RefereeStats;
        _pending = results[1] as List<RefereeMission>;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _stats ?? const RefereeStats();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _RefereeHeroHeader(name: widget.auth.user?.name ?? 'Arbitre', stats: s),
            if (_loading && _stats == null)
              const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator()))
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.errorRed)),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: _load, child: const Text('Réessayer')),
                ]),
              )
            else ...[
              _sectionTitle('Prochaine mission'),
              _NextMissionCard(
                mission: s.nextMission,
                onOpen: s.nextMission == null
                    ? null
                    : () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => RefereeMatchSheetPage(auth: widget.auth, mission: s.nextMission!),
                        )).then((_) => widget.refresh.value++),
              ),
              _sectionTitle('En attente de réponse', trailing: TextButton(onPressed: widget.onSeeMissions, child: const Text('Tout voir'))),
              if (_pending.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text('Aucune mission en attente', style: TextStyle(color: AppColors.textSecondary)),
                )
              else
                ..._pending.take(3).map((m) => _MissionRow(mission: m, onTap: widget.onSeeMissions)),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t, {Widget? trailing}) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
        child: Row(children: [
          Expanded(child: Text(t, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600))),
          if (trailing != null) trailing,
        ]),
      );
}

class _RefereeHeroHeader extends StatelessWidget {
  final String name;
  final RefereeStats stats;
  const _RefereeHeroHeader({required this.name, required this.stats});

  @override
  Widget build(BuildContext context) {
    Widget stat(String value, String label) => Expanded(
          child: Column(children: [
            Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ]),
        );
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [refereeAccent, Color(0xFF374151)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const CircleAvatar(radius: 24, backgroundColor: Color(0xFFFBBF24), child: Icon(Icons.sports, color: refereeAccent)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Arbitre', style: TextStyle(color: Colors.white70, fontSize: 13)),
              Text(name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
        const SizedBox(height: 22),
        Row(children: [
          stat('${stats.totalMissions}', 'Total missions'),
          stat('${stats.matchesRefereed}', 'Matchs arbitrés'),
          stat('${stats.acceptanceRate}%', 'Taux d\'acceptation'),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          const Icon(Icons.verified_outlined, color: Color(0xFF6EE7B7), size: 16),
          const SizedBox(width: 6),
          Text('${stats.officialDisputes} contestation officielle', style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ]),
    );
  }
}

class _NextMissionCard extends StatelessWidget {
  final RefereeMission? mission;
  final VoidCallback? onOpen;
  const _NextMissionCard({required this.mission, this.onOpen});

  @override
  Widget build(BuildContext context) {
    final m = mission;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: AppColors.borderGrey)),
        child: m == null
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Row(children: [
                  Icon(Icons.event_available, color: AppColors.textSecondary),
                  SizedBox(width: 12),
                  Expanded(child: Text('Aucune mission acceptée à venir', style: TextStyle(color: AppColors.textSecondary))),
                ]),
              )
            : InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onOpen,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      _RoleChip(label: m.roleLabel),
                      const Spacer(),
                      Text(formatMatchDate(m.date), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ]),
                    const SizedBox(height: 14),
                    Text('${m.homeTeam}  vs  ${m.awayTeam}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.place_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(child: Text(m.location, style: const TextStyle(color: AppColors.textSecondary))),
                    ]),
                    if (m.tournament.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(m.tournament, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                    const SizedBox(height: 14),
                    const Row(children: [
                      Icon(Icons.document_scanner_outlined, size: 18, color: AppColors.primaryBlue),
                      SizedBox(width: 6),
                      Text('Feuille de match', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                    ]),
                  ]),
                ),
              ),
      ),
    );
  }
}

class _MissionRow extends StatelessWidget {
  final RefereeMission mission;
  final VoidCallback onTap;
  const _MissionRow({required this.mission, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: const CircleAvatar(backgroundColor: Color(0xFFFEF3C7), child: Icon(Icons.hourglass_top, color: Color(0xFFB45309), size: 20)),
      title: Text('${mission.homeTeam} vs ${mission.awayTeam}', maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${mission.roleLabel} · ${formatMatchDate(mission.date)}'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  const _RoleChip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: refereeAccent, borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
      );
}
