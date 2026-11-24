import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../state/auth_controller.dart';
import '../services/player_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/home_design.dart';
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

  Future<void> _reload() async {
    setState(() {
      _matchesFuture = _playerService.getMyMatches();
    });
    await _matchesFuture.catchError((_) => <String, dynamic>{});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomePalette.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: const Color(0xFFDCE8F8),
        scrolledUnderElevation: 2,
        foregroundColor: HomePalette.title,
        elevation: 0,
        title: const Text('Mes matchs', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: HomePalette.title)),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return AppErrorWidget(message: snapshot.error.toString(), onRetry: _reload);
          }

          final data = snapshot.data!;
          final upcoming = data['upcomingMatches'] as List? ?? [];
          final recent = data['recentMatches'] as List? ?? [];
          final tournament = data['tournament'] as Map<String, dynamic>?;
          final standings = data['standings'] as List? ?? [];
          final myPosition = data['myPosition'] as int?;

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                if (tournament != null) ...[
                  const SizedBox(height: 8),
                  const HomeSectionHeader('Tournoi', Icons.emoji_events),
                  const SizedBox(height: 12),
                  _TournamentCard(
                    tournament: tournament,
                    myPosition: myPosition,
                    standings: standings,
                    expanded: _standingsExpanded,
                    onToggle: () => setState(() => _standingsExpanded = !_standingsExpanded),
                  ),
                ],
                const SizedBox(height: 26),
                const HomeSectionHeader('Prochains matchs', Icons.event),
                const SizedBox(height: 12),
                if (upcoming.isEmpty)
                  const _EmptySlot(icon: Icons.event_available, message: 'Aucun match à venir')
                else
                  ...upcoming.map((m) => _UpcomingCard(match: m as Map<String, dynamic>, auth: widget.auth)),
                const SizedBox(height: 26),
                const HomeSectionHeader('Historique', Icons.history),
                const SizedBox(height: 12),
                if (recent.isEmpty)
                  const _EmptySlot(icon: Icons.history, message: 'Aucun match joué')
                else
                  ...recent.map((m) => _RecentCard(match: m as Map<String, dynamic>, auth: widget.auth)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte tournoi + classement repliable
// ─────────────────────────────────────────────────────────────────────────────

class _TournamentCard extends StatelessWidget {
  final Map<String, dynamic> tournament;
  final int? myPosition;
  final List standings;
  final bool expanded;
  final VoidCallback onToggle;

  const _TournamentCard({
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
    final canExpand = standings.isNotEmpty && format == 'league';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: diagonal(HomePalette.navy),
        boxShadow: [BoxShadow(color: HomePalette.navy.last.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Positioned(
          right: -30,
          top: -30,
          child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08))),
        ),
        Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.14), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.emoji_events, color: Color(0xFFFBBF24), size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                  if (formatLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(formatLabel, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12.5)),
                  ],
                ]),
              ),
              if (myPosition != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(gradient: diagonal(HomePalette.orange), borderRadius: BorderRadius.circular(20)),
                  child: Text(myPosition == 1 ? '1ère place' : '${myPosition}ème place',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                ),
            ]),
          ),
          if (canExpand)
            InkWell(
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.12))),
                ),
                child: Row(children: [
                  const Icon(Icons.table_chart_outlined, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Text('Classement', style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white, size: 22),
                ]),
              ),
            ),
          if (expanded && canExpand) _MiniStandings(standings: standings),
        ]),
      ]),
    );
  }
}

class _MiniStandings extends StatelessWidget {
  final List standings;
  const _MiniStandings({required this.standings});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: const [
            SizedBox(width: 30),
            Expanded(child: Text('Équipe', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600))),
            _StdHdr('J'),
            _StdHdr('V'),
            _StdHdr('N'),
            _StdHdr('D'),
            _StdHdr('DB'),
            _StdHdr('Pts'),
          ]),
        ),
        const Divider(color: Color(0xFFE2E8F0), height: 1),
        ...standings.take(6).toList().asMap().entries.map((e) {
          final idx = e.key;
          final s = e.value as Map<String, dynamic>;
          final isMe = s['isMyTeam'] == true;
          final gd = _toInt(s['goalDiff']);
          return Container(
            color: isMe ? const Color(0xFFE0F2FE) : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              GradientSquare(
                size: 22,
                colors: idx == 0
                    ? HomePalette.orange
                    : idx < 3
                        ? HomePalette.navy
                        : const [Color(0xFF94A3B8), Color(0xFFCBD5E1)],
                child: Text('${idx + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s['teamName'] as String? ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: HomePalette.title,
                    fontWeight: isMe ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              _StdCell('${s['played'] ?? 0}'),
              _StdCell('${s['won'] ?? 0}'),
              _StdCell('${s['drawn'] ?? 0}'),
              _StdCell('${s['lost'] ?? 0}'),
              _StdCell('${gd >= 0 ? '+' : ''}$gd'),
              _StdCell('${s['points'] ?? 0}', bold: true),
            ]),
          );
        }),
        const SizedBox(height: 6),
      ]),
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
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600)));
}

class _StdCell extends StatelessWidget {
  final String text;
  final bool bold;
  const _StdCell(this.text, {this.bold = false});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 30,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: bold ? HomePalette.link : const Color(0xFF475569),
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Cartes match
// ─────────────────────────────────────────────────────────────────────────────

BoxDecoration get _whiteCard => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 3))],
    );

