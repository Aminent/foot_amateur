import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../state/auth_controller.dart';
import '../widgets/custom_widgets.dart';

// ── Formation definitions ─────────────────────────────────────────────────────

class _Slot {
  final String label;   // e.g. "GK", "CB", "LW"
  final double x;       // 0–100, left→right
  final double y;       // 0–100, own-goal(0)→opponent-goal(100)
  final bool isStarter;
  _Slot(this.label, this.x, this.y, {this.isStarter = true});
}

const _formations = ['4-3-3', '4-4-2', '4-2-3-1', '3-5-2', '5-3-2', '4-5-1'];

List<_Slot> _slotsFor(String f) {
  switch (f) {
    case '4-4-2':
      return [
        _Slot('GK', 50, 6),
        _Slot('LB', 14, 26), _Slot('CB', 36, 26), _Slot('CB', 64, 26), _Slot('RB', 86, 26),
        _Slot('LM', 14, 54), _Slot('CM', 36, 54), _Slot('CM', 64, 54), _Slot('RM', 86, 54),
        _Slot('ST', 36, 80), _Slot('ST', 64, 80),
      ];
    case '4-2-3-1':
      return [
        _Slot('GK', 50, 6),
        _Slot('LB', 14, 24), _Slot('CB', 36, 24), _Slot('CB', 64, 24), _Slot('RB', 86, 24),
        _Slot('DM', 34, 44), _Slot('DM', 66, 44),
        _Slot('LAM', 14, 64), _Slot('CAM', 50, 64), _Slot('RAM', 86, 64),
        _Slot('ST', 50, 84),
      ];
    case '3-5-2':
      return [
        _Slot('GK', 50, 6),
        _Slot('CB', 25, 26), _Slot('CB', 50, 26), _Slot('CB', 75, 26),
        _Slot('LWB', 10, 52), _Slot('CM', 30, 52), _Slot('CM', 50, 52), _Slot('CM', 70, 52), _Slot('RWB', 90, 52),
        _Slot('ST', 34, 80), _Slot('ST', 66, 80),
      ];
    case '5-3-2':
      return [
        _Slot('GK', 50, 6),
        _Slot('LWB', 10, 26), _Slot('CB', 30, 26), _Slot('CB', 50, 26), _Slot('CB', 70, 26), _Slot('RWB', 90, 26),
        _Slot('CM', 25, 56), _Slot('CM', 50, 56), _Slot('CM', 75, 56),
        _Slot('ST', 34, 82), _Slot('ST', 66, 82),
      ];
    case '4-5-1':
      return [
        _Slot('GK', 50, 6),
        _Slot('LB', 14, 24), _Slot('CB', 36, 24), _Slot('CB', 64, 24), _Slot('RB', 86, 24),
        _Slot('LM', 10, 54), _Slot('CM', 28, 54), _Slot('CM', 50, 54), _Slot('CM', 72, 54), _Slot('RM', 90, 54),
        _Slot('ST', 50, 82),
      ];
    default: // 4-3-3
      return [
        _Slot('GK', 50, 6),
        _Slot('LB', 14, 26), _Slot('CB', 36, 26), _Slot('CB', 64, 26), _Slot('RB', 86, 26),
        _Slot('CM', 25, 56), _Slot('CM', 50, 56), _Slot('CM', 75, 56),
        _Slot('LW', 14, 82), _Slot('ST', 50, 82), _Slot('RW', 86, 82),
      ];
  }
}

// ── Main page ─────────────────────────────────────────────────────────────────

class CoachLineupPage extends StatefulWidget {
  final AuthController auth;
  final Map<String, dynamic> match; // {id, date, opponent, location, status}
  const CoachLineupPage({super.key, required this.auth, required this.match});

  @override
  State<CoachLineupPage> createState() => _CoachLineupPageState();
}

class _CoachLineupPageState extends State<CoachLineupPage> {
  late ApiClient _api;

  bool _loading = true;
  String? _error;
  bool _saving = false;

