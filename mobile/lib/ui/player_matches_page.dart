import 'package:flutter/material.dart';

import '../state/auth_controller.dart';
import '../services/player_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';
import 'match_detail_page.dart';

class PlayerMatchesPage extends StatefulWidget {
  final AuthController auth;
  final String? myTeamName;
  const PlayerMatchesPage({super.key, required this.auth, this.myTeamName});

  @override
  State<PlayerMatchesPage> createState() => _PlayerMatchesPageState();
}

class _PlayerMatchesPageState extends State<PlayerMatchesPage> {
  late PlayerService _playerService;
  late Future<Map<String, dynamic>> _matchesFuture;
  bool _standingsExpanded = false;

  @override
  void initState() {
    super.initState();
    _playerService = PlayerService(ApiClient(token: widget.auth.token));
    _matchesFuture = _playerService.getMyMatches();
  }

  void _reload() {
    setState(() {
      _matchesFuture = _playerService.getMyMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Mes matchs'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return AppErrorWidget(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }

          final data = snapshot.data!;
          final upcoming = data['upcomingMatches'] as List? ?? [];
          final recent = data['recentMatches'] as List? ?? [];
          final tournament = data['tournament'] as Map<String, dynamic>?;
          final standings = data['standings'] as List? ?? [];
          final myPosition = data['myPosition'] as int?;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Tournament Banner ────────────────────────────────────────
                if (tournament != null)
                  _TournamentBanner(
                    tournament: tournament,
                    myPosition: myPosition,
                    standings: standings,
                    expanded: _standingsExpanded,
                    onToggle: () =>
                        setState(() => _standingsExpanded = !_standingsExpanded),
                  ),

                const SizedBox(height: 16),

                // ── Upcoming ─────────────────────────────────────────────────
                _SectionHeader(
                  label: 'À VENIR',
                  count: upcoming.length,
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(height: 8),
                if (upcoming.isEmpty)
                  _EmptySlot(
                    icon: Icons.event_available,
                    message: 'Aucun match à venir',
                  )
                else
                  ...upcoming.map((m) => _UpcomingCard(match: m, auth: widget.auth)),

                const SizedBox(height: 24),

                // ── Recent ───────────────────────────────────────────────────
                _SectionHeader(
                  label: 'HISTORIQUE',
                  count: recent.length,
                  color: const Color(0xFF64748B),
                ),
                const SizedBox(height: 8),
                if (recent.isEmpty)
                  _EmptySlot(
                    icon: Icons.history,
                    message: 'Aucun match joué',
                  )
                else
                  ...recent.map((m) => _RecentCard(match: m, auth: widget.auth)),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tournament Banner + collapsible standings
// ─────────────────────────────────────────────────────────────────────────────

class _TournamentBanner extends StatelessWidget {
  final Map<String, dynamic> tournament;
  final int? myPosition;
  final List standings;
  final bool expanded;
  final VoidCallback onToggle;

  const _TournamentBanner({
    required this.tournament,
    required this.myPosition,
    required this.standings,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final name = tournament['name'] as String? ?? 'Tournoi';
    final format = tournament['format'] as String? ?? '';
    final formatLabel = format == 'league'
        ? 'Ligue'
        : format == 'knockout'
            ? 'Élimination directe'
            : format;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.emoji_events,
                      color: Color(0xFFFBBF24), size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      if (formatLabel.isNotEmpty)
                        Text(formatLabel,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12)),
                    ],
                  ),
                ),
                if (myPosition != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _positionColor(myPosition!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_ordinal(myPosition!)} place',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),

          // Standings toggle (only for league)
          if (standings.isNotEmpty && format == 'league')
            InkWell(
              onTap: onToggle,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border(
                      top: BorderSide(
                          color: Colors.white.withOpacity(0.1))),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.table_chart,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    const Text('Classement',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const Spacer(),
                    Icon(
                        expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white70,
                        size: 20),
                  ],
                ),
              ),
            ),

          if (expanded && standings.isNotEmpty && format == 'league')
            _MiniStandings(standings: standings),
        ],
      ),
    );
  }

  Color _positionColor(int pos) {
    if (pos == 1) return const Color(0xFFF59E0B);
    if (pos == 2) return const Color(0xFF6B7280);
    if (pos == 3) return const Color(0xFFB45309);
    return const Color(0xFF3B82F6);
  }

  String _ordinal(int n) {
    if (n == 1) return '1ère';
    return '${n}ème';
  }
}

