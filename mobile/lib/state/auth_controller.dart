import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/token_storage.dart';

class AuthController extends ChangeNotifier {
  final TokenStorage _tokenStorage;

  User? user;
  String? token;
  bool loading = true;
  String? error;

  late ApiClient _api;
  late AuthService _auth;

  AuthController(this._tokenStorage) {
    _api = ApiClient();
    _auth = AuthService(_api);

    // ── #16 : Enregistrer le callback de déconnexion forcée (401 non récupérable)
    ApiClient.onForceLogout = () {
      debugPrint('[Auth] Token expiré non rafraîchissable → déconnexion forcée');
      logout();
    };
  }

  Future<void> bootstrap() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      token = await _tokenStorage.readToken();
      if (token == null) {
        user = null;
        return;
      }

      _api = _api.copyWithToken(token);
      _auth = AuthService(_api);

      // ── #15 : Si getProfile retourne 401, on tente un refresh avant d'abandonner
      try {
        user = await _auth.getProfile();
      } catch (e) {
        final refreshed = await ApiClient.tryRefreshToken(token!);
        if (refreshed != null) {
          token = refreshed;
          await _tokenStorage.saveToken(refreshed);
          _api = _api.copyWithToken(refreshed);
          _auth = AuthService(_api);
          user = await _auth.getProfile();
        } else {
          rethrow; // déclenchera le catch ci-dessous → logout
        }
      }

      if (user != null) _initNotifications();
    } catch (e) {
      await _tokenStorage.clearToken();
      token = null;
      user = null;
      error = AuthService.humanError(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final session = await _auth.login(email: email, password: password);

      token = session.token;
      user = session.user;
      await _tokenStorage.saveToken(session.token);

      _api = _api.copyWithToken(session.token);
      _auth = AuthService(_api);
      _initNotifications();
      return true;
    } catch (e) {
      debugPrint('[Auth] Login failed: ${e.runtimeType}');
      error = AuthService.humanError(e);
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
    user = null;
    token = null;
    error = null;
    notifyListeners();
  }

  bool get isAuthed => token != null && user != null;

  void _initNotifications() {
    if (user == null) return;
    NotificationService.instance
        .init(_api, userRole: user!.role)
        .catchError((e) => debugPrint('[FCM] init error: $e'));
  }
}

