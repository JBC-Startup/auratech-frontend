import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _expiresAtKey = 'expires_at';
  static const _userRoleKey = 'user_role';
  static const _userIdKey = 'user_id';

  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    required int expiresAt,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
    await _storage.write(key: _expiresAtKey, value: expiresAt.toString());
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<bool> isTokenExpired() async {
    final expiresAt = await _storage.read(key: _expiresAtKey);
    if (expiresAt == null) return true;
    final expiryTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAt) * 1000);
    return DateTime.now().isAfter(expiryTime);
  }

  static Future<void> saveUserInfo(
      {required int userId, required String role}) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(key: _userRoleKey, value: role);
  }

  static Future<int?> getUserId() async {
    final id = await _storage.read(key: _userIdKey);
    return id != null ? int.tryParse(id) : null;
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