  String _formation = '4-3-3';
  // assigned[slotIndex] = {id, name, jerseyNumber, position} or null
  List<Map<String, dynamic>?> _assigned = List.filled(11, null);
  // Full squad from backend
  List<Map<String, dynamic>> _squad = [];
  // Substitutes list (players assigned to bench, beyond 11 starters)
  List<Map<String, dynamic>> _subs = [];
  String _lineupStatus = 'draft';

  @override
  void initState() {
    super.initState();
    _api = ApiClient(token: widget.auth.token);
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final matchId = widget.match['id'];
      final res = await _api.dio.get('/coaches/me/matches/$matchId/lineup');
      if (res.statusCode == 200) {
        final data = res.data as Map<String, dynamic>;
        final squad = List<Map<String, dynamic>>.from(data['squad'] ?? []);
        final lineupData = data['lineup'] as Map<String, dynamic>?;

        String formation = _formation;
        List<Map<String, dynamic>?> assigned = List.filled(11, null);
        List<Map<String, dynamic>> subs = [];
        String status = 'draft';

        if (lineupData != null) {
          formation = lineupData['formation'] as String? ?? '4-3-3';
          status = lineupData['status'] as String? ?? 'draft';
          final players = List<Map<String, dynamic>>.from(lineupData['players'] ?? []);
          for (final p in players) {
            final isStarter = p['isStarter'] != false;
            if (isStarter) {
              final idx = (p['slotIndex'] as num?)?.toInt();
              if (idx != null && idx >= 0 && idx < 11) {
                assigned[idx] = p;
              }
            } else {
              subs.add(p);
            }
          }
        }


        setState(() {
          _squad = squad;
          _formation = formation;
          _assigned = assigned;
          _subs = subs;
          _lineupStatus = status;
          _loading = false;
        });
      } else {
        throw Exception('Erreur HTTP ${res.statusCode}');
      }
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  // Players not yet placed (neither starter nor sub)
  List<Map<String, dynamic>> get _bench {
    final usedIds = {
      ..._assigned.where((p) => p != null).map((p) => p!['id'] as dynamic),
      ..._subs.map((p) => p['id'] as dynamic),
    };
    return _squad.where((p) => !usedIds.contains(p['id'])).toList();
  }

  void _changeFormation(String f) {
    setState(() {
      _formation = f;
      _assigned = List.filled(11, null);
      _subs = [];
    });
  }

  void _pickPlayerForSlot(int slotIndex) async {
    final available = _bench;
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les joueurs sont déjà placés')),
      );
      return;
    }
    final picked = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlayerPickerSheet(players: available),
    );
    if (picked != null) {
      setState(() => _assigned[slotIndex] = picked);
    }
  }

  void _removeFromSlot(int slotIndex) {
    setState(() => _assigned[slotIndex] = null);
  }

  void _addSub() async {
    final available = _bench;
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les joueurs sont déjà utilisés')),
      );
      return;
    }
    if (_subs.length >= 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 7 remplaçants')),
      );
      return;
    }
    final picked = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlayerPickerSheet(players: available),
    );
    if (picked != null) setState(() => _subs.add(picked));
  }

  void _removeSub(int idx) => setState(() => _subs.removeAt(idx));

  List<Map<String, dynamic>> _buildPayload() {
    final list = <Map<String, dynamic>>[];
    for (int i = 0; i < _assigned.length; i++) {
      final p = _assigned[i];
      if (p != null) {
        list.add({
          'playerId': p['id'],
          'playerName': p['name'],
          'jerseyNumber': p['jerseyNumber'],
          'positionLabel': _slotsFor(_formation)[i].label,
          'slotIndex': i,
          'isStarter': true,
        });
      }
    }
    for (final s in _subs) {
      list.add({
        'playerId': s['id'],
        'playerName': s['name'],
        'jerseyNumber': s['jerseyNumber'],
        'positionLabel': 'SUB',
        'isStarter': false,
      });
    }
    return list;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final matchId = widget.match['id'];
      final res = await _api.dio.put('/coaches/me/matches/$matchId/lineup', data: {
        'formation': _formation,
        'players': _buildPayload(),
      });
      if (res.statusCode == 200) {
        setState(() => _lineupStatus = 'draft');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Brouillon enregistré ✓'), backgroundColor: Colors.blueGrey),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _publish() async {
    final starterCount = _assigned.where((p) => p != null).length;
    if (starterCount < 11) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Composition incomplète'),
          content: Text('Seulement $starterCount/11 titulaires assignés. Publier quand même ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
              child: const Text('Publier'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    setState(() => _saving = true);
    try {
      final matchId = widget.match['id'];
      // Save first, then publish
      await _api.dio.put('/coaches/me/matches/$matchId/lineup', data: {
        'formation': _formation,
        'players': _buildPayload(),
      });
      final res = await _api.dio.post('/coaches/me/matches/$matchId/lineup/publish');
      if (res.statusCode == 200) {
        setState(() => _lineupStatus = 'published');
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Composition publiée ✓ — Joueurs notifiés'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Composition vs ${widget.match['opponent'] ?? '?'}'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_lineupStatus == 'published')
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(40),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withAlpha(100)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 14),
                  SizedBox(width: 4),
                  Text('Publiée', style: TextStyle(color: Colors.green, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF55C1CF)))
          : _error != null
              ? _buildError()
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildFormationBar(),
                            _buildField(),
                            _buildSubsSection(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomBar(),
                  ],
                ),
    );
  }

  Widget _buildFormationBar() {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _formations.map((f) {
            final active = f == _formation;
            return GestureDetector(
              onTap: () => _changeFormation(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF55C1CF) : Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? const Color(0xFF55C1CF) : Colors.white.withAlpha(50),
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: active ? Colors.white : Colors.white70,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildField() {
    final slots = _slotsFor(_formation);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: AspectRatio(
        aspectRatio: 0.68,
        child: LayoutBuilder(builder: (ctx, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            children: [
              // Field background
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomPaint(
                  size: Size(w, h),
                  painter: _FieldPainter(),
                ),
              ),
              // Formation label
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(120),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formation,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              // Player slots
              ...slots.asMap().entries.map((entry) {
                final i = entry.key;
                final slot = entry.value;
                final player = _assigned[i];
                final dx = slot.x / 100 * w;
                final dy = slot.y / 100 * h;

                return Positioned(
                  left: dx - 26,
                  top: dy - 26,
                  child: _PlayerDot(
                    slot: slot,
                    player: player,
                    onTap: () => player == null ? _pickPlayerForSlot(i) : _removeFromSlot(i),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSubsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.airline_seat_recline_normal, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 6),
              Text(
                'REMPLAÇANTS (${_subs.length}/7)',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              if (_subs.length < 7)
                GestureDetector(
                  onTap: _addSub,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF55C1CF).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF55C1CF).withAlpha(80)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 13, color: Color(0xFF55C1CF)),
                        SizedBox(width: 4),
                        Text('Ajouter', style: TextStyle(fontSize: 11, color: Color(0xFF55C1CF), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (_subs.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Center(
                child: Text('Aucun remplaçant', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _subs.asMap().entries.map((e) {
                final p = e.value;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withAlpha(120)),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#${p['jerseyNumber'] ?? '?'} ${p['name'] ?? ''}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _removeSub(e.key),
                        child: const Icon(Icons.close, size: 14, color: Colors.red),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          // Unassigned bench players count
          if (_bench.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              '${_bench.length} joueur${_bench.length > 1 ? 's' : ''} non assigné${_bench.length > 1 ? 's' : ''}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isPublished = _lineupStatus == 'published';
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          // Save draft
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined, size: 16),
              label: const Text('Brouillon'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0F172A),
                side: const BorderSide(color: Color(0xFF0F172A)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Publish
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _publish,
              icon: _saving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(isPublished ? Icons.refresh : Icons.send_rounded, size: 16),
              label: Text(isPublished ? 'Re-publier' : 'Publier & Notifier'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPublished ? Colors.green : const Color(0xFF0F172A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() => AppErrorWidget(
        message: _error,
        onRetry: _load,
      );
}

// ── Player dot on field ───────────────────────────────────────────────────────

class _PlayerDot extends StatelessWidget {
  final _Slot slot;
  final Map<String, dynamic>? player;
  final VoidCallback onTap;
  const _PlayerDot({required this.slot, required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final assigned = player != null;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: assigned ? const Color(0xFF0F172A) : Colors.white.withAlpha(50),
                border: Border.all(
                  color: assigned ? const Color(0xFF55C1CF) : Colors.white70,
                  width: 2,
                ),
                boxShadow: assigned
                    ? [BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 6)]
                    : null,
              ),
              child: Center(
                child: assigned
                    ? Text(
                        '#${player!['jerseyNumber'] ?? '?'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : const Icon(Icons.add, color: Colors.white70, size: 16),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              assigned
                  ? (player!['name'] as String? ?? '').split(' ').last
                  : slot.label,
              style: TextStyle(
                color: assigned ? Colors.white : Colors.white60,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Football field painter ────────────────────────────────────────────────────

class _FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grass = Paint()..color = const Color(0xFF2D6A4F);
    final grassAlt = Paint()..color = const Color(0xFF2A6148);
    final line = Paint()
      ..color = Colors.white.withAlpha(160)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Stripes
    final stripeW = size.width / 8;
    for (int i = 0; i < 8; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * stripeW, 0, stripeW, size.height),
        i.isEven ? grass : grassAlt,
      );
    }

    // Border
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(12)),
      line,
    );

    final w = size.width;
    final h = size.height;

    // Centre line
    canvas.drawLine(Offset(0, h / 2), Offset(w, h / 2), line);
    // Centre circle
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.14, line);
    canvas.drawCircle(Offset(w / 2, h / 2), 3, Paint()..color = Colors.white.withAlpha(160));

    // Penalty areas
    final penH = h * 0.17;
    final penW = w * 0.56;
    final penX = (w - penW) / 2;
    canvas.drawRect(Rect.fromLTWH(penX, 0, penW, penH), line);
    canvas.drawRect(Rect.fromLTWH(penX, h - penH, penW, penH), line);

    // Goal areas
    final goalH = h * 0.08;
    final goalW = w * 0.3;
    final goalX = (w - goalW) / 2;
    canvas.drawRect(Rect.fromLTWH(goalX, 0, goalW, goalH), line);
    canvas.drawRect(Rect.fromLTWH(goalX, h - goalH, goalW, goalH), line);

    // Penalty spots
    final spotPaint = Paint()..color = Colors.white.withAlpha(160);
    canvas.drawCircle(Offset(w / 2, h * 0.13), 2.5, spotPaint);
    canvas.drawCircle(Offset(w / 2, h * 0.87), 2.5, spotPaint);

    // Corner arcs
    final cornerPaint = Paint()
      ..color = Colors.white.withAlpha(160)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final cr = w * 0.04;
    canvas.drawArc(Rect.fromCircle(center: Offset(0, 0), radius: cr), 0, math.pi / 2, false, cornerPaint);
    canvas.drawArc(Rect.fromCircle(center: Offset(w, 0), radius: cr), math.pi / 2, math.pi / 2, false, cornerPaint);
    canvas.drawArc(Rect.fromCircle(center: Offset(0, h), radius: cr), -math.pi / 2, math.pi / 2, false, cornerPaint);
    canvas.drawArc(Rect.fromCircle(center: Offset(w, h), radius: cr), math.pi, math.pi / 2, false, cornerPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ── Player picker bottom sheet ────────────────────────────────────────────────

class _PlayerPickerSheet extends StatefulWidget {
  final List<Map<String, dynamic>> players;
  const _PlayerPickerSheet({required this.players});
  @override
  State<_PlayerPickerSheet> createState() => _PlayerPickerSheetState();
}

class _PlayerPickerSheetState extends State<_PlayerPickerSheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _q.isEmpty
        ? widget.players
        : widget.players.where((p) {
            final name = (p['name'] as String? ?? '').toLowerCase();
            return name.contains(_q.toLowerCase());
          }).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Choisir un joueur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'Rechercher…',
                prefixIcon: const Icon(Icons.search, size: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final p = filtered[i];
                final pos = (p['position'] as String? ?? '').toUpperCase();
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF0F172A),
                    child: Text(
                      '#${p['jerseyNumber'] ?? '?'}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                  title: Text(p['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(pos, style: const TextStyle(fontSize: 11)),
                  onTap: () => Navigator.pop(context, p),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}
