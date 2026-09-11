import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists notification preferences and per-type received counts.
class NotificationPrefsService {
  NotificationPrefsService._();
  static final NotificationPrefsService instance = NotificationPrefsService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _keyEnabled     = 'notif_enabled';
  static const _keyTotal       = 'notif_count_total';

  // Per-type count keys
  static const Map<String, String> _typeKeys = {
    'training_scheduled' : 'notif_count_training_scheduled',
    'training_updated'   : 'notif_count_training_updated',
    'match_reminder'     : 'notif_count_match_reminder',
    'score_update'       : 'notif_count_score_update',
    'match_result'       : 'notif_count_match_result',
    'application_approved': 'notif_count_application_approved',
    'application_rejected': 'notif_count_application_rejected',
    'lineup_published'   : 'notif_count_lineup_published',
    'chat_message'       : 'notif_count_chat_message',
  };

  // ── enabled ──────────────────────────────────────────────────────────────────

  Future<bool> isEnabled() async {
    final v = await _storage.read(key: _keyEnabled);
    return v != 'false'; // default: enabled
  }

  Future<void> setEnabled(bool value) async {
    await _storage.write(key: _keyEnabled, value: value ? 'true' : 'false');
  }

  // ── counts ───────────────────────────────────────────────────────────────────

  Future<int> getTotal() async {
    final v = await _storage.read(key: _keyTotal);
    return int.tryParse(v ?? '0') ?? 0;
  }

  Future<Map<String, int>> getAllCounts() async {
    final result = <String, int>{};
    for (final entry in _typeKeys.entries) {
      final v = await _storage.read(key: entry.value);
      result[entry.key] = int.tryParse(v ?? '0') ?? 0;
    }
    return result;
  }

  Future<void> increment(String type) async {
    // total
    final total = await getTotal();
    await _storage.write(key: _keyTotal, value: (total + 1).toString());
    // per-type
    final key = _typeKeys[type];
    if (key != null) {
      final v = await _storage.read(key: key);
      final current = int.tryParse(v ?? '0') ?? 0;
      await _storage.write(key: key, value: (current + 1).toString());
    }
  }

  Future<void> resetAll() async {
    await _storage.write(key: _keyTotal, value: '0');
    for (final key in _typeKeys.values) {
      await _storage.write(key: key, value: '0');
    }
  }

  /// Human-readable label for each notification type
  static String typeLabel(String type) {
    switch (type) {
      case 'training_scheduled':  return 'Entraînement planifié';
      case 'training_updated':    return 'Entraînement modifié';
      case 'match_reminder':      return 'Rappel match 24h';
      case 'score_update':        return 'Score mis à jour';
      case 'match_result':        return 'Résultat final';
      case 'application_approved':return 'Candidature approuvée';
      case 'application_rejected':return 'Candidature refusée';
      case 'lineup_published':    return 'Composition publiée';
      case 'chat_message':        return 'Message reçu';
      default:                    return type;
    }
  }

}
