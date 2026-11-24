// Espace Arbitre — reconstruit d'après l'APK du 15/10.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_client.dart';
import '../services/referee_service.dart';
import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import 'referee_home_page.dart' show formatMatchDate;
import 'referee_match_sheet_page.dart';

/// Matchs passés sur lesquels l'arbitre a accepté la mission.
class RefereeHistoryPage extends StatefulWidget {
  final AuthController auth;
  final ValueNotifier<int> refresh;
  const RefereeHistoryPage({super.key, required this.auth, required this.refresh});

  @override
  State<RefereeHistoryPage> createState() => _RefereeHistoryPageState();
}

class _RefereeHistoryPageState extends State<RefereeHistoryPage> {
  late final RefereeService _service = RefereeService(ApiClient(token: widget.auth.token));
  List<RefereeMission> _items = [];
  bool _loading = true;
  String? _error;

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
      final list = await _service.getMyMissions(status: 'accepted');
      final past = list.where((m) => !m.isUpcoming || m.isCompleted).toList()..sort((a, b) => b.date.compareTo(a.date));
      if (mounted) setState(() { _items = past; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString().replaceFirst('Exception: ', ''); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Historique', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: TextButton(onPressed: _load, child: Text('$_error\nRéessayer', textAlign: TextAlign.center)))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _items.isEmpty
                      ? ListView(children: const [
                          SizedBox(height: 140),
                          Center(child: Text('Aucun match arbitré pour l\'instant', style: TextStyle(color: AppColors.textSecondary))),
                        ])
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
                          itemBuilder: (_, i) {
                            final m = _items[i];
                            final sheets = (m.presenceSheetUrl != null ? 1 : 0) + (m.matchSheetUrl != null ? 1 : 0);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.dividerGrey,
                                child: Text(m.isCompleted ? '${m.homeScore}-${m.awayScore}' : '—',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              ),
                              title: Text('${m.homeTeam} vs ${m.awayTeam}', maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Text('${m.roleLabel} · ${formatMatchDate(m.date)}'),
                              trailing: Icon(sheets == 2 ? Icons.task_alt : Icons.pending_actions,
                                  color: sheets == 2 ? AppColors.successGreen : AppColors.warningYellow),
                              onTap: () => Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) => RefereeMatchSheetPage(auth: widget.auth, mission: m)))
                                  .then((_) => widget.refresh.value++),
                            );
                          },
                        ),
                ),
    );
  }
}
