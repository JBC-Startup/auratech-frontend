import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/token_storage.dart';
import '../models/auth_models.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  bool _isLoading = false;
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthStatus() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      _isAuthenticated = false;
      notifyListeners();
      return;
    }

    final isExpired = await TokenStorage.isTokenExpired();
    if (isExpired) {
      await TokenStorage.clearAll();
      _isAuthenticated = false;
      notifyListeners();
      return;
    }

    try {
      final response = await _api.get(ApiEndpoints.me);
      _currentUser =
          UserModel.fromJson(response.data as Map<String, dynamic>);
      _isAuthenticated = true;
    } catch (e) {
      _isAuthenticated = false;
      await TokenStorage.clearAll();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.post(
        ApiEndpoints.login,
        data: LoginRequest(email: email, contrasena: password).toJson(),
      );

      final loginResponse =
          LoginResponse.fromJson(response.data as Map<String, dynamic>);

      final expiresAt =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000) +
              loginResponse.expiresIn;

      await TokenStorage.saveTokens(
        accessToken: loginResponse.accessToken,
        expiresAt: expiresAt,
      );

      await TokenStorage.saveUserInfo(
        userId: loginResponse.usuario.idUsuario,
        role: loginResponse.usuario.rol,
      );

      _currentUser = loginResponse.usuario;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      final apiError = ApiClient.parseError(e);
      _errorMessage = apiError.displayMessage;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado. Intente nuevamente.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      final apiError = ApiClient.parseError(e);
      _errorMessage = apiError.displayMessage;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado. Intente nuevamente.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> recoverPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _api.post(
        ApiEndpoints.recoverPassword,
        data: {'email': email},
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e) {
      final apiError = ApiClient.parseError(e);
      _errorMessage = apiError.displayMessage;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Error inesperado. Intente nuevamente.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiEndpoints.logout);
    } catch (_) {}
    await TokenStorage.clearAll();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
