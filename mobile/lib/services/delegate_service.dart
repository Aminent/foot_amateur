import './api_client.dart';

/// Match delegate: follows assigned matches live and records their facts.
class DelegateService {
  final ApiClient _api;
  DelegateService(this._api);

  String _error(dynamic data, String fallback) =>
      (data is Map && data['message'] != null) ? data['message'].toString() : fallback;

  Future<List<Map<String, dynamic>>> myMatches() async {
    final res = await _api.dio.get('/delegates/me/matches');
    if (res.statusCode != 200) throw Exception(_error(res.data, 'Erreur de chargement des matchs'));
    return List<Map<String, dynamic>>.from(res.data['matches'] ?? []);
  }

  Future<Map<String, dynamic>> match(int id) async {
    final res = await _api.dio.get('/matches/$id');
    if (res.statusCode != 200) throw Exception(_error(res.data, 'Match introuvable'));
    return Map<String, dynamic>.from(res.data['match']);
  }

  /// action: kickoff | half_time | second_half | full_time
  Future<Map<String, dynamic>> live(int id, String action, {int? winnerTeamId}) async {
    final res = await _api.dio.put('/matches/$id/live', data: {
      'action': action,
      if (winnerTeamId != null) 'winnerTeamId': winnerTeamId,
    });
    if (res.statusCode != 200) throw Exception(_error(res.data, 'Action impossible'));
    return Map<String, dynamic>.from(res.data['match']);
  }

  Future<Map<String, dynamic>> addEvent(int id, Map<String, dynamic> event) async {
    final res = await _api.dio.post('/matches/$id/events', data: event);
    if (res.statusCode != 201) throw Exception(_error(res.data, "Erreur lors de l'enregistrement"));
    return Map<String, dynamic>.from(res.data['match']);
  }

  Future<Map<String, dynamic>> deleteEvent(int id, int eventId) async {
    final res = await _api.dio.delete('/matches/$id/events/$eventId');
    if (res.statusCode != 200) throw Exception(_error(res.data, 'Erreur lors de la suppression'));
    return Map<String, dynamic>.from(res.data['match']);
  }
}
