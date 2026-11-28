import 'dart:async';

import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/delegate_service.dart';
import '../state/auth_controller.dart';
import 'delegate_home_page.dart' show statusLabels, statusColor;

const _kNavy = Color(0xFF003049);
const _kMuted = Color(0xFF94A3B8);
const _kGreen = Color(0xFF059669);

class _EventKind {
  final String type;
  final String label;
  final IconData icon;
  final Color color;
  const _EventKind(this.type, this.label, this.icon, this.color);
}

const _kinds = [
  _EventKind('goal', 'But', Icons.sports_soccer, _kGreen),
  _EventKind('penalty_goal', 'Penalty marqué', Icons.adjust, _kGreen),
  _EventKind('own_goal', 'Contre son camp', Icons.sports_soccer, Color(0xFF7C3AED)),
  _EventKind('assist', 'Passe décisive', Icons.assistant, Color(0xFF0284C7)),
  _EventKind('yellow_card', 'Carton jaune', Icons.style, Color(0xFFEAB308)),
  _EventKind('red_card', 'Carton rouge', Icons.style, Color(0xFFDC2626)),
  _EventKind('substitution', 'Remplacement', Icons.swap_horiz, _kNavy),
];

_EventKind _kindOf(String? t) => _kinds.firstWhere((k) => k.type == t, orElse: () => _EventKind(t ?? '', t ?? '', Icons.circle, _kMuted));

/// Live follow-up of one match by its delegate: clock, phases and match facts.
class DelegateMatchPage extends StatefulWidget {
  final AuthController auth;
  final int matchId;
  const DelegateMatchPage({super.key, required this.auth, required this.matchId});

  @override
  State<DelegateMatchPage> createState() => _DelegateMatchPageState();
}

