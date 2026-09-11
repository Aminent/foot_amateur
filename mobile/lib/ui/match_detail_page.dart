import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_client.dart';
import '../state/auth_controller.dart';

class MatchDetailPage extends StatefulWidget {
  final AuthController auth;
  final int matchId;
  final String homeTeam;
  final String awayTeam;
  final bool myTeamIsHome;

  const MatchDetailPage({
    super.key,
    required this.auth,
    required this.matchId,
    required this.homeTeam,
    required this.awayTeam,
    this.myTeamIsHome = true,
  });

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  late final ApiClient _api;
  Map<String, dynamic>? _match;
  bool _loading = true;
  String? _error;

  static const _teal = Color(0xFF55C1CF);

  @override
  void initState() {
    super.initState();
    _api = ApiClient(token: widget.auth.token);
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await _api.dio.get('/matches/${widget.matchId}');
      if (res.statusCode == 200) {
        final m = res.data['match'] as Map<String, dynamic>? ?? res.data;
        if (mounted) setState(() { _match = m; _loading = false; });
      } else {
        if (mounted) setState(() { _error = 'Impossible de charger le match'; _loading = false; });
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _teal))
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() => Scaffold(
    appBar: AppBar(
      title: Text('${widget.homeTeam} vs ${widget.awayTeam}'),
      backgroundColor: const Color(0xFF0F172A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, size: 48, color: Colors.red),
      const SizedBox(height: 12),
      Text(_error ?? 'Erreur', style: const TextStyle(fontSize: 15, color: Color(0xFF475569))),
      const SizedBox(height: 16),
      TextButton(onPressed: () { setState(() { _loading = true; _error = null; }); _load(); },
          child: const Text('Réessayer')),
    ])),
  );

  Widget _buildContent() {
    final m = _match!;
    final homeTeam   = (m['homeTeam'] as Map?)?.containsKey('name') == true
        ? m['homeTeam']['name'] as String? ?? widget.homeTeam
        : widget.homeTeam;
    final awayTeam   = (m['awayTeam'] as Map?)?.containsKey('name') == true
        ? m['awayTeam']['name'] as String? ?? widget.awayTeam
        : widget.awayTeam;
    final homeScore  = m['homeTeamScore'] as int? ?? 0;
    final awayScore  = m['awayTeamScore'] as int? ?? 0;
    final status     = m['status'] as String? ?? 'scheduled';
    final location   = m['location'] as String?;
    final date       = m['date'] as String?;
    final htHome     = m['halfTimeHomeScore'] as int?;
    final htAway     = m['halfTimeAwayScore'] as int?;
    final events     = List<Map<String, dynamic>>.from(m['events'] ?? []);
    events.sort((a, b) => (a['minute'] as int? ?? 0).compareTo(b['minute'] as int? ?? 0));

    final isCompleted = status == 'completed';
    final isLive      = status == 'in_progress' || status == 'half_time';

    return CustomScrollView(
      slivers: [
        // ── Hero scoreboard ───────────────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),

                    // Status
                    _StatusBadge(status: status),
                    const SizedBox(height: 16),

                    // Teams + Score
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          // Home
                          Expanded(child: Column(children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withAlpha(40),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFF3B82F6).withAlpha(80)),
                              ),
                              child: Center(child: Text(homeTeam[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))),
                            ),
                            const SizedBox(height: 8),
                            Text(homeTeam, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            const Text('Domicile', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          ])),

                          // Score
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: isLive
                                      ? const LinearGradient(colors: [Color(0xFF16A34A), Color(0xFF15803D)])
                                      : const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Text('$homeScore – $awayScore',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32, letterSpacing: -1)),
                              ),
                              if (htHome != null) ...[
                                const SizedBox(height: 6),
                                Text('MT : $htHome – $htAway',
                                    style: const TextStyle(color: Colors.white38, fontSize: 11)),
                              ],
                            ]),
                          ),

                          // Away
                          Expanded(child: Column(children: [
                            Container(
                              width: 56, height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withAlpha(40),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFEF4444).withAlpha(80)),
                              ),
                              child: Center(child: Text(awayTeam[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))),
                            ),
                            const SizedBox(height: 8),
                            Text(awayTeam, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            const Text('Extérieur', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          ])),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date + location
                    if (date != null || location != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          if (date != null) ...[
                            const Icon(Icons.schedule, size: 12, color: Colors.white38),
                            const SizedBox(width: 4),
                            Text(_fmtDate(date), style: const TextStyle(color: Colors.white54, fontSize: 11)),
                          ],
                          if (date != null && location != null)
                            const Text('  ·  ', style: TextStyle(color: Colors.white38, fontSize: 11)),
                          if (location != null) ...[
                            const Icon(Icons.location_on, size: 12, color: Colors.white38),
                            const SizedBox(width: 4),
                            Flexible(child: Text(location, style: const TextStyle(color: Colors.white54, fontSize: 11),
                                overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () async {
                                final q = Uri.encodeComponent(location);
                                final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$q');
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Maps', style: TextStyle(fontSize: 9, color: Color(0xFF55C1CF), fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // ── Result banner (if completed) ────────────────────────────────
              if (isCompleted) ...[
                _ResultBanner(homeScore: homeScore, awayScore: awayScore, myTeamIsHome: widget.myTeamIsHome, homeTeam: homeTeam, awayTeam: awayTeam),
                const SizedBox(height: 20),
              ],

              // ── Events timeline ─────────────────────────────────────────────
              _sectionHeader('Événements du match', Icons.timeline),
              const SizedBox(height: 12),
              events.isEmpty
                  ? _emptyCard(Icons.sports_soccer, 'Aucun événement enregistré')
                  : _card(Column(
                      children: [
                        // MT separator insertion
                        ..._buildTimeline(events, homeTeam, awayTeam, htHome),
                      ],
                    )),

              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTimeline(
      List<Map<String, dynamic>> events, String homeTeam, String awayTeam, int? htHome) {
    final widgets = <Widget>[];
    bool addedHt = false;

    for (int i = 0; i < events.length; i++) {
      final ev = events[i];
      final minute = ev['minute'] as int? ?? 0;

      // Insert half-time divider
      if (!addedHt && htHome != null && minute > 45) {
        addedHt = true;
        widgets.add(_HtDivider());
      }

      widgets.add(_EventRow(event: ev, homeTeam: homeTeam, awayTeam: awayTeam));
      if (i < events.length - 1) widgets.add(const Divider(height: 1, indent: 52));
    }

    return widgets;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) => Row(children: [
    Container(width: 4, height: 20, decoration: BoxDecoration(color: _teal, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 10),
    Icon(icon, size: 17, color: const Color(0xFF64748B)),
    const SizedBox(width: 6),
    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
  ]);

  Widget _card(Widget child) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2))],
    ),
    child: child,
  );

  Widget _emptyCard(IconData icon, String msg) => Container(
    width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 32),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2))]),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 40, color: Colors.grey.shade300),
      const SizedBox(height: 10),
      Text(msg, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
    ]),
  );

  String _fmtDate(String raw) {
    try {
      final d = DateTime.parse(raw);
      return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}  ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
    } catch (_) { return raw; }
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: cfg.$1.withAlpha(40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cfg.$1.withAlpha(80)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (status == 'in_progress')
          Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(color: cfg.$1, shape: BoxShape.circle)),
        Text(cfg.$2, style: TextStyle(color: cfg.$1, fontWeight: FontWeight.w700, fontSize: 12)),
      ]),
    );
  }

  (Color, String) _cfg() => switch (status) {
    'in_progress' => (const Color(0xFF16A34A), '🔴 En direct'),
    'half_time'   => (const Color(0xFFCA8A04), '⏸ Mi-temps'),
    'completed'   => (const Color(0xFF475569), '✅ Terminé'),
    'scheduled'   => (const Color(0xFF3B82F6), '📅 Planifié'),
    'postponed'   => (const Color(0xFF7C3AED), '⏳ Reporté'),
    'cancelled'   => (const Color(0xFFDC2626), '❌ Annulé'),
    _             => (const Color(0xFF64748B), status),
  };
}

