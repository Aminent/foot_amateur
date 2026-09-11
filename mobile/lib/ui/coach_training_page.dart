import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../services/coach_service.dart';
import '../services/api_client.dart';
import 'training_attendance_page.dart';

class CoachTrainingPage extends StatefulWidget {
  final AuthController auth;
  final VoidCallback? onBackToProfile;
  const CoachTrainingPage({super.key, required this.auth, this.onBackToProfile});

  @override
  State<CoachTrainingPage> createState() => _CoachTrainingPageState();
}

class _CoachTrainingPageState extends State<CoachTrainingPage> {
  late CoachService _coachService;
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;
  String? _error;

  // Filter: 'all' | 'scheduled' | 'completed'
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _coachService = CoachService(ApiClient(token: widget.auth.token));
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() { _loading = true; _error = null; });
    try {
      final sessions = await _coachService.getMyTrainings();
      setState(() { _sessions = sessions; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'all') return _sessions;
    return _sessions.where((s) => s['statusRaw'] == _filter).toList();
  }

  // ── type helpers ─────────────────────────────────────────────────────────────

  Color _typeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'technique': return Colors.blue;
      case 'tactique':  return Colors.purple;
      case 'physique':  return Colors.orange;
      case 'match':     return Colors.green;
      default:          return const Color(0xFF55C1CF);
    }
  }

  IconData _typeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'technique': return Icons.sports_soccer;
      case 'tactique':  return Icons.map;
      case 'physique':  return Icons.directions_run;
      case 'match':     return Icons.emoji_events;
      default:          return Icons.fitness_center;
    }
  }

  // ── build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Séances d\'entraînement'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.onBackToProfile != null) {
              widget.onBackToProfile!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nouvelle séance',
            onPressed: () => _openForm(null),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF55C1CF)))
          : _error != null
              ? _buildError()
              : Column(
                  children: [
                    _buildFilterBar(),
                    Expanded(child: _buildList()),
                  ],
                ),
    );
  }

  // ── filter bar ────────────────────────────────────────────────────────────────

  Widget _buildFilterBar() {
    final all       = _sessions.length;
    final scheduled = _sessions.where((s) => s['statusRaw'] == 'scheduled').length;
    final completed = _sessions.where((s) => s['statusRaw'] == 'completed').length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _filterChip('all',       'Toutes ($all)',          Colors.blueGrey),
          const SizedBox(width: 8),
          _filterChip('scheduled', 'À venir ($scheduled)',   Colors.orange),
          const SizedBox(width: 8),
          _filterChip('completed', 'Terminées ($completed)', Colors.green),
        ],
      ),
    );
  }

  Widget _filterChip(String key, String label, Color color) {
    final active = _filter == key;
    return GestureDetector(
      onTap: () => setState(() => _filter = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? color : color.withOpacity(0.25)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  // ── list ──────────────────────────────────────────────────────────────────────
  
  Widget _buildList() {
    final list = _filtered;
    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadSessions,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Lottie.asset('assets/empty_state.json'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _filter == 'all'
                        ? 'Aucune séance programmée'
                        : _filter == 'scheduled'
                            ? 'Aucune séance à venir'
                            : 'Aucune séance terminée',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Appuyez sur + pour créer une séance',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _openForm(null),
                    icon: const Icon(Icons.add),
                    label: const Text('Créer une séance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF55C1CF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSessions,
      color: const Color(0xFF55C1CF),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, i) => _buildCard(list[i]),
      ),
    );
  }

  // ── session card ──────────────────────────────────────────────────────────────

  Widget _buildCard(Map<String, dynamic> s) {
    final completed = s['statusRaw'] == 'completed';
    final cancelled = s['statusRaw'] == 'cancelled';
    final typeColor = _typeColor(s['typeRaw']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed
              ? Colors.green.withOpacity(0.3)
              : cancelled
                  ? Colors.red.withOpacity(0.2)
                  : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // coloured top stripe
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: typeColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_typeIcon(s['typeRaw']), size: 13, color: typeColor),
                          const SizedBox(width: 4),
                          Text(
                            s['type'] ?? '',
                            style: TextStyle(color: typeColor, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _statusBadge(s['statusRaw']),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  s['title'] ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                ),
                if ((s['description'] as String).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    s['description'] ?? '',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 14),

                // Info grid
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if ((s['date'] as String).isNotEmpty)
                      _infoItem(Icons.calendar_today, s['date']),
                    if ((s['time'] as String).isNotEmpty)
                      _infoItem(Icons.access_time, s['time']),
                    if ((s['duration'] as String).isNotEmpty)
                      _infoItem(Icons.timer, s['duration']),
                  ],
                ),
                // Location with Maps button
                if ((s['location'] as String).isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(child: Text(s['location'] as String,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500))),
                    GestureDetector(
                      onTap: () => _openMaps(s['location'] as String),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withAlpha(20),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF3B82F6).withAlpha(60)),
                        ),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.map_outlined, size: 12, color: Color(0xFF3B82F6)),
                          SizedBox(width: 4),
                          Text('Maps', style: TextStyle(fontSize: 11, color: Color(0xFF3B82F6), fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ),
                  ]),
                ],
                const SizedBox(height: 14),

                // Actions
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _actionBtn(
                      icon: Icons.edit, label: 'Modifier',
                      color: const Color(0xFF55C1CF), outlined: true,
                      onPressed: completed ? null : () => _openForm(s),
                    ),
                    _actionBtn(
                      icon: Icons.checklist, label: 'Présences',
                      color: const Color(0xFF8B5CF6), outlined: true,
                      onPressed: () => _openAttendance(s),
                    ),
                    if (!completed)
                      _actionBtn(
                        icon: Icons.check, label: 'Terminée',
                        color: Colors.green, outlined: false,
                        onPressed: () => _markCompleted(s),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _statusBadge(String? status) {
    Color color;
    String label;
    switch (status) {
      case 'completed': color = Colors.green; label = 'Terminée'; break;
      case 'cancelled': color = Colors.red;   label = 'Annulée';  break;
      default:          color = Colors.orange; label = 'À venir';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required bool outlined,
    required VoidCallback? onPressed,
  }) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: onPressed == null ? Colors.grey[300]! : color),
          foregroundColor: onPressed == null ? Colors.grey[400] : color,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    );
  }

  Future<void> _openMaps(String location) async {
    final query = Uri.encodeComponent(location);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir Maps')),
        );
      }
    }
  }

  Future<void> _openAttendance(Map<String, dynamic> s) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrainingAttendancePage(
          auth: widget.auth,
          sessionId: s['id'] as int,
          sessionTitle: s['title'] as String,
          sessionDate: '${s['date']} à ${s['time']}',
        ),
      ),
    );
  }

  // ── error state ───────────────────────────────────────────────────────────────

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Impossible de charger les séances', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_error ?? '', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSessions,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF55C1CF), foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // ── mark completed ────────────────────────────────────────────────────────────

  Future<void> _markCompleted(Map<String, dynamic> s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Marquer comme terminée'),
        content: Text('Confirmer la fin de la séance "${s['title']}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _coachService.updateTraining(s['id'], {'status': 'completed'});
      await _loadSessions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Séance marquée comme terminée ✓'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── delete ────────────────────────────────────────────────────────────────────

  Future<void> _confirmDelete(Map<String, dynamic> s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer la séance'),
        content: Text('Supprimer "${s['title']}" ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _coachService.deleteTraining(s['id']);
      await _loadSessions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Séance supprimée'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── form (create / edit) ──────────────────────────────────────────────────────

  void _openForm(Map<String, dynamic>? existing) {
    final isEdit = existing != null;
    final titleCtrl    = TextEditingController(text: existing?['title'] ?? '');
    final descCtrl     = TextEditingController(text: existing?['description'] ?? '');
    final locationCtrl = TextEditingController(text: existing?['location'] ?? '');
    final durationCtrl = TextEditingController(
        text: existing?['durationMin'] != null ? existing!['durationMin'].toString() : '');
    final notesCtrl    = TextEditingController(text: existing?['notes'] ?? '');

    String selectedType   = existing?['typeRaw'] ?? 'technique';
    String selectedStatus = existing?['statusRaw'] ?? 'scheduled';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    // Parse existing date/time
    // ignore: unnecessary_null_comparison
    if (isEdit && existing != null && (existing['dateIso'] as String? ?? '').isNotEmpty) {
      try {
        final dt = DateTime.parse(existing['dateIso'] as String);
        selectedDate = DateTime(dt.year, dt.month, dt.day);
        selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
      } catch (_) {}
    }

    final dateCtrl = TextEditingController(text: existing?['date'] ?? '');
    final timeCtrl = TextEditingController(text: existing?['time'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, controller) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
                    child: Row(
                      children: [
                        Text(
                          isEdit ? 'Modifier la séance' : 'Nouvelle séance',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Scrollable form
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: EdgeInsets.only(
                        left: 20, right: 20, top: 16,
                        bottom: MediaQuery.of(ctx).viewInsets.bottom + 100,
                      ),
                      children: [
                        // Title
                        _formField('Titre *', titleCtrl, hint: 'Ex : Travail technique'),
                        const SizedBox(height: 14),
                        // Description
                        _formField('Description', descCtrl, hint: 'Objectifs de la séance…', maxLines: 3),
                        const SizedBox(height: 14),

                        // Type dropdown
                        _label('Type *'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: selectedType,
                          decoration: _inputDeco(null),
                          items: const [
                            DropdownMenuItem(value: 'technique', child: Text('⚽ Technique')),
                            DropdownMenuItem(value: 'tactique',  child: Text('🗺️ Tactique')),
                            DropdownMenuItem(value: 'physique',  child: Text('🏃 Physique')),
                            DropdownMenuItem(value: 'match',     child: Text('🏆 Match')),
                            DropdownMenuItem(value: 'autre',     child: Text('📋 Autre')),
                          ],
                          onChanged: (v) { if (v != null) setSheetState(() => selectedType = v); },
                        ),
                        const SizedBox(height: 14),

                        // Date
                        _label('Date *'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: dateCtrl,
                          readOnly: true,
                          decoration: _inputDeco('JJ/MM/AAAA').copyWith(
                            suffixIcon: const Icon(Icons.calendar_today, size: 18),
                          ),
                          onTap: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 730)),
                            );
                            if (d != null) {
                              setSheetState(() {
                                selectedDate = d;
                                dateCtrl.text =
                                    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 14),

                        // Time
                        _label('Heure *'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: timeCtrl,
                          readOnly: true,
                          decoration: _inputDeco('HH:MM').copyWith(
                            suffixIcon: const Icon(Icons.access_time, size: 18),
                          ),
                          onTap: () async {
                            final t = await showTimePicker(
                              context: ctx,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (t != null) {
                              setSheetState(() {
                                selectedTime = t;
                                timeCtrl.text =
                                    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 14),

                        // Duration + Location (side by side)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Durée (min)'),
                                  const SizedBox(height: 6),
                                  TextFormField(
                                    controller: durationCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDeco('90'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Lieu'),
                                  const SizedBox(height: 6),
                                  _formField(null, locationCtrl, hint: 'Terrain A'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Status (edit only)
                        if (isEdit) ...[
                          _label('Statut'),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: selectedStatus,
                            decoration: _inputDeco(null),
                            items: const [
                              DropdownMenuItem(value: 'scheduled',  child: Text('📅 À venir')),
                              DropdownMenuItem(value: 'completed',  child: Text('✅ Terminée')),
                              DropdownMenuItem(value: 'cancelled',  child: Text('❌ Annulée')),
                            ],
                            onChanged: (v) { if (v != null) setSheetState(() => selectedStatus = v); },
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Notes
                        _formField('Notes', notesCtrl, hint: 'Remarques, exercices spécifiques…', maxLines: 3),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Save button
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        20, 12, 20, 12 + MediaQuery.of(ctx).padding.bottom),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _saveForm(
                          ctx: ctx,
                          isEdit: isEdit,
                          existing: existing,
                          titleCtrl: titleCtrl,
                          descCtrl: descCtrl,
                          selectedDate: selectedDate,
                          selectedTime: selectedTime,
                          selectedType: selectedType,
                          selectedStatus: selectedStatus,
                          durationCtrl: durationCtrl,
                          locationCtrl: locationCtrl,
                          notesCtrl: notesCtrl,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          isEdit ? 'Enregistrer les modifications' : 'Créer la séance',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveForm({
    required BuildContext ctx,
    required bool isEdit,
    required Map<String, dynamic>? existing,
    required TextEditingController titleCtrl,
    required TextEditingController descCtrl,
    required DateTime? selectedDate,
    required TimeOfDay? selectedTime,
    required String selectedType,
    required String selectedStatus,
    required TextEditingController durationCtrl,
    required TextEditingController locationCtrl,
    required TextEditingController notesCtrl,
  }) async {
    // Validation
    if (titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le titre est obligatoire'), backgroundColor: Colors.red),
      );
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La date et l\'heure sont obligatoires'), backgroundColor: Colors.red),
      );
      return;
    }

    // Build ISO datetime
    final dt = DateTime(
      selectedDate.year, selectedDate.month, selectedDate.day,
      selectedTime.hour, selectedTime.minute,
    );

    final payload = <String, dynamic>{
      'title': titleCtrl.text.trim(),
      'type':  selectedType,
      'date':  dt.toIso8601String(),
    };
    final desc     = descCtrl.text.trim();
    final loc      = locationCtrl.text.trim();
    final notes    = notesCtrl.text.trim();
    final durStr   = durationCtrl.text.trim();
    final durInt   = durStr.isNotEmpty ? int.tryParse(durStr) : null;
    if (desc.isNotEmpty)   payload['description'] = desc;
    if (loc.isNotEmpty)    payload['location']    = loc;
    if (notes.isNotEmpty)  payload['notes']       = notes;
    if (durInt != null)    payload['duration']    = durInt;
    if (isEdit)            payload['status']      = selectedStatus;

    Navigator.pop(ctx); // close sheet first

    try {
      if (isEdit) {
        await _coachService.updateTraining(existing!['id'], payload);
      } else {
        await _coachService.createTraining(payload);
      }
      await _loadSessions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Séance modifiée ✓' : 'Séance créée ✓'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── form helpers ──────────────────────────────────────────────────────────────

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
      );

  InputDecoration _inputDeco(String? hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF55C1CF), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        isDense: true,
      );

  Widget _formField(String? label, TextEditingController ctrl, {String? hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[_label(label), const SizedBox(height: 6)],
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          decoration: _inputDeco(hint),
        ),
      ],
    );
  }
}