class _DelegateMatchPageState extends State<DelegateMatchPage> {
  late final DelegateService _service = DelegateService(ApiClient(token: widget.auth.token));
  Map<String, dynamic>? _match;
  bool _busy = false;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _load();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) { if (mounted && _isLive) setState(() {}); });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String? get _status => _match?['status'] as String?;
  bool get _isRunning => _status == 'in_progress';
  bool get _isLive => _status == 'in_progress' || _status == 'half_time';
  bool get _secondHalf => _match?['secondHalfStartedAt'] != null;

  Future<void> _load() async {
    try {
      final m = await _service.match(widget.matchId);
      if (mounted) setState(() => _match = m);
    } catch (e) {
      _toast(e.toString(), error: true);
    }
  }

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg.replaceFirst('Exception: ', '')),
      backgroundColor: error ? Colors.red.shade700 : _kGreen,
    ));
  }

  Future<void> _run(Future<Map<String, dynamic>> Function() call, String success) async {
    setState(() => _busy = true);
    try {
      final m = await call();
      if (mounted) setState(() => _match = m);
      _toast(success);
    } catch (e) {
      _toast(e.toString(), error: true);
    }
    if (mounted) setState(() => _busy = false);
  }

  // ── Clock (from server timestamps, identical on every screen) ─────────────
  DateTime? _at(String k) => DateTime.tryParse(_match?[k]?.toString() ?? '')?.toLocal();

  /// Match time elapsed: 0:00 → 45:00 in the first half, 45:00 → 90:00 in the second.
  Duration get _matchTime {
    final now = DateTime.now();
    if (_secondHalf) {
      final s = _at('secondHalfStartedAt');
      return const Duration(minutes: 45) + (s == null ? Duration.zero : now.difference(s));
    }
    final f = _at('firstHalfStartedAt');
    return f == null ? Duration.zero : now.difference(f);
  }

  int get _currentMinute => _matchTime.inMinutes + 1;

  String _mmss(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final m = d.inMinutes.toString().padLeft(2, '0');
    final sec = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }

  /// (big timer, caption) shown in the scoreboard.
  (String, String) get _timerDisplay {
    switch (_status) {
      case 'half_time':
        final h = _at('halfTimeStartedAt');
        return (h == null ? '45:00' : _mmss(DateTime.now().difference(h)), 'Pause de la mi-temps');
      case 'in_progress':
        final t = _matchTime;
        final cap = Duration(minutes: _secondHalf ? 90 : 45);
        final period = _secondHalf ? '2e mi-temps' : '1re mi-temps';
        if (t > cap) return (_mmss(cap), '$period · temps additionnel +${_mmss(t - cap)}');
        return (_mmss(t), period);
      case 'completed':
        return ('90:00', 'Match terminé');
      default:
        return ('00:00', statusLabels[_status] ?? 'À venir');
    }
  }

  // ── Phases ────────────────────────────────────────────────────────────────
  Future<void> _phase() async {
    final m = _match!;
    String action, label;
    if (_status == 'scheduled' || _status == 'postponed') {
      action = 'kickoff'; label = "Siffler le coup d'envoi ?";
    } else if (_status == 'in_progress' && !_secondHalf) {
      action = 'half_time'; label = 'Siffler la mi-temps ?';
    } else if (_status == 'half_time') {
      action = 'second_half'; label = 'Lancer la 2e mi-temps ?';
    } else if (_status == 'in_progress') {
      action = 'full_time'; label = 'Siffler la fin du match ?';
    } else {
      return;
    }

    int? winnerTeamId;
    final isBracket = m['matchIndex'] != null;
    final draw = (m['homeTeamScore'] ?? 0) == (m['awayTeamScore'] ?? 0);
    if (action == 'full_time' && isBracket && draw) {
      winnerTeamId = await _pickShootoutWinner();
      if (winnerTeamId == null) return;
    } else {
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(label),
          content: action == 'full_time'
              ? Text('Score final : ${m['homeTeamScore'] ?? 0} – ${m['awayTeamScore'] ?? 0}.\n'
                  "Après la fin, seul l'administrateur pourra corriger les faits du match.")
              : null,
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Annuler')),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Confirmer')),
          ],
        ),
      );
      if (ok != true) return;
    }
    await _run(() => _service.live(widget.matchId, action, winnerTeamId: winnerTeamId), 'Enregistré');
  }

  Future<int?> _pickShootoutWinner() {
    final home = _match!['homeTeam'] as Map? ?? {};
    final away = _match!['awayTeam'] as Map? ?? {};
    return showDialog<int>(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Text('Match nul : qui gagne aux tirs au but ?'),
        children: [
          for (final t in [home, away])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(c, t['id'] as int?),
              child: Text('${t['name'] ?? '?'}', style: const TextStyle(fontSize: 16)),
            ),
        ],
      ),
    );
  }

  // ── Events ────────────────────────────────────────────────────────────────
  Future<void> _addEvent(_EventKind kind) async {
    final event = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _EventSheet(match: _match!, kind: kind, minute: _currentMinute.clamp(1, 120)),
    );
    if (event == null) return;
    await _run(() => _service.addEvent(widget.matchId, event), '${kind.label} enregistré');
  }

  Future<void> _deleteEvent(Map<String, dynamic> ev) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Supprimer cet événement ?'),
        content: Text("${_kindOf(ev['type']).label} · ${ev['minute']}'"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok != true) return;
    await _run(() => _service.deleteEvent(widget.matchId, ev['id'] as int), 'Événement supprimé');
  }

  @override
  Widget build(BuildContext context) {
    final m = _match;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: _kNavy,
        foregroundColor: Colors.white,
        title: const Text('Suivi du match', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: m == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(padding: EdgeInsets.zero, children: [
                _scoreboard(m),
                if (_status != 'completed') _phaseButton(),
                if (_isLive) _actionGrid(),
                if (_status == 'scheduled' || _status == 'postponed')
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                    child: Text("Les faits du match se saisissent après le coup d'envoi.",
                        style: TextStyle(color: _kMuted, fontSize: 12)),
                  ),
                _eventList(m),
                const SizedBox(height: 32),
              ]),
            ),
    );
  }

  Widget _scoreboard(Map<String, dynamic> m) {
    final home = (m['homeTeam'] as Map?)?['name'] ?? '?';
    final away = (m['awayTeam'] as Map?)?['name'] ?? '?';
    return Container(
      color: _kNavy,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_isRunning)
            Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
          Text(_timerDisplay.$1,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 44,
                  fontFeatures: [FontFeature.tabularFigures()])),
        ]),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(color: statusColor(_status), borderRadius: BorderRadius.circular(20)),
          child: Text(_timerDisplay.$2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Text('$home', textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15))),
          Text('${m['homeTeamScore'] ?? 0}  –  ${m['awayTeamScore'] ?? 0}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 32)),
          Expanded(child: Text('$away', textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15))),
        ]),
      ]),
    );
  }

  Widget _phaseButton() {
    final (String label, IconData icon, Color color) = switch (_status) {
      'scheduled' || 'postponed' => ("Coup d'envoi", Icons.play_arrow_rounded, _kGreen),
      'half_time' => ('Lancer la 2e mi-temps', Icons.play_arrow_rounded, _kGreen),
      'in_progress' when !_secondHalf => ('Siffler la mi-temps', Icons.pause_rounded, const Color(0xFFD97706)),
      _ => ('Fin du match', Icons.flag_rounded, const Color(0xFFDC2626)),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: SizedBox(
        height: 52,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          onPressed: _busy ? null : _phase,
          icon: Icon(icon),
          label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  Widget _actionGrid() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Wrap(spacing: 8, runSpacing: 8, children: [
          for (final k in _kinds)
            SizedBox(
              width: (MediaQuery.of(context).size.width - 32 - 8) / 2,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: k.color,
                  side: BorderSide(color: k.color.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _busy ? null : () => _addEvent(k),
                icon: Icon(k.icon, size: 18),
                label: Text(k.label, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
        ]),
      );

  Widget _eventList(Map<String, dynamic> m) {
    final events = List<Map<String, dynamic>>.from(m['events'] ?? [])
      ..sort((a, b) => ((b['minute'] ?? 0) as int).compareTo((a['minute'] ?? 0) as int));
    final home = (m['homeTeam'] as Map?)?['name'] ?? 'Domicile';
    final away = (m['awayTeam'] as Map?)?['name'] ?? 'Extérieur';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('FAITS DU MATCH (${events.length})',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kMuted, letterSpacing: 0.6)),
        const SizedBox(height: 8),
        if (events.isEmpty)
          const Text('Aucun événement pour le moment.', style: TextStyle(color: _kMuted)),
        for (final ev in events)
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: _kindOf(ev['type']).color.withOpacity(0.12),
                child: Icon(_kindOf(ev['type']).icon, size: 16, color: _kindOf(ev['type']).color),
              ),
              title: Text(_kindOf(ev['type']).label, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text([
                ev['type'] == 'substitution'
                    ? '${ev['substitutionPlayerOutName'] ?? '?'} → ${ev['substitutionPlayerInName'] ?? '?'}'
                    : (ev['relatedPlayerName'] ?? 'Joueur non précisé'),
                ev['isHomeTeam'] == true ? home : away,
              ].join(' · ')),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text("${ev['minute']}'", style: const TextStyle(fontWeight: FontWeight.w800)),
                if (_isLive)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: _kMuted),
                    onPressed: _busy ? null : () => _deleteEvent(ev),
                  ),
              ]),
            ),
          ),
      ]),
    );
  }
}