// ── Result banner ─────────────────────────────────────────────────────────────
class _ResultBanner extends StatelessWidget {
  final int homeScore, awayScore;
  final bool myTeamIsHome;
  final String homeTeam, awayTeam;
  const _ResultBanner({required this.homeScore, required this.awayScore, required this.myTeamIsHome, required this.homeTeam, required this.awayTeam});

  @override
  Widget build(BuildContext context) {
    final myGoals  = myTeamIsHome ? homeScore : awayScore;
    final oppGoals = myTeamIsHome ? awayScore : homeScore;
    final String label;
    final Color color;
    final IconData icon;
    if (myGoals > oppGoals) {
      label = '🏆 Victoire'; color = const Color(0xFF16A34A); icon = Icons.emoji_events;
    } else if (myGoals == oppGoals) {
      label = '🤝 Match nul'; color = const Color(0xFFF59E0B); icon = Icons.handshake;
    } else {
      label = '❌ Défaite'; color = const Color(0xFFEF4444); icon = Icons.close;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: color)),
          Text('${myTeamIsHome ? homeTeam : awayTeam}  $myGoals – $oppGoals  ${myTeamIsHome ? awayTeam : homeTeam}',
              style: TextStyle(color: color.withAlpha(180), fontSize: 12)),
        ]),
      ]),
    );
  }
}

