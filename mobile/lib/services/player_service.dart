import './api_client.dart';
import '../models/user.dart';

class PlayerService {
  final ApiClient _apiClient;

  PlayerService(this._apiClient);

  /// Get current player's profile and team information
  Future<Map<String, dynamic>> getMyPlayerProfile() async {
    try {
      final response = await _apiClient.dio.get('/players/me/profile');
      
      if (response.statusCode == 200) {
        final data = response.data;
        return {
          'player': data['player'],
          'team': data['team'],
          'stats': data['stats'],
          'upcomingMatches': data['upcomingMatches'] ?? [],
          'recentMatches': data['recentMatches'] ?? [],
        };
      }
      throw Exception('Failed to load player profile');
    } catch (e) {
      rethrow;
    }
  }

  /// Get player's detailed statistics
  Future<Map<String, dynamic>> getMyStats() async {
    try {
      final response = await _apiClient.dio.get('/players/me/stats');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to load player stats');
    } catch (e) {
      rethrow;
    }
  }

  /// Get player's rewards and badges
  Future<Map<String, dynamic>> getMyRewards() async {
    try {
      final response = await _apiClient.dio.get('/rewards/me');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to load player rewards');
    } catch (e) {
      rethrow;
    }
  }

  /// Get player's team information
  Future<Map<String, dynamic>> getMyTeam() async {
    try {
      final response = await _apiClient.dio.get('/players/me/team');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to load team information');
    } catch (e) {
      rethrow;
    }
  }

  /// Get player's matches (upcoming and recent)
  Future<Map<String, dynamic>> getMyMatches() async {
    try {
      final response = await _apiClient.dio.get('/players/me/matches');
      
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to load player matches');
    } catch (e) {
      rethrow;
    }
  }

  /// Get tournaments the player's team is participating in
  Future<List<Map<String, dynamic>>> getMyTournaments() async {
    try {
      final response = await _apiClient.dio.get('/players/me/tournaments');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      throw Exception('Failed to load tournaments');
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  /// Get player's training sessions
  Future<List<Map<String, dynamic>>> getMyTrainingSessions() async {
    try {
      final response = await _apiClient.dio.get('/players/me/training-sessions');
      
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      throw Exception('Failed to load training sessions');
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  /// Get player's attendance summary
  Future<Map<String, dynamic>> getMyAttendance() async {
    try {
      final response = await _apiClient.dio.get('/players/me/attendance');
      if (response.statusCode == 200) return Map<String, dynamic>.from(response.data);
      return {'rate': null, 'records': []};
    } catch (_) {
      return {'rate': null, 'records': []};
    }
  }

  /// Update player's profile information
  Future<bool> updateMyProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiClient.dio.put('/players/me/profile', data: profileData);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get player's age from date of birth
  int? calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return null;
    
    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      
      // Check if birthday hasn't occurred yet this year
      if (today.month < birthDate.month || 
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      
      return age;
    } catch (e) {
      return null;
    }
  }

  /// Format position from database to display format
  String formatPosition(String? position) {
    if (position == null) return 'Non défini';
    
    switch (position.toLowerCase()) {
      case 'gardien':
        return 'Gardien';
      case 'defenseur':
        return 'Défenseur';
      case 'milieu':
        return 'Milieu';
      case 'attaquant':
        return 'Attaquant';
      default:
        return position;
    }
  }

  /// Format preferred foot for display
  String formatPreferredFoot(String? preferredFoot) {
    if (preferredFoot == null) return 'Non défini';
    
    switch (preferredFoot.toLowerCase()) {
      case 'gauche':
        return 'Gauche';
      case 'droit':
        return 'Droit';
      case 'ambidextre':
        return 'Ambidextre';
      default:
        return preferredFoot;
    }
  }
}
