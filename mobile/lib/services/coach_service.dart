import './api_client.dart';

class CoachService {
  final ApiClient _apiClient;

  CoachService(this._apiClient);

  /// Get coach's team with players
  Future<Map<String, dynamic>> getMyTeam() async {
    try {
      final results = await Future.wait([
        _apiClient.dio.get('/coaches/me/team'),
        _apiClient.dio.get('/auth/profile'),
      ]);
      final response = results[0];
      final profileResponse = results[1];

      if (response.statusCode == 200) {
        final data = response.data;
        final team = data['team'];

        if (team == null) {
          throw Exception('Aucune équipe assignée');
        }

        final profileData = profileResponse.statusCode == 200
            ? profileResponse.data as Map<String, dynamic>
            : <String, dynamic>{};
        final coachData = profileData['user'] as Map<String, dynamic>? ?? profileData;

        // Format the data to match expected structure
        return {
          'coach': {
            'id': coachData['id'],
            'name': coachData['name'] ?? coachData['username'] ?? 'Coach',
            'email': coachData['email'] ?? '',
            'phone': coachData['phone'] ?? '',
          },
          'team': {
            'id': team['id'],
            'name': team['name'],
            'description': team['description'] ?? '',
            'createdAt': team['createdAt'] ?? 'N/A',
          },
          'players': (team['players'] as List?)?.map((player) => {
            'id': player['id'],
            'name': player['name'],
            'jerseyNumber': player['jerseyNumber'],
            'position': player['position'],
            'isCaptain': player['isCaptain'] ?? false,
            'email': player['email'],
            'phone': player['phone'],
            'status': player['isActive'] != false ? 'Actif' : 'Inactif',
          }).toList() ?? [],
        };
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement de l\'équipe: $e');
    }
  }

