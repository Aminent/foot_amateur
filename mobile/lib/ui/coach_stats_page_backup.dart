import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../state/auth_controller.dart';
import '../theme/app_theme.dart';
import '../services/coach_service.dart';
import '../services/api_client.dart';

class CoachStatsPage extends StatefulWidget {
  final AuthController auth;
  const CoachStatsPage({super.key, required this.auth});

  @override
  State<CoachStatsPage> createState() => _CoachStatsPageState();
}

class _CoachStatsPageState extends State<CoachStatsPage> {
  late CoachService _coachService;
  late Future<List<Map<String, dynamic>>> _playersWithStatsFuture;

  @override
  void initState() {
    super.initState();
    _coachService = CoachService(ApiClient(token: widget.auth.token));
    _playersWithStatsFuture = _loadPlayersWithStats();
  }

  Future<List<Map<String, dynamic>>> _loadPlayersWithStats() async {
    try {
      // First get the coach's team with players
      final teamData = await _coachService.getMyTeam();
      final players = teamData['players'] as List<dynamic>? ?? [];
      
      // Transform players data and fetch their stats
      final playersWithStats = <Map<String, dynamic>>[];
      
      for (final player in players) {
        final playerMap = player as Map<String, dynamic>;
        
        // Fetch individual player stats
        final stats = await _coachService.getPlayerStats(playerMap['id']);
        
        playersWithStats.add({
          'id': playerMap['id'],
          'name': playerMap['name'] ?? 'Joueur',
          'position': playerMap['position'] ?? 'Non défini',
          'jerseyNumber': playerMap['jerseyNumber'] ?? 0,
          'isCaptain': playerMap['isCaptain'] == true,
          'stats': stats,
        });
      }
      
      return playersWithStats;
    } catch (e) {
      throw 'Erreur de chargement: $e';
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _playersWithStatsFuture = _loadPlayersWithStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques des joueurs'),
        backgroundColor: const Color(0xFF55C1CF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF55C1CF),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _playersWithStatsFuture,
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
                    Text('Chargement des statistiques...'),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              );
            }

            final players = snapshot.data ?? [];

            if (players.isEmpty) {
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
                      'Aucune statistique disponible',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les statistiques apparaîtront ici une fois les matchs joués',
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
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return _buildPlayerStatsCard(context, player);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlayerStatsCard(BuildContext context, Map<String, dynamic> player) {
    final stats = player['stats'] as Map<String, dynamic>;
    final positionColor = _getPositionColor(player['position']);

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
            // Player header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: player['isCaptain'] == true 
                        ? Colors.amber.withOpacity(0.3)
                        : positionColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          player['jerseyNumber']?.toString() ?? '?',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: player['isCaptain'] == true 
                                ? Colors.amber[800]
                                : positionColor,
                          ),
                        ),
                        if (player['isCaptain'] == true)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber[800],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player['name'] ?? 'Joueur',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: positionColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              player['position'] ?? 'Poste',
                              style: TextStyle(
                                color: positionColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${stats['minutesPlayed'] ?? 0} min',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF55C1CF)),
                  onPressed: () => _showEditStatsDialog(player),
                  tooltip: 'Modifier les statistiques',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Key stats grid
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: [
                _buildStatItem('Buts', '${stats['goals'] ?? 0}', Icons.sports_soccer, Colors.green),
                _buildStatItem('Passes', '${stats['assists'] ?? 0}', Icons.swap_horiz, Colors.blue),
                _buildStatItem('Tirs', '${stats['shots'] ?? 0}', Icons.gps_fixed, Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            
            // Additional stats
            GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.8,
              children: [
                _buildSmallStatItem('Tirs cadrés', '${stats['shotsOnTarget'] ?? 0}'),
                _buildSmallStatItem('Passes', '${stats['passes'] ?? 0}'),
                _buildSmallStatItem('Tacles', '${stats['tackles'] ?? 0}'),
                _buildSmallStatItem('Interceptions', '${stats['interceptions'] ?? 0}'),
              ],
            ),
            const SizedBox(height: 12),
            
            // Cards and disciplinary
            Row(
              children: [
                _buildDisciplinaryItem('Cartons jaunes', '${stats['yellowCards'] ?? 0}', Colors.yellow),
                const SizedBox(width: 16),
                _buildDisciplinaryItem('Cartons rouges', '${stats['redCards'] ?? 0}', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStatItem(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisciplinaryItem(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              label.contains('jaune') ? Icons.style : Icons.circle,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(String? position) {
    switch (position?.toLowerCase()) {
      case 'gardien':
        return Colors.orange;
      case 'défenseur':
        return Colors.blue;
      case 'milieu':
        return Colors.green;
      case 'attaquant':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showEditStatsDialog(Map<String, dynamic> player) {
    final stats = Map<String, dynamic>.from(player['stats'] as Map<String, dynamic>);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier les statistiques - ${player['name']}'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatsField('Buts', 'goals', stats),
                _buildStatsField('Passes décisives', 'assists', stats),
                _buildStatsField('Tirs', 'shots', stats),
                _buildStatsField('Tirs cadrés', 'shotsOnTarget', stats),
                _buildStatsField('Passes', 'passes', stats),
                _buildStatsField('Passes clés', 'keyPasses', stats),
                _buildStatsField('Tacles', 'tackles', stats),
                _buildStatsField('Interceptions', 'interceptions', stats),
                _buildStatsField('Degagements', 'clearances', stats),
                _buildStatsField('Dribbles', 'dribbles', stats),
                _buildStatsField('Fautes commises', 'foulsCommitted', stats),
                _buildStatsField('Fautes subies', 'foulsSuffered', stats),
                _buildStatsField('Hors-jeu', 'offsides', stats),
                _buildStatsField('Arrêts', 'saves', stats),
                _buildStatsField('Clean sheets', 'cleanSheets', stats),
                _buildStatsField('Minutes jouées', 'minutesPlayed', stats),
                _buildStatsField('Cartons jaunes', 'yellowCards', stats),
                _buildStatsField('Cartons rouges', 'redCards', stats),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updatePlayerStats(player['id'], stats);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF55C1CF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsField(String label, String key, Map<String, dynamic> stats) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        keyboardType: TextInputType.number,
        controller: TextEditingController(text: stats[key]?.toString() ?? '0'),
        onChanged: (value) {
          stats[key] = int.tryParse(value) ?? 0;
        },
      ),
    );
  }

  void _updatePlayerStats(int playerId, Map<String, dynamic> updatedStats) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Mise à jour des statistiques...'),
            ],
          ),
        ),
      );

      // Update stats on backend
      await _coachService.updatePlayerStats(playerId, updatedStats);

      // Close loading dialog
      Navigator.pop(context);

      // Update local state
      setState(() {
        _playersWithStatsFuture = _playersWithStatsFuture.then((players) {
          return players.map((player) {
            if (player['id'] == playerId) {
              return {
                ...player,
                'stats': updatedStats,
              };
            }
            return player;
          }).toList();
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Statistiques mises à jour avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la mise à jour: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
