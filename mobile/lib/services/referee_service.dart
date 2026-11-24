// Espace Arbitre — reconstruit d'après l'APK du 15/10.
import 'package:dio/dio.dart';

import 'api_client.dart';

/// Rôle de l'arbitre sur une mission.
String refereeRoleLabel(String role) {
  switch (role) {
    case 'main':
      return 'Arbitre principal';
    case 'assistant':
      return 'Arbitre assistant';
    case 'fourth':
      return '4ème arbitre';
    default:
      return 'Arbitre';
  }
}

class RefereeMission {
  final int id;
  final String role;
  final String status; // pending | accepted | declined
  final DateTime? respondedAt;
  final String? declineReason;
  final String? presenceSheetUrl;
  final String? matchSheetUrl;
  final int matchId;
  final DateTime date;
  final String location;
  final String matchStatus;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String tournament;

  const RefereeMission({
    required this.id,
    required this.role,
    required this.status,
    this.respondedAt,
    this.declineReason,
    this.presenceSheetUrl,
    this.matchSheetUrl,
    required this.matchId,
    required this.date,
    required this.location,
    required this.matchStatus,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.tournament,
  });

  bool get isUpcoming => date.isAfter(DateTime.now());
  bool get isCompleted => matchStatus == 'completed';
  String get roleLabel => refereeRoleLabel(role);

  factory RefereeMission.fromJson(Map<String, dynamic> j) {
    final m = (j['match'] as Map?)?.cast<String, dynamic>() ?? {};
    String teamName(dynamic t) => (t is Map ? t['name'] : null)?.toString() ?? 'À déterminer';
    DateTime? parse(dynamic v) => v == null ? null : DateTime.tryParse(v.toString())?.toLocal();
    return RefereeMission(
      id: (j['id'] as num).toInt(),
      role: (j['role'] ?? 'main').toString(),
      status: (j['status'] ?? 'pending').toString(),
      respondedAt: parse(j['respondedAt']),
      declineReason: j['declineReason']?.toString(),
      presenceSheetUrl: j['presenceSheetUrl']?.toString(),
      matchSheetUrl: j['matchSheetUrl']?.toString(),
      matchId: (m['id'] as num?)?.toInt() ?? 0,
      date: parse(m['date']) ?? DateTime.now(),
      location: (m['location'] ?? 'Lieu non précisé').toString(),
      matchStatus: (m['status'] ?? 'scheduled').toString(),
      homeTeam: teamName(m['homeTeam']),
      awayTeam: teamName(m['awayTeam']),
      homeScore: (m['homeTeamScore'] as num?)?.toInt() ?? 0,
      awayScore: (m['awayTeamScore'] as num?)?.toInt() ?? 0,
      tournament: ((m['tournament'] as Map?)?['name'] ?? '').toString(),
    );
  }
}

class RefereeStats {
  final int totalMissions;
  final int pending;
  final int accepted;
  final int declined;
  final int matchesRefereed;
  final int acceptanceRate;
  final int officialDisputes;
  final RefereeMission? nextMission;

  const RefereeStats({
    this.totalMissions = 0,
    this.pending = 0,
    this.accepted = 0,
    this.declined = 0,
    this.matchesRefereed = 0,
    this.acceptanceRate = 0,
    this.officialDisputes = 0,
    this.nextMission,
  });

  factory RefereeStats.fromJson(Map<String, dynamic> j) {
    int n(String k) => (j[k] as num?)?.toInt() ?? 0;
    final next = j['nextMission'];
    return RefereeStats(
      totalMissions: n('totalMissions'),
      pending: n('pending'),
      accepted: n('accepted'),
      declined: n('declined'),
      matchesRefereed: n('matchesRefereed'),
      acceptanceRate: n('acceptanceRate'),
      officialDisputes: n('officialDisputes'),
      nextMission: next is Map ? RefereeMission.fromJson(next.cast<String, dynamic>()) : null,
    );
  }
}

class RefereeService {
  final ApiClient _api;
  RefereeService(this._api);

  Never _fail(Response res, String fallback) {
    final data = res.data;
    throw Exception(data is Map && data['message'] != null ? data['message'] : fallback);
  }

  Future<List<RefereeMission>> getMyMissions({String? status}) async {
    final res = await _api.dio.get('/referee/me/missions',
        queryParameters: status == null ? null : {'status': status});
    if (res.statusCode != 200) _fail(res, 'Erreur chargement missions');
    final list = (res.data['missions'] as List?) ?? [];
    return list.map((e) => RefereeMission.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<RefereeStats> getMyStats() async {
    final res = await _api.dio.get('/referee/me/stats');
    if (res.statusCode != 200) _fail(res, 'Erreur chargement statistiques');
    return RefereeStats.fromJson((res.data as Map).cast<String, dynamic>());
  }

  Future<void> respondToMission(int missionId, {required bool accept, String? reason}) async {
    final res = await _api.dio.post('/referee/me/missions/$missionId/respond',
        data: {'action': accept ? 'accept' : 'decline', if (reason != null) 'reason': reason});
    if (res.statusCode != 200) _fail(res, 'Impossible d\'envoyer la réponse');
  }

  /// [type] : 'presence' (feuille avec les joueurs sélectionnés) ou 'match' (faits du match).
  /// Les octets sont passés directement pour rester compatible web et mobile.
  Future<String> uploadSheet(int missionId,
      {required List<int> bytes, required String filename, required String type}) async {
    final ext = filename.toLowerCase().split('.').last;
    final mime = ext == 'png' ? 'png' : ext == 'webp' ? 'webp' : 'jpeg';
    final form = FormData.fromMap({
      'type': type,
      'sheet': MultipartFile.fromBytes(bytes, filename: filename, contentType: DioMediaType('image', mime)),
    });
    final res = await _api.dio.post('/referee/me/missions/$missionId/upload-sheet',
        data: form, options: Options(contentType: 'multipart/form-data'));
    if (res.statusCode != 200) _fail(res, 'Échec de l\'envoi de la feuille');
    return res.data['url'].toString();
  }
}