void _openDetail(BuildContext context, AuthController auth, Map<String, dynamic> match) {
  final matchId = match['id'] as int?;
  if (matchId == null) return;
  final opponent = _opponentName(match['opponent']);
  final isHome = match['myTeamIsHome'] as bool? ?? true;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MatchDetailPage(
        auth: auth,
        matchId: matchId,
        homeTeam: isHome ? 'Mon équipe' : opponent,
        awayTeam: isHome ? opponent : 'Mon équipe',
        myTeamIsHome: isHome,
      ),
    ),
  );
}

class _UpcomingCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final AuthController auth;
  const _UpcomingCard({required this.match, required this.auth});

  @override
  Widget build(BuildContext context) {
    final opponent = _opponentName(match['opponent']);
    final isHome = match['myTeamIsHome'] as bool? ?? true;
    final round = match['round'];
    final location = match['location'] as String?;
    final date = DateTime.tryParse(match['date'] as String? ?? '')?.toLocal();
    final daysLeft = date == null ? null : DateTime(date.year, date.month, date.day).difference(DateUtils.dateOnly(DateTime.now())).inDays;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _openDetail(context, auth, match),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: _whiteCard,
          child: Row(children: [
            GradientSquare(
              size: 54,
              colors: HomePalette.orange,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(date == null ? '--' : date.day.toString().padLeft(2, '0'),
                    style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800, height: 1)),
                const SizedBox(height: 2),
                Text(date == null ? '' : _months[date.month - 1],
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('vs $opponent',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, color: HomePalette.title)),
                const SizedBox(height: 6),
                Wrap(spacing: 6, runSpacing: 4, children: [
                  _Pill(isHome ? 'Domicile' : 'Extérieur', isHome ? HomePalette.navy : HomePalette.purple),
                  if (round != null) _Pill('J$round', HomePalette.sky),
                  if (date != null)
                    _Pill('${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}', const [Color(0xFF64748B), Color(0xFF94A3B8)]),
                ]),
                if (location != null && location.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(location,
                          maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ),
                  ]),
                ],
              ]),
            ),
            if (daysLeft != null && daysLeft >= 0)
              Column(children: [
                Text(daysLeft == 0 ? "Auj." : 'J-$daysLeft',
                    style: const TextStyle(color: HomePalette.link, fontWeight: FontWeight.w800, fontSize: 14)),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ]),
          ]),
        ),
      ),
    );
  }
}

class _Result {
  final String letter;
  final String label;
  final List<Color> colors;
  const _Result(this.letter, this.label, this.colors);

  static _Result of(Map<String, dynamic> m) {
    final gf = _toInt(m['goalsFor'] ?? m['homeTeamScore']);
    final ga = _toInt(m['goalsAgainst'] ?? m['awayTeamScore']);
    final r = m['result'] as String?;
    if (r == 'V' || (r == null && gf > ga)) return const _Result('V', 'Victoire', HomePalette.green);
    if (r == 'N' || (r == null && gf == ga)) return const _Result('N', 'Nul', HomePalette.orange);
    return const _Result('D', 'Défaite', HomePalette.red);
  }
}

class _RecentCard extends StatelessWidget {
  final Map<String, dynamic> match;
  final AuthController auth;
  const _RecentCard({required this.match, required this.auth});

  @override
  Widget build(BuildContext context) {
    final opponent = _opponentName(match['opponent']);
    final isHome = match['myTeamIsHome'] as bool? ?? true;
    final gf = _toInt(match['goalsFor'] ?? match['homeTeamScore']);
    final ga = _toInt(match['goalsAgainst'] ?? match['awayTeamScore']);
    final round = match['round'];
    final res = _Result.of(match);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _openDetail(context, auth, match),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: _whiteCard,
          child: Row(children: [
            GradientSquare(
              size: 48,
              colors: res.colors,
              child: Text(res.letter, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('vs $opponent',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: HomePalette.title)),
                const SizedBox(height: 4),
                Text(
                  [_fmtDate(match['date'] as String?), if (round != null) 'J$round', isHome ? 'Domicile' : 'Extérieur'].join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ]),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('$gf - $ga', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 21, color: res.colors.first)),
              const SizedBox(height: 3),
              _Pill(res.label, res.colors),
            ]),
          ]),
        ),
      ),
    );
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
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      decoration: _whiteCard,
      child: Column(children: [
        SizedBox(height: 90, child: Lottie.asset('assets/empty_state.json', fit: BoxFit.contain)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 18, color: Colors.grey[400]),
          const SizedBox(width: 8),
          Text(message, style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
        ]),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final List<Color> colors;
  const _Pill(this.text, this.colors);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(gradient: diagonal(colors), borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w700)),
      );
}

const _months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Août', 'Sep', 'Oct', 'Nov', 'Déc'];

int _toInt(dynamic v) => v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0);

/// Extrait le nom de l'adversaire, que le backend envoie une String ou un {id,name}.
String _opponentName(dynamic raw) {
  if (raw == null) return 'Adversaire';
  if (raw is String) return raw.isNotEmpty ? raw : 'Adversaire';
  if (raw is Map) return (raw['name'] as String?)?.isNotEmpty == true ? raw['name'] as String : 'Adversaire';
  return 'Adversaire';
}

String _fmtDate(String? raw) {
  if (raw == null || raw.isEmpty) return 'Date inconnue';
  final d = DateTime.tryParse(raw)?.toLocal();
  if (d == null) return raw;
  return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
