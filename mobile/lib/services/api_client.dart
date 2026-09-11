import 'package:dio/dio.dart';

import '../app_config.dart';
import 'token_storage.dart';

class ApiClient {
  final Dio dio;
  final String? token;

  // Référence nullable vers le callback de déconnexion forcée
  // Alimenté par AuthController après son initialisation
  static void Function()? onForceLogout;

  ApiClient({this.token})
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            // ── #16 : valider tous les statuts — l'interceptor gère les 401 ──
            validateStatus: (status) => status != null,
          ),
        ) {
    // ── Logging (dev) ─────────────────────────────────────────────────────────
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('API LOG: $obj'),
    ));

    // ── #15 & #16 : Interceptor 401 → tentative de refresh, puis logout ──────
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            final currentToken = token;
            if (currentToken != null) {
              // Tente de rafraîchir le token
              final newToken = await tryRefreshToken(currentToken);
              if (newToken != null) {
                // Rejoue la requête originale avec le nouveau token
                final opts = response.requestOptions;
                opts.headers['Authorization'] = 'Bearer $newToken';
                try {
                  final retried = await Dio(BaseOptions(
                    baseUrl: AppConfig.apiBaseUrl,
                    headers: opts.headers,
                    validateStatus: (s) => s != null,
                  )).fetch(opts);
                  return handler.resolve(retried);
                } catch (_) {}
              }
            }
            // Refresh impossible → déconnexion forcée
            onForceLogout?.call();
          }
          handler.next(response);
        },
        onError: (error, handler) {
          // Erreurs réseau (pas de réponse) → on laisse passer
          handler.next(error);
        },
      ),
    );
  }

  /// Tente POST /auth/refresh avec l'ancien token.
  /// Retourne le nouveau token ou null si le refresh échoue.
  /// Exposé publiquement pour AuthController.bootstrap().
  static Future<String?> tryRefreshToken(String expiredToken) => _tryRefresh(expiredToken);

  static Future<String?> _tryRefresh(String expiredToken) async {
    try {
      final refreshDio = Dio(BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (s) => s != null,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $expiredToken',
        },
      ));
      final res = await refreshDio.post('/auth/refresh');
      if (res.statusCode == 200 && res.data is Map) {
        final newToken = res.data['token'] as String?;
        if (newToken != null) {
          // Persister le nouveau token
          await TokenStorage().saveToken(newToken);
          return newToken;
        }
      }
    } catch (_) {}
    return null;
  }

  ApiClient copyWithToken(String? token) {
    return ApiClient(token: token);
  }
}
