// Espace Arbitre — reconstruit d'après l'APK du 15/10.
// Le nom de classe « RefereeeMissionsPage » (3 e) est repris tel quel de l'APK.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_client.dart';
import '../services/referee_service.dart';
import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import 'referee_home_page.dart' show formatMatchDate, refereeAccent;
import 'referee_match_sheet_page.dart';

class RefereeeMissionsPage extends StatefulWidget {
  final AuthController auth;
  final ValueNotifier<int> refresh;
  const RefereeeMissionsPage({super.key, required this.auth, required this.refresh});

  @override
  State<RefereeeMissionsPage> createState() => _RefereeeMissionsPageState();
}

class _RefereeeMissionsPageState extends State<RefereeeMissionsPage> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  late final RefereeService _service = RefereeService(ApiClient(token: widget.auth.token));
  List<RefereeMission> _missions = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.refresh.addListener(_loadMissions);
    _loadMissions();
  }

  @override
  void dispose() {
    widget.refresh.removeListener(_loadMissions);
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _loadMissions() async {
    setState(() { _loading = true; _error = null; });
    try {
      final list = await _service.getMyMissions();
      if (mounted) setState(() { _missions = list; _loading = false; });
    } catch (e) {
      debugPrint('Erreur chargement missions: $e');
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  Future<void> _respond(RefereeMission m, bool accept) async {
    String? reason;
    if (!accept) {
      reason = await showDialog<String>(context: context, builder: (_) => const _DeclineDialog());
      if (reason == null) return; // annulé
    }
    try {
      await _service.respondToMission(m.id, accept: accept, reason: reason);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(accept ? 'Mission acceptée' : 'Mission refusée')));
      widget.refresh.value++; // recharge toutes les pages arbitre
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<RefereeMission> by(String s) => _missions.where((m) => m.status == s).toList();
    final pending = by('pending'), accepted = by('accepted'), declined = by('declined');
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mes missions', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabs,
          labelColor: refereeAccent,
          indicatorColor: refereeAccent,
          tabs: [
            Tab(text: 'En attente (${pending.length})'),
            Tab(text: 'Acceptées (${accepted.length})'),
            Tab(text: 'Refusées (${declined.length})'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(_error!, style: const TextStyle(color: AppColors.errorRed)),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: _loadMissions, child: const Text('Réessayer')),
                  ]),
                )
              : TabBarView(controller: _tabs, children: [
                  _MissionList(missions: pending, empty: 'Aucune mission en attente', onRefresh: _loadMissions,
                      builder: (m) => _MissionCard(mission: m, onAccept: () => _respond(m, true), onDecline: () => _respond(m, false))),
                  _MissionList(missions: accepted, empty: 'Aucune mission acceptée', onRefresh: _loadMissions,
                      builder: (m) => _MissionCard(
                            mission: m,
                            onOpen: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => RefereeMatchSheetPage(auth: widget.auth, mission: m)))
                                .then((_) => widget.refresh.value++),
                          )),
                  _MissionList(missions: declined, empty: 'Aucune mission refusée', onRefresh: _loadMissions,
                      builder: (m) => _MissionCard(mission: m)),
                ]),
    );
  }
}

class _MissionList extends StatelessWidget {
  final List<RefereeMission> missions;
  final String empty;
  final Future<void> Function() onRefresh;
  final Widget Function(RefereeMission) builder;
  const _MissionList({required this.missions, required this.empty, required this.onRefresh, required this.builder});

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: onRefresh,
        child: missions.isEmpty
            ? ListView(children: [
                const SizedBox(height: 120),
                const Icon(Icons.inbox_outlined, size: 56, color: AppColors.textSecondary),
                const SizedBox(height: 12),
                Text(empty, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
              ])
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: missions.length,
                itemBuilder: (_, i) => builder(missions[i]),
              ),
      );
}

class _MissionCard extends StatelessWidget {
  final RefereeMission mission;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onOpen;
  const _MissionCard({required this.mission, this.onAccept, this.onDecline, this.onOpen});

  @override
  Widget build(BuildContext context) {
    final m = mission;
    final sheetsDone = (m.presenceSheetUrl != null ? 1 : 0) + (m.matchSheetUrl != null ? 1 : 0);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.borderGrey)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(m.roleLabel, style: const TextStyle(fontWeight: FontWeight.w600, color: refereeAccent)),
              const Spacer(),
              Text(formatMatchDate(m.date), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ]),
            const SizedBox(height: 10),
            Text('${m.homeTeam}  vs  ${m.awayTeam}', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(m.tournament.isEmpty ? m.location : '${m.tournament} · ${m.location}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            if (m.declineReason != null) ...[
              const SizedBox(height: 6),
              Text('Motif : ${m.declineReason}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            ],
            if (onAccept != null || onDecline != null) ...[
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: onDecline, style: OutlinedButton.styleFrom(foregroundColor: AppColors.errorRed), child: const Text('Refuser'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: onAccept, style: FilledButton.styleFrom(backgroundColor: AppColors.successGreen), child: const Text('Accepter'))),
              ]),
            ],
            if (onOpen != null) ...[
              const SizedBox(height: 12),
              Row(children: [
                Icon(sheetsDone == 2 ? Icons.check_circle : Icons.document_scanner_outlined,
                    size: 18, color: sheetsDone == 2 ? AppColors.successGreen : AppColors.primaryBlue),
                const SizedBox(width: 6),
                Text(sheetsDone == 2 ? 'Feuilles envoyées' : 'Feuilles : $sheetsDone/2',
                    style: TextStyle(color: sheetsDone == 2 ? AppColors.successGreen : AppColors.primaryBlue, fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ]),
            ],
          ]),
        ),
      ),
    );
  }
}

class _DeclineDialog extends StatefulWidget {
  const _DeclineDialog();
  @override
  State<_DeclineDialog> createState() => _DeclineDialogState();
}

class _DeclineDialogState extends State<_DeclineDialog> {
  final _ctrl = TextEditingController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Refuser la mission'),
        content: TextField(controller: _ctrl, maxLength: 300, decoration: const InputDecoration(hintText: 'Motif (optionnel)')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(context, _ctrl.text.trim()), child: const Text('Refuser')),
        ],
      );
}
