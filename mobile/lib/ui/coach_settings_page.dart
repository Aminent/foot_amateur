import 'package:flutter/material.dart';

import '../services/notification_prefs_service.dart';
import '../services/notification_service.dart';
import '../services/api_client.dart';
import '../state/auth_controller.dart';

class CoachSettingsPage extends StatefulWidget {
  final AuthController auth;
  const CoachSettingsPage({super.key, required this.auth});

  @override
  State<CoachSettingsPage> createState() => _CoachSettingsPageState();
}

class _CoachSettingsPageState extends State<CoachSettingsPage> {
  bool _notifEnabled = true;
  bool _loading = true;
  int _totalCount = 0;
  Map<String, int> _counts = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs  = NotificationPrefsService.instance;
    final enabled = await prefs.isEnabled();
    final total   = await prefs.getTotal();
    final counts  = await prefs.getAllCounts();
    if (mounted) {
      setState(() {
        _notifEnabled = enabled;
        _totalCount   = total;
        _counts       = counts;
        _loading      = false;
      });
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    await NotificationPrefsService.instance.setEnabled(value);
    setState(() => _notifEnabled = value);

    final api = ApiClient(token: widget.auth.token);

    if (!value) {
      await NotificationService.instance.unregisterToken(api, userRole: 'coach');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications désactivées'), backgroundColor: Colors.orange),
        );
      }
    } else {
      await NotificationService.instance.init(api, userRole: 'coach');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications activées ✓'), backgroundColor: Colors.green),
        );
      }
    }
  }

  Future<void> _resetCounts() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Réinitialiser les compteurs'),
        content: const Text('Remettre tous les compteurs à zéro ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await NotificationPrefsService.instance.resetAll();
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compteurs réinitialisés'), backgroundColor: Colors.blueGrey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF55C1CF)))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ── Notifications section ─────────────────────────────────────
                _sectionHeader('Notifications', Icons.notifications_outlined),
                const SizedBox(height: 12),
                _card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _notifEnabled
                                  ? const Color(0xFF55C1CF).withAlpha(30)
                                  : Colors.grey.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _notifEnabled
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              color: _notifEnabled ? const Color(0xFF55C1CF) : Colors.grey,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Activer les notifications',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  _notifEnabled
                                      ? 'Vous recevez des notifications push'
                                      : 'Notifications désactivées',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _notifEnabled,
                            onChanged: _toggleNotifications,
                            activeColor: const Color(0xFF55C1CF),
                          ),
                        ],
                      ),
                      if (_notifEnabled) ...[
                        const Divider(height: 24),
                        _infoRow(
                          Icons.info_outline,
                          Colors.blue,
                          'Types de notifications actives',
                          '3 événements surveillés',
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: const [
                            _TypeChip('✅ Candidature approuvée'),
                            _TypeChip('❌ Candidature refusée'),
                            _TypeChip('⏰ Rappel match 24h'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Count section ─────────────────────────────────────────────
                Row(
                  children: [
                    _sectionHeader('Notifications reçues', Icons.bar_chart),
                    const Spacer(),
                    if (_totalCount > 0)
                      TextButton.icon(
                        onPressed: _resetCounts,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Réinitialiser'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Total badge
                _card(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.notifications, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total reçues', style: TextStyle(fontSize: 13, color: Colors.grey)),
                            Text(
                              '$_totalCount notification${_totalCount != 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Per-type breakdown
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Détail par type',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_counts.values.every((v) => v == 0))
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                Icon(Icons.notifications_none, size: 40, color: Colors.grey[300]),
                                const SizedBox(height: 8),
                                Text(
                                  'Aucune notification reçue',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._counts.entries.map((e) => _countRow(e.key, e.value)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Account section ───────────────────────────────────────────
                _sectionHeader('Compte', Icons.person_outline),
                const SizedBox(height: 12),
                _card(
                  child: Column(
                    children: [
                      _infoRow(Icons.person, Colors.indigo,
                          'Nom', widget.auth.user?.name ?? '—'),
                      const Divider(height: 20),
                      _infoRow(Icons.email_outlined, Colors.teal,
                          'Email', widget.auth.user?.email ?? '—'),
                      const Divider(height: 20),
                      _infoRow(Icons.sports, Colors.orange,
                          'Rôle', 'Coach'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logout
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Déconnexion'),
                          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Annuler')),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F172A),
                                  foregroundColor: Colors.white),
                              child: const Text('Déconnexion'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true && mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        widget.auth.logout();
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Se déconnecter'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  // ── helpers ───────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, IconData icon) => Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              letterSpacing: 1.2,
            ),
          ),
        ],
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: child,
      );

  Widget _infoRow(IconData icon, Color color, String label, String value) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
          const Spacer(),
          Flexible(
            child: Text(value,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );

  Widget _countRow(String type, int count) {
    if (count == 0) return const SizedBox.shrink();
    final color = _typeColor(type);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: color.withAlpha(25), borderRadius: BorderRadius.circular(10)),
            child: Icon(_typeIcon(type), size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(NotificationPrefsService.typeLabel(type),
                style: const TextStyle(fontSize: 13, color: Color(0xFF334155))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
                color: color.withAlpha(25), borderRadius: BorderRadius.circular(20)),
            child: Text('$count',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'training_scheduled':   return Colors.blue;
      case 'training_updated':     return Colors.purple;
      case 'match_reminder':       return Colors.orange;
      case 'score_update':         return Colors.teal;
      case 'match_result':         return Colors.green;
      case 'application_approved': return Colors.green;
      case 'application_rejected': return Colors.red;
      default:                     return Colors.blueGrey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'training_scheduled':   return Icons.fitness_center;
      case 'training_updated':     return Icons.edit_calendar;
      case 'match_reminder':       return Icons.alarm;
      case 'score_update':         return Icons.sports_soccer;
      case 'match_result':         return Icons.emoji_events;
      case 'application_approved': return Icons.check_circle;
      case 'application_rejected': return Icons.cancel;
      default:                     return Icons.notifications;
    }
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  const _TypeChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withAlpha(8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF0F172A).withAlpha(20)),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF334155))),
    );
  }
}
