import 'package:dio/dio.dart';

import '../models/user.dart';
import 'api_client.dart';

class AuthSession {
  final User user;
  final String token;
  const AuthSession({required this.user, required this.token});
}

class AuthService {
  final ApiClient _client;
  AuthService(this._client);

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final res = await _client.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final data = res.data as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = User.fromJson(data['user'] as Map<String, dynamic>);
    return AuthSession(user: user, token: token);
  }

  Future<User> getProfile() async {
    final res = await _client.dio.get('/auth/profile');
    final data = res.data as Map<String, dynamic>;
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }

  static String humanError(Object error) {
    if (error is DioException) {
      final msg = error.response?.data is Map<String, dynamic>
          ? (error.response?.data['message']?.toString())
          : null;
      return msg ?? error.message ?? 'Erreur réseau';
    }
    return 'Erreur inconnue';
  }
}