class _MiniStandings extends StatelessWidget {
  final List standings;
  const _MiniStandings({required this.standings});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: const [
                SizedBox(width: 28),
                SizedBox(width: 8),
                Expanded(
                    child: Text('Équipe',
                        style: TextStyle(color: Colors.white54, fontSize: 11))),
                _StdHdr('J'),
                _StdHdr('V'),
                _StdHdr('N'),
                _StdHdr('D'),
                _StdHdr('DB'),
                _StdHdr('Pts'),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          ...standings.take(6).toList().asMap().entries.map((e) {
            final idx = e.key;
            final s = e.value as Map<String, dynamic>;
            final isMe = s['isMyTeam'] == true;
            return Container(
              color: isMe
                  ? const Color(0xFF3B82F6).withOpacity(0.2)
                  : idx.isEven
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.02),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              child: Row(
                children: [
                  _PosBadge(pos: idx + 1),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s['teamName'] as String? ?? '',
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.white70,
                        fontWeight:
                            isMe ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StdCell('${s['played'] ?? 0}'),
                  _StdCell('${s['won'] ?? 0}'),
                  _StdCell('${s['drawn'] ?? 0}'),
                  _StdCell('${s['lost'] ?? 0}'),
                  _StdCell('${(s['goalDiff'] ?? 0) >= 0 ? '+' : ''}${s['goalDiff'] ?? 0}'),
                  _StdCell('${s['points'] ?? 0}', bold: true, highlight: isMe),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _StdHdr extends StatelessWidget {
  final String text;
  const _StdHdr(this.text);
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 30,
      child: Text(text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white38, fontSize: 11)));
}

class _StdCell extends StatelessWidget {
  final String text;
  final bool bold;
  final bool highlight;
  const _StdCell(this.text, {this.bold = false, this.highlight = false});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 30,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: highlight ? const Color(0xFF93C5FD) : Colors.white60,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      );
}

class _PosBadge extends StatelessWidget {
  final int pos;
  const _PosBadge({required this.pos});

  Color get _color {
    if (pos == 1) return const Color(0xFFF59E0B);
    if (pos == 2) return const Color(0xFF9CA3AF);
    if (pos == 3) return const Color(0xFFB45309);
    return const Color(0xFF475569);
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
        child: Center(
          child: Text('$pos',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _SectionHeader(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(label,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
          const Spacer(),
          Text('$count match${count > 1 ? 's' : ''}',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Upcoming match card
// ─────────────────────────────────────────────────────────────────────────────

class _UpcomingCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final AuthController auth;
  const _UpcomingCard({required this.match, required this.auth});

  @override
  Widget build(BuildContext context) {
    final matchId  = match['id'] as int?;
    final opponent = _opponentName(match['opponent']);
    final isHome   = match['myTeamIsHome'] as bool? ?? true;
    final round    = match['round'];
    final location = match['location'] as String?;
    final dateStr  = match['date'] as String?;
    final formatted = _fmtDate(dateStr);

    return GestureDetector(
      onTap: matchId == null ? null : () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => MatchDetailPage(
          auth: auth, matchId: matchId,
          homeTeam: isHome ? 'Mon équipe' : opponent,
          awayTeam: isHome ? opponent : 'Mon équipe',
          myTeamIsHome: isHome,
        ),
      )),
      child: Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          // top stripe
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // badges row
                Row(
                  children: [
                    _Pill('À VENIR', const Color(0xFF10B981)),
                    const SizedBox(width: 6),
                    _Pill(isHome ? '🏠 Domicile' : '✈️ Extérieur',
                        const Color(0xFF6366F1)),
                    if (round != null) ...[
                      const SizedBox(width: 6),
                      _Pill('J$round', const Color(0xFF64748B)),
                    ],
                    const Spacer(),
                    Text(formatted,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 12),
                // teams row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.sports_soccer,
                          color: Color(0xFF6366F1), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHome
                                ? 'Mon équipe vs $opponent'
                                : '$opponent vs Mon équipe',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          if (location != null && location.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 12,
                                      color: Colors.grey.shade400),
                                  const SizedBox(width: 3),
                                  Text(location,
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ), // Container
    ); // GestureDetector
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recent match card
// ─────────────────────────────────────────────────────────────────────────────

class _RecentCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final AuthController auth;
  const _RecentCard({required this.match, required this.auth});

  @override
  Widget build(BuildContext context) {
    final matchId  = match['id'] as int?;
    final opponent = _opponentName(match['opponent']);
    final isHome   = match['myTeamIsHome'] as bool? ?? true;
    final gf = match['goalsFor'] ?? match['homeTeamScore'] ?? 0;
    final ga = match['goalsAgainst'] ?? match['awayTeamScore'] ?? 0;
    final result = match['result'] as String?;
    final round = match['round'];
    final dateStr = match['date'] as String?;

    // Determine result if not pre-computed
    final String resultLabel;
    final Color resultColor;
    final IconData resultIcon;

    if (result == 'V' || (result == null && gf > ga)) {
      resultLabel = 'Victoire';
      resultColor = const Color(0xFF10B981);
      resultIcon = Icons.emoji_events;
    } else if (result == 'N' || (result == null && gf == ga)) {
      resultLabel = 'Nul';
      resultColor = const Color(0xFFF59E0B);
      resultIcon = Icons.handshake;
    } else {
      resultLabel = 'Défaite';
      resultColor = const Color(0xFFEF4444);
      resultIcon = Icons.close;
    }

    return GestureDetector(
      onTap: matchId == null ? null : () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => MatchDetailPage(
          auth: auth, matchId: matchId,
          homeTeam: isHome ? 'Mon équipe' : opponent,
          awayTeam: isHome ? opponent : 'Mon équipe',
          myTeamIsHome: isHome,
        ),
      )),
      child: Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: resultColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // result icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: resultColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(resultIcon, color: resultColor, size: 22),
                ),
                const SizedBox(width: 12),
                // match info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isHome
                            ? 'Mon équipe vs $opponent'
                            : '$opponent vs Mon équipe',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(_fmtDate(dateStr),
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 11)),
                          if (round != null) ...[
                            Text('  ·  ',
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 11)),
                            Text('J$round',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // score + result
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$gf – $ga',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: resultColor),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: resultColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        resultLabel,
                        style: TextStyle(
                            color: resultColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ), // Container
    ); // GestureDetector
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _EmptySlot extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptySlot({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.grey.shade300),
          const SizedBox(width: 12),
          Text(message,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;
  const _Pill(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      );
}

/// Safely extracts the opponent name whether the backend sent a String or a {id,name} Map.
String _opponentName(dynamic raw) {
  if (raw == null) return 'Adversaire';
  if (raw is String) return raw.isNotEmpty ? raw : 'Adversaire';
  if (raw is Map) return (raw['name'] as String?)?.isNotEmpty == true ? raw['name'] as String : 'Adversaire';
  return 'Adversaire';
}
String _fmtDate(String? raw) {
  if (raw == null || raw.isEmpty) return 'Date inconnue';
  try {
    final d = DateTime.parse(raw);
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}'
        ' ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  } catch (_) {
    return raw;
  }
}