// ── Half-time divider ─────────────────────────────────────────────────────────
class _HtDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(children: [
      const Expanded(child: Divider()),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFFEF9C3), borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF59E0B).withAlpha(80))),
        child: const Text('Mi-temps', style: TextStyle(color: Color(0xFFB45309), fontSize: 11, fontWeight: FontWeight.w700)),
      ),
      const Expanded(child: Divider()),
    ]),
  );
}

// ── Event row ─────────────────────────────────────────────────────────────────
class _EventRow extends StatelessWidget {
  final Map<String, dynamic> event;
  final String homeTeam, awayTeam;
  const _EventRow({required this.event, required this.homeTeam, required this.awayTeam});

  static const _icons = <String, String>{
    'goal': '⚽', 'penalty_goal': '🎯', 'own_goal': '⚽',
    'yellow_card': '🟨', 'red_card': '🟥', 'substitution': '🔄', 'injury': '🚑',
  };

  static const _colors = <String, Color>{
    'goal': Color(0xFF16A34A), 'penalty_goal': Color(0xFF15803D), 'own_goal': Color(0xFFDC2626),
    'yellow_card': Color(0xFFCA8A04), 'red_card': Color(0xFFDC2626),
    'substitution': Color(0xFF7C3AED), 'injury': Color(0xFFEA580C),
  };

  @override
  Widget build(BuildContext context) {
    final type      = event['type'] as String? ?? '';
    final isHome    = event['isHomeTeam'] as bool? ?? true;
    final minute    = event['minute'] as int? ?? 0;
    final extra     = event['extraMinute'] as int?;
    final player    = event['relatedPlayerName'] as String?
        ?? event['substitutionPlayerOutName'] as String?
        ?? '—';
    final subIn     = event['substitutionPlayerInName'] as String?;
    final icon      = _icons[type] ?? '•';
    final color     = _colors[type] ?? const Color(0xFF64748B);
    final team      = isHome ? homeTeam : awayTeam;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        children: isHome
            ? _buildRow(icon, color, minute, extra, player, subIn, team, true)
            : _buildRow(icon, color, minute, extra, player, subIn, team, false),
      ),
    );
  }

  List<Widget> _buildRow(String icon, Color color, int min, int? extra, String player, String? subIn, String team, bool isHome) {
    final minuteBadge = Container(
      width: 44, height: 28,
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: Text("$min'${extra != null ? '+$extra' : ''}", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );

    final playerInfo = Expanded(child: Padding(
      padding: EdgeInsets.only(left: isHome ? 10 : 0, right: isHome ? 0 : 10),
      child: Column(
        crossAxisAlignment: isHome ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: isHome
                ? [Text(icon, style: const TextStyle(fontSize: 16)), const SizedBox(width: 6), Flexible(child: Text(player, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)))]
                : [Flexible(child: Text(player, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))), const SizedBox(width: 6), Text(icon, style: const TextStyle(fontSize: 16))],
          ),
          if (subIn != null) Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: isHome ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: isHome
                  ? [Text('↑ $subIn', style: const TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.w600))]
                  : [Text('↑ $subIn', style: const TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.w600))],
            ),
          ),
          Text(team, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        ],
      ),
    ));

    return isHome
        ? [minuteBadge, playerInfo]
        : [playerInfo, minuteBadge];
  }
}