// ─── Bottom sheet: team, player(s), minute ──────────────────────────────────
class _EventSheet extends StatefulWidget {
  final Map<String, dynamic> match;
  final _EventKind kind;
  final int minute;
  const _EventSheet({required this.match, required this.kind, required this.minute});

  @override
  State<_EventSheet> createState() => _EventSheetState();
}

class _EventSheetState extends State<_EventSheet> {
  bool _home = true;
  int? _player;
  int? _playerIn;
  late final TextEditingController _minute = TextEditingController(text: '${widget.minute}');

  bool get _isSub => widget.kind.type == 'substitution';

  List<Map<String, dynamic>> get _players {
    final team = widget.match[_home ? 'homeTeam' : 'awayTeam'] as Map?;
    return List<Map<String, dynamic>>.from(team?['players'] ?? [])
      ..sort((a, b) => ((a['jerseyNumber'] ?? 99) as int).compareTo((b['jerseyNumber'] ?? 99) as int));
  }

  String _label(Map<String, dynamic> p) => '${p['jerseyNumber'] != null ? '${p['jerseyNumber']}. ' : ''}${p['name']}';

  Widget _playerField(String label, int? value, ValueChanged<int?> onChanged) => DropdownButtonFormField<int>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        items: _players.map((p) => DropdownMenuItem<int>(value: p['id'] as int, child: Text(_label(p)))).toList(),
        onChanged: onChanged,
      );

  void _submit() {
    final minute = int.tryParse(_minute.text);
    if (minute == null || minute < 1 || minute > 120) return _err('Minute entre 1 et 120');
    if (_isSub && (_player == null || _playerIn == null)) return _err('Choisissez le joueur sortant et le joueur entrant');
    if (_isSub && _player == _playerIn) return _err('Le joueur entrant doit être différent du sortant');
    if (!_isSub && _player == null) return _err('Choisissez le joueur');
    Navigator.pop(context, {
      'type': widget.kind.type,
      'minute': minute,
      'isHomeTeam': _home,
      if (_isSub) ...{'substitutionPlayerOutId': _player, 'substitutionPlayerInId': _playerIn, 'relatedPlayerId': _player}
      else 'relatedPlayerId': _player,
    });
  }

  void _err(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final home = (widget.match['homeTeam'] as Map?)?['name'] ?? 'Domicile';
    final away = (widget.match['awayTeam'] as Map?)?['name'] ?? 'Extérieur';
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(widget.kind.icon, color: widget.kind.color),
          const SizedBox(width: 8),
          Text(widget.kind.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
        if (widget.kind.type == 'own_goal')
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text("Choisissez l'équipe du joueur qui a marqué contre son camp : le but est compté pour l'adversaire.",
                style: TextStyle(fontSize: 12, color: _kMuted)),
          ),
        const SizedBox(height: 16),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(value: true, label: Text('$home', overflow: TextOverflow.ellipsis)),
            ButtonSegment(value: false, label: Text('$away', overflow: TextOverflow.ellipsis)),
          ],
          selected: {_home},
          onSelectionChanged: (s) => setState(() { _home = s.first; _player = null; _playerIn = null; }),
        ),
        const SizedBox(height: 14),
        if (_players.isEmpty)
          const Text("Aucun joueur enregistré dans cette équipe. Demandez à l'administrateur de compléter l'effectif.",
              style: TextStyle(color: Colors.red))
        else ...[
          _playerField(_isSub ? 'Joueur sortant' : 'Joueur', _player, (v) => setState(() => _player = v)),
          if (_isSub) ...[
            const SizedBox(height: 12),
            _playerField('Joueur entrant', _playerIn, (v) => setState(() => _playerIn = v)),
          ],
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _minute,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Minute', border: OutlineInputBorder(), suffixText: "'"),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: widget.kind.color),
            onPressed: _players.isEmpty ? null : _submit,
            child: const Text('Enregistrer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }
}