  /// Get coach's team matches
  Future<List<Map<String, dynamic>>> getMyTeamMatches() async {
    try {
      final response = await _apiClient.dio.get('/coaches/me/matches');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['matches']);
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors du chargement des matchs: $e');
    }
  }

  /// Get coach statistics for dashboard
  Future<Map<String, int>> getCoachStats() async {
    try {
      final teamData = await getMyTeam();
      final matches = await getMyTeamMatches();
      
      final playersCount = (teamData['players'] as List?)?.length ?? 0;
      final matchesCount = matches.length;
      final upcomingMatches = matches.where((match) => 
        match['status'] == 'scheduled' || 
        (DateTime.tryParse(match['date'])?.isAfter(DateTime.now()) ?? false)
      ).length;
      
      return {
        'teamsCount': teamData['team'] != null ? 1 : 0,
        'playersCount': playersCount,
        'matchesCount': matchesCount,
        'upcomingMatches': upcomingMatches,
      };
    } catch (e) {
      // Return default values on error
      return {
        'teamsCount': 0,
        'playersCount': 0,
        'matchesCount': 0,
        'upcomingMatches': 0,
      };
    }
  }

  /// Update player information
  Future<void> updatePlayer(int playerId, Map<String, dynamic> playerData) async {
    try {
      final response = await _apiClient.dio.put('/players/$playerId', data: playerData);
      
      if (response.statusCode != 200) {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du joueur: $e');
    }
  }

  /// Get player statistics
  Future<Map<String, dynamic>> getPlayerStats(int playerId) async {
    try {
      final response = await _apiClient.dio.get('/player-stats/$playerId');
      
      if (response.statusCode == 200) {
        return response.data['stats'] ?? {};
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      // Return default stats if none exist
      return {
        'goals': 0,
        'assists': 0,
        'shots': 0,
        'shotsOnTarget': 0,
        'passes': 0,
        'keyPasses': 0,
        'tackles': 0,
        'interceptions': 0,
        'clearances': 0,
        'dribbles': 0,
        'foulsCommitted': 0,
        'foulsSuffered': 0,
        'offsides': 0,
        'saves': 0,
        'cleanSheets': 0,
        'minutesPlayed': 0,
        'yellowCards': 0,
        'redCards': 0
      };
    }
  }

  /// Update player statistics
  Future<void> updatePlayerStats(int playerId, Map<String, dynamic> stats) async {
    try {
      final response = await _apiClient.dio.put('/player-stats/$playerId', data: { 'stats': stats });

      if (response.statusCode != 200) {
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour des statistiques: $e');
    }
  }

  // ── Tournament ────────────────────────────────────────────────────────────

  /// Current tournament, standings, and team's matches
  Future<Map<String, dynamic>> getMyTournament() async {
    try {
      final response = await _apiClient.dio.get('/coaches/me/tournament');
      if (response.statusCode == 200) return Map<String, dynamic>.from(response.data);
      if (response.statusCode == 404) {
        // Route not found — server may need a restart
        throw Exception('Endpoint introuvable (redémarre le serveur)');
      }
      final msg = response.data is Map ? response.data['message'] ?? 'Erreur inconnue' : 'Erreur inconnue';
      throw Exception(msg);
    } catch (e) {
      rethrow;
    }
  }

  /// Active tournaments the team can apply to
  Future<List<Map<String, dynamic>>> getAvailableTournaments() async {
    try {
      final response = await _apiClient.dio.get('/coaches/me/available-tournaments');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['tournaments'] ?? []);
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Apply for a tournament
  Future<void> applyForTournament(int tournamentId) async {
    try {
      final coach = await getMyTeam();
      final teamId = coach['team']?['id'];
      if (teamId == null) throw Exception('Aucune équipe assignée');
      final response = await _apiClient.dio.post(
        '/tournament-applications',
        data: {'teamId': teamId, 'tournamentId': tournamentId},
      );
      if (response.statusCode != 201) {
        final msg = response.data['message'] ?? 'Erreur lors de la candidature';
        throw Exception(msg);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ── Training sessions ──────────────────────────────────────────────────────

  /// Get all training sessions for coach's team
  Future<List<Map<String, dynamic>>> getMyTrainings() async {
    try {
      final response = await _apiClient.dio.get('/coaches/me/trainings');
      if (response.statusCode == 200) {
        final data = response.data;
        final sessions = data['sessions'] as List? ?? [];
        return sessions.map((s) => _formatSession(s)).toList();
      }
      throw Exception('Erreur HTTP: ${response.statusCode}');
    } catch (e) {
      throw Exception('Erreur chargement séances: $e');
    }
  }

  /// Create a new training session
  Future<Map<String, dynamic>> createTraining(Map<String, dynamic> data) async {
    final response = await _apiClient.dio.post('/coaches/me/trainings', data: data);
    if (response.statusCode == 201) {
      return _formatSession(response.data['session']);
    }
    // Show specific validation errors if present
    if (response.statusCode == 400 && response.data is Map) {
      final errors = response.data['errors'] as List?;
      if (errors != null && errors.isNotEmpty) {
        final msgs = errors.map((e) => e['msg'] ?? e.toString()).join(', ');
        throw Exception('Données invalides: $msgs');
      }
    }
    final msg = response.data is Map
        ? response.data['message'] ?? 'Erreur HTTP ${response.statusCode}'
        : 'Erreur HTTP ${response.statusCode}';
    throw Exception(msg);
  }

  /// Update an existing training session
  Future<Map<String, dynamic>> updateTraining(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.dio.put('/coaches/me/trainings/$id', data: data);
    if (response.statusCode == 200) {
      return _formatSession(response.data['session']);
    }
    final msg = response.data is Map
        ? response.data['message'] ?? 'Erreur HTTP ${response.statusCode}'
        : 'Erreur HTTP ${response.statusCode}';
    throw Exception(msg);
  }

  /// Delete a training session
  Future<void> deleteTraining(int id) async {
    final response = await _apiClient.dio.delete('/coaches/me/trainings/$id');
    if (response.statusCode != 200) {
      final msg = response.data is Map
          ? response.data['message'] ?? 'Erreur HTTP ${response.statusCode}'
          : 'Erreur HTTP ${response.statusCode}';
      throw Exception(msg);
    }
  }

  /// Convert backend session to display-friendly map
  Map<String, dynamic> _formatSession(Map<String, dynamic> s) {
    final rawDate = s['date'] as String?;
    DateTime? dt;
    try { dt = rawDate != null ? DateTime.parse(rawDate) : null; } catch (_) {}

    final typeMap = {
      'technique': 'Technique', 'tactique': 'Tactique',
      'physique': 'Physique', 'match': 'Match', 'autre': 'Autre',
    };
    final statusMap = {
      'scheduled': 'À venir', 'completed': 'Terminé', 'cancelled': 'Annulé',
    };

    return {
      'id': s['id'],
      'title': s['title'] ?? '',
      'description': s['description'] ?? '',
      'type': typeMap[s['type']] ?? s['type'] ?? 'Entraînement',
      'typeRaw': s['type'] ?? 'technique',
      'date': dt != null
          ? '${dt.day.toString().padLeft(2,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.year}'
          : '',
      'dateIso': rawDate ?? '',
      'time': dt != null
          ? '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}'
          : '',
      'duration': s['duration'] != null ? '${s['duration']} min' : '',
      'durationMin': s['duration'],
      'location': s['location'] ?? '',
      'status': statusMap[s['status']] ?? s['status'] ?? 'À venir',
      'statusRaw': s['status'] ?? 'scheduled',
      'notes': s['notes'] ?? '',
      'coach': s['coach']?['name'] ?? '',
    };
  }

  // ── Attendance ───────────────────────────────────────────────────────────────

  /// Get attendance list for a training session
  Future<Map<String, dynamic>> getTrainingAttendance(int sessionId) async {
    try {
      final res = await _apiClient.dio.get('/coaches/me/trainings/$sessionId/attendance');
      if (res.statusCode == 200) return Map<String, dynamic>.from(res.data);
      throw Exception('Erreur HTTP ${res.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  /// Bulk-save attendance for a training session
  Future<void> saveTrainingAttendance(int sessionId, List<Map<String, dynamic>> records) async {
    try {
      final res = await _apiClient.dio.put(
        '/coaches/me/trainings/$sessionId/attendance',
        data: {'attendance': records},
      );
      if (res.statusCode != 200) {
        final msg = res.data is Map ? res.data['message'] ?? 'Erreur' : 'Erreur';
        throw Exception(msg);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ── Rewards ──────────────────────────────────────────────────────────────────

  /// Fetch all badges already awarded to a player (coach view).
  Future<List<Map<String, dynamic>>> getPlayerBadges(int playerId) async {
    try {
      final res = await _apiClient.dio.get('/rewards/player/$playerId/badges');
      final list = res.data['badges'] as List? ?? [];
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  /// Award a badge to a player.
  /// [badgeData] must contain: name, type, rarity, description, icon.
  Future<void> awardBadge(int playerId, Map<String, dynamic> badgeData) async {
    try {
      final response = await _apiClient.dio.post(
        '/rewards/award-badge',
        data: {'playerId': playerId, 'badgeData': badgeData},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        final msg = response.data is Map
            ? response.data['message'] ?? 'Erreur serveur: ${response.statusCode}'
            : 'Erreur serveur: ${response.statusCode}';
        throw Exception(msg);
      }
    } catch (e) {
      rethrow;
    }
  }
}
