import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/player_service.dart';
import '../services/api_client.dart';
import '../state/auth_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────────────────

class PlayerGoal {
  final String id;
  final String type;
  final String label;
  final String unit;
  final IconData icon;
  final Color color;
  int target;

  PlayerGoal({
    required this.id,
    required this.type,
    required this.label,
    required this.unit,
    required this.icon,
    required this.color,
    required this.target,
  });

  Map<String, dynamic> toJson() => {'id': id, 'target': target};
}

// ─────────────────────────────────────────────────────────────────────────────
// Catalog of goal types
// ─────────────────────────────────────────────────────────────────────────────

final _catalog = [
  _GoalDef(id: 'goals',    label: 'Buts à marquer',           unit: 'buts',         icon: Icons.sports_soccer,    color: const Color(0xFF16A34A), statKey: 'goals'),
  _GoalDef(id: 'assists',  label: 'Passes décisives',          unit: 'passes déc.',  icon: Icons.assistant,        color: const Color(0xFF3B82F6), statKey: 'assists'),
  _GoalDef(id: 'minutes',  label: 'Minutes jouées',            unit: 'min',          icon: Icons.timer,            color: const Color(0xFFF59E0B), statKey: 'minutesPlayed'),
  _GoalDef(id: 'presence', label: 'Taux de présence',          unit: '%',            icon: Icons.calendar_today,   color: const Color(0xFF8B5CF6), statKey: null),
  _GoalDef(id: 'tackles',  label: 'Tacles réussis',            unit: 'tacles',       icon: Icons.shield,           color: const Color(0xFF0891B2), statKey: 'tackles'),
  _GoalDef(id: 'shots',    label: 'Tirs cadrés',              unit: 'tirs',         icon: Icons.radio_button_checked, color: const Color(0xFFEA580C), statKey: 'shotsOnTarget'),
  _GoalDef(id: 'matches',  label: 'Matchs joués',             unit: 'matchs',       icon: Icons.emoji_events,     color: const Color(0xFF059669), statKey: 'matchesPlayed'),
  _GoalDef(id: 'clean',    label: 'Clean sheets',             unit: 'clean sheets', icon: Icons.lock,             color: const Color(0xFF6366F1), statKey: 'cleanSheets'),
];

class _GoalDef {
  final String id, label, unit;
  final String? statKey;
  final IconData icon;
  final Color color;
  const _GoalDef({required this.id, required this.label, required this.unit, required this.icon, required this.color, this.statKey});
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class PlayerGoalsPage extends StatefulWidget {
  final AuthController auth;
  const PlayerGoalsPage({super.key, required this.auth});

  @override
  State<PlayerGoalsPage> createState() => _PlayerGoalsPageState();
}

class _PlayerGoalsPageState extends State<PlayerGoalsPage> {
  static const _dark  = Color(0xFF0F172A);
  static const _teal  = Color(0xFF55C1CF);

  bool _loading = true;
  Map<String, int>  _targets    = {};
  Map<String, dynamic> _stats   = {};
  int? _attendanceRate;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('player_goals_${widget.auth.user?.id}');
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      _targets = decoded.map((k, v) => MapEntry(k, v as int));
    }

    final service = PlayerService(ApiClient(token: widget.auth.token));
    final statsData = await service.getMyStats();
    final attendData = await service.getMyAttendance();

