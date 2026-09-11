import 'package:flutter/material.dart';
import '../services/coach_service.dart';
import '../services/api_client.dart';
import '../state/auth_controller.dart';

class TrainingAttendancePage extends StatefulWidget {
  final AuthController auth;
  final int sessionId;
  final String sessionTitle;
  final String sessionDate;

  const TrainingAttendancePage({
    super.key,
    required this.auth,
    required this.sessionId,
    required this.sessionTitle,
    required this.sessionDate,
  });

  @override
  State<TrainingAttendancePage> createState() => _TrainingAttendancePageState();
}

class _TrainingAttendancePageState extends State<TrainingAttendancePage> {
  late CoachService _service;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  // playerId → status (null = not set)
  final Map<int, String> _statuses = {};
  List<Map<String, dynamic>> _players = [];

  static const _teal  = Color(0xFF55C1CF);
  static const _dark  = Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    _service = CoachService(ApiClient(token: widget.auth.token));
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _service.getTrainingAttendance(widget.sessionId);
      final list = (data['attendance'] as List? ?? []).cast<Map<String, dynamic>>();
      setState(() {
        _players = list;
        for (final p in list) {
          final s = p['status'] as String?;
          if (s != null) _statuses[p['playerId'] as int] = s;
        }
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final records = _statuses.entries.map((e) => {
        'playerId': e.key,
        'status': e.value,
      }).toList();
      await _service.saveTrainingAttendance(widget.sessionId, records);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Présences enregistrées ✓'), backgroundColor: Color(0xFF16A34A)),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _markAll(String status) {
    setState(() {
      for (final p in _players) {
        _statuses[p['playerId'] as int] = status;
      }
    });
  }

  int get _presentCount  => _statuses.values.where((s) => s == 'present').length;
  int get _absentCount   => _statuses.values.where((s) => s == 'absent').length;
  int get _excusedCount  => _statuses.values.where((s) => s == 'excused').length;
  int get _unmarkedCount => _players.length - _statuses.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Feuille de présence'),
        backgroundColor: _dark,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_saving)
            const Center(child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
            ))
          else
            TextButton(
              onPressed: _save,
              child: const Text('Enregistrer', style: TextStyle(color: _teal, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _teal))
          : _error != null
              ? _buildError()
              : Column(children: [
                  _buildHeader(),
                  _buildQuickActions(),
                  Expanded(child: _buildList()),
                  _buildSaveBar(),
                ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.sessionTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: _dark)),
        const SizedBox(height: 4),
        Text(widget.sessionDate, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        const SizedBox(height: 12),
        Row(children: [
          _statPill('Présents', _presentCount, const Color(0xFF16A34A)),
          const SizedBox(width: 8),
          _statPill('Absents', _absentCount, const Color(0xFFEF4444)),
          const SizedBox(width: 8),
          _statPill('Excusés', _excusedCount, const Color(0xFFF59E0B)),
          const SizedBox(width: 8),
          if (_unmarkedCount > 0) _statPill('Non marqués', _unmarkedCount, Colors.grey),
        ]),
      ]),
    );
  }

  Widget _statPill(String label, int count, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withAlpha(80))),
    child: Text('$count $label', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
  );

  Widget _buildQuickActions() => Container(
    color: const Color(0xFFF1F5F9),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(children: [
      const Text('Tout marquer :', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
      const SizedBox(width: 10),
      _quickBtn('Présents', 'present', const Color(0xFF16A34A)),
      const SizedBox(width: 6),
      _quickBtn('Absents', 'absent', const Color(0xFFEF4444)),
      const SizedBox(width: 6),
      _quickBtn('Excusés', 'excused', const Color(0xFFF59E0B)),
    ]),
  );

  Widget _quickBtn(String label, String status, Color color) => GestureDetector(
    onTap: () => _markAll(status),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    ),
  );

  Widget _buildList() => ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 8),
    itemCount: _players.length,
    itemBuilder: (_, i) => _buildPlayerRow(_players[i]),
  );

  Widget _buildPlayerRow(Map<String, dynamic> player) {
    final id      = player['playerId'] as int;
    final name    = player['name'] as String? ?? '?';
    final jersey  = player['jerseyNumber'];
    final status  = _statuses[id];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        // Jersey + name
        Container(
          width: 36, height: 36,
          decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
          child: Center(child: Text(jersey?.toString() ?? '?',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: _dark))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: _dark))),

        // Status buttons
        _statusBtn(id, 'present', Icons.check_circle, const Color(0xFF16A34A), status),
        const SizedBox(width: 6),
        _statusBtn(id, 'absent', Icons.cancel, const Color(0xFFEF4444), status),
        const SizedBox(width: 6),
        _statusBtn(id, 'excused', Icons.info, const Color(0xFFF59E0B), status),
      ]),
    );
  }

  Widget _statusBtn(int playerId, String status, IconData icon, Color color, String? current) {
    final active = current == status;
    return GestureDetector(
      onTap: () => setState(() {
        if (active) {
          _statuses.remove(playerId);
        } else {
          _statuses[playerId] = status;
        }
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: active ? color : color.withAlpha(20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: active ? Colors.white : color.withAlpha(120)),
      ),
    );
  }

  Widget _buildSaveBar() => Container(
    padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
    decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
    child: SizedBox(
      width: double.infinity, height: 50,
      child: ElevatedButton(
        onPressed: _saving ? null : _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: _dark, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
        ),
        child: _saving
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Enregistrer les présences', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      ),
    ),
  );

  Widget _buildError() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
    const SizedBox(height: 16),
    Text(_error ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
    const SizedBox(height: 16),
    ElevatedButton(onPressed: _load, child: const Text('Réessayer'),
      style: ElevatedButton.styleFrom(backgroundColor: _teal, foregroundColor: Colors.white)),
  ]));
}
