import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/delegate_service.dart';
import '../state/auth_controller.dart';
import 'delegate_match_page.dart';

const _kNavy = Color(0xFF003049);
const _kSky = Color(0xFF00B4D8);
const _kMuted = Color(0xFF94A3B8);

String _two(int n) => n.toString().padLeft(2, '0');

String formatMatchDate(String? iso) {
  final d = DateTime.tryParse(iso ?? '')?.toLocal();
  if (d == null) return '—';
  return '${_two(d.day)}/${_two(d.month)}/${d.year} · ${_two(d.hour)}:${_two(d.minute)}';
}

const statusLabels = {
  'scheduled': 'À venir',
  'postponed': 'Reporté',
  'in_progress': 'En cours',
  'half_time': 'Mi-temps',
  'completed': 'Terminé',
};

Color statusColor(String? s) => switch (s) {
      'in_progress' || 'half_time' => const Color(0xFFDC2626),
      'completed' => const Color(0xFF059669),
      'postponed' => const Color(0xFFD97706),
      _ => _kNavy,
    };

/// Home of the match delegate: the matches the admin assigned to them.
class DelegateHomePage extends StatefulWidget {
  final AuthController auth;
  const DelegateHomePage({super.key, required this.auth});

  @override
  State<DelegateHomePage> createState() => _DelegateHomePageState();
}

class _DelegateHomePageState extends State<DelegateHomePage> {
  late final DelegateService _service = DelegateService(ApiClient(token: widget.auth.token));
  List<Map<String, dynamic>> _matches = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final list = await _service.myMatches();
      if (mounted) setState(() => _matches = list);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _open(Map<String, dynamic> m) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (_) => DelegateMatchPage(auth: widget.auth, matchId: m['id'] as int),
    ));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final live = _matches.where((m) => ['in_progress', 'half_time'].contains(m['status'])).toList();
    final upcoming = _matches.where((m) => ['scheduled', 'postponed'].contains(m['status'])).toList();
    final past = _matches.where((m) => m['status'] == 'completed').toList().reversed.toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: _kNavy,
          foregroundColor: Colors.white,
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Mes matchs', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            Text('Délégué · ${widget.auth.user?.name ?? ''}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ]),
          actions: [
            IconButton(icon: const Icon(Icons.refresh), tooltip: 'Actualiser', onPressed: _load),
            IconButton(icon: const Icon(Icons.logout), tooltip: 'Se déconnecter', onPressed: () => widget.auth.logout()),
          ],
          bottom: TabBar(
            indicatorColor: _kSky,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'À venir (${live.length + upcoming.length})'),
              Tab(text: 'Passés (${past.length})'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(children: [
                _tab([
                  if (live.isNotEmpty) ..._section('En direct', live),
                  if (upcoming.isNotEmpty) ..._section('Prochains matchs', upcoming),
                ], "Aucun match à venir ne vous est affecté pour l'instant."),
                _tab(past.map(_card).toList(), 'Aucun match terminé.'),
              ]),
      ),
    );
  }

  Widget _tab(List<Widget> children, String empty) => RefreshIndicator(
        onRefresh: _load,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          if (children.isEmpty && _error == null)
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(children: [
                const Icon(Icons.sports_soccer, size: 56, color: Color(0xFFCBD5E1)),
                const SizedBox(height: 12),
                Text(empty, textAlign: TextAlign.center, style: const TextStyle(color: _kMuted)),
              ]),
            ),
          ...children,
        ]),
      );

  List<Widget> _section(String title, List<Map<String, dynamic>> items) => [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(title.toUpperCase(),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kMuted, letterSpacing: 0.6)),
        ),
        ...items.map(_card),
      ];

  Widget _card(Map<String, dynamic> m) {
    final status = m['status'] as String?;
    final home = (m['homeTeam'] as Map?)?['name'] ?? '?';
    final away = (m['awayTeam'] as Map?)?['name'] ?? '?';
    final started = status != 'scheduled' && status != 'postponed';
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _open(m),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusColor(status).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(statusLabels[status] ?? status ?? '',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor(status))),
              ),
              const Spacer(),
              Text(formatMatchDate(m['date'] as String?), style: const TextStyle(fontSize: 11, color: _kMuted)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: Text('$home', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
              Text(started ? '${m['homeTeamScore'] ?? 0} – ${m['awayTeamScore'] ?? 0}' : 'vs',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _kNavy)),
              Expanded(child: Text('$away', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
            ]),
            if ((m['location'] ?? '').toString().isNotEmpty || m['tournament'] != null) ...[
              const SizedBox(height: 8),
              Text([
                if (m['tournament'] != null) (m['tournament'] as Map)['name'],
                if ((m['location'] ?? '').toString().isNotEmpty) m['location'],
              ].join(' · '), style: const TextStyle(fontSize: 12, color: _kMuted)),
            ],
            if (status == 'in_progress' || status == 'half_time' || status == 'scheduled') ...[
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.edit_note, size: 16, color: _kSky),
                const SizedBox(width: 4),
                Text(status == 'scheduled' ? 'Ouvrir pour lancer le match' : 'Continuer le suivi',
                    style: const TextStyle(fontSize: 12, color: _kSky, fontWeight: FontWeight.w600)),
              ]),
            ],
          ]),
        ),
      ),
    );
  }
}