    if (mounted) {
      setState(() {
        _stats = statsData;
        _attendanceRate = attendData['rate'] as int?;
        _loading = false;
      });
    }
  }

  Future<void> _saveTargets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'player_goals_${widget.auth.user?.id}',
      jsonEncode(_targets),
    );
  }

  int _current(String id, _GoalDef def) {
    if (id == 'presence') return _attendanceRate ?? 0;
    if (def.statKey == null) return 0;
    return (_stats[def.statKey] as num?)?.toInt() ?? 0;
  }

  double _progress(String id, _GoalDef def) {
    final target = _targets[id] ?? 0;
    if (target == 0) return 0;
    final cur = _current(id, def);
    return (cur / target).clamp(0.0, 1.0);
  }

  void _openAddGoal() {
    final notAdded = _catalog.where((d) => !_targets.containsKey(d.id)).toList();
    if (notAdded.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les types d\'objectifs sont déjà ajoutés')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddGoalSheet(
        available: notAdded,
        onAdd: (def, target) {
          setState(() => _targets[def.id] = target);
          _saveTargets();
        },
      ),
    );
  }

  void _editTarget(String id, _GoalDef def) {
    final ctrl = TextEditingController(text: _targets[id]?.toString() ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Objectif : ${def.label}'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Valeur cible (${def.unit})',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _dark, foregroundColor: Colors.white),
            onPressed: () {
              final val = int.tryParse(ctrl.text.trim());
              if (val != null && val > 0) {
                setState(() => _targets[id] = val);
                _saveTargets();
              }
              Navigator.pop(context);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _removeGoal(String id) {
    setState(() => _targets.remove(id));
    _saveTargets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Mes objectifs'),
        backgroundColor: _dark,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Ajouter un objectif',
            onPressed: _openAddGoal,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _teal))
          : _targets.isEmpty
              ? _buildEmpty()
              : _buildGoalList(),
    );
  }

  Widget _buildEmpty() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(color: _teal.withAlpha(25), shape: BoxShape.circle),
          child: const Icon(Icons.flag_outlined, size: 44, color: _teal),
        ),
        const SizedBox(height: 20),
        const Text('Aucun objectif défini', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: _dark)),
        const SizedBox(height: 10),
        const Text(
          'Fixe-toi des objectifs pour la saison et suis ta progression.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _openAddGoal,
          icon: const Icon(Icons.add),
          label: const Text('Ajouter un objectif'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _teal, foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ]),
    ),
  );

  Widget _buildGoalList() {
    final activeGoals = _catalog.where((d) => _targets.containsKey(d.id)).toList();
    final accomplished = activeGoals.where((d) => _progress(d.id, d) >= 1.0).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary banner
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [_dark, Color(0xFF1E3A5F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(children: [
            const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 36),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$accomplished / ${activeGoals.length} objectifs atteints',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: activeGoals.isEmpty ? 0 : accomplished / activeGoals.length,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                  minHeight: 8,
                ),
              ),
            ])),
          ]),
        ),

        ...activeGoals.map((def) => _GoalCard(
          def: def,
          target: _targets[def.id]!,
          current: _current(def.id, def),
          progress: _progress(def.id, def),
          onEdit: () => _editTarget(def.id, def),
          onDelete: () => _removeGoal(def.id),
        )),

        const SizedBox(height: 8),
        Center(
          child: TextButton.icon(
            onPressed: _openAddGoal,
            icon: const Icon(Icons.add, color: _teal),
            label: const Text('Ajouter un autre objectif', style: TextStyle(color: _teal)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Goal Card widget
// ─────────────────────────────────────────────────────────────────────────────

class _GoalCard extends StatelessWidget {
  final _GoalDef def;
  final int target, current;
  final double progress;
  final VoidCallback onEdit, onDelete;

  const _GoalCard({
    required this.def,
    required this.target,
    required this.current,
    required this.progress,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final done = progress >= 1.0;
    final pct  = (progress * 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: done ? Border.all(color: const Color(0xFF16A34A), width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: def.color.withAlpha(25), borderRadius: BorderRadius.circular(12)),
            child: Icon(def.icon, color: def.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(def.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A))),
            Text('$current / $target ${def.unit}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ])),
          if (done)
            const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 22),
          PopupMenuButton<String>(
            onSelected: (v) { if (v == 'edit') onEdit(); else onDelete(); },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Modifier')])),
              const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 16, color: Colors.red), SizedBox(width: 8), Text('Supprimer', style: TextStyle(color: Colors.red))])),
            ],
            icon: const Icon(Icons.more_vert, color: Color(0xFF94A3B8)),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: def.color.withAlpha(20),
                valueColor: AlwaysStoppedAnimation(done ? const Color(0xFF16A34A) : def.color),
                minHeight: 10,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('$pct%', style: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 13,
            color: done ? const Color(0xFF16A34A) : def.color,
          )),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Goal bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _AddGoalSheet extends StatefulWidget {
  final List<_GoalDef> available;
  final void Function(_GoalDef def, int target) onAdd;

  const _AddGoalSheet({required this.available, required this.onAdd});

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  _GoalDef? _selected;
  final _ctrl = TextEditingController();

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _confirm() {
    final target = int.tryParse(_ctrl.text.trim());
    if (_selected == null || target == null || target <= 0) return;
    widget.onAdd(_selected!, target);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(children: [
          Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(alignment: Alignment.centerLeft,
              child: Text('Choisir un objectif', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF0F172A)))),
          ),
          const Divider(height: 1),
          Expanded(child: ListView.builder(
            controller: ctrl,
            padding: const EdgeInsets.all(12),
            itemCount: widget.available.length,
            itemBuilder: (_, i) {
              final def = widget.available[i];
              final sel = _selected?.id == def.id;
              return GestureDetector(
                onTap: () => setState(() => _selected = def),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: sel ? def.color.withAlpha(20) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: sel ? def.color : const Color(0xFFE2E8F0), width: sel ? 1.5 : 1),
                  ),
                  child: Row(children: [
                    Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: def.color.withAlpha(25), borderRadius: BorderRadius.circular(10)),
                      child: Icon(def.icon, color: def.color, size: 20)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(def.label,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: sel ? def.color : const Color(0xFF0F172A)))),
                    if (sel) Icon(Icons.check_circle, color: def.color),
                  ]),
                ),
              );
            },
          )),
          if (_selected != null) Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Objectif (${_selected!.unit})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
              const SizedBox(height: 8),
              TextField(
                controller: _ctrl,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'ex: 10',
                  suffixText: _selected!.unit,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _selected!.color, width: 1.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selected!.color, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                  child: const Text('Ajouter cet objectif', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
