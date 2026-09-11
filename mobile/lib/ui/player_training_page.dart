import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../services/player_service.dart';
import '../services/api_client.dart';
import '../widgets/custom_widgets.dart';

class PlayerTrainingPage extends StatefulWidget {
  final AuthController auth;
  const PlayerTrainingPage({super.key, required this.auth});

  @override
  State<PlayerTrainingPage> createState() => _PlayerTrainingPageState();
}

class _PlayerTrainingPageState extends State<PlayerTrainingPage> {
  late PlayerService _playerService;
  late Future<List<Map<String, dynamic>>> _trainingsFuture;
  int? _attendanceRate;

  @override
  void initState() {
    super.initState();
    _playerService = PlayerService(ApiClient(token: widget.auth.token));
    _trainingsFuture = _loadTrainings();
    _loadAttendance();
  }

  Future<List<Map<String, dynamic>>> _loadTrainings() async {
    return await _playerService.getMyTrainingSessions();
  }

  Future<void> _loadAttendance() async {
    final data = await _playerService.getMyAttendance();
    if (mounted) setState(() => _attendanceRate = data['rate'] as int?);
  }

  Future<void> _refreshData() async {
    setState(() { _trainingsFuture = _loadTrainings(); });
    _loadAttendance();
  }

  Future<void> _openMaps(String location) async {
    final query = Uri.encodeComponent(location);
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir Maps')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes entraînements'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(children: [
        if (_attendanceRate != null) _buildAttendanceBanner(),
        Expanded(child: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF55C1CF),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _trainingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF55C1CF)),
                    ),
                    SizedBox(height: 16),
                    Text('Chargement de vos entraînements...'),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return AppErrorWidget(
                message: snapshot.error.toString(),
                onRetry: _refreshData,
              );
            }

            final trainings = snapshot.data ?? [];

            if (trainings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Lottie.asset('assets/empty_state.json'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun entraînement pour le moment',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Votre coach ajoutera prochainement des séances',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trainings.length,
              itemBuilder: (context, index) {
                final training = trainings[index];
                return _buildTrainingCard(context, training);
              },
            );
          },
        ),
        )), // Expanded + RefreshIndicator
      ]), // Column
    );
  }

  Widget _buildAttendanceBanner() {
    final rate = _attendanceRate!;
    final color = rate >= 80 ? const Color(0xFF16A34A) : rate >= 60 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Icon(Icons.checklist, size: 18, color: color),
        const SizedBox(width: 10),
        Text('Taux de présence', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const Spacer(),
        Text('$rate%', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: color)),
        const SizedBox(width: 10),
        SizedBox(width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: rate / 100.0,
              backgroundColor: color.withAlpha(20),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildTrainingCard(BuildContext context, Map<String, dynamic> training) {
    final isCompleted = training['status'] == 'Terminé';
    final typeColor = _getTrainingTypeColor(training['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    training['type'] ?? 'Entraînement',
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    training['status'] ?? 'À venir',
                    style: TextStyle(
                      color: isCompleted ? Colors.green[800] : Colors.orange[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              training['title'] ?? 'Séance d\'entraînement',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              training['description'] ?? 'Description de la séance',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(
                  Icons.calendar_today,
                  training['date'] ?? 'Date',
                  'Date',
                ),
                const SizedBox(width: 16),
                _buildInfoItem(
                  Icons.access_time,
                  training['time'] ?? 'Heure',
                  'Heure',
                ),
                const SizedBox(width: 16),
                _buildInfoItem(
                  Icons.timer,
                  training['duration'] ?? 'Durée',
                  'Durée',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (training['location'] != null && training['location'].toString().isNotEmpty) ...[
                  Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(child: Text(training['location'] as String,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis)),
                  GestureDetector(
                    onTap: () => _openMaps(training['location'] as String),
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
                ] else
                  _buildInfoItem(Icons.location_on, 'Non spécifié', 'Lieu'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showTrainingDetails(context, training),
                icon: const Icon(Icons.info_outline),
                label: const Text('Détails'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF55C1CF)),
                  foregroundColor: const Color(0xFF55C1CF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTrainingTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'technique':
        return Colors.blue;
      case 'tactique':
        return Colors.purple;
      case 'physique':
        return Colors.orange;
      case 'match':
        return Colors.green;
      default:
        return const Color(0xFF55C1CF);
    }
  }

  void _showTrainingDetails(BuildContext context, Map<String, dynamic> training) {
    final typeColor   = _getTrainingTypeColor(training['type']);
    final isCompleted = training['status'] == 'Terminé';
    final statusColor = isCompleted ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ── Drag handle ──────────────────────────────────────────
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // ── Header with gradient ────────────────────────────────
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [typeColor.withOpacity(0.3), typeColor.withOpacity(0.05)],
                  ),
                  border: Border.all(color: typeColor.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: typeColor.withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getTypeIcon(training['type']), size: 13, color: typeColor),
                              const SizedBox(width: 5),
                              Text(
                                training['type'] ?? 'Entraînement',
                                style: TextStyle(color: typeColor, fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 6, height: 6,
                                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                              const SizedBox(width: 5),
                              Text(
                                training['status'] ?? 'À venir',
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      training['title'] ?? 'Séance d\'entraînement',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    if (training['description'] != null && training['description'].toString().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        training['description'],
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, height: 1.5),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Scrollable info ─────────────────────────────────────
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    // Info grid
                    Row(
                      children: [
                        Expanded(child: _buildDetailTile(Icons.calendar_today_outlined, 'Date', training['date'] ?? '—', typeColor)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDetailTile(Icons.access_time_outlined, 'Heure', training['time'] ?? '—', typeColor)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildDetailTile(Icons.timer_outlined, 'Durée', training['duration'] ?? '—', typeColor)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDetailTile(Icons.group_outlined, 'Joueurs', '${training['players'] ?? 0}', typeColor)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailTile(Icons.location_on_outlined, 'Lieu', training['location'] ?? 'Non spécifié', typeColor, fullWidth: true),

                    // Exercises section
                    if (training['exercises'] != null && (training['exercises'] as List).isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text('Exercices', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 10),
                      ...(training['exercises'] as List).asMap().entries.map((e) => _buildExerciseItem(e.key + 1, e.value, typeColor)),
                    ],

                    // Notes section
                    if (training['notes'] != null && training['notes'].toString().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text('Notes du coach', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text(
                          training['notes'],
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.6),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    // Close button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: typeColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Text('Fermer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value, Color color, {bool fullWidth = false}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(int index, dynamic exercise, Color color) {
    final name = exercise is Map ? (exercise['name'] ?? exercise.toString()) : exercise.toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text('$index', style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'technique':  return Icons.sports_soccer;
      case 'tactique':   return Icons.schema_outlined;
      case 'physique':   return Icons.fitness_center;
      case 'match':      return Icons.emoji_events_outlined;
      default:           return Icons.sports;
    }
  }
}

