import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/config/app_env.dart';
import '../../../core/storage/app_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Dio get _dio => Dio(
    BaseOptions(
      baseUrl: AppStorage.serverHost,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<String> login(String username, String password) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      final token = res.data['access_token'] as String;
      await AppStorage.setToken(token);
      return token;
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'] ?? 'Không thể kết nối server';
      throw Exception(detail);
    }
  }

  Future<void> register(String username, String password) async {
    try {
      await _dio.post(
        '/auth/register',
        data: {'username': username, 'password': password},
      );
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'] ?? 'Đăng ký thất bại';
      throw Exception(detail);
    }
  }

  Future<void> logout() async {
    await AppStorage.clearToken();
  }

  static Future<void>? _googleInitFuture;

  Future<void> ensureGoogleInitialized() {
    final clientId = AppEnv.googleClientId;
    final serverClientId = AppEnv.googleServerClientId;
    return _googleInitFuture ??= GoogleSignIn.instance.initialize(
      clientId: clientId.isNotEmpty ? clientId : null,
      serverClientId: (!kIsWeb && serverClientId.isNotEmpty)
          ? serverClientId
          : null,
    );
  }

  Future<String> loginWithGoogleAccount(GoogleSignInAccount account) async {
    try {
      final idToken = account.authentication.idToken;
      if (idToken == null) throw Exception('Không lấy được Google ID Token');

      final res = await _dio.post('/auth/google', data: {'id_token': idToken});
      final token = res.data['access_token'] as String;
      await AppStorage.setToken(token);
      return token;
    } on DioException catch (e) {
      final detail = e.response?.data?['detail'] ?? 'Đăng nhập Google thất bại';
      throw Exception(detail);
    }
  }

  Future<String> loginWithGoogle() async {
    try {
      await ensureGoogleInitialized();
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        throw Exception(
          'Nền tảng này không hỗ trợ gọi đăng nhập Google trực tiếp',
        );
      }

      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email', 'profile'],
      );
      return loginWithGoogleAccount(account);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Đã hủy đăng nhập Google');
      }
      throw Exception(
        'Đăng nhập Google thất bại: ${e.description ?? e.code.name}',
      );
    }
  }
}
